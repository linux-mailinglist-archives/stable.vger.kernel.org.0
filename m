Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCBD2F16BA
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbhAKNHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730532AbhAKNHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:07:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD1722251F;
        Mon, 11 Jan 2021 13:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370390;
        bh=qUziF+x+vkE7l0Qc0ydsWSwZ/md35vyMtcMMyR3TadA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXMuAogKNWGrhQWt19FK3ucUaUZkMLOSjn7p1mQaajvCxsRmPiLc5AHUAtnz9oY5/
         0ziPe4dUIRntze1ERJLTtJHfJHBEQOJ44xPVftFJqmB+UrHPcJABlArp/KgBsTYvs7
         2hVZ6K9x9BeNMwBF4IkkTOxAWTnLQo0vR1wJIaxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 28/57] crypto: ecdh - avoid buffer overflow in ecdh_set_secret()
Date:   Mon, 11 Jan 2021 14:01:47 +0100
Message-Id: <20210111130035.076633853@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 0aa171e9b267ce7c52d3a3df7bc9c1fc0203dec5 upstream.

Pavel reports that commit 17858b140bf4 ("crypto: ecdh - avoid unaligned
accesses in ecdh_set_secret()") fixes one problem but introduces another:
the unconditional memcpy() introduced by that commit may overflow the
target buffer if the source data is invalid, which could be the result of
intentional tampering.

So check params.key_size explicitly against the size of the target buffer
before validating the key further.

Fixes: 17858b140bf4 ("crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()")
Reported-by: Pavel Machek <pavel@denx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/ecdh.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -43,7 +43,8 @@ static int ecdh_set_secret(struct crypto
 	struct ecdh params;
 	unsigned int ndigits;
 
-	if (crypto_ecdh_decode_key(buf, len, &params) < 0)
+	if (crypto_ecdh_decode_key(buf, len, &params) < 0 ||
+	    params.key_size > sizeof(ctx->private_key))
 		return -EINVAL;
 
 	ndigits = ecdh_supported_curve(params.curve_id);


