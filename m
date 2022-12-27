Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBDE6566A2
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 02:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiL0Buz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Dec 2022 20:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiL0But (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Dec 2022 20:50:49 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFEA326;
        Mon, 26 Dec 2022 17:50:47 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NgyJC0KBvz16LqT;
        Tue, 27 Dec 2022 09:49:31 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 27 Dec
 2022 09:50:45 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <zohar@linux.ibm.com>
CC:     <paul@paul-moore.com>, <linux-integrity@vger.kernel.org>,
        <luhuaxin1@huawei.com>
Subject: [PATCH 1/2] ima: use the lsm policy update notifier
Date:   Tue, 27 Dec 2022 09:47:28 +0800
Message-ID: <20221227014729.4799-2-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221227014729.4799-1-guozihua@huawei.com>
References: <20221227014729.4799-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janne Karhunen <janne.karhunen@gmail.com>

[ Upstream commit b169424551930a9325f700f502802f4d515194e5 ]

This patch is backported to resolve the issue of IMA ignoreing LSM part of
an LSM based rule. As the LSM notifier chain was an atomic notifier
chain, we'll not be able to call synchronize_rcu() within our notifier
handling function.

Original patch message is as follows:

  Don't do lazy policy updates while running the rule matching,
  run the updates as they happen.

  Depends on commit f242064c5df3 ("LSM: switch to blocking policy
  update notifiers")

Signed-off-by: Janne Karhunen <janne.karhunen@gmail.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: stable@vger.kernel.org #4.19.y
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 security/integrity/ima/ima.h        |   2 +
 security/integrity/ima/ima_main.c   |   8 ++
 security/integrity/ima/ima_policy.c | 115 +++++++++++++++++++++++-----
 3 files changed, 105 insertions(+), 20 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index e2916b115b93..dc564ed9a790 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -154,6 +154,8 @@ int ima_measurements_show(struct seq_file *m, void *v);
 unsigned long ima_get_binary_runtime_size(void);
 int ima_init_template(void);
 void ima_init_template_list(void);
+int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
+			  void *lsm_data);
 
 /*
  * used to protect h_table and sha_table
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2d31921fbda4..f461b3e2de00 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -41,6 +41,10 @@ int ima_appraise;
 int ima_hash_algo = HASH_ALGO_SHA1;
 static int hash_setup_done;
 
+static struct notifier_block ima_lsm_policy_notifier = {
+	.notifier_call = ima_lsm_policy_change,
+};
+
 static int __init hash_setup(char *str)
 {
 	struct ima_template_desc *template_desc = ima_template_desc_current();
@@ -553,6 +557,10 @@ static int __init init_ima(void)
 		error = ima_init();
 	}
 
+	error = register_lsm_notifier(&ima_lsm_policy_notifier);
+	if (error)
+		pr_warn("Couldn't register LSM notifier, error %d\n", error);
+
 	if (!error)
 		ima_update_policy_flag();
 
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index b2dadff3626b..1e0251e9510a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -256,31 +256,112 @@ static void ima_free_rule(struct ima_rule_entry *entry)
 	kfree(entry);
 }
 
+static void ima_lsm_free_rule(struct ima_rule_entry *entry)
+{
+	int i;
+
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		kfree(entry->lsm[i].rule);
+		kfree(entry->lsm[i].args_p);
+	}
+	kfree(entry);
+}
+
+static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
+{
+	struct ima_rule_entry *nentry;
+	int i, result;
+
+	nentry = kmalloc(sizeof(*nentry), GFP_KERNEL);
+	if (!nentry)
+		return NULL;
+
+	/*
+	 * Immutable elements are copied over as pointers and data; only
+	 * lsm rules can change
+	 */
+	memcpy(nentry, entry, sizeof(*nentry));
+	memset(nentry->lsm, 0, FIELD_SIZEOF(struct ima_rule_entry, lsm));
+
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		if (!entry->lsm[i].rule)
+			continue;
+
+		nentry->lsm[i].type = entry->lsm[i].type;
+		nentry->lsm[i].args_p = kstrdup(entry->lsm[i].args_p,
+						GFP_KERNEL);
+		if (!nentry->lsm[i].args_p)
+			goto out_err;
+
+		result = security_filter_rule_init(nentry->lsm[i].type,
+						   Audit_equal,
+						   nentry->lsm[i].args_p,
+						   &nentry->lsm[i].rule);
+		if (result == -EINVAL)
+			pr_warn("ima: rule for LSM \'%d\' is undefined\n",
+				entry->lsm[i].type);
+	}
+	return nentry;
+
+out_err:
+	ima_lsm_free_rule(nentry);
+	return NULL;
+}
+
+static int ima_lsm_update_rule(struct ima_rule_entry *entry)
+{
+	struct ima_rule_entry *nentry;
+
+	nentry = ima_lsm_copy_rule(entry);
+	if (!nentry)
+		return -ENOMEM;
+
+	list_replace_rcu(&entry->list, &nentry->list);
+	ima_lsm_free_rule(entry);
+
+	return 0;
+}
+
 /*
  * The LSM policy can be reloaded, leaving the IMA LSM based rules referring
  * to the old, stale LSM policy.  Update the IMA LSM based rules to reflect
- * the reloaded LSM policy.  We assume the rules still exist; and BUG_ON() if
- * they don't.
+ * the reloaded LSM policy.
  */
 static void ima_lsm_update_rules(void)
 {
-	struct ima_rule_entry *entry;
-	int result;
-	int i;
+	struct ima_rule_entry *entry, *e;
+	int i, result, needs_update;
 
-	list_for_each_entry(entry, &ima_policy_rules, list) {
+	list_for_each_entry_safe(entry, e, &ima_policy_rules, list) {
+		needs_update = 0;
 		for (i = 0; i < MAX_LSM_RULES; i++) {
-			if (!entry->lsm[i].rule)
-				continue;
-			result = security_filter_rule_init(entry->lsm[i].type,
-							   Audit_equal,
-							   entry->lsm[i].args_p,
-							   &entry->lsm[i].rule);
-			BUG_ON(!entry->lsm[i].rule);
+			if (entry->lsm[i].rule) {
+				needs_update = 1;
+				break;
+			}
+		}
+		if (!needs_update)
+			continue;
+
+		result = ima_lsm_update_rule(entry);
+		if (result) {
+			pr_err("ima: lsm rule update error %d\n",
+				result);
+			return;
 		}
 	}
 }
 
+int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
+			  void *lsm_data)
+{
+	if (event != LSM_POLICY_CHANGE)
+		return NOTIFY_DONE;
+
+	ima_lsm_update_rules();
+	return NOTIFY_OK;
+}
+
 /**
  * ima_match_rules - determine whether an inode matches the measure rule.
  * @rule: a pointer to a rule
@@ -334,11 +415,10 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;
 		u32 osid;
-		int retried = 0;
 
 		if (!rule->lsm[i].rule)
 			continue;
-retry:
+
 		switch (i) {
 		case LSM_OBJ_USER:
 		case LSM_OBJ_ROLE:
@@ -361,11 +441,6 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 		default:
 			break;
 		}
-		if ((rc < 0) && (!retried)) {
-			retried = 1;
-			ima_lsm_update_rules();
-			goto retry;
-		}
 		if (!rc)
 			return false;
 	}
-- 
2.17.1

