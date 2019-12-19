Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A11B126B35
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbfLSSym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbfLSSyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA86227BF;
        Thu, 19 Dec 2019 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781680;
        bh=zP6kqnQJ5BCUk2R2cL1qnZys2A33AWA+hG5nkb7QpSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ux7kV5NHeq8AftP4pLZ79fKllULU5O0uJnXmoNANvZYMI2ECF0Fl6uks/ZzkuZsdZ
         CsC2bd+D+ns/vPWWpMA+yKTiADsSRzCyLn9sCZ0jSgl34Dxrvr8kFKZ7QoetJLyDne
         RZdtKzEkG46n86tPxXHOE7mjSoD4EguUEIF5Fnv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 07/80] PCI/PM: Always return devices to D0 when thawing
Date:   Thu, 19 Dec 2019 19:33:59 +0100
Message-Id: <20191219183038.872792429@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit f2c33ccacb2d4bbeae2a255a7ca0cbfd03017b7c upstream.

pci_pm_thaw_noirq() is supposed to return the device to D0 and restore its
configuration registers, but previously it only did that for devices whose
drivers implemented the new power management ops.

Hibernation, e.g., via "echo disk > /sys/power/state", involves freezing
devices, creating a hibernation image, thawing devices, writing the image,
and powering off.  The fact that thawing did not return devices with legacy
power management to D0 caused errors, e.g., in this path:

  pci_pm_thaw_noirq
    if (pci_has_legacy_pm_support(pci_dev)) # true for Mellanox VF driver
      return pci_legacy_resume_early(dev)   # ... legacy PM skips the rest
    pci_set_power_state(pci_dev, PCI_D0)
    pci_restore_state(pci_dev)
  pci_pm_thaw
    if (pci_has_legacy_pm_support(pci_dev))
      pci_legacy_resume
	drv->resume
	  mlx4_resume
	    ...
	      pci_enable_msix_range
	        ...
		  if (dev->current_state != PCI_D0)  # <---
		    return -EINVAL;

which caused these warnings:

  mlx4_core a6d1:00:02.0: INTx is not supported in multi-function mode, aborting
  PM: dpm_run_callback(): pci_pm_thaw+0x0/0xd7 returns -95
  PM: Device a6d1:00:02.0 failed to thaw: error -95

Return devices to D0 and restore config registers for all devices, not just
those whose drivers support new power management.

[bhelgaas: also call pci_restore_state() before pci_legacy_resume_early(),
update comment, add stable tag, commit log]
Link: https://lore.kernel.org/r/KU1P153MB016637CAEAD346F0AA8E3801BFAD0@KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable@vger.kernel.org	# v4.13+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-driver.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1076,17 +1076,22 @@ static int pci_pm_thaw_noirq(struct devi
 			return error;
 	}
 
-	if (pci_has_legacy_pm_support(pci_dev))
-		return pci_legacy_resume_early(dev);
-
 	/*
-	 * pci_restore_state() requires the device to be in D0 (because of MSI
-	 * restoration among other things), so force it into D0 in case the
-	 * driver's "freeze" callbacks put it into a low-power state directly.
+	 * Both the legacy ->resume_early() and the new pm->thaw_noirq()
+	 * callbacks assume the device has been returned to D0 and its
+	 * config state has been restored.
+	 *
+	 * In addition, pci_restore_state() restores MSI-X state in MMIO
+	 * space, which requires the device to be in D0, so return it to D0
+	 * in case the driver's "freeze" callbacks put it into a low-power
+	 * state.
 	 */
 	pci_set_power_state(pci_dev, PCI_D0);
 	pci_restore_state(pci_dev);
 
+	if (pci_has_legacy_pm_support(pci_dev))
+		return pci_legacy_resume_early(dev);
+
 	if (drv && drv->pm && drv->pm->thaw_noirq)
 		error = drv->pm->thaw_noirq(dev);
 


