Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EC96B4996
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbjCJPOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbjCJPNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:13:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2089A12F06
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA554B822F2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17886C433A8;
        Fri, 10 Mar 2023 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459814;
        bh=RAIavJ4jffJjiEf39bOfpPl/k1lTu4zr/NqLx957w7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+8tBXLCsDT9S93dIdBYPptqtMURhflziwiuDxi5upNcqGR1CBo73sRHqLGtgjuiI
         Q8OvaIzGJDD0+pYNzpop2fN8IbohRzZaZ/tWgro8Cg8WHdNEyVIH1GqoarTn5aJHjq
         CAD3imEuuQVPaq/mlVwQLEarZbVg8vhldYVzVxnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/529] crypto: rsa-pkcs1pad - Use akcipher_request_complete
Date:   Fri, 10 Mar 2023 14:34:32 +0100
Message-Id: <20230310133810.950448903@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 564cabc0ca0bdfa8f0fc1ae74b24d0a7554522c5 ]

Use the akcipher_request_complete helper instead of calling the
completion function directly.  In fact the previous code was buggy
in that EINPROGRESS was never passed back to the original caller.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rsa-pkcs1pad.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 9d804831c8b3f..a4ebbb889274e 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -214,16 +214,14 @@ static void pkcs1pad_encrypt_sign_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
+
+	err = pkcs1pad_encrypt_sign_complete(req, err);
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req,
-			pkcs1pad_encrypt_sign_complete(req, err));
+out:
+	akcipher_request_complete(req, err);
 }
 
 static int pkcs1pad_encrypt(struct akcipher_request *req)
@@ -332,15 +330,14 @@ static void pkcs1pad_decrypt_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
+
+	err = pkcs1pad_decrypt_complete(req, err);
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req, pkcs1pad_decrypt_complete(req, err));
+out:
+	akcipher_request_complete(req, err);
 }
 
 static int pkcs1pad_decrypt(struct akcipher_request *req)
@@ -512,15 +509,14 @@ static void pkcs1pad_verify_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req, pkcs1pad_verify_complete(req, err));
+	err = pkcs1pad_verify_complete(req, err);
+
+out:
+	akcipher_request_complete(req, err);
 }
 
 /*
-- 
2.39.2



