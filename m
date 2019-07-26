Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D191476DC2
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388642AbfGZPbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389191AbfGZPbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:31:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A974A205F4;
        Fri, 26 Jul 2019 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155062;
        bh=UzBZKX+YAvWDWmYQ+tmNB5ZGSrCDrz9XJDigPe6VYhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9pUyL236k3UKJQrPQCSO5qENqSYG6PBGP/ZXeoQnshg8M7tK0/8XuGZ1oMReLNgH
         rqPvWsWtCFxM2fNkClxYmzyorIPRBbqic552EATb5d7eZImzKhEwcN5xsTVsxRDAMI
         gh99lMyA0ftP7YwwwbAhlnSzIRDP6AeeIqfveM9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ionut Radu <ionut.radu@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 18/62] r8169: fix issue with confused RX unit after PHY power-down on RTL8411b
Date:   Fri, 26 Jul 2019 17:24:30 +0200
Message-Id: <20190726152303.624067402@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit fe4e8db0392a6c2e795eb89ef5fcd86522e66248 ]

On RTL8411b the RX unit gets confused if the PHY is powered-down.
This was reported in [0] and confirmed by Realtek. Realtek provided
a sequence to fix the RX unit after PHY wakeup.

The issue itself seems to have been there longer, the Fixes tag
refers to where the fix applies properly.

[0] https://bugzilla.redhat.com/show_bug.cgi?id=1692075

