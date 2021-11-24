Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C1545C122
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347172AbhKXNPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:15:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344719AbhKXNLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:11:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1252C61A7D;
        Wed, 24 Nov 2021 12:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757724;
        bh=nyd9qcJTpgWRvmjKoTXfVhux14jDMACQiRjtJvyn83Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anK325Gbn+MKoe2eQPhLmb3VAiT+CESXSyVQ8lg+9dUofqJddj0puJl/dQ6pYkX8y
         uW5J6saaH2xDMPRqqdgxOnN2Tkr0akhB0RZrrDYMIkqLRp5Z0YnJU2f6o+8EMBOjHs
         7B0lF8cfR9XvdrT0F2rcvEvRuySO8iB8BqNC/fVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH 4.19 255/323] PCI/MSI: Deal with devices lying about their MSI mask capability
Date:   Wed, 24 Nov 2021 12:57:25 +0100
Message-Id: <20211124115727.508031801@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 2226667a145db2e1f314d7f57fd644fe69863ab9 upstream.

It appears that some devices are lying about their mask capability,
pretending that they don't have it, while they actually do.
The net result is that now that we don't enable MSIs on such
endpoint.

Add a new per-device flag to deal with this. Further patches will
make use of it, sadly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20211104180130.3825416-2-maz@kernel.org
Cc: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c   |    3 +++
 include/linux/pci.h |    2 ++
 2 files changed, 5 insertions(+)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -569,6 +569,9 @@ msi_setup_entry(struct pci_dev *dev, int
 		goto out;
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
+	/* Lies, damned lies, and MSIs */
+	if (dev->dev_flags & PCI_DEV_FLAGS_HAS_MSI_MASKING)
+		control |= PCI_MSI_FLAGS_MASKBIT;
 
 	entry->msi_attrib.is_msix	= 0;
 	entry->msi_attrib.is_64		= !!(control & PCI_MSI_FLAGS_64BIT);
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -205,6 +205,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
 	/* Don't use Relaxed Ordering for TLPs directed at this device */
 	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
+	/* Device does honor MSI masking despite saying otherwise */
+	PCI_DEV_FLAGS_HAS_MSI_MASKING = (__force pci_dev_flags_t) (1 << 12),
 };
 
 enum pci_irq_reroute_variant {


