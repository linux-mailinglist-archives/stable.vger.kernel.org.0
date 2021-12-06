Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D78469CB0
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359284AbhLFPYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:24:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55546 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356936AbhLFPWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:22:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD5B6B8101C;
        Mon,  6 Dec 2021 15:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC42C341C5;
        Mon,  6 Dec 2021 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803939;
        bh=g5vzduTfSGynRVeX59VVaxoshbzTsTbElMLPzfqW/JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFSpHvkRgLAxMlIR42c3cFE+pjgfS6wzeUdKoeiS+BE8WLbQkTudE8Wv3kB3jxgbX
         Lbh+T/lmvwjxu41zjo9ti1eH2gU+mKHfyJKkaRQZACvwDFWKq0KnsXfG4tyXUbTUuF
         naJIkZnYfAcgRpI/lz0TUZp4rDR77cMtMSsCzVxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 069/130] siphash: use _unaligned version by default
Date:   Mon,  6 Dec 2021 15:56:26 +0100
Message-Id: <20211206145602.056239773@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f7e5b9bfa6c8820407b64eabc1f29c9a87e8993d upstream.

On ARM v6 and later, we define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
because the ordinary load/store instructions (ldr, ldrh, ldrb) can
tolerate any misalignment of the memory address. However, load/store
double and load/store multiple instructions (ldrd, ldm) may still only
be used on memory addresses that are 32-bit aligned, and so we have to
use the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS macro with care, or we
may end up with a severe performance hit due to alignment traps that
require fixups by the kernel. Testing shows that this currently happens
with clang-13 but not gcc-11. In theory, any compiler version can
produce this bug or other problems, as we are dealing with undefined
behavior in C99 even on architectures that support this in hardware,
see also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100363.

Fortunately, the get_unaligned() accessors do the right thing: when
building for ARMv6 or later, the compiler will emit unaligned accesses
using the ordinary load/store instructions (but avoid the ones that
require 32-bit alignment). When building for older ARM, those accessors
will emit the appropriate sequence of ldrb/mov/orr instructions. And on
architectures that can truly tolerate any kind of misalignment, the
get_unaligned() accessors resolve to the leXX_to_cpup accessors that
operate on aligned addresses.

Since the compiler will in fact emit ldrd or ldm instructions when
building this code for ARM v6 or later, the solution is to use the
unaligned accessors unconditionally on architectures where this is
known to be fast. The _aligned version of the hash function is
however still needed to get the best performance on architectures
that cannot do any unaligned access in hardware.

This new version avoids the undefined behavior and should produce
the fastest hash on all architectures we support.

Link: https://lore.kernel.org/linux-arm-kernel/20181008211554.5355-4-ard.biesheuvel@linaro.org/
Link: https://lore.kernel.org/linux-crypto/CAK8P3a2KfmmGDbVHULWevB0hv71P2oi2ZCHEAqT=8dQfa0=cqQ@mail.gmail.com/
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 2c956a60778c ("siphash: add cryptographically secure PRF")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/siphash.h |   14 ++++----------
 lib/siphash.c           |   12 ++++++------
 2 files changed, 10 insertions(+), 16 deletions(-)

--- a/include/linux/siphash.h
+++ b/include/linux/siphash.h
@@ -27,9 +27,7 @@ static inline bool siphash_key_is_zero(c
 }
 
 u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key);
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key);
-#endif
 
 u64 siphash_1u64(const u64 a, const siphash_key_t *key);
 u64 siphash_2u64(const u64 a, const u64 b, const siphash_key_t *key);
@@ -82,10 +80,9 @@ static inline u64 ___siphash_aligned(con
 static inline u64 siphash(const void *data, size_t len,
 			  const siphash_key_t *key)
 {
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (!IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+	    !IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
 		return __siphash_unaligned(data, len, key);
-#endif
 	return ___siphash_aligned(data, len, key);
 }
 
@@ -96,10 +93,8 @@ typedef struct {
 
 u32 __hsiphash_aligned(const void *data, size_t len,
 		       const hsiphash_key_t *key);
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_unaligned(const void *data, size_t len,
 			 const hsiphash_key_t *key);
-#endif
 
 u32 hsiphash_1u32(const u32 a, const hsiphash_key_t *key);
 u32 hsiphash_2u32(const u32 a, const u32 b, const hsiphash_key_t *key);
@@ -135,10 +130,9 @@ static inline u32 ___hsiphash_aligned(co
 static inline u32 hsiphash(const void *data, size_t len,
 			   const hsiphash_key_t *key)
 {
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (!IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+	    !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
 		return __hsiphash_unaligned(data, len, key);
-#endif
 	return ___hsiphash_aligned(data, len, key);
 }
 
--- a/lib/siphash.c
+++ b/lib/siphash.c
@@ -49,6 +49,7 @@
 	SIPROUND; \
 	return (v0 ^ v1) ^ (v2 ^ v3);
 
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key)
 {
 	const u8 *end = data + len - (len % sizeof(u64));
@@ -80,8 +81,8 @@ u64 __siphash_aligned(const void *data,
 	POSTAMBLE
 }
 EXPORT_SYMBOL(__siphash_aligned);
+#endif
 
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key)
 {
 	const u8 *end = data + len - (len % sizeof(u64));
@@ -113,7 +114,6 @@ u64 __siphash_unaligned(const void *data
 	POSTAMBLE
 }
 EXPORT_SYMBOL(__siphash_unaligned);
-#endif
 
 /**
  * siphash_1u64 - compute 64-bit siphash PRF value of a u64
@@ -250,6 +250,7 @@ EXPORT_SYMBOL(siphash_3u32);
 	HSIPROUND; \
 	return (v0 ^ v1) ^ (v2 ^ v3);
 
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
 {
 	const u8 *end = data + len - (len % sizeof(u64));
@@ -280,8 +281,8 @@ u32 __hsiphash_aligned(const void *data,
 	HPOSTAMBLE
 }
 EXPORT_SYMBOL(__hsiphash_aligned);
+#endif
 
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_unaligned(const void *data, size_t len,
 			 const hsiphash_key_t *key)
 {
@@ -313,7 +314,6 @@ u32 __hsiphash_unaligned(const void *dat
 	HPOSTAMBLE
 }
 EXPORT_SYMBOL(__hsiphash_unaligned);
-#endif
 
 /**
  * hsiphash_1u32 - compute 64-bit hsiphash PRF value of a u32
@@ -418,6 +418,7 @@ EXPORT_SYMBOL(hsiphash_4u32);
 	HSIPROUND; \
 	return v1 ^ v3;
 
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
 {
 	const u8 *end = data + len - (len % sizeof(u32));
@@ -438,8 +439,8 @@ u32 __hsiphash_aligned(const void *data,
 	HPOSTAMBLE
 }
 EXPORT_SYMBOL(__hsiphash_aligned);
+#endif
 
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_unaligned(const void *data, size_t len,
 			 const hsiphash_key_t *key)
 {
@@ -461,7 +462,6 @@ u32 __hsiphash_unaligned(const void *dat
 	HPOSTAMBLE
 }
 EXPORT_SYMBOL(__hsiphash_unaligned);
-#endif
 
 /**
  * hsiphash_1u32 - compute 32-bit hsiphash PRF value of a u32


