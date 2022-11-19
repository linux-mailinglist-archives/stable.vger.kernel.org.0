Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C72630A9F
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiKSC3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236318AbiKSC1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:27:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BC9C80E7;
        Fri, 18 Nov 2022 18:16:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E9A2B82672;
        Sat, 19 Nov 2022 02:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000C9C433D6;
        Sat, 19 Nov 2022 02:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824189;
        bh=Yn7b3ZpClszSgkxraNq+zQUScPN0MsRlph39pWE96Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcEliL2ndg9rLJiBWSFGHqCI0+urU2fb2eW+kMQplgL/Rk9MWBlC4cAyNodUZncoi
         /T2xqMUq9Y3nQfr2d0PDvFGZrDh+EkYxheWEthumSiFNScdXCs8IEtV7t37zI7IZeV
         5zvLNhnAgJ8YW3gpWivxj1HVWyDlZm+S0dkz2xQ/CdAywansSIwHCmO2Ke/VkhH6Dt
         v6p28FuI5XNsZaqXsG7o3V0BYEgsvnGkMu3Owya3FQ6oMIBrA5HALld8kjd4qrOgWW
         CoYe4QRPJ6DcPp+bIRvA4sS4JPH8ClmjEupLFhWQyuTLA3n4A9ArZwxdyRAoX51xxu
         5+62ugbyoOdHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, yangtiezhu@loongson.cn,
        wsa+renesas@sang-engineering.com, windhl@126.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 8/8] MIPS: pic32: treat port as signed integer
Date:   Fri, 18 Nov 2022 21:16:09 -0500
Message-Id: <20221119021610.1775469-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021610.1775469-1-sashal@kernel.org>
References: <20221119021610.1775469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 648060902aa302331b5d6e4f26d8ee0761d239ab ]

get_port_from_cmdline() returns an int, yet is assigned to a char, which
is wrong in its own right, but also, with char becoming unsigned, this
poses problems, because -1 is used as an error value. Further
complicating things, fw_init_early_console() is only ever called with a
-1 argument. Fix this up by removing the unused argument from
fw_init_early_console() and treating port as a proper signed integer.

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/fw/fw.h             |  2 +-
 arch/mips/pic32/pic32mzda/early_console.c | 13 ++++++-------
 arch/mips/pic32/pic32mzda/init.c          |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/mips/include/asm/fw/fw.h b/arch/mips/include/asm/fw/fw.h
index d0ef8b4892bb..d0494ce4b337 100644
--- a/arch/mips/include/asm/fw/fw.h
+++ b/arch/mips/include/asm/fw/fw.h
@@ -26,6 +26,6 @@ extern char *fw_getcmdline(void);
 extern void fw_meminit(void);
 extern char *fw_getenv(char *name);
 extern unsigned long fw_getenvl(char *name);
-extern void fw_init_early_console(char port);
+extern void fw_init_early_console(void);
 
 #endif /* __ASM_FW_H_ */
diff --git a/arch/mips/pic32/pic32mzda/early_console.c b/arch/mips/pic32/pic32mzda/early_console.c
index 8ed4961b1271..c00c6149ee30 100644
--- a/arch/mips/pic32/pic32mzda/early_console.c
+++ b/arch/mips/pic32/pic32mzda/early_console.c
@@ -35,7 +35,7 @@
 #define U_BRG(x)	(UART_BASE(x) + 0x40)
 
 static void __iomem *uart_base;
-static char console_port = -1;
+static int console_port = -1;
 
 static int __init configure_uart_pins(int port)
 {
@@ -55,7 +55,7 @@ static int __init configure_uart_pins(int port)
 	return 0;
 }
 
-static void __init configure_uart(char port, int baud)
+static void __init configure_uart(int port, int baud)
 {
 	u32 pbclk;
 
@@ -68,7 +68,7 @@ static void __init configure_uart(char port, int baud)
 		     uart_base + PIC32_SET(U_STA(port)));
 }
 
-static void __init setup_early_console(char port, int baud)
+static void __init setup_early_console(int port, int baud)
 {
 	if (configure_uart_pins(port))
 		return;
@@ -138,16 +138,15 @@ static int __init get_baud_from_cmdline(char *arch_cmdline)
 	return baud;
 }
 
-void __init fw_init_early_console(char port)
+void __init fw_init_early_console(void)
 {
 	char *arch_cmdline = pic32_getcmdline();
-	int baud = -1;
+	int baud, port;
 
 	uart_base = ioremap_nocache(PIC32_BASE_UART, 0xc00);
 
 	baud = get_baud_from_cmdline(arch_cmdline);
-	if (port == -1)
-		port = get_port_from_cmdline(arch_cmdline);
+	port = get_port_from_cmdline(arch_cmdline);
 
 	if (port == -1)
 		port = EARLY_CONSOLE_PORT;
diff --git a/arch/mips/pic32/pic32mzda/init.c b/arch/mips/pic32/pic32mzda/init.c
index 406c6c5cec29..cf2625551b45 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -68,7 +68,7 @@ void __init plat_mem_setup(void)
 		strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 
 #ifdef CONFIG_EARLY_PRINTK
-	fw_init_early_console(-1);
+	fw_init_early_console();
 #endif
 	pic32_config_init();
 }
-- 
2.35.1

