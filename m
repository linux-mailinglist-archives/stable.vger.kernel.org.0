Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7EB1EACEB
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbgFASMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731231AbgFASMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:12:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEDED2065C;
        Mon,  1 Jun 2020 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035152;
        bh=5ohnT+53OhofnfzhkpfOKq3gy1ljv3XtLhTw5zwu6js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFQ5yZW3xMbMSvDm7fcuLfRIrmikaffGO26x6RRzlFU2Yr9A2bsO7FHvlKf6i4EHp
         +awGArvJyc/ScsJdA7/EkOmDwvsGt2lHiep7v+UrEYJM1WLFSvF1PrsmrOhCU6IsgL
         aHWS9pg2GAXQ5rKXA1zaGO0ffsP2Gailk6TnhY+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 031/177] r8169: fix OCP access on RTL8117
Date:   Mon,  1 Jun 2020 19:52:49 +0200
Message-Id: <20200601174051.463573340@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 561535b0f23961ced071b82575d5e83e6351a814 ]

According to r8168 vendor driver DASHv3 chips like RTL8168fp/RTL8117
need a special addressing for OCP access.
Fix is compile-tested only due to missing test hardware.

Fixes: 1287723aa139 ("r8169: add support for RTL8117")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1044,6 +1044,13 @@ static u16 rtl_ephy_read(struct rtl8169_
 		RTL_R32(tp, EPHYAR) & EPHYAR_DATA_MASK : ~0;
 }
 
+static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int type)
+{
+	/* based on RTL8168FP_OOBMAC_BASE in vendor driver */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
+		*cmd |= 0x7f0 << 18;
+}
+
 DECLARE_RTL_COND(rtl_eriar_cond)
 {
 	return RTL_R32(tp, ERIAR) & ERIAR_FLAG;
@@ -1052,9 +1059,12 @@ DECLARE_RTL_COND(rtl_eriar_cond)
 static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
 			   u32 val, int type)
 {
+	u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
+
 	BUG_ON((addr & 3) || (mask == 0));
 	RTL_W32(tp, ERIDR, val);
-	RTL_W32(tp, ERIAR, ERIAR_WRITE_CMD | type | mask | addr);
+	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
+	RTL_W32(tp, ERIAR, cmd);
 
 	rtl_udelay_loop_wait_low(tp, &rtl_eriar_cond, 100, 100);
 }
@@ -1067,7 +1077,10 @@ static void rtl_eri_write(struct rtl8169
 
 static u32 _rtl_eri_read(struct rtl8169_private *tp, int addr, int type)
 {
-	RTL_W32(tp, ERIAR, ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr);
+	u32 cmd = ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr;
+
+	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
+	RTL_W32(tp, ERIAR, cmd);
 
 	return rtl_udelay_loop_wait_high(tp, &rtl_eriar_cond, 100, 100) ?
 		RTL_R32(tp, ERIDR) : ~0;


