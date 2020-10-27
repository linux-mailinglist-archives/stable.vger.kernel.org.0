Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227A029BE5D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812879AbgJ0Qqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801571AbgJ0Pmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2F820657;
        Tue, 27 Oct 2020 15:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813369;
        bh=BrzE6FuA9rcWBhFxOTzzLu3ZkxPjMnXxY6yoS+GALEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSJkoHQ2CzLpoSf4RbIA35fbt8H4L7sFwlvcOYiTVMdMt+cvT6BeoQC7fuTH2M5d5
         +xEAh7XvTfOmfBUhnZU9PN0XRlwp+K+UyXhxXrcS4FHUaukPEb4wKy4TwHmIAxwEzL
         OqpAG7WTVZc4ympVpAe0Vmshp6z9DS7+xxAEe98M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 528/757] s390/pci: Mark all VFs as not implementing PCI_COMMAND_MEMORY
Date:   Tue, 27 Oct 2020 14:52:58 +0100
Message-Id: <20201027135515.253588002@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

[ Upstream commit 08b6e22b850c28b6032da1e4d767a33116e23dfb ]

For s390 we can have VFs that are passed-through without the associated
PF. Firmware provides an emulation layer to allow these devices to
operate independently, but is missing emulation of the Memory Space
Enable bit.  For these as well as linked VFs, set no_command_memory
which specifies these devices do not implement PCI_COMMAND_MEMORY.

Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_bus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index 5967f30141563..c93486a9989bc 100644
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -197,9 +197,10 @@ void pcibios_bus_add_device(struct pci_dev *pdev)
 	 * With pdev->no_vf_scan the common PCI probing code does not
 	 * perform PF/VF linking.
 	 */
-	if (zdev->vfn)
+	if (zdev->vfn) {
 		zpci_bus_setup_virtfn(zdev->zbus, pdev, zdev->vfn);
-
+		pdev->no_command_memory = 1;
+	}
 }
 
 static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
-- 
2.25.1



