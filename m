Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72B43A14A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhJYTiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236687AbhJYTfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F10C660720;
        Mon, 25 Oct 2021 19:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190332;
        bh=bbPG23kf7cemD9IEp0pyGaHW8thjOrMOylc2zno9JZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4JAG1EUmI9cNmaWH30LrF+ZPmtwkSpkABVa50OTabF+4bXJtyqS7qW1celUsvbJv
         0NZipcyZ4aCq2D/4EmIMG63DX/pnDm5/Sx8GzELYQj1KHKJYMFmgXWrtnAhQPBUyZH
         YvvN+qI13CgT5AQzNC0trYk/XYs/j5EtpoQslHWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/95] ice: Add missing E810 device ids
Date:   Mon, 25 Oct 2021 21:14:28 +0200
Message-Id: <20211025191001.427203653@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

[ Upstream commit 7dcf78b870be6418d72bb1c4d4924bf0f5ca5052 ]

As part of support for E810 XXV devices, some device ids were
inadvertently left out. Add those missing ids.

Fixes: 195fb97766da ("ice: add additional E810 device id")
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 ++
 drivers/net/ethernet/intel/ice/ice_devids.h | 4 ++++
 drivers/net/ethernet/intel/ice/ice_main.c   | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2239a5f45e5a..64714757bd4f 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -24,6 +24,8 @@ static enum ice_status ice_set_mac_type(struct ice_hw *hw)
 	case ICE_DEV_ID_E810C_BACKPLANE:
 	case ICE_DEV_ID_E810C_QSFP:
 	case ICE_DEV_ID_E810C_SFP:
+	case ICE_DEV_ID_E810_XXV_BACKPLANE:
+	case ICE_DEV_ID_E810_XXV_QSFP:
 	case ICE_DEV_ID_E810_XXV_SFP:
 		hw->mac_type = ICE_MAC_E810;
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index 9d8194671f6a..ef4392e6e244 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -21,6 +21,10 @@
 #define ICE_DEV_ID_E810C_QSFP		0x1592
 /* Intel(R) Ethernet Controller E810-C for SFP */
 #define ICE_DEV_ID_E810C_SFP		0x1593
+/* Intel(R) Ethernet Controller E810-XXV for backplane */
+#define ICE_DEV_ID_E810_XXV_BACKPLANE	0x1599
+/* Intel(R) Ethernet Controller E810-XXV for QSFP */
+#define ICE_DEV_ID_E810_XXV_QSFP	0x159A
 /* Intel(R) Ethernet Controller E810-XXV for SFP */
 #define ICE_DEV_ID_E810_XXV_SFP		0x159B
 /* Intel(R) Ethernet Connection E823-C for backplane */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5d0dc1f811e0..66d92a0cfef3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4773,6 +4773,8 @@ static const struct pci_device_id ice_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_BACKPLANE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810C_SFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_BACKPLANE), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_QSFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E810_XXV_SFP), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_BACKPLANE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823C_QSFP), 0 },
-- 
2.33.0



