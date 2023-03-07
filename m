Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60206AEE9B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjCGSNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjCGSNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:13:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8DF72BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:08:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B98BB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54C6C433EF;
        Tue,  7 Mar 2023 18:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212534;
        bh=YuYhB/dKHorjUyZL4Inu0z7kFjwTLil0DAr9I6YhTa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5TnCatavdR3CHe6Kywd8IYAPUt/lzgCo4Sq9OfkFnyBdd45dXxCzfEeZE1gEAjPS
         UMyoOXdlvQL24HBoMCFwETgmE/p/BD50szHqUjW6Ua+XRcYsFSyvv5YV4Q7ytXQHvT
         lFguHAVhzRMiLlxjDd/vGftJw8/qEXP5VvuJMNdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/885] crypto: xts - Handle EBUSY correctly
Date:   Tue,  7 Mar 2023 17:51:58 +0100
Message-Id: <20230307170009.990489508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 51c082514c2dedf2711c99d93c196cc4eedceb40 ]

As it is xts only handles the special return value of EINPROGRESS,
which means that in all other cases it will free data related to the
request.

However, as the caller of xts may specify MAY_BACKLOG, we also need
to expect EBUSY and treat it in the same way.  Otherwise backlogged
requests will trigger a use-after-free.

Fixes: 8083b1bf8163 ("crypto: xts - add support for ciphertext stealing")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/xts.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 63c85b9e64e08..de6cbcf69bbd6 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -203,12 +203,12 @@ static void xts_encrypt_done(struct crypto_async_request *areq, int err)
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
-		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		err = xts_xor_tweak_post(req, true);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
 			err = xts_cts_final(req, crypto_skcipher_encrypt);
-			if (err == -EINPROGRESS)
+			if (err == -EINPROGRESS || err == -EBUSY)
 				return;
 		}
 	}
@@ -223,12 +223,12 @@ static void xts_decrypt_done(struct crypto_async_request *areq, int err)
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
-		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		err = xts_xor_tweak_post(req, false);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
 			err = xts_cts_final(req, crypto_skcipher_decrypt);
-			if (err == -EINPROGRESS)
+			if (err == -EINPROGRESS || err == -EBUSY)
 				return;
 		}
 	}
-- 
2.39.2



