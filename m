Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66882B2305
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 18:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgKMRwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 12:52:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbgKMRwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 12:52:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605289939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mG78bfKvhfyIekZqtPMjXVvxvjsa6qnyXxPRZ2PYppc=;
        b=PpX4iNio7Ww82sbxnLQSIEDr4pmb4LWxg3sC7FQSN8IcjsXXgbJxiJH46QpUN+oE/ApSSO
        jwbbldBQSH9UyIb1LuH0h0EvIsomsc2stGzNaAFFog1glzxUItOzudcRS4JUV03xgPSlrN
        cfI2JmWu9QWTCVWrXL+EkPr4aUgD7Gc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-Dp0zvZ4EOLq57lLx7IZELg-1; Fri, 13 Nov 2020 12:52:17 -0500
X-MC-Unique: Dp0zvZ4EOLq57lLx7IZELg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45490805EFC;
        Fri, 13 Nov 2020 17:52:16 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21F925B4C6;
        Fri, 13 Nov 2020 17:52:07 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Cc:     stable@vger.kernel.org, cohuck@redhat.com,
        xyjxie@linux.vnet.ibm.com
Subject: [PATCH] vfio/pci: Move dummy_resources_list init in vfio_pci_probe()
Date:   Fri, 13 Nov 2020 18:52:02 +0100
Message-Id: <20201113175202.4500-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case an error occurs in vfio_pci_enable() before the call to
vfio_pci_probe_mmaps(), vfio_pci_disable() will  try to iterate
on an uninitialized list and cause a kernel panic.

Lets move to the initialization to vfio_pci_probe() to fix the
issue.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Fixes: 05f0c03fbac1 ("vfio-pci: Allow to mmap sub-page MMIO BARs if the mmio page is exclusive")
CC: Stable <stable@vger.kernel.org> # v4.7+
---
 drivers/vfio/pci/vfio_pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index e6190173482c..47ebc5c49ca4 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -161,8 +161,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 	int i;
 	struct vfio_pci_dummy_resource *dummy_res;
 
-	INIT_LIST_HEAD(&vdev->dummy_resources_list);
-
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		int bar = i + PCI_STD_RESOURCES;
 
@@ -1966,6 +1964,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
 	mutex_init(&vdev->ioeventfds_lock);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
-- 
2.21.3

