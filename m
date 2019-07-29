Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC0979656
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390003AbfG2Tuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390715AbfG2Tuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:50:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F6042054F;
        Mon, 29 Jul 2019 19:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429853;
        bh=rZ6BEF+/vB0pxBk7idytzu53Gz6bfW7NZdFFkIUd7Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVk4POuAZ2fnVI9F7Myx8FLoAfMPfO9qa0vt2zM+Szr9z2ZC87dpueMMMJ2jI768d
         /pFE0szJvDZWjFA8ysH54JnGPLw4aX4ctsoCueO7+s4LfZAlbaua+BvI47Tyvw3KRW
         s9oDzsnneegioWc537wU7uSyqkvUBe3/7Wv1OS5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Oliver OHalloran <oohall@gmail.com>,
        Shawn Anastasio <shawn@anastas.io>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 077/215] powerpc/pci/of: Fix OF flags parsing for 64bit BARs
Date:   Mon, 29 Jul 2019 21:21:13 +0200
Message-Id: <20190729190753.294904333@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit df5be5be8735ef2ae80d5ae1f2453cd81a035c4b ]

When the firmware does PCI BAR resource allocation, it passes the assigned
addresses and flags (prefetch/64bit/...) via the "reg" property of
a PCI device device tree node so the kernel does not need to do
resource allocation.

The flags are stored in resource::flags - the lower byte stores
PCI_BASE_ADDRESS_SPACE/etc bits and the other bytes are IORESOURCE_IO/etc.
Some flags from PCI_BASE_ADDRESS_xxx and IORESOURCE_xxx are duplicated,
such as PCI_BASE_ADDRESS_MEM_PREFETCH/PCI_BASE_ADDRESS_MEM_TYPE_64/etc.
When parsing the "reg" property, we copy the prefetch flag but we skip
on PCI_BASE_ADDRESS_MEM_TYPE_64 which leaves the flags out of sync.

The missing IORESOURCE_MEM_64 flag comes into play under 2 conditions:
1. we remove PCI_PROBE_ONLY for pseries (by hacking pSeries_setup_arch()
or by passing "/chosen/linux,pci-probe-only");
2. we request resource alignment (by passing pci=resource_alignment=
via the kernel cmd line to request PAGE_SIZE alignment or defining
ppc_md.pcibios_default_alignment which returns anything but 0). Note that
the alignment requests are ignored if PCI_PROBE_ONLY is enabled.

With 1) and 2), the generic PCI code in the kernel unconditionally
decides to:
- reassign the BARs in pci_specified_resource_alignment() (works fine)
- write new BARs to the device - this fails for 64bit BARs as the generic
code looks at IORESOURCE_MEM_64 (not set) and writes only lower 32bits
of the BAR and leaves the upper 32bit unmodified which breaks BAR mapping
in the hypervisor.

This fixes the issue by copying the flag. This is useful if we want to
enforce certain BAR alignment per platform as handling subpage sized BARs
is proven to cause problems with hotplug (SLOF already aligns BARs to 64k).

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Sam Bobroff <sbobroff@linux.ibm.com>
Reviewed-by: Oliver O'Halloran <oohall@gmail.com>
Reviewed-by: Shawn Anastasio <shawn@anastas.io>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/pci_of_scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 24522aa37665..c63c53b37e8e 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -42,6 +42,8 @@ unsigned int pci_parse_of_flags(u32 addr0, int bridge)
 	if (addr0 & 0x02000000) {
 		flags = IORESOURCE_MEM | PCI_BASE_ADDRESS_SPACE_MEMORY;
 		flags |= (addr0 >> 22) & PCI_BASE_ADDRESS_MEM_TYPE_64;
+		if (flags & PCI_BASE_ADDRESS_MEM_TYPE_64)
+			flags |= IORESOURCE_MEM_64;
 		flags |= (addr0 >> 28) & PCI_BASE_ADDRESS_MEM_TYPE_1M;
 		if (addr0 & 0x40000000)
 			flags |= IORESOURCE_PREFETCH
-- 
2.20.1



