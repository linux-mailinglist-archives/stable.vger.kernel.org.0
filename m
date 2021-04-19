Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40743643CE
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbhDSNVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241117AbhDSNTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8AC3613C7;
        Mon, 19 Apr 2021 13:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838130;
        bh=m83Jsjv1frtpyFiCelm+5L0QoMSJo7QdUF1BOkmsDbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuQ5Tha4nZTGsCW4OW63I6akkUkZRNgvhnm/dZpbYALSeKueB95dQEKcZOFAL72ad
         69/DAWl6w4GUq+VHUdG/4xycYBwi8oyiLmo9jjYGmqGV+uugm9jsySqAQ0SESUSKMK
         kVgYDppAIzXMh9+0s6IlIi5xGcTdEV2DWkcs75QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Christian A. Ehrhardt" <lk@c--e.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.10 054/103] vfio/pci: Add missing range check in vfio_pci_mmap
Date:   Mon, 19 Apr 2021 15:06:05 +0200
Message-Id: <20210419130529.664687421@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian A. Ehrhardt <lk@c--e.de>

commit 909290786ea335366e21d7f1ed5812b90f2f0a92 upstream.

When mmaping an extra device region verify that the region index
derived from the mmap offset is valid.

Fixes: a15b1883fee1 ("vfio_pci: Allow mapping extra regions")
Cc: stable@vger.kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Message-Id: <20210412214124.GA241759@lisa.in-ulm.de>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1658,6 +1658,8 @@ static int vfio_pci_mmap(void *device_da
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
+	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+		return -EINVAL;
 	if (vma->vm_end < vma->vm_start)
 		return -EINVAL;
 	if ((vma->vm_flags & VM_SHARED) == 0)
@@ -1666,7 +1668,7 @@ static int vfio_pci_mmap(void *device_da
 		int regnum = index - VFIO_PCI_NUM_REGIONS;
 		struct vfio_pci_region *region = vdev->region + regnum;
 
-		if (region && region->ops && region->ops->mmap &&
+		if (region->ops && region->ops->mmap &&
 		    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
 			return region->ops->mmap(vdev, region, vma);
 		return -EINVAL;


