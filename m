Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5422957AC56
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241774AbiGTBWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241703AbiGTBVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:21:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91206FA0E;
        Tue, 19 Jul 2022 18:16:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5BCFB81DE8;
        Wed, 20 Jul 2022 01:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF22C341CA;
        Wed, 20 Jul 2022 01:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279779;
        bh=WP6r6LQNJO2+9pHuPQRmTbKrAoo3ff+tZkivkVuHCjY=;
        h=From:To:Cc:Subject:Date:From;
        b=it6b/flguRzXz16kLQg48EuKJ2BcbkcuUTNIWhFwdiufquknzBc2m1ZngWl17/GlS
         64jPOlTyWTvKi+C4eXcBJ76mkc7nOT7HUlhityh7Tm0WZG1Gz0aJ4W1bdxfOiGMQsx
         YW9YyIRYJUoPx3gPsvyGRm8dLJLBHcx/kfbhUvpMxVtCz6iupYF3GPtvyJHl7DyR3e
         euvEFtRrAg7kUwzANAeC//mVmNiDZtcSctBotLa2EeB+QLy1hfH1jCUrzqwLCrnX+s
         mQgirpccFhesxJiLGQ1IO7FYFJRE+dqQQrd+8D4O8d9DRiVM0y0NDM5KO8q7brOPtV
         ZKUKh8OWqnlCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiu Jianfeng <xiujianfeng@huawei.com>,
        Guozihua <guozihua@huawei.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, dmitry.kasatkin@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/25] Revert "evm: Fix memleak in init_desc"
Date:   Tue, 19 Jul 2022 21:15:52 -0400
Message-Id: <20220720011616.1024753-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 51dd64bb99e4478fc5280171acd8e1b529eadaf7 ]

This reverts commit ccf11dbaa07b328fa469415c362d33459c140a37.

Commit ccf11dbaa07b ("evm: Fix memleak in init_desc") said there is
memleak in init_desc. That may be incorrect, as we can see, tmp_tfm is
saved in one of the two global variables hmac_tfm or evm_tfm[hash_algo],
then if init_desc is called next time, there is no need to alloc tfm
again, so in the error path of kmalloc desc or crypto_shash_init(desc),
It is not a problem without freeing tmp_tfm.

And also that commit did not reset the global variable to NULL after
freeing tmp_tfm and this makes *tfm a dangling pointer which may cause a
UAF issue.

Reported-by: Guozihua (Scott) <guozihua@huawei.com>
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index a6dd47eb086d..168c3b78ac47 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -73,7 +73,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 {
 	long rc;
 	const char *algo;
-	struct crypto_shash **tfm, *tmp_tfm = NULL;
+	struct crypto_shash **tfm, *tmp_tfm;
 	struct shash_desc *desc;
 
 	if (type == EVM_XATTR_HMAC) {
@@ -118,16 +118,13 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 alloc:
 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(*tfm),
 			GFP_KERNEL);
-	if (!desc) {
-		crypto_free_shash(tmp_tfm);
+	if (!desc)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	desc->tfm = *tfm;
 
 	rc = crypto_shash_init(desc);
 	if (rc) {
-		crypto_free_shash(tmp_tfm);
 		kfree(desc);
 		return ERR_PTR(rc);
 	}
-- 
2.35.1

