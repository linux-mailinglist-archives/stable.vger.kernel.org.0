Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6877144183B
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhKAJpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233043AbhKAJlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF476137C;
        Mon,  1 Nov 2021 09:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758903;
        bh=D2Kw8ZeBUWKw65O4pZ6IHRH80AuFRjqf5gcq3B7UpGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w47aLRbIlERlSgetJ8pZ7thjFJa8p9BqqP73Dbb2CN3JaRzxsNcimlqTHOWO1Y2v1
         2AMwRhZK+iNaR9kwTcIbRH3fFpZDS55A9luwLSfV+VsdxpgFLb8dP5BvFU8QwntGrj
         sDre28Sl7CQ7WvFGQC8e239f7ImzPa0F/dqqJb6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.14 003/125] ARM: 9134/1: remove duplicate memcpy() definition
Date:   Mon,  1 Nov 2021 10:16:16 +0100
Message-Id: <20211101082534.140745488@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
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
@@ -47,7 +47,10 @@ extern char * strchrnul(const char *, in
 #endif
 
 #ifdef CONFIG_KERNEL_XZ
+/* Prevent KASAN override of string helpers in decompressor */
+#undef memmove
 #define memmove memmove
+#undef memcpy
 #define memcpy memcpy
 #include "../../../../lib/decompress_unxz.c"
 #endif


