Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F92D469BC4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357080AbhLFPSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49766 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359196AbhLFPRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:17:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7589B8101C;
        Mon,  6 Dec 2021 15:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030A5C341C2;
        Mon,  6 Dec 2021 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803613;
        bh=lgazTf/KmclGBV+oVKueKG8F65kkA0ahysymL142Ne0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIUC8g9BUG1zbYvuaGzICkJKF0f4/Gz8+LL7M4V+jmLi4gPArDcoPfsr8I5eM/L1b
         maNzMjMwyik1ZL2PBiJsRzNwf2jqPHkNIjtjRnH2D6/zF6jb3Shf8dKeFDVb0Dv5Df
         COhZVPImevdfb99fGOOJYmKQPY9a1dmF9PrHOjD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 28/70] s390/pci: move pseudo-MMIO to prevent MIO overlap
Date:   Mon,  6 Dec 2021 15:56:32 +0100
Message-Id: <20211206145552.886764405@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 52d04d408185b7aa47628d2339c28ec70074e0ae upstream.

When running without MIO support, with pci=nomio or for devices which
are not MIO-capable the zPCI subsystem generates pseudo-MMIO addresses
to allow access to PCI BARs via MMIO based Linux APIs even though the
platform uses function handles and BAR numbers.

This is done by stashing an index into our global IOMAP array which
contains the function handle in the 16 most significant bits of the
addresses returned by ioremap() always setting the most significant bit.

On the other hand the MIO addresses assigned by the platform for use,
while requiring special instructions, allow PCI access with virtually
mapped physical addresses. Now the problem is that these MIO addresses
and our own pseudo-MMIO addresses may overlap, while functionally this
would not be a problem by itself this overlap is detected by common code
as both address types are added as resources in the iomem_resource tree.
This leads to the overlapping resource claim of either the MIO capable
or non-MIO capable devices with being rejected.

Since PCI is tightly coupled to the use of the iomem_resource tree, see
for example the code for request_mem_region(), we can't reasonably get
rid of the overlap being detected by keeping our pseudo-MMIO addresses
out of the iomem_resource tree.

Instead let's move the range used by our own pseudo-MMIO addresses by
starting at (1UL << 62) and only using addresses below (1UL << 63) thus
avoiding the range currently used for MIO addresses.

Fixes: c7ff0e918a7c ("s390/pci: deal with devices that have no support for MIO instructions")
Cc: stable@vger.kernel.org # 5.3+
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pci_io.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/s390/include/asm/pci_io.h
+++ b/arch/s390/include/asm/pci_io.h
@@ -14,12 +14,13 @@
 
 /* I/O Map */
 #define ZPCI_IOMAP_SHIFT		48
-#define ZPCI_IOMAP_ADDR_BASE		0x8000000000000000UL
+#define ZPCI_IOMAP_ADDR_SHIFT		62
+#define ZPCI_IOMAP_ADDR_BASE		(1UL << ZPCI_IOMAP_ADDR_SHIFT)
 #define ZPCI_IOMAP_ADDR_OFF_MASK	((1UL << ZPCI_IOMAP_SHIFT) - 1)
 #define ZPCI_IOMAP_MAX_ENTRIES							\
-	((ULONG_MAX - ZPCI_IOMAP_ADDR_BASE + 1) / (1UL << ZPCI_IOMAP_SHIFT))
+	(1UL << (ZPCI_IOMAP_ADDR_SHIFT - ZPCI_IOMAP_SHIFT))
 #define ZPCI_IOMAP_ADDR_IDX_MASK						\
-	(~ZPCI_IOMAP_ADDR_OFF_MASK - ZPCI_IOMAP_ADDR_BASE)
+	((ZPCI_IOMAP_ADDR_BASE - 1) & ~ZPCI_IOMAP_ADDR_OFF_MASK)
 
 struct zpci_iomap_entry {
 	u32 fh;


