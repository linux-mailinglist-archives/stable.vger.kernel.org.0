Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4144165A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhKAJY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232409AbhKAJXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15873611AF;
        Mon,  1 Nov 2021 09:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758429;
        bh=l30ck8SXyDK4DhSNB9/Z/IXS+gJ8HRpcY6HOmylLOwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8Aqe51K0XuHDTRIHaeMkiM/wIW3Xkr5TuZoxL9eGD0571+IZhKtxljNsUckMTFPU
         IKalUzKWKvxpAEASYXKp7zo48NKp5YUvV73guABl4SAcdBpa11l+sagANgI8QXtWaK
         61U9e28ES7av97UKwMHuRHpRz+RSO9/jfsq94aT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 02/25] ARM: 9134/1: remove duplicate memcpy() definition
Date:   Mon,  1 Nov 2021 10:17:14 +0100
Message-Id: <20211101082447.604888983@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082447.070493993@linuxfoundation.org>
References: <20211101082447.070493993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit eaf6cc7165c9c5aa3c2f9faa03a98598123d0afb upstream.

Both the decompressor code and the kasan logic try to override
the memcpy() and memmove()  definitions, which leading to a clash
in a KASAN-enabled kernel with XZ decompression:

arch/arm/boot/compressed/decompress.c:50:9: error: 'memmove' macro redefined [-Werror,-Wmacro-redefined]
 #define memmove memmove
        ^
arch/arm/include/asm/string.h:59:9: note: previous definition is here
 #define memmove(dst, src, len) __memmove(dst, src, len)
        ^
arch/arm/boot/compressed/decompress.c:51:9: error: 'memcpy' macro redefined [-Werror,-Wmacro-redefined]
 #define memcpy memcpy
        ^
arch/arm/include/asm/string.h:58:9: note: previous definition is here
 #define memcpy(dst, src, len) __memcpy(dst, src, len)
        ^

Here we want the set of functions from the decompressor, so undefine
the other macros before the override.

Link: https://lore.kernel.org/linux-arm-kernel/CACRpkdZYJogU_SN3H9oeVq=zJkRgRT1gDz3xp59gdqWXxw-B=w@mail.gmail.com/
Link: https://lore.kernel.org/lkml/202105091112.F5rmd4By-lkp@intel.com/

Fixes: d6d51a96c7d6 ("ARM: 9014/2: Replace string mem* functions for KASan")
Fixes: a7f464f3db93 ("ARM: 7001/2: Wire up support for the XZ decompressor")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/compressed/decompress.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/boot/compressed/decompress.c
+++ b/arch/arm/boot/compressed/decompress.c
@@ -49,7 +49,10 @@ extern int memcmp(const void *cs, const
 #endif
 
 #ifdef CONFIG_KERNEL_XZ
+/* Prevent KASAN override of string helpers in decompressor */
+#undef memmove
 #define memmove memmove
+#undef memcpy
 #define memcpy memcpy
 #include "../../../../lib/decompress_unxz.c"
 #endif


