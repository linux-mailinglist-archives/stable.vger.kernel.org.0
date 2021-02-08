Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F78313820
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhBHPg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233937AbhBHPby (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:31:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D411064E87;
        Mon,  8 Feb 2021 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797450;
        bh=Ly7jcL+VBICn8kff0MRqia8hg7fxON4+szUyRyHSIpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Go4Lat/Wb0JtRH1bL2w1/2L3nmMbkJTin00fYVGuseg/KwCHCMwZu4VGI2jw+6INa
         /gHQbhXXNRwmZSqly3CJg2Pi7DMwKnTBQQ44fJIXnZ5ivOd+IbpXxmY0M1793MCOJn
         O1apt5lNA05G6mFQkMLsWM5BMw4oBZi7bGPZK+v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 097/120] ARM: 9043/1: tegra: Fix misplaced tegra_uart_config in decompressor
Date:   Mon,  8 Feb 2021 16:01:24 +0100
Message-Id: <20210208145822.250611748@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 538eea5362a1179dfa7770dd2b6607dc30cc50c6 upstream.

The tegra_uart_config of the DEBUG_LL code is now placed right at the
start of the .text section after commit which enabled debug output in the
decompressor. Tegra devices are not booting anymore if DEBUG_LL is enabled
since tegra_uart_config data is executes as a code. Fix the misplaced
tegra_uart_config storage by embedding it into the code.

Cc: stable@vger.kernel.org
Fixes: 2596a72d3384 ("ARM: 9009/1: uncompress: Enable debug in head.S")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/debug/tegra.S |   54 ++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/arch/arm/include/debug/tegra.S
+++ b/arch/arm/include/debug/tegra.S
@@ -149,7 +149,34 @@
 
 		.align
 99:		.word	.
+#if defined(ZIMAGE)
+		.word	. + 4
+/*
+ * Storage for the state maintained by the macro.
+ *
+ * In the kernel proper, this data is located in arch/arm/mach-tegra/tegra.c.
+ * That's because this header is included from multiple files, and we only
+ * want a single copy of the data. In particular, the UART probing code above
+ * assumes it's running using physical addresses. This is true when this file
+ * is included from head.o, but not when included from debug.o. So we need
+ * to share the probe results between the two copies, rather than having
+ * to re-run the probing again later.
+ *
+ * In the decompressor, we put the storage right here, since common.c
+ * isn't included in the decompressor build. This storage data gets put in
+ * .text even though it's really data, since .data is discarded from the
+ * decompressor. Luckily, .text is writeable in the decompressor, unless
+ * CONFIG_ZBOOT_ROM. That dependency is handled in arch/arm/Kconfig.debug.
+ */
+		/* Debug UART initialization required */
+		.word	1
+		/* Debug UART physical address */
+		.word	0
+		/* Debug UART virtual address */
+		.word	0
+#else
 		.word	tegra_uart_config
+#endif
 		.ltorg
 
 		/* Load previously selected UART address */
@@ -189,30 +216,3 @@
 
 		.macro	waituarttxrdy,rd,rx
 		.endm
-
-/*
- * Storage for the state maintained by the macros above.
- *
- * In the kernel proper, this data is located in arch/arm/mach-tegra/tegra.c.
- * That's because this header is included from multiple files, and we only
- * want a single copy of the data. In particular, the UART probing code above
- * assumes it's running using physical addresses. This is true when this file
- * is included from head.o, but not when included from debug.o. So we need
- * to share the probe results between the two copies, rather than having
- * to re-run the probing again later.
- *
- * In the decompressor, we put the symbol/storage right here, since common.c
- * isn't included in the decompressor build. This symbol gets put in .text
- * even though it's really data, since .data is discarded from the
- * decompressor. Luckily, .text is writeable in the decompressor, unless
- * CONFIG_ZBOOT_ROM. That dependency is handled in arch/arm/Kconfig.debug.
- */
-#if defined(ZIMAGE)
-tegra_uart_config:
-	/* Debug UART initialization required */
-	.word 1
-	/* Debug UART physical address */
-	.word 0
-	/* Debug UART virtual address */
-	.word 0
-#endif


