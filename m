Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C13551B7E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245575AbiFTNLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343713AbiFTNJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D66B1A831;
        Mon, 20 Jun 2022 06:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEA82B811C2;
        Mon, 20 Jun 2022 13:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F33C3411C;
        Mon, 20 Jun 2022 13:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730251;
        bh=k8zmyARx55MqkvJ5B8V7V6Zh4rf4fyhqNRcEFT6bOOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dsq+gm5PvfhQo+Qa5ERJtYqmuBsCXHmGHGKW2dO0blJDo0Ra5beYlPEH65unAAo/x
         qw26SuCMSplKc9Ukf5iteUolFP9l7bv2GdtKj19GRrPI85AFQqGakbq4un16GHomHx
         aIiyFyoC5jv8WqJcrFo8q8xG4IMQH/4lj+xUFQp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 62/84] crypto: memneq - move into lib/
Date:   Mon, 20 Jun 2022 14:51:25 +0200
Message-Id: <20220620124722.724651903@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit abfed87e2a12bd246047d78c01d81eb9529f1d06 upstream.

This is used by code that doesn't need CONFIG_CRYPTO, so move this into
lib/ with a Kconfig option so that it can be selected by whatever needs
it.

This fixes a linker error Zheng pointed out when
CRYPTO_MANAGER_DISABLE_TESTS!=y and CRYPTO=m:

  lib/crypto/curve25519-selftest.o: In function `curve25519_selftest':
  curve25519-selftest.c:(.init.text+0x60): undefined reference to `__crypto_memneq'
  curve25519-selftest.c:(.init.text+0xec): undefined reference to `__crypto_memneq'
  curve25519-selftest.c:(.init.text+0x114): undefined reference to `__crypto_memneq'
  curve25519-selftest.c:(.init.text+0x154): undefined reference to `__crypto_memneq'

Reported-by: Zheng Bin <zhengbin13@huawei.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org
Fixes: aa127963f1ca ("crypto: lib/curve25519 - re-add selftests")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/Kconfig           | 1 +
 crypto/Makefile          | 2 +-
 lib/Kconfig              | 3 +++
 lib/Makefile             | 1 +
 lib/crypto/Kconfig       | 1 +
 {crypto => lib}/memneq.c | 0
 crypto/Kconfig     |    1 
 crypto/Makefile    |    2 
 crypto/memneq.c    |  168 -----------------------------------------------------
 lib/Kconfig        |    3 
 lib/Makefile       |    1 
 lib/crypto/Kconfig |    1 
 lib/memneq.c       |  168 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 175 insertions(+), 169 deletions(-)
 rename {crypto => lib}/memneq.c (100%)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -15,6 +15,7 @@ source "crypto/async_tx/Kconfig"
 #
 menuconfig CRYPTO
 	tristate "Cryptographic API"
+	select LIB_MEMNEQ
 	help
 	  This option provides the core Cryptographic API.
 
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-y := api.o cipher.o compress.o memneq.o
+crypto-y := api.o cipher.o compress.o
 
 obj-$(CONFIG_CRYPTO_ENGINE) += crypto_engine.o
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
--- a/crypto/memneq.c
+++ /dev/null
@@ -1,168 +0,0 @@
-/*
- * Constant-time equality testing of memory regions.
- *
- * Authors:
- *
- *   James Yonan <james@openvpn.net>
- *   Daniel Borkmann <dborkman@redhat.com>
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *   * Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *   * Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *   * Neither the name of OpenVPN Technologies nor the names of its
- *     contributors may be used to endorse or promote products derived
- *     from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-#include <crypto/algapi.h>
-
-#ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
-
-/* Generic path for arbitrary size */
-static inline unsigned long
-__crypto_memneq_generic(const void *a, const void *b, size_t size)
-{
-	unsigned long neq = 0;
-
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-	while (size >= sizeof(unsigned long)) {
-		neq |= *(unsigned long *)a ^ *(unsigned long *)b;
-		OPTIMIZER_HIDE_VAR(neq);
-		a += sizeof(unsigned long);
-		b += sizeof(unsigned long);
-		size -= sizeof(unsigned long);
-	}
-#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-	while (size > 0) {
-		neq |= *(unsigned char *)a ^ *(unsigned char *)b;
-		OPTIMIZER_HIDE_VAR(neq);
-		a += 1;
-		b += 1;
-		size -= 1;
-	}
-	return neq;
-}
-
-/* Loop-free fast-path for frequently used 16-byte size */
-static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
-{
-	unsigned long neq = 0;
-
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (sizeof(unsigned long) == 8) {
-		neq |= *(unsigned long *)(a)   ^ *(unsigned long *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned long *)(a+8) ^ *(unsigned long *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
-	} else if (sizeof(unsigned int) == 4) {
-		neq |= *(unsigned int *)(a)    ^ *(unsigned int *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
-		OPTIMIZER_HIDE_VAR(neq);
-	} else
-#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-	{
-		neq |= *(unsigned char *)(a)    ^ *(unsigned char *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+10) ^ *(unsigned char *)(b+10);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+11) ^ *(unsigned char *)(b+11);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+12) ^ *(unsigned char *)(b+12);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+13) ^ *(unsigned char *)(b+13);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+14) ^ *(unsigned char *)(b+14);
-		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned char *)(a+15) ^ *(unsigned char *)(b+15);
-		OPTIMIZER_HIDE_VAR(neq);
-	}
-
-	return neq;
-}
-
-/* Compare two areas of memory without leaking timing information,
- * and with special optimizations for common sizes.  Users should
- * not call this function directly, but should instead use
- * crypto_memneq defined in crypto/algapi.h.
- */
-noinline unsigned long __crypto_memneq(const void *a, const void *b,
-				       size_t size)
-{
-	switch (size) {
-	case 16:
-		return __crypto_memneq_16(a, b);
-	default:
-		return __crypto_memneq_generic(a, b, size);
-	}
-}
-EXPORT_SYMBOL(__crypto_memneq);
-
-#endif /* __HAVE_ARCH_CRYPTO_MEMNEQ */
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -103,6 +103,9 @@ config INDIRECT_PIO
 
 source "lib/crypto/Kconfig"
 
+config LIB_MEMNEQ
+	bool
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -248,6 +248,7 @@ obj-$(CONFIG_DIMLIB) += dim/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
 lib-$(CONFIG_CLZ_TAB) += clz_tab.o
+lib-$(CONFIG_LIB_MEMNEQ) += memneq.o
 
 obj-$(CONFIG_GENERIC_STRNCPY_FROM_USER) += strncpy_from_user.o
 obj-$(CONFIG_GENERIC_STRNLEN_USER) += strnlen_user.o
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -71,6 +71,7 @@ config CRYPTO_LIB_CURVE25519
 	tristate "Curve25519 scalar multiplication library"
 	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
+	select LIB_MEMNEQ
 	help
 	  Enable the Curve25519 library interface. This interface may be
 	  fulfilled by either the generic implementation or an arch-specific
--- /dev/null
+++ b/lib/memneq.c
@@ -0,0 +1,168 @@
+/*
+ * Constant-time equality testing of memory regions.
+ *
+ * Authors:
+ *
+ *   James Yonan <james@openvpn.net>
+ *   Daniel Borkmann <dborkman@redhat.com>
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2013 OpenVPN Technologies, Inc. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of OpenVPN Technologies nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <crypto/algapi.h>
+
+#ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
+
+/* Generic path for arbitrary size */
+static inline unsigned long
+__crypto_memneq_generic(const void *a, const void *b, size_t size)
+{
+	unsigned long neq = 0;
+
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	while (size >= sizeof(unsigned long)) {
+		neq |= *(unsigned long *)a ^ *(unsigned long *)b;
+		OPTIMIZER_HIDE_VAR(neq);
+		a += sizeof(unsigned long);
+		b += sizeof(unsigned long);
+		size -= sizeof(unsigned long);
+	}
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+	while (size > 0) {
+		neq |= *(unsigned char *)a ^ *(unsigned char *)b;
+		OPTIMIZER_HIDE_VAR(neq);
+		a += 1;
+		b += 1;
+		size -= 1;
+	}
+	return neq;
+}
+
+/* Loop-free fast-path for frequently used 16-byte size */
+static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
+{
+	unsigned long neq = 0;
+
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (sizeof(unsigned long) == 8) {
+		neq |= *(unsigned long *)(a)   ^ *(unsigned long *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned long *)(a+8) ^ *(unsigned long *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+	} else if (sizeof(unsigned int) == 4) {
+		neq |= *(unsigned int *)(a)    ^ *(unsigned int *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
+		OPTIMIZER_HIDE_VAR(neq);
+	} else
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+	{
+		neq |= *(unsigned char *)(a)    ^ *(unsigned char *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+10) ^ *(unsigned char *)(b+10);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+11) ^ *(unsigned char *)(b+11);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+12) ^ *(unsigned char *)(b+12);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+13) ^ *(unsigned char *)(b+13);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+14) ^ *(unsigned char *)(b+14);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+15) ^ *(unsigned char *)(b+15);
+		OPTIMIZER_HIDE_VAR(neq);
+	}
+
+	return neq;
+}
+
+/* Compare two areas of memory without leaking timing information,
+ * and with special optimizations for common sizes.  Users should
+ * not call this function directly, but should instead use
+ * crypto_memneq defined in crypto/algapi.h.
+ */
+noinline unsigned long __crypto_memneq(const void *a, const void *b,
+				       size_t size)
+{
+	switch (size) {
+	case 16:
+		return __crypto_memneq_16(a, b);
+	default:
+		return __crypto_memneq_generic(a, b, size);
+	}
+}
+EXPORT_SYMBOL(__crypto_memneq);
+
+#endif /* __HAVE_ARCH_CRYPTO_MEMNEQ */


