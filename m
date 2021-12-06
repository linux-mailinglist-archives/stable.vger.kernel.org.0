Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D52469D3B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbhLFP2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42376 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359134AbhLFPYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 734C36133C;
        Mon,  6 Dec 2021 15:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D03C341C2;
        Mon,  6 Dec 2021 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804046;
        bh=RLPrFAp3DVZ6ThzxUXhWMGaAznPUo5CPpjnjLqs8W7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLF7g30IbNQ4B9YEAfgQ5Tav60aww6b/D9G0QpOnU3/ybbd4qplzufYZfT9NoNsuf
         XFk+SsRm3u+ptfS3uI5XYk7rFGfgJTtjuv/gLpIqFCHkFsin7WTi5pRlq7X9vV/E7S
         v5LPTC9vHug77fIKT0xfpumiV/RjM5vk7wG7eFC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Danilov <ndanilov@aquantia.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 099/130] atlantic: Add missing DIDs and fix 115c.
Date:   Mon,  6 Dec 2021 15:56:56 +0100
Message-Id: <20211206145603.070909853@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Danilov <ndanilov@aquantia.com>

commit 413d5e09caa5a11da9c7d72401ba0588466a04c0 upstream.

At the late production stages new dev ids were introduced. These are
now in production, so its important for the driver to recognize these.
And also fix the board caps for AQC115C adapter.

Fixes: b3f0c79cba206 ("net: atlantic: A2 hw_ops skeleton")
Signed-off-by: Nikita Danilov <ndanilov@aquantia.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_common.h       |    2 +
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c     |    7 +++++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c |   17 +++++++++++++++
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h |    2 +
 4 files changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -40,10 +40,12 @@
 
 #define AQ_DEVICE_ID_AQC113DEV	0x00C0
 #define AQ_DEVICE_ID_AQC113CS	0x94C0
+#define AQ_DEVICE_ID_AQC113CA	0x34C0
 #define AQ_DEVICE_ID_AQC114CS	0x93C0
 #define AQ_DEVICE_ID_AQC113	0x04C0
 #define AQ_DEVICE_ID_AQC113C	0x14C0
 #define AQ_DEVICE_ID_AQC115C	0x12C0
+#define AQ_DEVICE_ID_AQC116C	0x11C0
 
 #define HW_ATL_NIC_NAME "Marvell (aQuantia) AQtion 10Gbit Network Adapter"
 
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -49,6 +49,8 @@ static const struct pci_device_id aq_pci
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113), },
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113C), },
 	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC115C), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC113CA), },
+	{ PCI_VDEVICE(AQUANTIA, AQ_DEVICE_ID_AQC116C), },
 
 	{}
 };
@@ -85,7 +87,10 @@ static const struct aq_board_revision_s
 	{ AQ_DEVICE_ID_AQC113CS,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
 	{ AQ_DEVICE_ID_AQC114CS,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
 	{ AQ_DEVICE_ID_AQC113C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
-	{ AQ_DEVICE_ID_AQC115C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC115C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc115c, },
+	{ AQ_DEVICE_ID_AQC113CA,	AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc113, },
+	{ AQ_DEVICE_ID_AQC116C,		AQ_HWREV_ANY,	&hw_atl2_ops, &hw_atl2_caps_aqc116c, },
+
 };
 
 MODULE_DEVICE_TABLE(pci, aq_pci_tbl);
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -72,6 +72,23 @@ const struct aq_hw_caps_s hw_atl2_caps_a
 			  AQ_NIC_RATE_10M_HALF,
 };
 
+const struct aq_hw_caps_s hw_atl2_caps_aqc115c = {
+	DEFAULT_BOARD_BASIC_CAPABILITIES,
+	.media_type = AQ_HW_MEDIA_TYPE_TP,
+	.link_speed_msk = AQ_NIC_RATE_2G5 |
+			  AQ_NIC_RATE_1G  |
+			  AQ_NIC_RATE_100M      |
+			  AQ_NIC_RATE_10M,
+};
+
+const struct aq_hw_caps_s hw_atl2_caps_aqc116c = {
+	DEFAULT_BOARD_BASIC_CAPABILITIES,
+	.media_type = AQ_HW_MEDIA_TYPE_TP,
+	.link_speed_msk = AQ_NIC_RATE_1G  |
+			  AQ_NIC_RATE_100M      |
+			  AQ_NIC_RATE_10M,
+};
+
 static u32 hw_atl2_sem_act_rslvr_get(struct aq_hw_s *self)
 {
 	return hw_atl_reg_glb_cpu_sem_get(self, HW_ATL2_FW_SM_ACT_RSLVR);
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h
@@ -9,6 +9,8 @@
 #include "aq_common.h"
 
 extern const struct aq_hw_caps_s hw_atl2_caps_aqc113;
+extern const struct aq_hw_caps_s hw_atl2_caps_aqc115c;
+extern const struct aq_hw_caps_s hw_atl2_caps_aqc116c;
 extern const struct aq_hw_ops hw_atl2_ops;
 
 #endif /* HW_ATL2_H */


