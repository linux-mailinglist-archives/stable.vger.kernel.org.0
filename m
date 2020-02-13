Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEB315C864
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgBMQi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:38:26 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:38055 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgBMQi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 11:38:26 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a4256e13;
        Thu, 13 Feb 2020 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=UIUcVigLyhuwbihDTXLa/xFiI
        A4=; b=mR8M3+tFggkWNkyaj50+0PSDdURdniICmfP9TwV24o9rcc79j4XE0dbf+
        mcpwdoT1FpsfQmtfW9hUMd/s3ye5OBwx+3NHfSOaFIT0gJOVX1CFJctVg5A/iU0r
        zAHbB+QrYxXBY/8SO03DSeiQmH3Y7QAzzCwWrYXsA8iwVuUUtjcUXXfIFXAHL1VA
        j588D9HDIAJQ2q0wRJc50+fZjg14aOdp3wU4ObtmLzNLsjov/l2bGsPkpI0Kqjy8
        iMXK3U26BlNye9VEoZQeIVt+lCQziEtREXe9tQoZxfGfX76A/GVQbJ2ORFDHlJc5
        HQkef458NmcADTG8FRdFJRcP3TKJA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 88524b21 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 13 Feb 2020 16:36:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] crypto: chacha20poly1305 - prevent integer overflow on large input
Date:   Thu, 13 Feb 2020 17:38:13 +0100
Message-Id: <20200213163813.3210-1-Jason@zx2c4.com>
In-Reply-To: <20200213114647.cupaio6zmodix3fq@gondor.apana.org.au>
References: <20200213114647.cupaio6zmodix3fq@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This code assigns src_len (size_t) to sl (int), which causes problems
when src_len is very large. Probably nobody in the kernel should be
passing this much data to chacha20poly1305 all in one go anyway, so I
don't think we need to change the algorithm or introduce larger types
or anything. But we should at least error out early in this case and
print a warning so that we get reports if this does happen and can look
into why anybody is possibly passing it that much data or if they're
accidently passing -1 or similar.

Fixes: d95312a3ccc0 ("crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine")
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
---
Due to the "stable" in the subject line prior, this patch missed
Herbert's filters. So, I'm simply resending it here so that they can get
picked up. Note that this is intended for the crypto-2.6.git tree rather
than cryptodev-2.6.git.

 lib/crypto/chacha20poly1305.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 6d83cafebc69..ad0699ce702f 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -235,6 +235,9 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 		__le64 lens[2];
 	} b __aligned(16);
 
+	if (WARN_ON(src_len > INT_MAX))
+		return false;
+
 	chacha_load_key(b.k, key);
 
 	b.iv[0] = 0;
-- 
2.25.0

