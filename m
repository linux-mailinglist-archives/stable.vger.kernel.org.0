Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C33A7F3D7
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392094AbfHBJvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391833AbfHBJvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:51:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BE5220880;
        Fri,  2 Aug 2019 09:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739507;
        bh=TNKOL0Nje0Z/X0kAaBQh3f1RgID2/jSJGzhcYJnRLWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1+gazA7Lin7G86Z5IRiDQggbJkET7VqFXmv4pkdih4u8S4/xdA/TCNJyly95m5h5
         m85bDp3uEAXHwHUJ9Wybc3JJsJbDk6FI9soYSvpRb27uA0rmXCBtQOv1YjkJQx2TtW
         u/1JvmBSD3L0D7wAvYBNM/F7d+ZFp9Dnq3Ht+96Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 192/223] powerpc/boot: add {get, put}_unaligned_be32 to xz_config.h
Date:   Fri,  2 Aug 2019 11:36:57 +0200
Message-Id: <20190802092249.796833364@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9e005b761e7ad153dcf40a6cba1d681fe0830ac6 ]

The next commit will make the way of passing CONFIG options more robust.
Unfortunately, it would uncover another hidden issue; without this
commit, skiroot_defconfig would be broken like this:

|   WRAP    arch/powerpc/boot/zImage.pseries
| arch/powerpc/boot/wrapper.a(decompress.o): In function `bcj_powerpc.isra.10':
| decompress.c:(.text+0x720): undefined reference to `get_unaligned_be32'
| decompress.c:(.text+0x7a8): undefined reference to `put_unaligned_be32'
| make[1]: *** [arch/powerpc/boot/Makefile;383: arch/powerpc/boot/zImage.pseries] Error 1
| make: *** [arch/powerpc/Makefile;295: zImage] Error 2

skiroot_defconfig is the only defconfig that enables CONFIG_KERNEL_XZ
for ppc, which has never been correctly built before.

I figured out the root cause in lib/decompress_unxz.c:

| #ifdef CONFIG_PPC
| #      define XZ_DEC_POWERPC
| #endif

CONFIG_PPC is undefined here in the ppc bootwrapper because autoconf.h
is not included except by arch/powerpc/boot/serial.c

XZ_DEC_POWERPC is not defined, therefore, bcj_powerpc() is not compiled
for the bootwrapper.

With the next commit passing CONFIG_PPC correctly, we would realize that
{get,put}_unaligned_be32 was missing.

Unlike the other decompressors, the ppc bootwrapper duplicates all the
necessary helpers in arch/powerpc/boot/.

The other architectures define __KERNEL__ and pull in helpers for
building the decompressors.

If ppc bootwrapper had defined __KERNEL__, lib/xz/xz_private.h would
have included <asm/unaligned.h>:

| #ifdef __KERNEL__
| #       include <linux/xz.h>
| #       include <linux/kernel.h>
| #       include <asm/unaligned.h>

However, doing so would cause tons of definition conflicts since the
bootwrapper has duplicated everything.

I just added copies of {get,put}_unaligned_be32, following the
bootwrapper coding convention.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190705100144.28785-1-yamada.masahiro@socionext.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/xz_config.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/powerpc/boot/xz_config.h b/arch/powerpc/boot/xz_config.h
index 5c6afdbca642..21b52c15aafc 100644
--- a/arch/powerpc/boot/xz_config.h
+++ b/arch/powerpc/boot/xz_config.h
@@ -19,10 +19,30 @@ static inline uint32_t swab32p(void *p)
 
 #ifdef __LITTLE_ENDIAN__
 #define get_le32(p) (*((uint32_t *) (p)))
+#define cpu_to_be32(x) swab32(x)
+static inline u32 be32_to_cpup(const u32 *p)
+{
+	return swab32p((u32 *)p);
+}
 #else
 #define get_le32(p) swab32p(p)
+#define cpu_to_be32(x) (x)
+static inline u32 be32_to_cpup(const u32 *p)
+{
+	return *p;
+}
 #endif
 
+static inline uint32_t get_unaligned_be32(const void *p)
+{
+	return be32_to_cpup(p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	*((u32 *)p) = cpu_to_be32(val);
+}
+
 #define memeq(a, b, size) (memcmp(a, b, size) == 0)
 #define memzero(buf, size) memset(buf, 0, size)
 
-- 
2.20.1