Fixes: a99790bf5c7f ("r8169: Reinstate ASPM Support")
Tested-by: Ionut Radu <ionut.radu@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |  137 +++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5241,6 +5241,143 @@ static void rtl_hw_start_8411_2(struct r
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8411_2, ARRAY_SIZE(e_info_8411_2));
+
+	/* The following Realtek-provided magic fixes an issue with the RX unit
+	 * getting confused after the PHY having been powered-down.
+	 */
+	r8168_mac_ocp_write(tp, 0xFC28, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC2A, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC2C, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC2E, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC30, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC32, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC34, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC36, 0x0000);
+	mdelay(3);
+	r8168_mac_ocp_write(tp, 0xFC26, 0x0000);
+
+	r8168_mac_ocp_write(tp, 0xF800, 0xE008);
+	r8168_mac_ocp_write(tp, 0xF802, 0xE00A);
+	r8168_mac_ocp_write(tp, 0xF804, 0xE00C);
+	r8168_mac_ocp_write(tp, 0xF806, 0xE00E);
+	r8168_mac_ocp_write(tp, 0xF808, 0xE027);
+	r8168_mac_ocp_write(tp, 0xF80A, 0xE04F);
+	r8168_mac_ocp_write(tp, 0xF80C, 0xE05E);
+	r8168_mac_ocp_write(tp, 0xF80E, 0xE065);
+	r8168_mac_ocp_write(tp, 0xF810, 0xC602);
+	r8168_mac_ocp_write(tp, 0xF812, 0xBE00);
+	r8168_mac_ocp_write(tp, 0xF814, 0x0000);
+	r8168_mac_ocp_write(tp, 0xF816, 0xC502);
+	r8168_mac_ocp_write(tp, 0xF818, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF81A, 0x074C);
+	r8168_mac_ocp_write(tp, 0xF81C, 0xC302);
+	r8168_mac_ocp_write(tp, 0xF81E, 0xBB00);
+	r8168_mac_ocp_write(tp, 0xF820, 0x080A);
+	r8168_mac_ocp_write(tp, 0xF822, 0x6420);
+	r8168_mac_ocp_write(tp, 0xF824, 0x48C2);
+	r8168_mac_ocp_write(tp, 0xF826, 0x8C20);
+	r8168_mac_ocp_write(tp, 0xF828, 0xC516);
+	r8168_mac_ocp_write(tp, 0xF82A, 0x64A4);
+	r8168_mac_ocp_write(tp, 0xF82C, 0x49C0);
+	r8168_mac_ocp_write(tp, 0xF82E, 0xF009);
+	r8168_mac_ocp_write(tp, 0xF830, 0x74A2);
+	r8168_mac_ocp_write(tp, 0xF832, 0x8CA5);
+	r8168_mac_ocp_write(tp, 0xF834, 0x74A0);
+	r8168_mac_ocp_write(tp, 0xF836, 0xC50E);
+	r8168_mac_ocp_write(tp, 0xF838, 0x9CA2);
+	r8168_mac_ocp_write(tp, 0xF83A, 0x1C11);
+	r8168_mac_ocp_write(tp, 0xF83C, 0x9CA0);
+	r8168_mac_ocp_write(tp, 0xF83E, 0xE006);
+	r8168_mac_ocp_write(tp, 0xF840, 0x74F8);
+	r8168_mac_ocp_write(tp, 0xF842, 0x48C4);
+	r8168_mac_ocp_write(tp, 0xF844, 0x8CF8);
+	r8168_mac_ocp_write(tp, 0xF846, 0xC404);
+	r8168_mac_ocp_write(tp, 0xF848, 0xBC00);
+	r8168_mac_ocp_write(tp, 0xF84A, 0xC403);
+	r8168_mac_ocp_write(tp, 0xF84C, 0xBC00);
+	r8168_mac_ocp_write(tp, 0xF84E, 0x0BF2);
+	r8168_mac_ocp_write(tp, 0xF850, 0x0C0A);
+	r8168_mac_ocp_write(tp, 0xF852, 0xE434);
+	r8168_mac_ocp_write(tp, 0xF854, 0xD3C0);
+	r8168_mac_ocp_write(tp, 0xF856, 0x49D9);
+	r8168_mac_ocp_write(tp, 0xF858, 0xF01F);
+	r8168_mac_ocp_write(tp, 0xF85A, 0xC526);
+	r8168_mac_ocp_write(tp, 0xF85C, 0x64A5);
+	r8168_mac_ocp_write(tp, 0xF85E, 0x1400);
+	r8168_mac_ocp_write(tp, 0xF860, 0xF007);
+	r8168_mac_ocp_write(tp, 0xF862, 0x0C01);
+	r8168_mac_ocp_write(tp, 0xF864, 0x8CA5);
+	r8168_mac_ocp_write(tp, 0xF866, 0x1C15);
+	r8168_mac_ocp_write(tp, 0xF868, 0xC51B);
+	r8168_mac_ocp_write(tp, 0xF86A, 0x9CA0);
+	r8168_mac_ocp_write(tp, 0xF86C, 0xE013);
+	r8168_mac_ocp_write(tp, 0xF86E, 0xC519);
+	r8168_mac_ocp_write(tp, 0xF870, 0x74A0);
+	r8168_mac_ocp_write(tp, 0xF872, 0x48C4);
+	r8168_mac_ocp_write(tp, 0xF874, 0x8CA0);
+	r8168_mac_ocp_write(tp, 0xF876, 0xC516);
+	r8168_mac_ocp_write(tp, 0xF878, 0x74A4);
+	r8168_mac_ocp_write(tp, 0xF87A, 0x48C8);
+	r8168_mac_ocp_write(tp, 0xF87C, 0x48CA);
+	r8168_mac_ocp_write(tp, 0xF87E, 0x9CA4);
+	r8168_mac_ocp_write(tp, 0xF880, 0xC512);
+	r8168_mac_ocp_write(tp, 0xF882, 0x1B00);
+	r8168_mac_ocp_write(tp, 0xF884, 0x9BA0);
+	r8168_mac_ocp_write(tp, 0xF886, 0x1B1C);
+	r8168_mac_ocp_write(tp, 0xF888, 0x483F);
+	r8168_mac_ocp_write(tp, 0xF88A, 0x9BA2);
+	r8168_mac_ocp_write(tp, 0xF88C, 0x1B04);
+	r8168_mac_ocp_write(tp, 0xF88E, 0xC508);
+	r8168_mac_ocp_write(tp, 0xF890, 0x9BA0);
+	r8168_mac_ocp_write(tp, 0xF892, 0xC505);
+	r8168_mac_ocp_write(tp, 0xF894, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF896, 0xC502);
+	r8168_mac_ocp_write(tp, 0xF898, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF89A, 0x0300);
+	r8168_mac_ocp_write(tp, 0xF89C, 0x051E);
+	r8168_mac_ocp_write(tp, 0xF89E, 0xE434);
+	r8168_mac_ocp_write(tp, 0xF8A0, 0xE018);
+	r8168_mac_ocp_write(tp, 0xF8A2, 0xE092);
+	r8168_mac_ocp_write(tp, 0xF8A4, 0xDE20);
+	r8168_mac_ocp_write(tp, 0xF8A6, 0xD3C0);
+	r8168_mac_ocp_write(tp, 0xF8A8, 0xC50F);
+	r8168_mac_ocp_write(tp, 0xF8AA, 0x76A4);
+	r8168_mac_ocp_write(tp, 0xF8AC, 0x49E3);
+	r8168_mac_ocp_write(tp, 0xF8AE, 0xF007);
+	r8168_mac_ocp_write(tp, 0xF8B0, 0x49C0);
+	r8168_mac_ocp_write(tp, 0xF8B2, 0xF103);
+	r8168_mac_ocp_write(tp, 0xF8B4, 0xC607);
+	r8168_mac_ocp_write(tp, 0xF8B6, 0xBE00);
+	r8168_mac_ocp_write(tp, 0xF8B8, 0xC606);
+	r8168_mac_ocp_write(tp, 0xF8BA, 0xBE00);
+	r8168_mac_ocp_write(tp, 0xF8BC, 0xC602);
+	r8168_mac_ocp_write(tp, 0xF8BE, 0xBE00);
+	r8168_mac_ocp_write(tp, 0xF8C0, 0x0C4C);
+	r8168_mac_ocp_write(tp, 0xF8C2, 0x0C28);
+	r8168_mac_ocp_write(tp, 0xF8C4, 0x0C2C);
+	r8168_mac_ocp_write(tp, 0xF8C6, 0xDC00);
+	r8168_mac_ocp_write(tp, 0xF8C8, 0xC707);
+	r8168_mac_ocp_write(tp, 0xF8CA, 0x1D00);
+	r8168_mac_ocp_write(tp, 0xF8CC, 0x8DE2);
+	r8168_mac_ocp_write(tp, 0xF8CE, 0x48C1);
+	r8168_mac_ocp_write(tp, 0xF8D0, 0xC502);
+	r8168_mac_ocp_write(tp, 0xF8D2, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF8D4, 0x00AA);
+	r8168_mac_ocp_write(tp, 0xF8D6, 0xE0C0);
+	r8168_mac_ocp_write(tp, 0xF8D8, 0xC502);
+	r8168_mac_ocp_write(tp, 0xF8DA, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF8DC, 0x0132);
+
+	r8168_mac_ocp_write(tp, 0xFC26, 0x8000);
+
+	r8168_mac_ocp_write(tp, 0xFC2A, 0x0743);
+	r8168_mac_ocp_write(tp, 0xFC2C, 0x0801);
+	r8168_mac_ocp_write(tp, 0xFC2E, 0x0BE9);
+	r8168_mac_ocp_write(tp, 0xFC30, 0x02FD);
+	r8168_mac_ocp_write(tp, 0xFC32, 0x0C25);
+	r8168_mac_ocp_write(tp, 0xFC34, 0x00A9);
+	r8168_mac_ocp_write(tp, 0xFC36, 0x012D);
+
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 


