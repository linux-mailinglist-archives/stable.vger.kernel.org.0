Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DCD2E3E27
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503135AbgL1OYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503131AbgL1OYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2707C20791;
        Mon, 28 Dec 2020 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165471;
        bh=EWLUgXL++eCggRttILvYyI17z+cKJUg0l/kJ0Nht58E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YySZkF4a+RXdimG0ac7ZxWi41dAb1oCL9W5GFWZOlFJ3Q6WoChla+Hcpjw6ndmgeB
         YGUBk7zJY8e0RjSdQvNa0vDXD8bQeXrdDSjT3z3BWgzGjCMaWMVnc8rmq3TPQUK1wZ
         5757chbHKxMkPoYetFuqBfPJJ/UZ7v8m8+bTCs3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.10 513/717] vfio/pci: Move dummy_resources_list init in vfio_pci_probe()
Date:   Mon, 28 Dec 2020 13:48:31 +0100
Message-Id: <20201228125045.549457581@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit 16b8fe4caf499ae8e12d2ab1b1324497e36a7b83 upstream.

In case an error occurs in vfio_pci_enable() before the call to
vfio_pci_probe_mmaps(), vfio_pci_disable() will  try to iterate
on an uninitialized list and cause a kernel panic.

Lets move to the initialization to vfio_pci_probe() to fix the
issue.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Fixes: 05f0c03fbac1 ("vfio-pci: Allow to mmap sub-page MMIO BARs if the mmio page is exclusive")
CC: Stable <stable@vger.kernel.org> # v4.7+
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vfio/pci/vfio_pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -161,8 +161,6 @@ static void vfio_pci_probe_mmaps(struct
 	int i;
 	struct vfio_pci_dummy_resource *dummy_res;
 
-	INIT_LIST_HEAD(&vdev->dummy_resources_list);
-
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		int bar = i + PCI_STD_RESOURCES;
 
@@ -1966,6 +1964,7 @@ static int vfio_pci_probe(struct pci_dev
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);


