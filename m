Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1145C4F41E6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379689AbiDEMYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356125AbiDEKW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42314B7169;
        Tue,  5 Apr 2022 03:06:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEBAAB81C8B;
        Tue,  5 Apr 2022 10:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39579C385A1;
        Tue,  5 Apr 2022 10:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153185;
        bh=EIqZGIC3MEY6zK++/3lavNvUv7djR+iZn/Z4aFTomR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlqGPqZrka7B7VyvIQ5jLmqWkaqX/E+H5xVYym/dRzmiAXcf4mD2m8QmZWowXXIVQ
         XnV8UTdtzEgvf0TBmXSECnaGo031A9lhyEmlhaY1cmqiDdZTcvP+xqonWXWM/Qe2NY
         UMCfaQFr8z/+2eCFGZm87R+gIq/qMtiz/Uv7pkVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/599] crypto: authenc - Fix sleep in atomic context in decrypt_tail
Date:   Tue,  5 Apr 2022 09:27:07 +0200
Message-Id: <20220405070302.799140357@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 66eae850333d639fc278d6f915c6fc01499ea893 ]

The function crypto_authenc_decrypt_tail discards its flags
argument and always relies on the flags from the original request
when starting its sub-request.

This is clearly wrong as it may cause the SLEEPABLE flag to be
set when it shouldn't.

Fixes: 92d95ba91772 ("crypto: authenc - Convert to new AEAD interface")
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/authenc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 670bf1a01d00..17f674a7cdff 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -253,7 +253,7 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
-	skcipher_request_set_callback(skreq, aead_request_flags(req),
+	skcipher_request_set_callback(skreq, flags,
 				      req->base.complete, req->base.data);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
-- 
2.34.1



