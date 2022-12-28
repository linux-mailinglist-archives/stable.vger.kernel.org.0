Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B917658421
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbiL1QzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiL1Qy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:54:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7871AA0F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2852361579
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35365C433F0;
        Wed, 28 Dec 2022 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246153;
        bh=7kbCR2crzDvx9icrq7XfxiKCXACYh1djJjgz3X3iK4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJJSar5/aDiqY+PfMJ0+uYnOHFF3VDb6zI0syk77/zCEfANHs6yRnScCthyRKam8i
         Szzj5z3LT4D6SBz530dgJ5o8gZiT+bQk2ozUpKuiAOSjrQ30KrmLZPDfrGPgcLRCiD
         4+nWvq93tS2cI5FbV30iqNItO7q6RptZKUk5xnR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, GUO Zihua <guozihua@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1021/1073] ima: Simplify ima_lsm_copy_rule
Date:   Wed, 28 Dec 2022 15:43:29 +0100
Message-Id: <20221228144355.921710026@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit d57378d3aa4d864d9e590482602068af1b20c0c5 ]

Currently ima_lsm_copy_rule() set the arg_p field of the source rule to
NULL, so that the source rule could be freed afterward. It does not make
sense for this behavior to be inside a "copy" function. So move it
outside and let the caller handle this field.

ima_lsm_copy_rule() now produce a shallow copy of the original entry
including args_p field. Meaning only the lsm.rule and the rule itself
should be freed for the original rule. Thus, instead of calling
ima_lsm_free_rule() which frees lsm.rule as well as args_p field, free
the lsm.rule directly.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_policy.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index bb3707160b01..2edff7f58c25 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -398,12 +398,6 @@ static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
 
 		nentry->lsm[i].type = entry->lsm[i].type;
 		nentry->lsm[i].args_p = entry->lsm[i].args_p;
-		/*
-		 * Remove the reference from entry so that the associated
-		 * memory will not be freed during a later call to
-		 * ima_lsm_free_rule(entry).
-		 */
-		entry->lsm[i].args_p = NULL;
 
 		ima_filter_rule_init(nentry->lsm[i].type, Audit_equal,
 				     nentry->lsm[i].args_p,
@@ -417,6 +411,7 @@ static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
 
 static int ima_lsm_update_rule(struct ima_rule_entry *entry)
 {
+	int i;
 	struct ima_rule_entry *nentry;
 
 	nentry = ima_lsm_copy_rule(entry);
@@ -431,7 +426,8 @@ static int ima_lsm_update_rule(struct ima_rule_entry *entry)
 	 * references and the entry itself. All other memory references will now
 	 * be owned by nentry.
 	 */
-	ima_lsm_free_rule(entry);
+	for (i = 0; i < MAX_LSM_RULES; i++)
+		ima_filter_rule_free(entry->lsm[i].rule);
 	kfree(entry);
 
 	return 0;
-- 
2.35.1



