Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10232A16C1
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgJaLoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgJaLoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6007220825;
        Sat, 31 Oct 2020 11:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144652;
        bh=w0YWYuPjfmsxWuuseKi4yKDF9zgBqItLaZXuVmsJQdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCA6IRfu9eparGOksISZExNjuxCGfeH0hW1hD88MHkWW7FlVA9JQQzEdSLeFuYCBd
         40cpPEW1FxoF6VCuqd5gcLzXn4Z1Sca65RQkNxIw2d9mUX2QFtm5m6XrhlyE/xnxBM
         mUiQWohMc7qRF51x+idZX0yclmTDLenFgXp7GiYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 30/74] bnxt_en: Re-write PCI BARs after PCI fatal error.
Date:   Sat, 31 Oct 2020 12:36:12 +0100
Message-Id: <20201031113501.488875261@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit f75d9a0aa96721d20011cd5f8c7a24eb32728589 ]

When a PCIe fatal error occurs, the internal latched BAR addresses
in the chip get reset even though the BAR register values in config
space are retained.

pci_restore_state() will not rewrite the BAR addresses if the
BAR address values are valid, causing the chip's internal BAR addresses
to stay invalid.  So we need to zero the BAR registers during PCIe fatal
error to force pci_restore_state() to restore the BAR addresses.  These
write cycles to the BAR registers will cause the proper BAR addresses to
latch internally.

Fixes: 6316ea6db93d ("bnxt_en: Enable AER support.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   19 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |    1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12530,6 +12530,9 @@ static pci_ers_result_t bnxt_io_error_de
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	if (state == pci_channel_io_frozen)
+		set_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN, &bp->state);
+
 	if (netif_running(netdev))
 		bnxt_close(netdev);
 
@@ -12556,7 +12559,7 @@ static pci_ers_result_t bnxt_io_slot_res
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(netdev);
-	int err = 0;
+	int err = 0, off;
 	pci_ers_result_t result = PCI_ERS_RESULT_DISCONNECT;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
@@ -12568,6 +12571,20 @@ static pci_ers_result_t bnxt_io_slot_res
 			"Cannot re-enable PCI device after reset.\n");
 	} else {
 		pci_set_master(pdev);
+		/* Upon fatal error, our device internal logic that latches to
+		 * BAR value is getting reset and will restore only upon
+		 * rewritting the BARs.
+		 *
+		 * As pci_restore_state() does not re-write the BARs if the
+		 * value is same as saved value earlier, driver needs to
+		 * write the BARs to 0 to force restore, in case of fatal error.
+		 */
+		if (test_and_clear_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN,
+				       &bp->state)) {
+			for (off = PCI_BASE_ADDRESS_0;
+			     off <= PCI_BASE_ADDRESS_5; off += 4)
+				pci_write_config_dword(bp->pdev, off, 0);
+		}
 		pci_restore_state(pdev);
 		pci_save_state(pdev);
 
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1736,6 +1736,7 @@ struct bnxt {
 #define BNXT_STATE_ABORT_ERR	5
 #define BNXT_STATE_FW_FATAL_COND	6
 #define BNXT_STATE_DRV_REGISTERED	7
+#define BNXT_STATE_PCI_CHANNEL_IO_FROZEN	8
 
 #define BNXT_NO_FW_ACCESS(bp)					\
 	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\


