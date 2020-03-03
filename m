Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4827B17808A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732211AbgCCR52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:57:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733075AbgCCR52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:57:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 882DB20656;
        Tue,  3 Mar 2020 17:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258248;
        bh=bAUUKb7tQmovY2KCpkljFtcy/HITx7HxuDONJh7/nAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yC8s1D3SdTITmEWqvqtoTONuXyxUAHLxPlWgol8p9DdfFLmmsy3hlJ7xeHXJZ3T7q
         rzrSJkZI42yUHWPaskvK37XbcuxkyUCOYMB7EAxVUyO63f0SJUuaZkABGSUNLLcSY+
         jaCBPzwFngUCo93RlDqmPx8saHxqEbMWmWOc8xbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Janne Karhunen <janne.karhunen@gmail.com>,
        Konsta Karsisto <konsta.karsisto@gmail.com>
Subject: [PATCH 5.4 127/152] ima: ima/lsm policy rule loading logic bug fixes
Date:   Tue,  3 Mar 2020 18:43:45 +0100
Message-Id: <20200303174317.233730377@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janne Karhunen <janne.karhunen@gmail.com>

commit 483ec26eed42bf050931d9a5c5f9f0b5f2ad5f3b upstream.

Keep the ima policy rules around from the beginning even if they appear
invalid at the time of loading, as they may become active after an lsm
policy load.  However, loading a custom IMA policy with unknown LSM
labels is only safe after we have transitioned from the "built-in"
policy rules to a custom IMA policy.

Patch also fixes the rule re-use during the lsm policy reload and makes
some prints a bit more human readable.

Changelog:
v4:
- Do not allow the initial policy load refer to non-existing lsm rules.
v3:
- Fix too wide policy rule matching for non-initialized LSMs
v2:
- Fix log prints

Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Cc: Casey Schaufler <casey@schaufler-ca.com>
Reported-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Janne Karhunen <janne.karhunen@gmail.com>
Signed-off-by: Konsta Karsisto <konsta.karsisto@gmail.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_policy.c |   44 +++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -263,7 +263,7 @@ static void ima_lsm_free_rule(struct ima
 static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
 {
 	struct ima_rule_entry *nentry;
-	int i, result;
+	int i;
 
 	nentry = kmalloc(sizeof(*nentry), GFP_KERNEL);
 	if (!nentry)
@@ -277,7 +277,7 @@ static struct ima_rule_entry *ima_lsm_co
 	memset(nentry->lsm, 0, FIELD_SIZEOF(struct ima_rule_entry, lsm));
 
 	for (i = 0; i < MAX_LSM_RULES; i++) {
-		if (!entry->lsm[i].rule)
+		if (!entry->lsm[i].args_p)
 			continue;
 
 		nentry->lsm[i].type = entry->lsm[i].type;
@@ -286,13 +286,13 @@ static struct ima_rule_entry *ima_lsm_co
 		if (!nentry->lsm[i].args_p)
 			goto out_err;
 
-		result = security_filter_rule_init(nentry->lsm[i].type,
-						   Audit_equal,
-						   nentry->lsm[i].args_p,
-						   &nentry->lsm[i].rule);
-		if (result == -EINVAL)
-			pr_warn("ima: rule for LSM \'%d\' is undefined\n",
-				entry->lsm[i].type);
+		security_filter_rule_init(nentry->lsm[i].type,
+					  Audit_equal,
+					  nentry->lsm[i].args_p,
+					  &nentry->lsm[i].rule);
+		if (!nentry->lsm[i].rule)
+			pr_warn("rule for LSM \'%s\' is undefined\n",
+				(char *)entry->lsm[i].args_p);
 	}
 	return nentry;
 
@@ -329,7 +329,7 @@ static void ima_lsm_update_rules(void)
 	list_for_each_entry_safe(entry, e, &ima_policy_rules, list) {
 		needs_update = 0;
 		for (i = 0; i < MAX_LSM_RULES; i++) {
-			if (entry->lsm[i].rule) {
+			if (entry->lsm[i].args_p) {
 				needs_update = 1;
 				break;
 			}
@@ -339,8 +339,7 @@ static void ima_lsm_update_rules(void)
 
 		result = ima_lsm_update_rule(entry);
 		if (result) {
-			pr_err("ima: lsm rule update error %d\n",
-				result);
+			pr_err("lsm rule update error %d\n", result);
 			return;
 		}
 	}
@@ -357,7 +356,7 @@ int ima_lsm_policy_change(struct notifie
 }
 
 /**
- * ima_match_rules - determine whether an inode matches the measure rule.
+ * ima_match_rules - determine whether an inode matches the policy rule.
  * @rule: a pointer to a rule
  * @inode: a pointer to an inode
  * @cred: a pointer to a credentials structure for user validation
@@ -415,9 +414,12 @@ static bool ima_match_rules(struct ima_r
 		int rc = 0;
 		u32 osid;
 
-		if (!rule->lsm[i].rule)
-			continue;
-
+		if (!rule->lsm[i].rule) {
+			if (!rule->lsm[i].args_p)
+				continue;
+			else
+				return false;
+		}
 		switch (i) {
 		case LSM_OBJ_USER:
 		case LSM_OBJ_ROLE:
@@ -822,8 +824,14 @@ static int ima_lsm_rule_init(struct ima_
 					   entry->lsm[lsm_rule].args_p,
 					   &entry->lsm[lsm_rule].rule);
 	if (!entry->lsm[lsm_rule].rule) {
-		kfree(entry->lsm[lsm_rule].args_p);
-		return -EINVAL;
+		pr_warn("rule for LSM \'%s\' is undefined\n",
+			(char *)entry->lsm[lsm_rule].args_p);
+
+		if (ima_rules == &ima_default_rules) {
+			kfree(entry->lsm[lsm_rule].args_p);
+			result = -EINVAL;
+		} else
+			result = 0;
 	}
 
 	return result;


