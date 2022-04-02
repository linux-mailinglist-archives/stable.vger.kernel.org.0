Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A5F4F0194
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354222AbiDBMqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353001AbiDBMqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4794D63A7
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7DE361469
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC19C340EC;
        Sat,  2 Apr 2022 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648903449;
        bh=k5ZCqRcWMPf6ba0lRyO3cOElD6DXsoWIYsKBA/46RhA=;
        h=Subject:To:Cc:From:Date:From;
        b=E9IW/y/BcpYz4K97WTAWbnNa/FDdrD9PnImjLBxZ4kENcGRLjaXKqKNF7elKeqtg0
         LZRq+MIHiIJg1VCdxRlI0Tbt2G9cQxGAUFJKC90ahkEj0kfmbM0Pg7z9U4QoaDHGGl
         mgIoVyxzAhjMJ61EwReR2Ui4/bcQRZ17f0f3dVuk=
Subject: FAILED: patch "[PATCH] crypto: rsa-pkcs1pad - restore signature length check" failed to apply to 4.14-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org, tadeusz.struk@linaro.org, vt@altlinux.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:43:58 +0200
Message-ID: <164890343866191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3481accd974541e6a5d6a1fb588924a3519c36e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 18 Jan 2022 16:13:04 -0800
Subject: [PATCH] crypto: rsa-pkcs1pad - restore signature length check

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

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 7b223adebabf..6b556ddeb3a0 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -538,7 +538,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 
 	if (WARN_ON(req->dst) ||
 	    WARN_ON(!req->dst_len) ||
-	    !ctx->key_size || req->src_len < ctx->key_size)
+	    !ctx->key_size || req->src_len != ctx->key_size)
 		return -EINVAL;
 
 	req_ctx->out_buf = kmalloc(ctx->key_size + req->dst_len, GFP_KERNEL);

