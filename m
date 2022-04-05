Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331C24F2EB0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbiDEJE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243285AbiDEIuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C90C12AF2;
        Tue,  5 Apr 2022 01:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 267C061500;
        Tue,  5 Apr 2022 08:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F80CC385A1;
        Tue,  5 Apr 2022 08:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147911;
        bh=wxo5Qgm4ML6MQghSIyIPjrQXgvNxgJgLaqb67pNgPhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asGlX5E3gcurU0uTdjDN+GMNKXlfzFTkyDvvmhGdYlr3dmi725HpCmUCrtRv8+sER
         vxQ9j7FrjBuYjiwU5hVjb8ffzSWK8gvi3gB/4yh9FvyDbPtc6E5LrU2aiYlwWptJVr
         eQgn2o0L37EigUYBLkxUv29BRwdTeV21biqpsKBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.16 0167/1017] crypto: rsa-pkcs1pad - restore signature length check
Date:   Tue,  5 Apr 2022 09:18:00 +0200
Message-Id: <20220405070359.181100856@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit d3481accd974541e6a5d6a1fb588924a3519c36e upstream.

RSA PKCS#1 v1.5 signatures are required to be the same length as the RSA
key size.  RFC8017 specifically requires the verifier to check this
(https://datatracker.ietf.org/doc/html/rfc8017#section-8.2.2).

Commit a49de377e051 ("crypto: Add hash param to pkcs1pad") changed the
kernel to allow longer signatures, but didn't explain this part of the
change; it seems to be unrelated to the rest of the commit.

Revert this change, since it doesn't appear to be correct.

We can be pretty sure that no one is relying on overly-long signatures
(which would have to be front-padded with zeroes) being supported, given
that they would have been broken since commit c7381b012872
("crypto: akcipher - new verify API for public key algorithms").

Fixes: a49de377e051 ("crypto: Add hash param to pkcs1pad")
Cc: <stable@vger.kernel.org> # v4.6+
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Suggested-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/rsa-pkcs1pad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -538,7 +538,7 @@ static int pkcs1pad_verify(struct akciph
 
 	if (WARN_ON(req->dst) ||
 	    WARN_ON(!req->dst_len) ||
-	    !ctx->key_size || req->src_len < ctx->key_size)
+	    !ctx->key_size || req->src_len != ctx->key_size)
 		return -EINVAL;
 
 	req_ctx->out_buf = kmalloc(ctx->key_size + req->dst_len, GFP_KERNEL);


