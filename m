Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3A64F2616
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiDEHyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiDEHyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:54:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D959B1EEE9;
        Tue,  5 Apr 2022 00:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67807B81B90;
        Tue,  5 Apr 2022 07:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF336C36AE2;
        Tue,  5 Apr 2022 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144951;
        bh=/zcQWl4cnL+I3ZfuME7Mb0EVNvIwIq8FHZw1BCbA7oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BD6ZMGVlEWSlQyd1lrUTLJmvUURtVtO8bgcZxYpOcJQ6nxzMK6TPetQyfwpezS/eQ
         kyp39hpKyvLLFP/tg3ZOLwtC3o8O9LAcqBUkZIcbxXqaupihABVHL9G8PmJBgT6F08
         M846zX3v8qRWbTioQxRjMJah5ZHICE2Xbeo3vrqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0231/1126] crypto: hisilicon/sec - fix the aead software fallback for engine
Date:   Tue,  5 Apr 2022 09:16:18 +0200
Message-Id: <20220405070414.388627376@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 0a2a464f863187f97e96ebc6384c052cafd4a54c ]

Due to the subreq pointer misuse the private context memory. The aead
soft crypto occasionally casues the OS panic as setting the 64K page.
Here is fix it.

Fixes: 6c46a3297bea ("crypto: hisilicon/sec - add fallback tfm...")
Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 6a45bd23b363..090920ed50c8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2284,9 +2284,10 @@ static int sec_aead_soft_crypto(struct sec_ctx *ctx,
 				struct aead_request *aead_req,
 				bool encrypt)
 {
-	struct aead_request *subreq = aead_request_ctx(aead_req);
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 	struct device *dev = ctx->dev;
+	struct aead_request *subreq;
+	int ret;
 
 	/* Kunpeng920 aead mode not support input 0 size */
 	if (!a_ctx->fallback_aead_tfm) {
@@ -2294,6 +2295,10 @@ static int sec_aead_soft_crypto(struct sec_ctx *ctx,
 		return -EINVAL;
 	}
 
+	subreq = aead_request_alloc(a_ctx->fallback_aead_tfm, GFP_KERNEL);
+	if (!subreq)
+		return -ENOMEM;
+
 	aead_request_set_tfm(subreq, a_ctx->fallback_aead_tfm);
 	aead_request_set_callback(subreq, aead_req->base.flags,
 				  aead_req->base.complete, aead_req->base.data);
@@ -2301,8 +2306,13 @@ static int sec_aead_soft_crypto(struct sec_ctx *ctx,
 			       aead_req->cryptlen, aead_req->iv);
 	aead_request_set_ad(subreq, aead_req->assoclen);
 
-	return encrypt ? crypto_aead_encrypt(subreq) :
-		   crypto_aead_decrypt(subreq);
+	if (encrypt)
+		ret = crypto_aead_encrypt(subreq);
+	else
+		ret = crypto_aead_decrypt(subreq);
+	aead_request_free(subreq);
+
+	return ret;
 }
 
 static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
-- 
2.34.1



