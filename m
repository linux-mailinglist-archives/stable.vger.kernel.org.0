Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F4D6D479F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjDCOV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbjDCOVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3EC2D7D3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C41761C52
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ACBC4339B;
        Mon,  3 Apr 2023 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531685;
        bh=HT180A6nHoeTr8D6GJkawDcManDGE/3RZjPVgOey1SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzBqSjgMEZFlvjIs41SeUmeueUaKXGakXcnB3AqZlUNbWDug+Hx/FCRYcFYu/wgSo
         wlVWhJi0TXZpIG0RaRmVwke0/3nJYtCNUa+e+dgLYBY27+wvqdCS4BvO2c4/86SYl+
         0fxoqy+j2kbPilRv7/htfWHwTUrvNTqptLbyhd7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/104] mips: bmips: BCM6358: disable RAC flush for TP1
Date:   Mon,  3 Apr 2023 16:09:05 +0200
Message-Id: <20230403140407.014787737@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,RCVD_IN_DNSWL_HI,
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
index df56bf4179e34..98d39585c80ff 100644
--- a/arch/mips/bmips/dma.c
+++ b/arch/mips/bmips/dma.c
@@ -64,6 +64,8 @@ phys_addr_t __dma_to_phys(struct device *dev, dma_addr_t dma_addr)
 	return dma_addr;
 }
 
+bool bmips_rac_flush_disable;
+
 void arch_sync_dma_for_cpu_all(void)
 {
 	void __iomem *cbr = BMIPS_GET_CBR();
@@ -74,6 +76,9 @@ void arch_sync_dma_for_cpu_all(void)
 	    boot_cpu_type() != CPU_BMIPS4380)
 		return;
 
+	if (unlikely(bmips_rac_flush_disable))
+		return;
+
 	/* Flush stale data out of the readahead cache */
 	cfg = __raw_readl(cbr + BMIPS_RAC_CONFIG);
 	__raw_writel(cfg | 0x100, cbr + BMIPS_RAC_CONFIG);
diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index 7aee9ff19c1a6..36fbedcbd518d 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -34,6 +34,8 @@
 #define REG_BCM6328_OTP		((void __iomem *)CKSEG1ADDR(0x1000062c))
 #define BCM6328_TP1_DISABLED	BIT(9)
 
+extern bool bmips_rac_flush_disable;
+
 static const unsigned long kbase = VMLINUX_LOAD_ADDRESS & 0xfff00000;
 
 struct bmips_quirk {
@@ -103,6 +105,12 @@ static void bcm6358_quirks(void)
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



