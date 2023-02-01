Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16C8685D74
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 03:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjBACmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 21:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjBACmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 21:42:20 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E774B485;
        Tue, 31 Jan 2023 18:42:18 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4P65kd16HpzJs9q;
        Wed,  1 Feb 2023 10:40:41 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 10:42:16 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <zohar@linux.ibm.com>,
        <paul@paul-moore.com>, <luhuaxin1@huawei.com>
Subject: [PATCH 4.19 3/3] ima: Handle -ESTALE returned by ima_filter_rule_match()
Date:   Wed, 1 Feb 2023 10:39:52 +0800
Message-ID: <20230201023952.30247-4-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230201023952.30247-1-guozihua@huawei.com>
References: <20230201023952.30247-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c7423dbdbc9ecef7fff5239d144cad4b9887f4de ]

IMA relies on the blocking LSM policy notifier callback to update the
LSM based IMA policy rules.

When SELinux update its policies, IMA would be notified and starts
updating all its lsm rules one-by-one. During this time, -ESTALE would
be returned by ima_filter_rule_match() if it is called with a LSM rule
that has not yet been updated. In ima_match_rules(), -ESTALE is not
handled, and the LSM rule is considered a match, causing extra files
to be measured by IMA.

Fix it by re-initializing a temporary rule if -ESTALE is returned by
ima_filter_rule_match(). The origin rule in the rule list would be
updated by the LSM policy notifier callback.

Fixes: b16942455193 ("ima: use the lsm policy update notifier")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 security/integrity/ima/ima_policy.c | 37 ++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 5a15524bca4c..9d500a06c710 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -375,6 +375,9 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 			    enum ima_hooks func, int mask)
 {
 	int i;
+	bool result = false;
+	struct ima_rule_entry *lsm_rule = rule;
+	bool rule_reinitialized = false;
 
 	if ((rule->flags & IMA_FUNC) &&
 	    (rule->func != func && func != POST_SETATTR))
@@ -413,35 +416,53 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 		int rc = 0;
 		u32 osid;
 
-		if (!rule->lsm[i].rule)
+		if (!lsm_rule->lsm[i].rule)
 			continue;
 
+retry:
 		switch (i) {
 		case LSM_OBJ_USER:
 		case LSM_OBJ_ROLE:
 		case LSM_OBJ_TYPE:
 			security_inode_getsecid(inode, &osid);
 			rc = security_filter_rule_match(osid,
-							rule->lsm[i].type,
+							lsm_rule->lsm[i].type,
 							Audit_equal,
-							rule->lsm[i].rule,
+							lsm_rule->lsm[i].rule,
 							NULL);
 			break;
 		case LSM_SUBJ_USER:
 		case LSM_SUBJ_ROLE:
 		case LSM_SUBJ_TYPE:
 			rc = security_filter_rule_match(secid,
-							rule->lsm[i].type,
+							lsm_rule->lsm[i].type,
 							Audit_equal,
-							rule->lsm[i].rule,
+							lsm_rule->lsm[i].rule,
 							NULL);
 		default:
 			break;
 		}
-		if (!rc)
-			return false;
+
+		if (rc == -ESTALE && !rule_reinitialized) {
+			lsm_rule = ima_lsm_copy_rule(rule);
+			if (lsm_rule) {
+				rule_reinitialized = true;
+				goto retry;
+			}
+		}
+		if (!rc) {
+			result = false;
+			goto out;
+		}
+	}
+	result = true;
+
+out:
+	if (rule_reinitialized) {
+		ima_lsm_free_rule(lsm_rule);
+		kfree(lsm_rule);
 	}
-	return true;
+	return result;
 }
 
 /*
-- 
2.17.1

