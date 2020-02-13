Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E8B15C1D0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgBMP0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387608AbgBMP0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:36 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7B18222C2;
        Thu, 13 Feb 2020 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607595;
        bh=mRN16gy+86886KrXaqWW/kvDoKgPKYfm3OlmM+N+Obk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAETyESshAOZGrpGaFvya+k+YJYYGcTFmch6NMVVgC4GLB8cp1ExEYg/ZQvggNi3r
         v0d8B+HJSeH119Ahw/t5lylSeSOFTMEpjLp15kUqvcpbJj2rwhQhZlh2ydW7/AGSkm
         jK9yEE0sLHholgz/DE6+lwKqOg5IABWYa4un8dSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 29/52] powerpc/pseries/vio: Fix iommu_table use-after-free refcount warning
Date:   Thu, 13 Feb 2020 07:21:10 -0800
Message-Id: <20200213151822.007654746@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

commit aff8c8242bc638ba57247ae1ec5f272ac3ed3b92 upstream.

Commit e5afdf9dd515 ("powerpc/vfio_spapr_tce: Add reference counting to
iommu_table") missed an iommu_table allocation in the pseries vio code.
The iommu_table is allocated with kzalloc and as a result the associated
kref gets a value of zero. This has the side effect that during a DLPAR
remove of the associated virtual IOA the iommu_tce_table_put() triggers
a use-after-free underflow warning.

Call Trace:
[c0000002879e39f0] [c00000000071ecb4] refcount_warn_saturate+0x184/0x190
(unreliable)
[c0000002879e3a50] [c0000000000500ac] iommu_tce_table_put+0x9c/0xb0
[c0000002879e3a70] [c0000000000f54e4] vio_dev_release+0x34/0x70
[c0000002879e3aa0] [c00000000087cfa4] device_release+0x54/0xf0
[c0000002879e3b10] [c000000000d64c84] kobject_cleanup+0xa4/0x240
[c0000002879e3b90] [c00000000087d358] put_device+0x28/0x40
[c0000002879e3bb0] [c0000000007a328c] dlpar_remove_slot+0x15c/0x250
[c0000002879e3c50] [c0000000007a348c] remove_slot_store+0xac/0xf0
[c0000002879e3cd0] [c000000000d64220] kobj_attr_store+0x30/0x60
[c0000002879e3cf0] [c0000000004ff13c] sysfs_kf_write+0x6c/0xa0
[c0000002879e3d10] [c0000000004fde4c] kernfs_fop_write+0x18c/0x260
[c0000002879e3d60] [c000000000410f3c] __vfs_write+0x3c/0x70
[c0000002879e3d80] [c000000000415408] vfs_write+0xc8/0x250
[c0000002879e3dd0] [c0000000004157dc] ksys_write+0x7c/0x120
[c0000002879e3e20] [c00000000000b278] system_call+0x5c/0x68

Further, since the refcount was always zero the iommu_tce_table_put()
fails to call the iommu_table release function resulting in a leak.

Fix this issue be initilizing the iommu_table kref immediately after
allocation.

Fixes: e5afdf9dd515 ("powerpc/vfio_spapr_tce: Add reference counting to iommu_table")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1579558202-26052-1-git-send-email-tyreld@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/vio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -1195,6 +1195,8 @@ static struct iommu_table *vio_build_iom
 	if (tbl == NULL)
 		return NULL;
 
+	kref_init(&tbl->it_kref);
+
 	of_parse_dma_window(dev->dev.of_node, dma_window,
 			    &tbl->it_index, &offset, &size);
 


