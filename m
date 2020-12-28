Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B903C2E4371
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408499AbgL1Pdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404230AbgL1NyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 136B3206D4;
        Mon, 28 Dec 2020 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163648;
        bh=C4Xx29pfeW0Sm72GZwO45w63PsyaxlpmUCXJGWfKUyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGfHd7I7CzfQlso2+AFxWg5F+gs2HAMPaTQe+HGAwif19Igg4vMxGTtfmhr1s22s5
         dwgR+oeCuoW99LWWFXNCj3fCcZKI2j1v2AU6fZ60ujLuZkjUjkEDlVK6g073MbGkZT
         q0efK1Vv35b4FRYHdV8tF1p4gxFjdY2przt/kbMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 359/453] crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()
Date:   Mon, 28 Dec 2020 13:49:55 +0100
Message-Id: <20201228124954.484259579@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 17858b140bf49961b71d4e73f1c3ea9bc8e7dda0 upstream.

ecdh_set_secret() casts a void* pointer to a const u64* in order to
feed it into ecc_is_key_valid(). This is not generally permitted by
the C standard, and leads to actual misalignment faults on ARMv6
cores. In some cases, these are fixed up in software, but this still
leads to performance hits that are entirely avoidable.

So let's copy the key into the ctx buffer first, which we will do
anyway in the common case, and which guarantees correct alignment.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/ecdh.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -53,12 +53,13 @@ static int ecdh_set_secret(struct crypto
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);
 
-	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
-			     (const u64 *)params.key, params.key_size) < 0)
-		return -EINVAL;
-
 	memcpy(ctx->private_key, params.key, params.key_size);
 
+	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
+			     ctx->private_key, params.key_size) < 0) {
+		memzero_explicit(ctx->private_key, params.key_size);
+		return -EINVAL;
+	}
 	return 0;
 }
 


