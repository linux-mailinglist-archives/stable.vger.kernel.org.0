Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F40364474
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241735AbhDSN1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241715AbhDSN0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:26:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC03613F9;
        Mon, 19 Apr 2021 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838489;
        bh=NQXQVz+GnkBLi3hRUrVOpI/v8qwZ4DsYozB32pkPW/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjPoNo5j8GrznB4ImCbnOXndCR2bODf5wdBM7piUXZEZ9VDOrsDNqzZrTdTDYb4nI
         KlpGm+27zmDaqWgGw30ShtdfFrtmQ5tbTUl/SMlU7hhSEY0hHM30pCkpGne8auThCb
         c6O+bHje6zNISjxQFPZH3WZUFpRGppJLpvnnjfqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 67/73] r8169: simplify setting PCI_EXP_DEVCTL_NOSNOOP_EN
Date:   Mon, 19 Apr 2021 15:06:58 +0200
Message-Id: <20210419130526.006886223@linuxfoundation.org>
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

[ Upstream commit e0bbe7cbb3c5ff72d680993edf89db2391e80d5d ]

r8168b_0_hw_jumbo_enable() and r8168b_0_hw_jumbo_disable() both do the
same and just set PCI_EXP_DEVCTL_NOSNOOP_EN. We can simplify the code
by moving this setting for RTL8168B to rtl_hw_start_8168().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 34 +++++++----------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fb11561a4f17..5ca28985c86b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4083,29 +4083,13 @@ static void r8168e_hw_jumbo_disable(struct rtl8169_private *tp)
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~0x01);
 }
 
-static void r8168b_0_hw_jumbo_enable(struct rtl8169_private *tp)
-{
-	pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
-				 PCI_EXP_DEVCTL_NOSNOOP_EN);
-}
-
-static void r8168b_0_hw_jumbo_disable(struct rtl8169_private *tp)
-{
-	pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
-				 PCI_EXP_DEVCTL_NOSNOOP_EN);
-}
-
 static void r8168b_1_hw_jumbo_enable(struct rtl8169_private *tp)
 {
-	r8168b_0_hw_jumbo_enable(tp);
-
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) | (1 << 0));
 }
 
 static void r8168b_1_hw_jumbo_disable(struct rtl8169_private *tp)
 {
-	r8168b_0_hw_jumbo_disable(tp);
-
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~(1 << 0));
 }
 
@@ -4113,9 +4097,6 @@ static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
 {
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_11:
-		r8168b_0_hw_jumbo_enable(tp);
-		break;
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		r8168b_1_hw_jumbo_enable(tp);
@@ -4139,9 +4120,6 @@ static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 {
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_11:
-		r8168b_0_hw_jumbo_disable(tp);
-		break;
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		r8168b_1_hw_jumbo_disable(tp);
@@ -5406,10 +5384,18 @@ static void rtl_hw_start_8125(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8168(struct rtl8169_private *tp)
 {
-	if (tp->mac_version == RTL_GIGA_MAC_VER_13 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_16)
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_11:
+	case RTL_GIGA_MAC_VER_12:
+	case RTL_GIGA_MAC_VER_13:
+	case RTL_GIGA_MAC_VER_16:
+	case RTL_GIGA_MAC_VER_17:
 		pcie_capability_set_word(tp->pci_dev, PCI_EXP_DEVCTL,
 					 PCI_EXP_DEVCTL_NOSNOOP_EN);
+		break;
+	default:
+		break;
+	}
 
 	if (rtl_is_8168evl_up(tp))
 		RTL_W8(tp, MaxTxPacketSize, EarlySize);
-- 
2.30.2



