Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C8C63DE61
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiK3Sgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiK3SgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:36:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618189491A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEEF7B81CA4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C60C433D6;
        Wed, 30 Nov 2022 18:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833370;
        bh=YGLkXBH8+hVHM09LLJLlWXCXmqDMmA9MMhLiR7fuMg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDoi/Mec3uf3yXWghCY4Pkr335Vc9It96Zmj2mpvkva+5lo8whAGEe0CWyzAGxGlv
         kga203P27k/90JHPs6oQ63HFeK4hEvFwsitZ8LIs2u8oA1l1WATV4GxqR8rAOozred
         eQNlAc2JSaoBk0MiRMcdGTFiZDYQWNQL/ez+KfX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/206] MIPS: pic32: treat port as signed integer
Date:   Wed, 30 Nov 2022 19:21:46 +0100
Message-Id: <20221130180534.374313077@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

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
index 764f2d022fae..429830afff54 100644
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -47,7 +47,7 @@ void __init plat_mem_setup(void)
 		strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
 
 #ifdef CONFIG_EARLY_PRINTK
-	fw_init_early_console(-1);
+	fw_init_early_console();
 #endif
 	pic32_config_init();
 }
-- 
2.35.1



