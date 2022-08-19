Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDCC59A3AB
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353603AbiHSQqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353696AbiHSQo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:44:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4821C11233C;
        Fri, 19 Aug 2022 09:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33796CE26B5;
        Fri, 19 Aug 2022 16:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEA4C433C1;
        Fri, 19 Aug 2022 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925412;
        bh=e4fzJkxHkCfCA/v8/jONJ6SHVEdCxKUEUFyLtpqTCpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Id/nWXPkQb31lRpEvtPCDvraZ5pmoHVg2L0KzdbFJGod4c9scC8DuWjBWRxHZ6Fe6
         1rV/TIgdMbyItDKQYgBWXSlwA35tECIGbIm9RA51Ro3uVN/4qVmF0snHz4hoBGZjg3
         gJAdZD/+rNqcqCtwuaozDMD2fUEVnhNw2Kw6Xco0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/545] serial: 8250: Correct the clock for OxSemi PCIe devices
Date:   Fri, 19 Aug 2022 17:44:14 +0200
Message-Id: <20220819153851.091401487@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 6cbe45d8ac9316ceedd0749759bd54caf03f7012 ]

Oxford Semiconductor PCIe (Tornado) serial port devices are driven by a
fixed 62.5MHz clock input derived from the 100MHz PCI Express clock.

