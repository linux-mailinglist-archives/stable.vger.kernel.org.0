Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8C383343
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbhEQO4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242074AbhEQOyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:54:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA81D61995;
        Mon, 17 May 2021 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261476;
        bh=odCksGUYP1kyBVF+vtiCul5iCe5NVU3L7LP8bGDgnOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4KT88ai78CV6LyTiP9LQ4T5nA/LMFV8vwqs9qD9aC9dA06JsCaG/tcTVHlbFavd/
         wZSPVgzfJw1YI+ZoYuS97qs8WIc5EDz6IlltnPRaDFD+7Jjacf37YdYI58VyGOXf22
         d/U48fHZKlS0rtWqHJWArDP7sEVoq6UpGQKpQ/6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/141] bnxt_en: Add PCI IDs for Hyper-V VF devices.
Date:   Mon, 17 May 2021 16:01:41 +0200
Message-Id: <20210517140244.424317241@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 7fbf359bb2c19c824cbb1954020680824f6ee5a5 ]

Support VF device IDs used by the Hyper-V hypervisor.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 588389697cf9..106f2b2ce17f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -125,7 +125,10 @@ enum board_idx {
 	NETXTREME_E_VF,
 	NETXTREME_C_VF,
 	NETXTREME_S_VF,
+	NETXTREME_C_VF_HV,
+	NETXTREME_E_VF_HV,
 	NETXTREME_E_P5_VF,
+	NETXTREME_E_P5_VF_HV,
 };
 
 /* indexed by enum above */
@@ -173,7 +176,10 @@ static const struct {
 	[NETXTREME_E_VF] = { "Broadcom NetXtreme-E Ethernet Virtual Function" },
 	[NETXTREME_C_VF] = { "Broadcom NetXtreme-C Ethernet Virtual Function" },
 	[NETXTREME_S_VF] = { "Broadcom NetXtreme-S Ethernet Virtual Function" },
+	[NETXTREME_C_VF_HV] = { "Broadcom NetXtreme-C Virtual Function for Hyper-V" },
+	[NETXTREME_E_VF_HV] = { "Broadcom NetXtreme-E Virtual Function for Hyper-V" },
 	[NETXTREME_E_P5_VF] = { "Broadcom BCM5750X NetXtreme-E Ethernet Virtual Function" },
+	[NETXTREME_E_P5_VF_HV] = { "Broadcom BCM5750X NetXtreme-E Virtual Function for Hyper-V" },
 };
 
 static const struct pci_device_id bnxt_pci_tbl[] = {
@@ -225,15 +231,25 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
 #ifdef CONFIG_BNXT_SRIOV
 	{ PCI_VDEVICE(BROADCOM, 0x1606), .driver_data = NETXTREME_E_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x1607), .driver_data = NETXTREME_E_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x1608), .driver_data = NETXTREME_E_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x1609), .driver_data = NETXTREME_E_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x16bd), .driver_data = NETXTREME_E_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x16c1), .driver_data = NETXTREME_E_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x16c2), .driver_data = NETXTREME_C_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x16c3), .driver_data = NETXTREME_C_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x16c4), .driver_data = NETXTREME_E_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x16c5), .driver_data = NETXTREME_E_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x16cb), .driver_data = NETXTREME_C_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16d3), .driver_data = NETXTREME_E_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16dc), .driver_data = NETXTREME_E_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16e1), .driver_data = NETXTREME_C_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x16e5), .driver_data = NETXTREME_C_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x16e6), .driver_data = NETXTREME_C_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0x1806), .driver_data = NETXTREME_E_P5_VF },
 	{ PCI_VDEVICE(BROADCOM, 0x1807), .driver_data = NETXTREME_E_P5_VF },
+	{ PCI_VDEVICE(BROADCOM, 0x1808), .driver_data = NETXTREME_E_P5_VF_HV },
+	{ PCI_VDEVICE(BROADCOM, 0x1809), .driver_data = NETXTREME_E_P5_VF_HV },
 	{ PCI_VDEVICE(BROADCOM, 0xd800), .driver_data = NETXTREME_S_VF },
 #endif
 	{ 0 }
@@ -263,7 +279,8 @@ static struct workqueue_struct *bnxt_pf_wq;
 static bool bnxt_vf_pciid(enum board_idx idx)
 {
 	return (idx == NETXTREME_C_VF || idx == NETXTREME_E_VF ||
-		idx == NETXTREME_S_VF || idx == NETXTREME_E_P5_VF);
+		idx == NETXTREME_S_VF || idx == NETXTREME_C_VF_HV ||
+		idx == NETXTREME_E_VF_HV || idx == NETXTREME_E_P5_VF);
 }
 
 #define DB_CP_REARM_FLAGS	(DB_KEY_CP | DB_IDX_VALID)
-- 
2.30.2



