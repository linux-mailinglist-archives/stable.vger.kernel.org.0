Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FCC36447C
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242410AbhDSN2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242113AbhDSN0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:26:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F537613FB;
        Mon, 19 Apr 2021 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838492;
        bh=JewShkVqLKQa5Ygsehfd+N6mhzVph9NRF02dEbubrZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsCeAouhZrN+Z0vXEoqByIZFJVo0s6FQEBHxjy+VHEq2MN8ZJvrns4AZgAefduNxN
         gP6qraKqjh4XjjLKAjt7ZCdQTsBUaITYalqere6e3k6ptFwBUZRHKv8WTMNljG78W2
         oM1tt5z409ahFBTsTpcnu7XLeR3Qe+pmLFyM8fs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 68/73] r8169: fix performance regression related to PCIe max read request size
Date:   Mon, 19 Apr 2021 15:06:59 +0200
Message-Id: <20210419130526.038418686@linuxfoundation.org>
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

[ Upstream commit 21b5f672fb2eb1366dedc4ac9d32431146b378d3 ]

It turned out that on low performance systems the original change can
cause lower tx performance. On a N3450-based mini-PC tx performance
in iperf3 was reduced from 950Mbps to ~900Mbps. Therefore effectively
revert the original change, just use pcie_set_readrq() now instead of
changing the PCIe capability register directly.

Fixes: 2df49d365498 ("r8169: remove fiddling with the PCIe max read request size")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5ca28985c86b..19ebde91555d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4099,15 +4099,18 @@ static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
+		pcie_set_readrq(tp->pci_dev, 512);
 		r8168b_1_hw_jumbo_enable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
+		pcie_set_readrq(tp->pci_dev, 512);
 		r8168c_hw_jumbo_enable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
 		r8168dp_hw_jumbo_enable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
+		pcie_set_readrq(tp->pci_dev, 512);
 		r8168e_hw_jumbo_enable(tp);
 		break;
 	default:
@@ -4137,6 +4140,9 @@ static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 		break;
 	}
 	rtl_lock_config_regs(tp);
+
+	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
+		pcie_set_readrq(tp->pci_dev, 4096);
 }
 
 static void rtl_jumbo_config(struct rtl8169_private *tp, int mtu)
-- 
2.30.2



