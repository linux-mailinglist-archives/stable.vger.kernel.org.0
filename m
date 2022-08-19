Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B42C59A06A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352060AbiHSQTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352002AbiHSQO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:14:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0061D13D09;
        Fri, 19 Aug 2022 08:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CF5361644;
        Fri, 19 Aug 2022 15:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B44C433D6;
        Fri, 19 Aug 2022 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924704;
        bh=hrZ+pMMWOm9U7SjpZV9VqjIu8w+tqgwe3RsxT4IBplE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l36taMJ/cpGqfgPxzSlc52DkNDyLC0rm6/bKYi+1OnzIKdTjYBJxVW7+/vDpQvW/6
         pqpYMSZ3JEaLxVE5JgzkYhkjn06tunn1egY0cSVvIGm9fPqWpGCvvnxwScoLtSnmlc
         150j4rOuk8YJ2aSUOecz0GXn92BrG+XfF0dXsXCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/545] crypto: hisilicon/sec - fix auth key size error
Date:   Fri, 19 Aug 2022 17:40:26 +0200
Message-Id: <20220819153840.799899505@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 45f5d0176d8426cc1ab0bab84fbd8ef5c57526c6 ]

The authentication algorithm supports a maximum of 128-byte keys.
The allocated key memory is insufficient.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 6 +++---
 drivers/crypto/hisilicon/sec2/sec_crypto.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 39d2af84d953..2dbec638cca8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -516,7 +516,7 @@ static int sec_auth_init(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 
-	a_ctx->a_key = dma_alloc_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
+	a_ctx->a_key = dma_alloc_coherent(ctx->dev, SEC_MAX_AKEY_SIZE,
 					  &a_ctx->a_key_dma, GFP_KERNEL);
 	if (!a_ctx->a_key)
 		return -ENOMEM;
@@ -528,8 +528,8 @@ static void sec_auth_uninit(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 
-	memzero_explicit(a_ctx->a_key, SEC_MAX_KEY_SIZE);
-	dma_free_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
+	memzero_explicit(a_ctx->a_key, SEC_MAX_AKEY_SIZE);
+	dma_free_coherent(ctx->dev, SEC_MAX_AKEY_SIZE,
 			  a_ctx->a_key, a_ctx->a_key_dma);
 }
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 1db2ae4b7b66..20f11e5bbf1d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -6,6 +6,7 @@
 
 #define SEC_IV_SIZE		24
 #define SEC_MAX_KEY_SIZE	64
+#define SEC_MAX_AKEY_SIZE	128
 #define SEC_COMM_SCENE		0
 
 enum sec_calg {
-- 
2.35.1



