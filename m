Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E7974580
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391012AbfGYFnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404913AbfGYFnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E08C21880;
        Thu, 25 Jul 2019 05:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033401;
        bh=jCpDUQUInq4d0iQrHrClBp/uYmfBF+WVwvvFfEEPLIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5XoCRgZ0n0x4VWiJzPM6cSqSlvGy1K9Vud72RKpIUMwFGg41lIpRy7r3mJ4EPeyN
         uL3CaQRhXK7KYhzlxJcxiZfT//t/HOZvD1M18eFY2rF27IXJnLcsCwBi/fRMpvtqIX
         ppKX4RH1XXOHWeSod/+e/Wj0mvaBg+PFyzmNvKzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 4.19 195/271] iwlwifi: pcie: dont service an interrupt that was masked
Date:   Wed, 24 Jul 2019 21:21:04 +0200
Message-Id: <20190724191711.811887990@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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
@@ -2060,10 +2060,18 @@ irqreturn_t iwl_pcie_irq_msix_handler(in
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
@@ -2103,11 +2111,18 @@ irqreturn_t iwl_pcie_irq_msix_handler(in
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


