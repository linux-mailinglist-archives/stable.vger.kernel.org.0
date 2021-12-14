Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF0474283
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 13:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhLNM2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 07:28:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41436 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbhLNM2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 07:28:08 -0500
Date:   Tue, 14 Dec 2021 12:28:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639484886;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/a7P+emilbTJ2cfpaJvDo3tAA04C0Q8mu1EWjz/8FC0=;
        b=zqVAKEL6o4DYWtOC344Q9leWvFWznEBhQg4iDn+aPYXEn1m0qiP7puEguSbcwgytmF04yb
        dDymuWMTmTP4LfQCdxh4p4+H83ZaprMi57Kp2mhAM/nB41wzJ4V/zWl8bjYlSp3wMGK4JK
        cgC6k5ffYTUypoe1xkYpltvnlXKV1AnmTMDkULDSgdG9QkT026/lBskad/HzClFlcFQbbR
        FG+Q+TN97BvCP/Bp0LibAdeobv2RNBF1gXraJjdB7tg2KXTQ/kwGHj9N/X1IYH/dX+RL6p
        no21PL2Bh64xBQv+gsZQb8BJusffroVE+ZEmc3RhqJkY/DUOZ0sfsdrc2tBqJQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639484886;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/a7P+emilbTJ2cfpaJvDo3tAA04C0Q8mu1EWjz/8FC0=;
        b=qeGEwP5zdRfUTXpgQDz2OymDoIpA6tQLhnQLH0uirez52kp3ohjyT+MvryfiOUBHt0e7O4
        GbWPENVGZJPCajBQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error
Cc:     Stefan Roese <sr@denx.de>, Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Marek Vasut <marex@denx.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <87tufevoqx.ffs@tglx>
References: <87tufevoqx.ffs@tglx>
MIME-Version: 1.0
Message-ID: <163948488529.23020.12461686869161043299.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     94185adbfad56815c2c8401e16d81bdb74a79201
Gitweb:        https://git.kernel.org/tip/94185adbfad56815c2c8401e16d81bdb74a79201
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 14 Dec 2021 12:42:14 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 14 Dec 2021 13:23:32 +01:00

PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

PCI_MSIX_FLAGS_MASKALL is set in the MSI-X control register at MSI-X
interrupt setup time. It's cleared on success, but the error handling path
only clears the PCI_MSIX_FLAGS_ENABLE bit.

That's incorrect as the reset state of the PCI_MSIX_FLAGS_MASKALL bit is
zero. That can be observed via lspci:

        Capabilities: [b0] MSI-X: Enable- Count=67 Masked+

Clear the bit in the error path to restore the reset state.

Fixes: 438553958ba1 ("PCI/MSI: Enable and mask MSI-X early")
Reported-by: Stefan Roese <sr@denx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Stefan Roese <sr@denx.de>
Cc: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87tufevoqx.ffs@tglx
---
 drivers/pci/msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6748cf9..d84cf30 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -784,7 +784,7 @@ out_free:
 	free_msi_irqs(dev);
 
 out_disable:
-	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
 
 	return ret;
 }
