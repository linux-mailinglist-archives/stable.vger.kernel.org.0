Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4754015C424
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387684AbgBMP1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387671AbgBMP1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:08 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B49392465D;
        Thu, 13 Feb 2020 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607627;
        bh=5c5HxMqvkuSCxF9rj1sG0dTkvaPN9Q5K7ejTic2O88c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNtQ7qxhHY9lFqCknKr4dyRzRgMq12vncyMvoNmSGQrHtYcl9jMmSGofLm318RWLX
         64IsA1bq7OBMuXfV2qN6angmtHIk+hBsV4OjBkWzkx7YEGcrJexAXXNi+GeWlHqxFr
         hyRLUXEV1ilG9vqSd2OHaqfCwFCs4yDBBw6l9Tls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kit Chow <kchow@gigaio.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 18/96] PCI: Dont disable bridge BARs when assigning bus resources
Date:   Thu, 13 Feb 2020 07:20:25 -0800
Message-Id: <20200213151846.486334533@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

commit 9db8dc6d0785225c42a37be7b44d1b07b31b8957 upstream.

Some PCI bridges implement BARs in addition to bridge windows.  For
example, here's a PLX switch:

  04:00.0 PCI bridge: PLX Technology, Inc. PEX 8724 24-Lane, 6-Port PCI
            Express Gen 3 (8 GT/s) Switch, 19 x 19mm FCBGA (rev ca)
	    (prog-if 00 [Normal decode])
      Flags: bus master, fast devsel, latency 0, IRQ 30, NUMA node 0
      Memory at 90a00000 (32-bit, non-prefetchable) [size=256K]
      Bus: primary=04, secondary=05, subordinate=0a, sec-latency=0
      I/O behind bridge: 00002000-00003fff
      Memory behind bridge: 90000000-909fffff
      Prefetchable memory behind bridge: 0000380000800000-0000380000bfffff

Previously, when the kernel assigned resource addresses (with the
pci=realloc command line parameter, for example) it could clear the struct
resource corresponding to the BAR.  When this happened, lspci would report
this BAR as "ignored":

   Region 0: Memory at <ignored> (32-bit, non-prefetchable) [size=256K]

This is because the kernel reports a zero start address and zero flags
in the corresponding sysfs resource file and in /proc/bus/pci/devices.
Investigation with 'lspci -x', however, shows the BIOS-assigned address
will still be programmed in the device's BAR registers.

It's clearly a bug that the kernel lost track of the BAR value, but in most
cases, this still won't result in a visible issue because nothing uses the
memory, so nothing is affected.  However, when an IOMMU is in use, it will
not reserve this space in the IOVA because the kernel no longer thinks the
range is valid.  (See dmar_init_reserved_ranges() for the Intel
implementation of this.)

Without the proper reserved range, a DMA mapping may allocate an IOVA that
matches a bridge BAR, which results in DMA accesses going to the BAR
instead of the intended RAM.

The problem was in pci_assign_unassigned_root_bus_resources().  When any
resource from a bridge device fails to get assigned, the code set the
resource's flags to zero.  This makes sense for bridge windows, as they
will be re-enabled later, but for regular BARs, it makes the kernel
permanently lose track of the fact that they decode address space.

Change pci_assign_unassigned_root_bus_resources() and
pci_assign_unassigned_bridge_resources() so they only clear "res->flags"
for bridge *windows*, not bridge BARs.

Fixes: da7822e5ad71 ("PCI: update bridge resources to get more big ranges when allocating space (again)")
Link: https://lore.kernel.org/r/20200108213208.4612-1-logang@deltatee.com
[bhelgaas: commit log, check for pci_is_bridge()]
Reported-by: Kit Chow <kchow@gigaio.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-bus.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1785,12 +1785,18 @@ again:
 	/* Restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
 		struct resource *res = fail_res->res;
+		int idx;
 
 		res->start = fail_res->start;
 		res->end = fail_res->end;
 		res->flags = fail_res->flags;
-		if (fail_res->dev->subordinate)
-			res->flags = 0;
+
+		if (pci_is_bridge(fail_res->dev)) {
+			idx = res - &fail_res->dev->resource[0];
+			if (idx >= PCI_BRIDGE_RESOURCES &&
+			    idx <= PCI_BRIDGE_RESOURCE_END)
+				res->flags = 0;
+		}
 	}
 	free_list(&fail_head);
 
@@ -2037,12 +2043,18 @@ again:
 	/* Restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
 		struct resource *res = fail_res->res;
+		int idx;
 
 		res->start = fail_res->start;
 		res->end = fail_res->end;
 		res->flags = fail_res->flags;
-		if (fail_res->dev->subordinate)
-			res->flags = 0;
+
+		if (pci_is_bridge(fail_res->dev)) {
+			idx = res - &fail_res->dev->resource[0];
+			if (idx >= PCI_BRIDGE_RESOURCES &&
+			    idx <= PCI_BRIDGE_RESOURCE_END)
+				res->flags = 0;
+		}
 	}
 	free_list(&fail_head);
 


