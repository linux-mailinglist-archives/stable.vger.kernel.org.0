Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A1B6D4972
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbjDCOiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbjDCOh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:37:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C456F17662
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B929BCE12DF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3352C433D2;
        Mon,  3 Apr 2023 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532670;
        bh=SOEJmCQrbTopYVE1Ag8DVpLUlBhlcA40MD4sRS5USy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAfPacVMpTX6MWQQ0X2WuzfK0709dkyl5QutKq0DMHjr4KVRc8ZcNtkyB6qeTdOCl
         vTXfNvhtUgwXHwCYxNILfjLS/Pe6jR8kfLtGahja+Q6ImK+ktE8srIeeiJLNV+SBjY
         dCARF2wBAXQ8ryHuhjYrrKfgkhEsdm6WVhXn+9NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/181] mips: bmips: BCM6358: disable RAC flush for TP1
Date:   Mon,  3 Apr 2023 16:08:26 +0200
Message-Id: <20230403140417.444059817@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit ab327f8acdf8d06601fbf058859a539a9422afff ]

RAC flush causes kernel panics on BCM6358 with EHCI/OHCI when booting from TP1:
[    3.881739] usb 1-1: new high-speed USB device number 2 using ehci-platform
[    3.895011] Reserved instruction in kernel code[#1]:
[    3.900113] CPU: 0 PID: 1 Comm: init Not tainted 5.10.16 #0
[    3.905829] $ 0   : 00000000 10008700 00000000 77d94060
[    3.911238] $ 4   : 7fd1f088 00000000 81431cac 81431ca0
[    3.916641] $ 8   : 00000000 ffffefff 8075cd34 00000000
[    3.922043] $12   : 806f8d40 f3e812b7 00000000 000d9aaa
[    3.927446] $16   : 7fd1f068 7fd1f080 7ff559b8 81428470
[    3.932848] $20   : 00000000 00000000 55590000 77d70000
[    3.938251] $24   : 00000018 00000010
[    3.943655] $28   : 81430000 81431e60 81431f28 800157fc
[    3.949058] Hi    : 00000000
[    3.952013] Lo    : 00000000
[    3.955019] epc   : 80015808 setup_sigcontext+0x54/0x24c
[    3.960464] ra    : 800157fc setup_sigcontext+0x48/0x24c
[    3.965913] Status: 10008703	KERNEL EXL IE
[    3.970216] Cause : 00800028 (ExcCode 0a)
[    3.974340] PrId  : 0002a010 (Broadcom BMIPS4350)
[    3.979170] Modules linked in: ohci_platform ohci_hcd fsl_mph_dr_of ehci_platform ehci_fsl ehci_hcd gpio_button_hotplug usbcore nls_base usb_common
[    3.992907] Process init (pid: 1, threadinfo=(ptrval), task=(ptrval), tls=77e22ec8)
[    4.000776] Stack : 81431ef4 7fd1f080 81431f28 81428470 7fd1f068 81431edc 7ff559b8 81428470
[    4.009467]         81431f28 7fd1f080 55590000 77d70000 77d5498c 80015c70 806f0000 8063ae74
[    4.018149]         08100002 81431f28 0000000a 08100002 81431f28 0000000a 77d6b418 00000003
[    4.026831]         ffffffff 80016414 80080734 81431ecc 81431ecc 00000001 00000000 04000000
[    4.035512]         77d54874 00000000 00000000 00000000 00000000 00000012 00000002 00000000
[    4.044196]         ...
[    4.046706] Call Trace:
[    4.049238] [<80015808>] setup_sigcontext+0x54/0x24c
[    4.054356] [<80015c70>] setup_frame+0xdc/0x124
[    4.059015] [<80016414>] do_notify_resume+0x1dc/0x288
[    4.064207] [<80011b50>] work_notifysig+0x10/0x18
[    4.069036]
[    4.070538] Code: 8fc300b4  00001025  26240008 <ac820000> ac830004  3c048063  0c0228aa  24846a00  26240010
[    4.080686]
[    4.082517] ---[ end trace 22a8edb41f5f983b ]---
[    4.087374] Kernel panic - not syncing: Fatal exception
[    4.092753] Rebooting in 1 seconds..

Because the bootloader (CFE) is not initializing the Read-ahead cache properly
on the second thread (TP1). Since the RAC was not initialized properly, we
should avoid flushing it at the risk of corrupting the instruction stream as
seen in the trace above.

Fixes: d59098a0e9cb ("MIPS: bmips: use generic dma noncoherent ops")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bmips/dma.c   | 5 +++++
 arch/mips/bmips/setup.c | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/mips/bmips/dma.c b/arch/mips/bmips/dma.c
index 33788668cbdbf..3779e7855bd75 100644
--- a/arch/mips/bmips/dma.c
+++ b/arch/mips/bmips/dma.c
@@ -5,6 +5,8 @@
 #include <asm/bmips.h>
 #include <asm/io.h>
 
+bool bmips_rac_flush_disable;
+
 void arch_sync_dma_for_cpu_all(void)
 {
 	void __iomem *cbr = BMIPS_GET_CBR();
@@ -15,6 +17,9 @@ void arch_sync_dma_for_cpu_all(void)
 	    boot_cpu_type() != CPU_BMIPS4380)
 		return;
 
+	if (unlikely(bmips_rac_flush_disable))
+		return;
+
 	/* Flush stale data out of the readahead cache */
 	cfg = __raw_readl(cbr + BMIPS_RAC_CONFIG);
 	__raw_writel(cfg | 0x100, cbr + BMIPS_RAC_CONFIG);
diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index e95b3f78e7cd4..549a6392a3d2d 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -35,6 +35,8 @@
 #define REG_BCM6328_OTP		((void __iomem *)CKSEG1ADDR(0x1000062c))
 #define BCM6328_TP1_DISABLED	BIT(9)
 
+extern bool bmips_rac_flush_disable;
+
 static const unsigned long kbase = VMLINUX_LOAD_ADDRESS & 0xfff00000;
 
 struct bmips_quirk {
@@ -104,6 +106,12 @@ static void bcm6358_quirks(void)
 	 * disable SMP for now
 	 */
 	bmips_smp_enabled = 0;
+
+	/*
+	 * RAC flush causes kernel panics on BCM6358 when booting from TP1
+	 * because the bootloader is not initializing it properly.
+	 */
+	bmips_rac_flush_disable = !!(read_c0_brcm_cmt_local() & (1 << 31));
 }
 
 static void bcm6368_quirks(void)
-- 
2.39.2



