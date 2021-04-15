Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D6D361579
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhDOW0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhDOW0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 18:26:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73361610FB;
        Thu, 15 Apr 2021 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618525547;
        bh=LhgPQdxtm2TuyLQmnpd+X9aucQm6TK194UjDevkccTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cb6CE8XsxzgtdZq3EJsrZpJJmJxJwW7YU473Oa2JydY2hWGj+iK19zD4y3PT2tDU9
         yTw9r7Z7z7aaP/4z3Xr9tvw6sXDu/gUGXKsGnoyEp8Wu7Nny/ldRFoybOZ6blfs/pc
         RaU3LcYKLw7xUD3qwTy6Orljl/fNQ8ytYJX2FZUzVq/LDsPwd1O9XfQ4RaKbKjXSZr
         my3Ygs+eyJlLQUGQz6IVF37+ciSL4n4j5p74fYDWSoXcBhGamtUjbxWxTitzMjGqzB
         mHZSasgzJbAR5JGUb8E66aTzRgV7dWYKOJ3sW+LVb4iU2nCH+oB5pthwmCmC0orDaR
         L/7H0BdoSM4vg==
Date:   Thu, 15 Apr 2021 15:25:44 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     "Liang, Prike" <Prike.Liang@amd.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Subject: Re: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Message-ID: <20210415222544.GA2760247@dhcp-10-100-145-180.wdc.com>
References: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
 <20210415082057.GA1973565@infradead.org>
 <BYAPR12MB3238E0366477A6CDE7AC9B94FB4D9@BYAPR12MB3238.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB3238E0366477A6CDE7AC9B94FB4D9@BYAPR12MB3238.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 09:41:53AM +0000, Liang, Prike wrote:
> > From: Christoph Hellwig <hch@infradead.org>
> 
> > I'd also much prefer if the flag is used on every pci_dev that is affected by the
> > broken behavior rather than requiring another lookup in the driver.
> Sorry can't get the meaning, could you give more detail how to implement this?

The suggestion is child devices of the pci bus inherit the quirk so
drivers don't need to look up the parent device that requires it.

That makes sense for a couple reasons. For one, your hard-coded 0:0.0
probably aligns to actual implementations, but I did't find a spec
requirement that the host bridge occupy that BDf, so not having to look
up a fixed location is more flexible.

If I understand the suggestion correctly, I think it's probably easier
to thread the quirk through the pci_bus->bus_flags. Does the below
(untested) make sense?

---
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d47bb18b976a..022ff6cf202f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2834,6 +2834,9 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 	acpi_status status;
 	u8 val;
 
+	if (dev->bus->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
+		return true;
+
 	/*
 	 * Look for _DSD property specifying that the storage device on the port
 	 * must use D3 to support deep platform power savings during
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 953f15abc850..34ba691ec545 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -558,10 +558,13 @@ static struct pci_bus *pci_alloc_bus(struct pci_bus *parent)
 	INIT_LIST_HEAD(&b->resources);
 	b->max_bus_speed = PCI_SPEED_UNKNOWN;
 	b->cur_bus_speed = PCI_SPEED_UNKNOWN;
+	if (parent) {
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
-	if (parent)
 		b->domain_nr = parent->domain_nr;
 #endif
+		if (parent->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
+			b->bus_flags |= PCI_BUS_FLAGS_DISABLE_ON_S2I;
+	}
 	return b;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 653660e3ba9e..e8f74661138a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -312,6 +312,14 @@ static void quirk_nopciamd(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8151_0,	quirk_nopciamd);
 
+static void quirk_amd_s2i_fixup(struct pci_dev *dev)
+{
+	dev->bus->bus_flags |= PCI_BUS_FLAGS_DISABLE_ON_S2I;
+	pci_info(dev, "AMD simple suspend opt enabled\n");
+
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1630, quirk_amd_s2i_fixup);
+
 /* Triton requires workarounds to be used by the drivers */
 static void quirk_triton(struct pci_dev *dev)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 86c799c97b77..7072e2ec88a2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -240,6 +240,8 @@ enum pci_bus_flags {
 	PCI_BUS_FLAGS_NO_MMRBC	= (__force pci_bus_flags_t) 2,
 	PCI_BUS_FLAGS_NO_AERSID	= (__force pci_bus_flags_t) 4,
 	PCI_BUS_FLAGS_NO_EXTCFG	= (__force pci_bus_flags_t) 8,
+	/* Driver must pci_disable_device() for suspend-to-idle */
+	PCI_BUS_FLAGS_DISABLE_ON_S2I	= (__force pci_bus_flags_t) 16,
 };
 
 /* Values from Link Status register, PCIe r3.1, sec 7.8.8 */
--
