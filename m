Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A44657C98
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbiL1PeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiL1PeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:34:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C487315FC3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:34:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 602E26154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C2BC433D2;
        Wed, 28 Dec 2022 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241652;
        bh=q39LaOa2W43HErDuWLiPWEb7xwgNIST8ul/1nBzXxHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZStf0z76dy4U7ymAcpjsanwfjrORxWe/sEIY8xTczlk5aZwSJDGwAx/JbzGFjOkX
         dCmqMdvyZ6v1GBZOJ7UnGoCuAsJE8BZAVWstBOlWj516IpM9Ocfq97a24klygITKKO
         gn3kYdqJmXvc+p2efWP63ozz384kHnIyqRzMOMxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, GUO Zihua <guozihua@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0273/1146] ima: Handle -ESTALE returned by ima_filter_rule_match()
Date:   Wed, 28 Dec 2022 15:30:12 +0100
Message-Id: <20221228144337.550500105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 41 ++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a8802b8da946..bb3707160b01 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -549,6 +549,9 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 			    const char *func_data)
 {
 	int i;
+	bool result = false;
+	struct ima_rule_entry *lsm_rule = rule;
+	bool rule_reinitialized = false;
 
 	if ((rule->flags & IMA_FUNC) &&
 	    (rule->func != func && func != POST_SETATTR))
@@ -610,35 +613,55 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 		int rc = 0;
 		u32 osid;
 
-		if (!rule->lsm[i].rule) {
-			if (!rule->lsm[i].args_p)
+		if (!lsm_rule->lsm[i].rule) {
+			if (!lsm_rule->lsm[i].args_p)
 				continue;
 			else
 				return false;
 		}
+
+retry:
 		switch (i) {
 		case LSM_OBJ_USER:
 		case LSM_OBJ_ROLE:
 		case LSM_OBJ_TYPE:
 			security_inode_getsecid(inode, &osid);
-			rc = ima_filter_rule_match(osid, rule->lsm[i].type,
+			rc = ima_filter_rule_match(osid, lsm_rule->lsm[i].type,
 						   Audit_equal,
-						   rule->lsm[i].rule);
+						   lsm_rule->lsm[i].rule);
 			break;
 		case LSM_SUBJ_USER:
 		case LSM_SUBJ_ROLE:
 		case LSM_SUBJ_TYPE:
-			rc = ima_filter_rule_match(secid, rule->lsm[i].type,
+			rc = ima_filter_rule_match(secid, lsm_rule->lsm[i].type,
 						   Audit_equal,
-						   rule->lsm[i].rule);
+						   lsm_rule->lsm[i].rule);
 			break;
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
 	}
-	return true;
+	result = true;
+
+out:
+	if (rule_reinitialized) {
+		for (i = 0; i < MAX_LSM_RULES; i++)
+			ima_filter_rule_free(lsm_rule->lsm[i].rule);
+		kfree(lsm_rule);
+	}
+	return result;
 }
 
 /*
-- 
2.35.1



