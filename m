Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E55B5C3A
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfIRGYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbfIRGYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C3C21925;
        Wed, 18 Sep 2019 06:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787840;
        bh=pNjQlHwmYnMq2l7APwROzUARrPp84X47aBsz4iOvu9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JrTKDHM2bkWUSNNOB8jnoROBjp5l9sH5OOvmP7CbbO7HewjWl2uJL23rwxu2voIE
         e94sQZPTkrpjwhC0hQsXvzEZFRIrWME1MRFNrdYkqAB43yPsLHw9+JfhrnqXnCaLHP
         fmCrUOaCQWSt6PCElCkczEmZNwcModkcWnif8yEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 30/50] PCI: Always allow probing with driver_override
Date:   Wed, 18 Sep 2019 08:19:13 +0200
Message-Id: <20190918061226.640775776@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

commit 2d2f4273cbe9058d1f5a518e5e880d27d7b3b30f upstream.

Commit 0e7df22401a3 ("PCI: Add sysfs sriov_drivers_autoprobe to control
VF driver binding") introduced the sriov_drivers_autoprobe attribute
which allows users to prevent the kernel from automatically probing a
driver for new VFs as they are created.  This allows VFs to be spawned
without automatically binding the new device to a host driver, such as
in cases where the user intends to use the device only with a meta
driver like vfio-pci.  However, the current implementation prevents any
use of drivers_probe with the VF while sriov_drivers_autoprobe=0.  This
blocks the now current general practice of setting driver_override
followed by using drivers_probe to bind a device to a specified driver.

The kernel never automatically sets a driver_override therefore it seems
we can assume a driver_override reflects the intent of the user.  Also,
probing a device using a driver_override match seems outside the scope
of the 'auto' part of sriov_drivers_autoprobe.  Therefore, let's allow
driver_override matches regardless of sriov_drivers_autoprobe, which we
can do by simply testing if a driver_override is set for a device as a
'can probe' condition.

Fixes: 0e7df22401a3 ("PCI: Add sysfs sriov_drivers_autoprobe to control VF driver binding")
Link: https://lore.kernel.org/lkml/155742996741.21878.569845487290798703.stgit@gimli.home
Link: https://lore.kernel.org/linux-pci/155672991496.20698.4279330795743262888.stgit@gimli.home/T/#u
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-driver.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -399,7 +399,8 @@ void __weak pcibios_free_irq(struct pci_
 #ifdef CONFIG_PCI_IOV
 static inline bool pci_device_can_probe(struct pci_dev *pdev)
 {
-	return (!pdev->is_virtfn || pdev->physfn->sriov->drivers_autoprobe);
+	return (!pdev->is_virtfn || pdev->physfn->sriov->drivers_autoprobe ||
+		pdev->driver_override);
 }
 #else
 static inline bool pci_device_can_probe(struct pci_dev *pdev)


