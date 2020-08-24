Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC5624FAC7
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgHXIdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbgHXIdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3973220FC3;
        Mon, 24 Aug 2020 08:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257985;
        bh=MF2K8+Ehl/VJaKMb3H22JHtKNRizbexLguEWFkD5l7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FK9J6MzkcSIPn7jVOL5grbWb5tJRIpFhXvbQUIEHjAkov0bdH65ngkgRznkWJzqbi
         mCKPFPc9xv5dYtn4iKUUjPRbm4RKp8xo60QngYHgDHld2/0Ql4w21JlbNx4zkaMfmK
         yI3Wnbi46oYBupbocpqSE4queXOqph1Peii89tfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.8 032/148] s390/pci: re-introduce zpci_remove_device()
Date:   Mon, 24 Aug 2020 10:28:50 +0200
Message-Id: <20200824082415.500891407@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 2f0230b2f2d5fd287a85583eefb5aed35b6fe510 upstream.

For fixing the PF to VF link removal we need to perform some action on
every removal of a zdev from the common PCI subsystem.
So in preparation re-introduce zpci_remove_device() and use that instead
of directly calling the common code functions. This  was actually still
declared from earlier code but no longer implemented.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/pci/pci.c                |   19 ++++++++++++-------
 arch/s390/pci/pci_event.c          |    4 ++--
 drivers/pci/hotplug/s390_pci_hpc.c |   12 +++++-------
 3 files changed, 19 insertions(+), 16 deletions(-)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -672,6 +672,16 @@ int zpci_disable_device(struct zpci_dev
 }
 EXPORT_SYMBOL_GPL(zpci_disable_device);
 
+void zpci_remove_device(struct zpci_dev *zdev)
+{
+	struct zpci_bus *zbus = zdev->zbus;
+	struct pci_dev *pdev;
+
+	pdev = pci_get_slot(zbus->bus, zdev->devfn);
+	if (pdev)
+		pci_stop_and_remove_bus_device_locked(pdev);
+}
+
 int zpci_create_device(struct zpci_dev *zdev)
 {
 	int rc;
@@ -716,13 +726,8 @@ void zpci_release_device(struct kref *kr
 {
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
 
-	if (zdev->zbus->bus) {
-		struct pci_dev *pdev;
-
-		pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
-		if (pdev)
-			pci_stop_and_remove_bus_device_locked(pdev);
-	}
+	if (zdev->zbus->bus)
+		zpci_remove_device(zdev);
 
 	switch (zdev->state) {
 	case ZPCI_FN_STATE_ONLINE:
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -118,7 +118,7 @@ static void __zpci_event_availability(st
 		if (!zdev)
 			break;
 		if (pdev)
-			pci_stop_and_remove_bus_device_locked(pdev);
+			zpci_remove_device(zdev);
 
 		ret = zpci_disable_device(zdev);
 		if (ret)
@@ -137,7 +137,7 @@ static void __zpci_event_availability(st
 			/* Give the driver a hint that the function is
 			 * already unusable. */
 			pdev->error_state = pci_channel_io_perm_failure;
-			pci_stop_and_remove_bus_device_locked(pdev);
+			zpci_remove_device(zdev);
 		}
 
 		zdev->state = ZPCI_FN_STATE_STANDBY;
--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -83,21 +83,19 @@ static int disable_slot(struct hotplug_s
 	struct zpci_dev *zdev = container_of(hotplug_slot, struct zpci_dev,
 					     hotplug_slot);
 	struct pci_dev *pdev;
-	struct zpci_bus *zbus = zdev->zbus;
 	int rc;
 
 	if (!zpci_fn_configured(zdev->state))
 		return -EIO;
 
-	pdev = pci_get_slot(zbus->bus, zdev->devfn);
-	if (pdev) {
-		if (pci_num_vf(pdev))
-			return -EBUSY;
-
-		pci_stop_and_remove_bus_device_locked(pdev);
+	pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
+	if (pdev && pci_num_vf(pdev)) {
 		pci_dev_put(pdev);
+		return -EBUSY;
 	}
 
+	zpci_remove_device(zdev);
+
 	rc = zpci_disable_device(zdev);
 	if (rc)
 		return rc;


