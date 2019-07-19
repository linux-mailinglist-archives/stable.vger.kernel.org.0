Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0333E6DEC5
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbfGSEEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfGSEEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:04:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9208A218BB;
        Fri, 19 Jul 2019 04:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509081;
        bh=hgJkuCkiyrDIKkt0/J1X07riFQaB6WSgxgS5A4gaqZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHeElQ69DYOxdd9s9ZiKKTYF1xZgqa55Fyse2ZxjBSWku5QgoBER5HhpKGlGhNu5w
         Z+DHQem/r8joa/GVb9MNOZ2V+tZZATwOLqNnpgl47kNkztRefBSsj41HFrcEX0b4hW
         2lfE34nnWDQRhhPdzeYKQA6eymP2kgEOSraqVWoU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        Shawn Anastasio <shawn@anastas.io>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.1 058/141] powerpc/pci/of: Fix OF flags parsing for 64bit BARs
Date:   Fri, 19 Jul 2019 00:01:23 -0400
Message-Id: <20190719040246.15945-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

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
index 24191ea2d9a7..64ad92016b63 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -45,6 +45,8 @@ unsigned int pci_parse_of_flags(u32 addr0, int bridge)
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

