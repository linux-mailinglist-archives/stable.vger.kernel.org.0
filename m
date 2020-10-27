Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9895129B278
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762206AbgJ0Ol3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762063AbgJ0Okh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:40:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BDB206B2;
        Tue, 27 Oct 2020 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809637;
        bh=VxhTCrQLrcjEDIBpeO4+zQ/U2sCiFfCHSFMs0B9OC9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwrDoD1QCtzSoSB1lU9PD8srMPsJdePQHaAkAfGUT5jvKLRG4Mw7yzGvuVNHwD8Df
         drq8NfM+ebW4Zi9pwHffARGz+fgZPHu83rz0dredwmRf7n99H8jMS3yIHFKNoTGC7s
         +BYLTEMJdCa9Faw35xywesgvwyg2S/4UKCP9xnsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 266/408] vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks from is_virtfn
Date:   Tue, 27 Oct 2020 14:53:24 +0100
Message-Id: <20201027135507.386081217@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

[ Upstream commit 515ecd5368f1510152fa4f9b9ce55b66ac56c334 ]

While it is true that devices with is_virtfn=1 will have a Memory Space
Enable bit that is hard-wired to 0, this is not the only case where we
see this behavior -- For example some bare-metal hypervisors lack
Memory Space Enable bit emulation for devices not setting is_virtfn
(s390). Fix this by instead checking for the newly-added
no_command_memory bit which directly denotes the need for
PCI_COMMAND_MEMORY emulation in vfio.

Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 927b608461c82..bf32997c557ff 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
 	 * PF SR-IOV capability, there's therefore no need to trigger
 	 * faults based on the virtual value.
 	 */
-	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
+	return pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY);
 }
 
 /*
@@ -518,8 +518,8 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
 
 	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
 
-	/* Mask in virtual memory enable for SR-IOV devices */
-	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
+	/* Mask in virtual memory enable */
+	if (offset == PCI_COMMAND && vdev->pdev->no_command_memory) {
 		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 		u32 tmp_val = le32_to_cpu(*val);
 
@@ -587,9 +587,11 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 		 * shows it disabled (phys_mem/io, then the device has
 		 * undergone some kind of backdoor reset and needs to be
 		 * restored before we allow it to enable the bars.
-		 * SR-IOV devices will trigger this, but we catch them later
+		 * SR-IOV devices will trigger this - for mem enable let's
+		 * catch this now and for io enable it will be caught later
 		 */
-		if ((new_mem && virt_mem && !phys_mem) ||
+		if ((new_mem && virt_mem && !phys_mem &&
+		     !pdev->no_command_memory) ||
 		    (new_io && virt_io && !phys_io) ||
 		    vfio_need_bar_restore(vdev))
 			vfio_bar_restore(vdev);
@@ -1732,12 +1734,14 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 				 vconfig[PCI_INTERRUPT_PIN]);
 
 		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
-
+	}
+	if (pdev->no_command_memory) {
 		/*
-		 * VFs do no implement the memory enable bit of the COMMAND
-		 * register therefore we'll not have it set in our initial
-		 * copy of config space after pci_enable_device().  For
-		 * consistency with PFs, set the virtual enable bit here.
+		 * VFs and devices that set pdev->no_command_memory do not
+		 * implement the memory enable bit of the COMMAND register
+		 * therefore we'll not have it set in our initial copy of
+		 * config space after pci_enable_device().  For consistency
+		 * with PFs, set the virtual enable bit here.
 		 */
 		*(__le16 *)&vconfig[PCI_COMMAND] |=
 					cpu_to_le16(PCI_COMMAND_MEMORY);
-- 
2.25.1