In the enhanced (650) mode, which we select in `autoconfig_has_efr' by
setting the ECB bit in the EFR register, and in the absence of clock
reconfiguration, which we currently don't do, the clock rate is divided
only by the oversampling rate of 16 as it is supplied to the baud rate
generator, yielding the baud base of 3906250.  This comes from the reset
values of the TCR and MCR[7] registers which are both zero[1][2][3][4],
choosing the oversampling rate of 16 and the normal (divide by 1) baud
rate generator prescaler respectively.  This is the rate that is divided
by the value held in the divisor latch to determine the baud rate used.

Replace the incorrect baud base of 4000000 with the right value of
3906250 then.


[1] "OXPCIe200 PCI Express Multi-Port Bridge", Oxford Semiconductor,
    Inc., DS-0045, 10 Nov 2008, Section "Reset Configuration", p. 72

[2] "OXPCIe952 PCI Express Bridge to Dual Serial & Parallel Port",
    Oxford Semiconductor, Inc., DS-0046, Mar 06 08, Section "Reset
    Configuration", p. 27

[3] "OXPCIe954 PCI Express Bridge to Quad Serial Port", Oxford
    Semiconductor, Inc., DS-0047, Feb 08, Section "Reset Configuration",
    p. 28

[4] "OXPCIe958 PCI Express Bridge to Octal Serial Port", Oxford
    Semiconductor, Inc., DS-0048, Feb 08, Section "Reset Configuration",
    p. 28

Fixes: 7106b4e333bae ("8250: Oxford Semiconductor Devices")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2106100203510.5469@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 128 ++++++++++++++---------------
 1 file changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index c309a8a31621..bdc262b4109c 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2862,7 +2862,7 @@ enum pci_board_num_t {
 	pbn_b0_2_1843200,
 	pbn_b0_4_1843200,
 
-	pbn_b0_1_4000000,
+	pbn_b0_1_3906250,
 
 	pbn_b0_bt_1_115200,
 	pbn_b0_bt_2_115200,
@@ -2942,10 +2942,10 @@ enum pci_board_num_t {
 	pbn_plx_romulus,
 	pbn_endrun_2_3906250,
 	pbn_oxsemi,
-	pbn_oxsemi_1_4000000,
-	pbn_oxsemi_2_4000000,
-	pbn_oxsemi_4_4000000,
-	pbn_oxsemi_8_4000000,
+	pbn_oxsemi_1_3906250,
+	pbn_oxsemi_2_3906250,
+	pbn_oxsemi_4_3906250,
+	pbn_oxsemi_8_3906250,
 	pbn_intel_i960,
 	pbn_sgi_ioc3,
 	pbn_computone_4,
@@ -3092,10 +3092,10 @@ static struct pciserial_board pci_boards[] = {
 		.uart_offset	= 8,
 	},
 
-	[pbn_b0_1_4000000] = {
+	[pbn_b0_1_3906250] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 1,
-		.base_baud	= 4000000,
+		.base_baud	= 3906250,
 		.uart_offset	= 8,
 	},
 
@@ -3490,31 +3490,31 @@ static struct pciserial_board pci_boards[] = {
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
-	[pbn_oxsemi_1_4000000] = {
+	[pbn_oxsemi_1_3906250] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 1,
-		.base_baud	= 4000000,
+		.base_baud	= 3906250,
 		.uart_offset	= 0x200,
 		.first_offset	= 0x1000,
 	},
-	[pbn_oxsemi_2_4000000] = {
+	[pbn_oxsemi_2_3906250] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 2,
-		.base_baud	= 4000000,
+		.base_baud	= 3906250,
 		.uart_offset	= 0x200,
 		.first_offset	= 0x1000,
 	},
-	[pbn_oxsemi_4_4000000] = {
+	[pbn_oxsemi_4_3906250] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 4,
-		.base_baud	= 4000000,
+		.base_baud	= 3906250,
 		.uart_offset	= 0x200,
 		.first_offset	= 0x1000,
 	},
-	[pbn_oxsemi_8_4000000] = {
+	[pbn_oxsemi_8_3906250] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 8,
-		.base_baud	= 4000000,
+		.base_baud	= 3906250,
 		.uart_offset	= 0x200,
 		.first_offset	= 0x1000,
 	},
@@ -4528,158 +4528,158 @@ static const struct pci_device_id serial_pci_tbl[] = {
 	 */
 	{	PCI_VENDOR_ID_OXSEMI, 0xc101,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_b0_1_4000000 },
+		pbn_b0_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc105,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_b0_1_4000000 },
+		pbn_b0_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc11b,    /* OXPCIe952 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc11f,    /* OXPCIe952 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc120,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_b0_1_4000000 },
+		pbn_b0_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc124,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_b0_1_4000000 },
+		pbn_b0_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc138,    /* OXPCIe952 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc13d,    /* OXPCIe952 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc140,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_b0_1_4000000 },
+		pbn_b0_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc141,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_b0_1_4000000 },
+		pbn_b0_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc144,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_b0_1_4000000 },
+		pbn_b0_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc145,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_b0_1_4000000 },
+		pbn_b0_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc158,    /* OXPCIe952 2 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_2_4000000 },
+		pbn_oxsemi_2_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc15d,    /* OXPCIe952 2 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_2_4000000 },
+		pbn_oxsemi_2_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc208,    /* OXPCIe954 4 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_4_4000000 },
+		pbn_oxsemi_4_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc20d,    /* OXPCIe954 4 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_4_4000000 },
+		pbn_oxsemi_4_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc308,    /* OXPCIe958 8 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_8_4000000 },
+		pbn_oxsemi_8_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc30d,    /* OXPCIe958 8 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_8_4000000 },
+		pbn_oxsemi_8_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc40b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc40f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc41b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc41f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc42b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc42f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc43b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc43f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc44b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc44f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc45b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc45f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc46b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc46f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc47b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc47f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc48b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc48f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc49b,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc49f,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc4ab,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc4af,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc4bb,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc4bf,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc4cb,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_OXSEMI, 0xc4cf,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	/*
 	 * Mainpine Inc. IQ Express "Rev3" utilizing OxSemi Tornado
 	 */
 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 1 Port V.34 Super-G3 Fax */
 		PCI_VENDOR_ID_MAINPINE, 0x4001, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_oxsemi_1_3906250 },
 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 2 Port V.34 Super-G3 Fax */
 		PCI_VENDOR_ID_MAINPINE, 0x4002, 0, 0,
-		pbn_oxsemi_2_4000000 },
+		pbn_oxsemi_2_3906250 },
 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 4 Port V.34 Super-G3 Fax */
 		PCI_VENDOR_ID_MAINPINE, 0x4004, 0, 0,
-		pbn_oxsemi_4_4000000 },
+		pbn_oxsemi_4_3906250 },
 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 8 Port V.34 Super-G3 Fax */
 		PCI_VENDOR_ID_MAINPINE, 0x4008, 0, 0,
-		pbn_oxsemi_8_4000000 },
+		pbn_oxsemi_8_3906250 },
 
 	/*
 	 * Digi/IBM PCIe 2-port Async EIA-232 Adapter utilizing OxSemi Tornado
 	 */
 	{	PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_2_OX_IBM,
 		PCI_SUBVENDOR_ID_IBM, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_2_4000000 },
+		pbn_oxsemi_2_3906250 },
 
 	/*
 	 * SBS Technologies, Inc. P-Octal and PMC-OCTPRO cards,
-- 
2.35.1



