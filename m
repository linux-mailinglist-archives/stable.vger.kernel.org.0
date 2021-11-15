Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E643451DD5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbhKPAeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343896AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A1F3635FE;
        Mon, 15 Nov 2021 18:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002111;
        bh=/QjSk28O4u+gTWYdfcpjfbQgxGT5eXSLrqCvCEZ/rIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8E2M2DOesFunXizHC9wDYti0ERO94oGsLLn5LCbnM4hKn6OiJFbiN3AJPI9W8Ckk
         7Gj1FzMO3OKmbHMz63f88P2QKJNriC8o1e4BGzaYIodxOHRpKvrBrZmn1KRhDSUXE4
         bFUBpV8KR1N0hn619Q97MFYiY9/FbZhp5ZiD6mgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liqiong <liqiong@nfschina.com>,
        THOBY Simon <Simon.THOBY@viveris.fr>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.15 415/917] ima: fix deadlock when traversing "ima_default_rules".
Date:   Mon, 15 Nov 2021 17:58:30 +0100
Message-Id: <20211115165442.860364435@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liqiong <liqiong@nfschina.com>

[ Upstream commit eb0782bbdfd0d7c4786216659277c3fd585afc0e ]

The current IMA ruleset is identified by the variable "ima_rules"
that default to "&ima_default_rules". When loading a custom policy
for the first time, the variable is updated to "&ima_policy_rules"
instead. That update isn't RCU-safe, and deadlocks are possible.
Indeed, some functions like ima_match_policy() may loop indefinitely
when traversing "ima_default_rules" with list_for_each_entry_rcu().

When iterating over the default ruleset back to head, if the list
head is "ima_default_rules", and "ima_rules" have been updated to
"&ima_policy_rules", the loop condition (&entry->list != ima_rules)
stays always true, traversing won't terminate, causing a soft lockup
and RCU stalls.

Introduce a temporary value for "ima_rules" when iterating over
the ruleset to avoid the deadlocks.

Signed-off-by: liqiong <liqiong@nfschina.com>
Reviewed-by: THOBY Simon <Simon.THOBY@viveris.fr>
Fixes: 38d859f991f3 ("IMA: policy can now be updated multiple times")
Reported-by: kernel test robot <lkp@intel.com> (Fix sparse: incompatible types in comparison expression.)
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 87b9b71cb8201..12e8adcd80a2a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -228,7 +228,7 @@ static struct ima_rule_entry *arch_policy_entry __ro_after_init;
 static LIST_HEAD(ima_default_rules);
 static LIST_HEAD(ima_policy_rules);
 static LIST_HEAD(ima_temp_rules);
-static struct list_head *ima_rules = &ima_default_rules;
+static struct list_head __rcu *ima_rules = (struct list_head __rcu *)(&ima_default_rules);
 
 static int ima_policy __initdata;
 
@@ -675,12 +675,14 @@ int ima_match_policy(struct user_namespace *mnt_userns, struct inode *inode,
 {
 	struct ima_rule_entry *entry;
 	int action = 0, actmask = flags | (flags << 1);
+	struct list_head *ima_rules_tmp;
 
 	if (template_desc && !*template_desc)
 		*template_desc = ima_template_desc_current();
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(entry, ima_rules, list) {
+	ima_rules_tmp = rcu_dereference(ima_rules);
+	list_for_each_entry_rcu(entry, ima_rules_tmp, list) {
 
 		if (!(entry->action & actmask))
 			continue;
@@ -741,9 +743,11 @@ void ima_update_policy_flags(void)
 {
 	struct ima_rule_entry *entry;
 	int new_policy_flag = 0;
+	struct list_head *ima_rules_tmp;
 
 	rcu_read_lock();
-	list_for_each_entry(entry, ima_rules, list) {
+	ima_rules_tmp = rcu_dereference(ima_rules);
+	list_for_each_entry_rcu(entry, ima_rules_tmp, list) {
 		/*
 		 * SETXATTR_CHECK rules do not implement a full policy check
 		 * because rule checking would probably have an important
@@ -968,10 +972,10 @@ void ima_update_policy(void)
 
 	list_splice_tail_init_rcu(&ima_temp_rules, policy, synchronize_rcu);
 
-	if (ima_rules != policy) {
+	if (ima_rules != (struct list_head __rcu *)policy) {
 		ima_policy_flag = 0;
-		ima_rules = policy;
 
+		rcu_assign_pointer(ima_rules, policy);
 		/*
 		 * IMA architecture specific policy rules are specified
 		 * as strings and converted to an array of ima_entry_rules
@@ -1061,7 +1065,7 @@ static int ima_lsm_rule_init(struct ima_rule_entry *entry,
 		pr_warn("rule for LSM \'%s\' is undefined\n",
 			entry->lsm[lsm_rule].args_p);
 
-		if (ima_rules == &ima_default_rules) {
+		if (ima_rules == (struct list_head __rcu *)(&ima_default_rules)) {
 			kfree(entry->lsm[lsm_rule].args_p);
 			entry->lsm[lsm_rule].args_p = NULL;
 			result = -EINVAL;
@@ -1768,9 +1772,11 @@ void *ima_policy_start(struct seq_file *m, loff_t *pos)
 {
 	loff_t l = *pos;
 	struct ima_rule_entry *entry;
+	struct list_head *ima_rules_tmp;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(entry, ima_rules, list) {
+	ima_rules_tmp = rcu_dereference(ima_rules);
+	list_for_each_entry_rcu(entry, ima_rules_tmp, list) {
 		if (!l--) {
 			rcu_read_unlock();
 			return entry;
@@ -1789,7 +1795,8 @@ void *ima_policy_next(struct seq_file *m, void *v, loff_t *pos)
 	rcu_read_unlock();
 	(*pos)++;
 
-	return (&entry->list == ima_rules) ? NULL : entry;
+	return (&entry->list == &ima_default_rules ||
+		&entry->list == &ima_policy_rules) ? NULL : entry;
 }
 
 void ima_policy_stop(struct seq_file *m, void *v)
@@ -2014,6 +2021,7 @@ bool ima_appraise_signature(enum kernel_read_file_id id)
 	struct ima_rule_entry *entry;
 	bool found = false;
 	enum ima_hooks func;
+	struct list_head *ima_rules_tmp;
 
 	if (id >= READING_MAX_ID)
 		return false;
@@ -2021,7 +2029,8 @@ bool ima_appraise_signature(enum kernel_read_file_id id)
 	func = read_idmap[id] ?: FILE_CHECK;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(entry, ima_rules, list) {
+	ima_rules_tmp = rcu_dereference(ima_rules);
+	list_for_each_entry_rcu(entry, ima_rules_tmp, list) {
 		if (entry->action != APPRAISE)
 			continue;
 
-- 
2.33.0



