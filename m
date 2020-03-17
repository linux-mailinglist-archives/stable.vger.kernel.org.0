Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F9F18819E
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgCQLGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgCQLGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:06:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D44620714;
        Tue, 17 Mar 2020 11:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443194;
        bh=wlMkzyEOUABkf65+CeNdXrakb3PvnKqftn9wSDK3LjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQYQSy7RSLYfP7NtVMD7ErVbLFcf5zJ7AH1MQcQSTTSBAzYnhlkmVF7UPdof+FaWh
         vQl8gIUW2Emh9KkDt03M51qJ1X7EuiQ2JPaVuj6qXF9s66qOTc168P6j0L7mBvf7UL
         Dzbd7cDKS26XbvaDPGiOZuwSNRiHgTq7z8YuJf3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Daniel Drake <drake@endlessm.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 118/123] iommu/vt-d: Ignore devices with out-of-spec domain number
Date:   Tue, 17 Mar 2020 11:55:45 +0100
Message-Id: <20200317103319.382152411@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Drake <drake@endlessm.com>

commit da72a379b2ec0bad3eb265787f7008bead0b040c upstream.

VMD subdevices are created with a PCI domain ID of 0x10000 or
higher.

These subdevices are also handled like all other PCI devices by
dmar_pci_bus_notifier().

However, when dmar_alloc_pci_notify_info() take records of such devices,
it will truncate the domain ID to a u16 value (in info->seg).
The device at (e.g.) 10000:00:02.0 is then treated by the DMAR code as if
it is 0000:00:02.0.

In the unlucky event that a real device also exists at 0000:00:02.0 and
also has a device-specific entry in the DMAR table,
dmar_insert_dev_scope() will crash on:
   BUG_ON(i >= devices_cnt);

That's basically a sanity check that only one PCI device matches a
single DMAR entry; in this case we seem to have two matching devices.

Fix this by ignoring devices that have a domain number higher than
what can be looked up in the DMAR table.

This problem was carefully diagnosed by Jian-Hong Pan.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Daniel Drake <drake@endlessm.com>
Fixes: 59ce0515cdaf3 ("iommu/vt-d: Update DRHD/RMRR/ATSR device scope caches when PCI hotplug happens")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/dmar.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/iommu.h>
 #include <linux/numa.h>
+#include <linux/limits.h>
 #include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
@@ -128,6 +129,13 @@ dmar_alloc_pci_notify_info(struct pci_de
 
 	BUG_ON(dev->is_virtfn);
 
+	/*
+	 * Ignore devices that have a domain number higher than what can
+	 * be looked up in DMAR, e.g. VMD subdevices with domain 0x10000
+	 */
+	if (pci_domain_nr(dev->bus) > U16_MAX)
+		return NULL;
+
 	/* Only generate path[] for device addition event */
 	if (event == BUS_NOTIFY_ADD_DEVICE)
 		for (tmp = dev; tmp; tmp = tmp->bus->self)


