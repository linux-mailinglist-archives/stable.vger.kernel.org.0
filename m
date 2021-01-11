Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6E2F14B8
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbhAKNQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:16:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732321AbhAKNQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C850E22AAF;
        Mon, 11 Jan 2021 13:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370924;
        bh=oOBJirg8qm11NYUZkzKNBcocKaIKzDjg3yr8e5hFAnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dj9EGbW6mt/OxT2Q8bGcLaAtRvMwPBu8XZG/HAq0Xr58EC6eTcPcCfj84zPDPj3Nb
         xJHr/Pu1baLNuXNoTidr6ppYxoYhUZ/tHYpUTdczILuKZ507J+YeHoKl14pAZiMRXL
         1bNswxN/fzaVWt1uJMcZKe4eCnjROigPwcs3DYuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 033/145] bnxt_en: Fix AER recovery.
Date:   Mon, 11 Jan 2021 14:00:57 +0100
Message-Id: <20210111130050.109775061@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit fb1e6e562b37b39adfe251919c9abfdb3e01f921 ]

A recent change skips sending firmware messages to the firmware when
pci_channel_offline() is true during fatal AER error.  To make this
complete, we need to move the re-initialization sequence to
bnxt_io_resume(), otherwise the firmware messages to re-initialize
will all be skipped.  In any case, it is more correct to re-initialize
in bnxt_io_resume().

Also, fix the reverse x-mas tree format when defining variables
in bnxt_io_slot_reset().

Fixes: b340dc680ed4 ("bnxt_en: Avoid sending firmware messages when AER error is detected.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   31 +++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12890,10 +12890,10 @@ static pci_ers_result_t bnxt_io_error_de
  */
 static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 {
+	pci_ers_result_t result = PCI_ERS_RESULT_DISCONNECT;
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(netdev);
 	int err = 0, off;
-	pci_ers_result_t result = PCI_ERS_RESULT_DISCONNECT;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
@@ -12922,22 +12922,8 @@ static pci_ers_result_t bnxt_io_slot_res
 		pci_save_state(pdev);
 
 		err = bnxt_hwrm_func_reset(bp);
-		if (!err) {
-			err = bnxt_hwrm_func_qcaps(bp);
-			if (!err && netif_running(netdev))
-				err = bnxt_open(netdev);
-		}
-		bnxt_ulp_start(bp, err);
-		if (!err) {
-			bnxt_reenable_sriov(bp);
+		if (!err)
 			result = PCI_ERS_RESULT_RECOVERED;
-		}
-	}
-
-	if (result != PCI_ERS_RESULT_RECOVERED) {
-		if (netif_running(netdev))
-			dev_close(netdev);
-		pci_disable_device(pdev);
 	}
 
 	rtnl_unlock();
@@ -12955,10 +12941,21 @@ static pci_ers_result_t bnxt_io_slot_res
 static void bnxt_io_resume(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct bnxt *bp = netdev_priv(netdev);
+	int err;
 
+	netdev_info(bp->dev, "PCI Slot Resume\n");
 	rtnl_lock();
 
-	netif_device_attach(netdev);
+	err = bnxt_hwrm_func_qcaps(bp);
+	if (!err && netif_running(netdev))
+		err = bnxt_open(netdev);
+
+	bnxt_ulp_start(bp, err);
+	if (!err) {
+		bnxt_reenable_sriov(bp);
+		netif_device_attach(netdev);
+	}
 
 	rtnl_unlock();
 }


