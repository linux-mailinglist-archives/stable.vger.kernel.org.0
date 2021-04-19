Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486D1364473
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241686AbhDSN13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241672AbhDSN0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:26:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C209A613ED;
        Mon, 19 Apr 2021 13:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838486;
        bh=b3NFOQO0oit3QjkQ+lmIfZ1RWUFCrGMy0ctFi/XkfmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4KB2yUKILDRfnZyovsk9u57nic3Cx45B9Hzx2pI2HllEf161E148r7HEs8i2J/Ks
         18N7WHOmuUtGuIJSy5k/pk2VCJKUmwNhNBRcNO3b/1nqFnt82VSEVZNpyNRTB++bVa
         +c80KUQOnN4nagFY85yrRb+6kepbi3EaQtDhMEvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 66/73] r8169: remove fiddling with the PCIe max read request size
Date:   Mon, 19 Apr 2021 15:06:57 +0200
Message-Id: <20210419130525.972456777@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 2df49d36549808a7357ad9f78b7a8e39516e7809 ]

The attempt to improve performance by changing the PCIe max read request
size was added in the vendor driver more than 10 years back and copied
to r8169 driver. In the vendor driver this has been removed long ago.
Obviously it had no effect, also in my tests I didn't see any
difference. Typically the max payload size is less than 512 bytes
anyway, and the PCI core takes care that the maximum supported value
is set. So let's remove fiddling with PCIe max read request size from
r8169 too.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 40 +++--------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bd8decc54b87..fb11561a4f17 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -742,12 +742,6 @@ static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
 }
 
-static void rtl_tx_performance_tweak(struct rtl8169_private *tp, u16 force)
-{
-	pcie_capability_clear_and_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
-					   PCI_EXP_DEVCTL_READRQ, force);
-}
-
 static bool rtl_is_8125(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_60;
@@ -4057,14 +4051,12 @@ static void r8168c_hw_jumbo_enable(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) | Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) | Jumbo_En1);
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_512B);
 }
 
 static void r8168c_hw_jumbo_disable(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~Jumbo_En1);
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void r8168dp_hw_jumbo_enable(struct rtl8169_private *tp)
@@ -4082,7 +4074,6 @@ static void r8168e_hw_jumbo_enable(struct rtl8169_private *tp)
 	RTL_W8(tp, MaxTxPacketSize, 0x24);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) | Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) | 0x01);
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_512B);
 }
 
 static void r8168e_hw_jumbo_disable(struct rtl8169_private *tp)
@@ -4090,19 +4081,18 @@ static void r8168e_hw_jumbo_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, MaxTxPacketSize, 0x3f);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~0x01);
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void r8168b_0_hw_jumbo_enable(struct rtl8169_private *tp)
 {
-	rtl_tx_performance_tweak(tp,
-		PCI_EXP_DEVCTL_READRQ_512B | PCI_EXP_DEVCTL_NOSNOOP_EN);
+	pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
+				 PCI_EXP_DEVCTL_NOSNOOP_EN);
 }
 
 static void r8168b_0_hw_jumbo_disable(struct rtl8169_private *tp)
 {
-	rtl_tx_performance_tweak(tp,
-		PCI_EXP_DEVCTL_READRQ_4096B | PCI_EXP_DEVCTL_NOSNOOP_EN);
+	pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
+				 PCI_EXP_DEVCTL_NOSNOOP_EN);
 }
 
 static void r8168b_1_hw_jumbo_enable(struct rtl8169_private *tp)
@@ -4575,18 +4565,12 @@ static void rtl_hw_start_8168d(struct rtl8169_private *tp)
 	rtl_set_def_aspm_entry_latency(tp);
 
 	rtl_disable_clock_request(tp);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void rtl_hw_start_8168dp(struct rtl8169_private *tp)
 {
 	rtl_set_def_aspm_entry_latency(tp);
 
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_disable_clock_request(tp);
 }
 
@@ -4601,8 +4585,6 @@ static void rtl_hw_start_8168d_4(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_ephy_init(tp, e_info_8168d_4);
 
 	rtl_enable_clock_request(tp);
@@ -4677,8 +4659,6 @@ static void rtl_hw_start_8168f(struct rtl8169_private *tp)
 {
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
@@ -4741,8 +4721,6 @@ static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_reset_packet_filter(tp);
 	rtl_eri_write(tp, 0x2f8, ERIAR_MASK_0011, 0x1d8f);
 
@@ -4979,8 +4957,6 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_reset_packet_filter(tp);
 
 	rtl_eri_set_bits(tp, 0xdc, ERIAR_MASK_1111, BIT(4));
@@ -5038,8 +5014,6 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_reset_packet_filter(tp);
 
 	rtl_eri_set_bits(tp, 0xd4, ERIAR_MASK_1111, 0x1f80);
@@ -5142,8 +5116,6 @@ static void rtl_hw_start_8102e_1(struct rtl8169_private *tp)
 
 	RTL_W8(tp, DBG_REG, FIX_NAK_1);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	RTL_W8(tp, Config1,
 	       LEDS1 | LEDS0 | Speed_down | MEMMAP | IOMAP | VPD | PMEnable);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
@@ -5159,8 +5131,6 @@ static void rtl_hw_start_8102e_2(struct rtl8169_private *tp)
 {
 	rtl_set_def_aspm_entry_latency(tp);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	RTL_W8(tp, Config1, MEMMAP | IOMAP | VPD | PMEnable);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
 }
@@ -5221,8 +5191,6 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8402);
 
-	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_set_fifo_size(tp, 0x00, 0x00, 0x02, 0x06);
 	rtl_reset_packet_filter(tp);
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
-- 
2.30.2



