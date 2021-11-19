Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957D44575FB
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbhKSRn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235037AbhKSRnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9572B611F2;
        Fri, 19 Nov 2021 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343619;
        bh=+ZpeMat09hm/wSvameSzbumAn27wGJE4sZykwgj5lGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYaV1KR66FMLzMAX76/SQeb51Y9uCW4wAh3mDQR6FPY2lNzTMCVhApOgGNoZSQpgs
         /nSCD6XNKhGYVUJguFxlrGstK9/5OxLa9MQ3SSVm5xN9IU8PHUWpfTF+KNzW7gkvC0
         Fly/Z0k1+Pf6dx+FJmKkftyjGK2Dihax0UZRRq7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH 5.15 16/20] PCI/MSI: Deal with devices lying about their MSI mask capability
Date:   Fri, 19 Nov 2021 18:39:34 +0100
Message-Id: <20211119171445.182524260@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
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
@@ -477,6 +477,9 @@ msi_setup_entry(struct pci_dev *dev, int
 		goto out;
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
+	/* Lies, damned lies, and MSIs */
+	if (dev->dev_flags & PCI_DEV_FLAGS_HAS_MSI_MASKING)
+		control |= PCI_MSI_FLAGS_MASKBIT;
 
 	entry->msi_attrib.is_msix	= 0;
 	entry->msi_attrib.is_64		= !!(control & PCI_MSI_FLAGS_64BIT);
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -233,6 +233,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
 	/* Don't use Relaxed Ordering for TLPs directed at this device */
 	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
+	/* Device does honor MSI masking despite saying otherwise */
+	PCI_DEV_FLAGS_HAS_MSI_MASKING = (__force pci_dev_flags_t) (1 << 12),
 };
 
 enum pci_irq_reroute_variant {


