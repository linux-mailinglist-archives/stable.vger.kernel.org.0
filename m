Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C283289CB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbhCASFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234720AbhCASAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:00:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6E9365251;
        Mon,  1 Mar 2021 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619686;
        bh=pqrhmPyDjMr2fZPyt0EqJlUE/+Fvq26jV/4AtpESwnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZDfbtqLvIPU1Kv+F6Dm5La8MxVIpzX18AXAxEh58io6lW1NGYVk1nwxt28Q0YuJ8
         RmHcls//qnRYM2oOlyqyrfhCJgL/d1KatW+tbTzyDuFlbWBHgw8IJ33PTDBL47VnVw
         5ddID01P/GwkPlzaTg+H537TwC+NV1EwAH9nMamc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 544/663] crypto: michael_mic - fix broken misalignment handling
Date:   Mon,  1 Mar 2021 17:13:12 +0100
Message-Id: <20210301161208.787267311@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit e1b2d980f03b833442768c1987d5ad0b9a58cfe7 upstream.

The Michael MIC driver uses the cra_alignmask to ensure that pointers
presented to its update and finup/final methods are 32-bit aligned.
However, due to the way the shash API works, this is no guarantee that
the 32-bit reads occurring in the update method are also aligned, as the
size of the buffer presented to update may be of uneven length. For
instance, an update() of 3 bytes followed by a misaligned update() of 4
or more bytes will result in a misaligned access using an accessor that
is not suitable for this.

On most architectures, this does not matter, and so setting the
cra_alignmask is pointless. On architectures where this does matter,
setting the cra_alignmask does not actually solve the problem.

So let's get rid of the cra_alignmask, and use unaligned accessors
instead, where appropriate.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/michael_mic.c |   31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -7,7 +7,7 @@
  * Copyright (c) 2004 Jouni Malinen <j@w1.fi>
  */
 #include <crypto/internal/hash.h>
-#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
@@ -19,7 +19,7 @@ struct michael_mic_ctx {
 };
 
 struct michael_mic_desc_ctx {
-	u8 pending[4];
+	__le32 pending;
 	size_t pending_len;
 
 	u32 l, r;
@@ -60,13 +60,12 @@ static int michael_update(struct shash_d
 			   unsigned int len)
 {
 	struct michael_mic_desc_ctx *mctx = shash_desc_ctx(desc);
-	const __le32 *src;
 
 	if (mctx->pending_len) {
 		int flen = 4 - mctx->pending_len;
 		if (flen > len)
 			flen = len;
-		memcpy(&mctx->pending[mctx->pending_len], data, flen);
+		memcpy((u8 *)&mctx->pending + mctx->pending_len, data, flen);
 		mctx->pending_len += flen;
 		data += flen;
 		len -= flen;
@@ -74,23 +73,21 @@ static int michael_update(struct shash_d
 		if (mctx->pending_len < 4)
 			return 0;
 
-		src = (const __le32 *)mctx->pending;
-		mctx->l ^= le32_to_cpup(src);
+		mctx->l ^= le32_to_cpu(mctx->pending);
 		michael_block(mctx->l, mctx->r);
 		mctx->pending_len = 0;
 	}
 
-	src = (const __le32 *)data;
-
 	while (len >= 4) {
-		mctx->l ^= le32_to_cpup(src++);
+		mctx->l ^= get_unaligned_le32(data);
 		michael_block(mctx->l, mctx->r);
+		data += 4;
 		len -= 4;
 	}
 
 	if (len > 0) {
 		mctx->pending_len = len;
-		memcpy(mctx->pending, src, len);
+		memcpy(&mctx->pending, data, len);
 	}
 
 	return 0;
@@ -100,8 +97,7 @@ static int michael_update(struct shash_d
 static int michael_final(struct shash_desc *desc, u8 *out)
 {
 	struct michael_mic_desc_ctx *mctx = shash_desc_ctx(desc);
-	u8 *data = mctx->pending;
-	__le32 *dst = (__le32 *)out;
+	u8 *data = (u8 *)&mctx->pending;
 
 	/* Last block and padding (0x5a, 4..7 x 0) */
 	switch (mctx->pending_len) {
@@ -123,8 +119,8 @@ static int michael_final(struct shash_de
 	/* l ^= 0; */
 	michael_block(mctx->l, mctx->r);
 
-	dst[0] = cpu_to_le32(mctx->l);
-	dst[1] = cpu_to_le32(mctx->r);
+	put_unaligned_le32(mctx->l, out);
+	put_unaligned_le32(mctx->r, out + 4);
 
 	return 0;
 }
@@ -135,13 +131,11 @@ static int michael_setkey(struct crypto_
 {
 	struct michael_mic_ctx *mctx = crypto_shash_ctx(tfm);
 
-	const __le32 *data = (const __le32 *)key;
-
 	if (keylen != 8)
 		return -EINVAL;
 
-	mctx->l = le32_to_cpu(data[0]);
-	mctx->r = le32_to_cpu(data[1]);
+	mctx->l = get_unaligned_le32(key);
+	mctx->r = get_unaligned_le32(key + 4);
 	return 0;
 }
 
@@ -156,7 +150,6 @@ static struct shash_alg alg = {
 		.cra_name		=	"michael_mic",
 		.cra_driver_name	=	"michael_mic-generic",
 		.cra_blocksize		=	8,
-		.cra_alignmask		=	3,
 		.cra_ctxsize		=	sizeof(struct michael_mic_ctx),
 		.cra_module		=	THIS_MODULE,
 	}


