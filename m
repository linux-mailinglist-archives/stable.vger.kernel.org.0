Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA07C364439
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241093AbhDSNZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242004AbhDSNZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52917613B2;
        Mon, 19 Apr 2021 13:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838402;
        bh=1afSktFHzbvLfgh7ummAMN4gyTACY4iqYSb1to7CFz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayCDiqccn7Bk10ygln1AgmPzQNabegnckBj+VVkEpTZ9b3aXVeea2zmCqI+uBfuh0
         CmfWONQ5gQJxgTfwDH6AstVOoyZeRdfNooBxtISJdQqy5h5cPG1AaulNM+8N7ppre1
         itnf1MkW/NLsCYwqhBhi+z2m7fBPODsdppwdhC5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Christian A. Ehrhardt" <lk@c--e.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 47/73] vfio/pci: Add missing range check in vfio_pci_mmap
Date:   Mon, 19 Apr 2021 15:06:38 +0200
Message-Id: <20210419130525.353078583@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
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
@@ -1474,6 +1474,8 @@ static int vfio_pci_mmap(void *device_da
 
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
+	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
+		return -EINVAL;
 	if (vma->vm_end < vma->vm_start)
 		return -EINVAL;
 	if ((vma->vm_flags & VM_SHARED) == 0)
@@ -1482,7 +1484,7 @@ static int vfio_pci_mmap(void *device_da
 		int regnum = index - VFIO_PCI_NUM_REGIONS;
 		struct vfio_pci_region *region = vdev->region + regnum;
 
-		if (region && region->ops && region->ops->mmap &&
+		if (region->ops && region->ops->mmap &&
 		    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
 			return region->ops->mmap(vdev, region, vma);
 		return -EINVAL;


