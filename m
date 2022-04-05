Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511E94F2582
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiDEHuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiDEHsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C128C281;
        Tue,  5 Apr 2022 00:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5486BB81BA4;
        Tue,  5 Apr 2022 07:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A52C3410F;
        Tue,  5 Apr 2022 07:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144760;
        bh=jLJHdncUYIgkXzg4FNI//hgrXP1ygYahSZ/ZDNplSPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfPnZZzE9L01obbt4bCXJrRUyUVhENl0f/IiDBiEpVVjQURWnPziIzh0uMFHpZI0t
         dUasT5zfA5IZfMwL6Wh3qoCxUzbgGTpyDlxk0sH2r/z8kAOiCrTTxeLpQVAIn9DJ2k
         zb1/DC3hNkBBsBJfAVKIGeHa/mDQtS0klwN72SRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.17 0161/1126] crypto: rsa-pkcs1pad - correctly get hash from source scatterlist
Date:   Tue,  5 Apr 2022 09:15:08 +0200
Message-Id: <20220405070412.318064223@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit e316f7179be22912281ce6331d96d7c121fb2b17 upstream.

Commit c7381b012872 ("crypto: akcipher - new verify API for public key
algorithms") changed akcipher_alg::verify to take in both the signature
and the actual hash and do the signature verification, rather than just
return the hash expected by the signature as was the case before.  To do
this, it implemented a hack where the signature and hash are
concatenated with each other in one scatterlist.

Obviously, for this to work correctly, akcipher_alg::verify needs to
correctly extract the two items from the scatterlist it is given.
Unfortunately, it doesn't correctly extract the hash in the case where
the signature is longer than the RSA key size, as it assumes that the
signature's length is equal to the RSA key size.  This causes a prefix
of the hash, or even the entire hash, to be taken from the *signature*.

(Note, the case of a signature longer than the RSA key size should not
be allowed in the first place; a separate patch will fix that.)

It is unclear whether the resulting scheme has any useful security
properties.

Fix this by correctly extracting the hash from the scatterlist.

Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/rsa-pkcs1pad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -495,7 +495,7 @@ static int pkcs1pad_verify_complete(stru
 			   sg_nents_for_len(req->src,
 					    req->src_len + req->dst_len),
 			   req_ctx->out_buf + ctx->key_size,
-			   req->dst_len, ctx->key_size);
+			   req->dst_len, req->src_len);
 	/* Do the actual verification step. */
 	if (memcmp(req_ctx->out_buf + ctx->key_size, out_buf + pos,
 		   req->dst_len) != 0)


