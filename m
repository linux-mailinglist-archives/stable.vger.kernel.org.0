Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E10E13FF8B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbgAPXYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387807AbgAPXYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB0B20748;
        Thu, 16 Jan 2020 23:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217071;
        bh=gXlucmQXaJRN2NvwLwtt5SNUnBMfGb5PCo9Z7vBS/hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWEufhi46MT9rdbTNgbJZQc5AbWDDqoG/zYK6s4qlSFhvEIakKz8ldChClTAPPK5G
         WKhLfJVr0jyf/+KVHfXvW/lH0p/g6njOQe7RKxrPJCqBRwhH/9DM8VUOTxRGRlgPeq
         dkeH6Y+37tyjf6L6HBqVkCBXAGWXuW/9ss+ssTwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 136/203] PCI/PM: Clear PCIe PME Status even for legacy power management
Date:   Fri, 17 Jan 2020 00:17:33 +0100
Message-Id: <20200116231756.949934252@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

commit ec6a75ef8e33fe33f963b916fd902c52a0be33ff upstream.

Previously, pci_pm_resume_noirq() cleared the PME Status bit in the Root
Status register only if the device had no driver or the driver did not
implement legacy power management.  It should clear PME Status regardless
of what sort of power management the driver supports, so do this before
checking for legacy power management.

This affects Root Ports and Root Complex Event Collectors, for which the
usual driver is the PCIe portdrv, which implements new power management, so
this change is just on principle, not to fix any actual defects.

Fixes: a39bd851dccf ("PCI/PM: Clear PCIe PME Status bit in core, not PCIe port driver")
Link: https://lore.kernel.org/r/20191014230016.240912-4-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-driver.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -941,12 +941,11 @@ static int pci_pm_resume_noirq(struct de
 		pci_pm_default_resume_early(pci_dev);
 
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
+	pcie_pme_root_status_cleanup(pci_dev);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
 
-	pcie_pme_root_status_cleanup(pci_dev);
-
 	if (drv && drv->pm && drv->pm->resume_noirq)
 		error = drv->pm->resume_noirq(dev);
 


