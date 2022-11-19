Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F931630A64
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbiKSC0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbiKSCYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:24:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F8CC759A;
        Fri, 18 Nov 2022 18:15:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EEB7624B7;
        Sat, 19 Nov 2022 02:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CDFC433D6;
        Sat, 19 Nov 2022 02:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824142;
        bh=iYQHepQ/6OdpRyp/ogacRlCfIMgtH1QQKzt63KiA/yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5UAyvuxeIE2nX9rfZjdc01vmIH27euXq0n0Gc47YVyZFl0LEpg3iSOv58k37Th6b
         e63rti/6RLBXXHZTr2jnu9e3LfZ3laQgBGtyJjFV8ct0/A0d50tL3w5rg3Y0furhcP
         6Riy5kHxnmtdpWwvGQJwM8uZ0gVY/nejRgX6APf8VP1EFts0v/x0lCRgygQi2V5YHo
         xGPv9ma++NYZ5RIMIP2BdZXyLgDxQJpm9gIRgCSkvXaSVHvdLLlQqq/Q2St8HYvHVT
         8wyfV7vqRpq4O1dwzPzOaQbxnQWWXfEnYSzkuIXhLMuBOQCfblM3NJNRUeOt+HaKV7
         bVMV5QAZX9EiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, yangtiezhu@loongson.cn,
        windhl@126.com, wsa+renesas@sang-engineering.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/18] MIPS: pic32: treat port as signed integer
Date:   Fri, 18 Nov 2022 21:14:59 -0500
Message-Id: <20221119021459.1775052-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021459.1775052-1-sashal@kernel.org>
References: <20221119021459.1775052-1-sashal@kernel.org>
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
index 25372e62783b..3cd1b408fa1c 100644
--- a/arch/mips/pic32/pic32mzda/early_console.c
+++ b/arch/mips/pic32/pic32mzda/early_console.c
@@ -27,7 +27,7 @@
 #define U_BRG(x)	(UART_BASE(x) + 0x40)
 
 static void __iomem *uart_base;
-static char console_port = -1;
+static int console_port = -1;
 
 static int __init configure_uart_pins(int port)
 {
@@ -47,7 +47,7 @@ static int __init configure_uart_pins(int port)
 	return 0;
 }
 
-static void __init configure_uart(char port, int baud)
+static void __init configure_uart(int port, int baud)
 {
 	u32 pbclk;
 
@@ -60,7 +60,7 @@ static void __init configure_uart(char port, int baud)
 		     uart_base + PIC32_SET(U_STA(port)));
 }
 
-static void __init setup_early_console(char port, int baud)
+static void __init setup_early_console(int port, int baud)
 {
 	if (configure_uart_pins(port))
 		return;
@@ -130,16 +130,15 @@ static int __init get_baud_from_cmdline(char *arch_cmdline)
 	return baud;
 }
 
-void __init fw_init_early_console(char port)
+void __init fw_init_early_console(void)
 {
 	char *arch_cmdline = pic32_getcmdline();
-	int baud = -1;
+	int baud, port;
 
 	uart_base = ioremap(PIC32_BASE_UART, 0xc00);
 
 	baud = get_baud_from_cmdline(arch_cmdline);
-	if (port == -1)
-		port = get_port_from_cmdline(arch_cmdline);
+	port = get_port_from_cmdline(arch_cmdline);
 
 	if (port == -1)
 		port = EARLY_CONSOLE_PORT;
diff --git a/arch/mips/pic32/pic32mzda/init.c b/arch/mips/pic32/pic32mzda/init.c
index f232c77ff526..488c0bee7ebf 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -60,7 +60,7 @@ void __init plat_mem_setup(void)
 		strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 
 #ifdef CONFIG_EARLY_PRINTK
-	fw_init_early_console(-1);
+	fw_init_early_console();
 #endif
 	pic32_config_init();
 }
-- 
2.35.1

