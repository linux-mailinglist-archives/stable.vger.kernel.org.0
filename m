Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFE97F20B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbfHBJob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405252AbfHBJoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:44:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13C120880;
        Fri,  2 Aug 2019 09:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739070;
        bh=Ydzo/M4pzNaguWdIFX4/lUmoCl34IQOmszNk0yMUbmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnRJ5jPhQqqWlKrQrR5hjnWwCrOgq7j0bvzQyh+VaUwjuIgyPnbS/o800TEVO/Ala
         IJFfai0i2QDrNrlTtt3qILRsstS3VWyJNhe/xoPvpxqOunHrjU7H+gcX6ABZFzZl1D
         CM49EqtEreUeLcFa7fv6dCcqHgbmifaxNMNeV5jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 4.9 086/223] iwlwifi: pcie: dont service an interrupt that was masked
Date:   Fri,  2 Aug 2019 11:35:11 +0200
Message-Id: <20190802092244.613286921@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 3b57a10ca14c619707398dc58fe5ece18c95b20b upstream.

Sometimes the register status can include interrupts that
were masked. We can, for example, get the RF-Kill bit set
in the interrupt status register although this interrupt
was masked. Then if we get the ALIVE interrupt (for example)
that was not masked, we need to *not* service the RF-Kill
interrupt.
Fix this in the MSI-X interrupt handler.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1901,10 +1901,18 @@ irqreturn_t iwl_pcie_irq_msix_handler(in
 		return IRQ_NONE;
 	}
 
-	if (iwl_have_debug_level(IWL_DL_ISR))
-		IWL_DEBUG_ISR(trans, "ISR inta_fh 0x%08x, enabled 0x%08x\n",
-			      inta_fh,
+	if (iwl_have_debug_level(IWL_DL_ISR)) {
+		IWL_DEBUG_ISR(trans,
+			      "ISR inta_fh 0x%08x, enabled (sw) 0x%08x (hw) 0x%08x\n",
+			      inta_fh, trans_pcie->fh_mask,
 			      iwl_read32(trans, CSR_MSIX_FH_INT_MASK_AD));
+		if (inta_fh & ~trans_pcie->fh_mask)
+			IWL_DEBUG_ISR(trans,
+				      "We got a masked interrupt (0x%08x)\n",
+				      inta_fh & ~trans_pcie->fh_mask);
+	}
+
+	inta_fh &= trans_pcie->fh_mask;
 
 	if ((trans_pcie->shared_vec_mask & IWL_SHARED_IRQ_NON_RX) &&
 	    inta_fh & MSIX_FH_INT_CAUSES_Q0) {
@@ -1943,11 +1951,18 @@ irqreturn_t iwl_pcie_irq_msix_handler(in
 	}
 
 	/* After checking FH register check HW register */
-	if (iwl_have_debug_level(IWL_DL_ISR))
+	if (iwl_have_debug_level(IWL_DL_ISR)) {
 		IWL_DEBUG_ISR(trans,
-			      "ISR inta_hw 0x%08x, enabled 0x%08x\n",
-			      inta_hw,
+			      "ISR inta_hw 0x%08x, enabled (sw) 0x%08x (hw) 0x%08x\n",
+			      inta_hw, trans_pcie->hw_mask,
 			      iwl_read32(trans, CSR_MSIX_HW_INT_MASK_AD));
+		if (inta_hw & ~trans_pcie->hw_mask)
+			IWL_DEBUG_ISR(trans,
+				      "We got a masked interrupt 0x%08x\n",
+				      inta_hw & ~trans_pcie->hw_mask);
+	}
+
+	inta_hw &= trans_pcie->hw_mask;
 
 	/* Alive notification via Rx interrupt will do the real work */
 	if (inta_hw & MSIX_HW_INT_CAUSES_REG_ALIVE) {


