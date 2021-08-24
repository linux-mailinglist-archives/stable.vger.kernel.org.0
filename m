Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CA83F64FF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbhHXRJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239422AbhHXRHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DDB3619EA;
        Tue, 24 Aug 2021 16:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824393;
        bh=OQ4I/BMOYSLVlMvcx9RjcvWe8+VZjWye4MX++2RqPys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYPeTDRMTPnnm8qTHLAEo/m78u3wEOT3Me6lvbMDKW2XxhepNThJtBxd1Ya6zIimw
         ds6WCjhaiEs8xRlvGuXIEWiOh54NWa9ScFztfR/pHzeiWBoCBJ1bvP+wROISINNGIp
         xtGHEAIQqt1FRjirGAqhAnhiF/bdbP3dDwusKezPUcwKOTvpx2ip2s5MZ6dt+CeJvd
         EhVsckFGixQdh0qL1G1S+QsBVDd3eh7EgdGXUefYGudl239rNbZ6Y5F6CCpmG9f+6V
         UuN6FREYgkAo/jMZ8MDJcoy0mdLWfkiPf2XN05LORQCLJHzVR9IunThrH+j9FjONd+
         9aBrDUthMx2bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/98] vdpa/mlx5: Avoid destroying MR on empty iotlb
Date:   Tue, 24 Aug 2021 12:58:14 -0400
Message-Id: <20210824165908.709932-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 08dbd5660232bede7916d8568003012c1182cc9a ]

The current code treats an empty iotlb provdied in set_map() as a
special case and destroy the memory region object. This must not be done
since the virtqueue objects reference this MR. Doing so will cause the
driver unload to emit errors and log timeouts caused by the firmware
complaining on busy resources.

This patch treats an empty iotlb as any other change of mapping. In this
case, mlx5_vdpa_create_mr() will fail and the entire set_map() call to
fail.

This issue has not been encountered before but was seen to occur in a
non-official version of qemu. Since qemu is a userspace program, the
driver must protect against such case.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210811053713.66658-1-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index aa656f57bf5b..32c9925de473 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -454,11 +454,6 @@ out:
 	mutex_unlock(&mr->mkey_mtx);
 }
 
-static bool map_empty(struct vhost_iotlb *iotlb)
-{
-	return !vhost_iotlb_itree_first(iotlb, 0, U64_MAX);
-}
-
 int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 			     bool *change_map)
 {
@@ -466,10 +461,6 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *io
 	int err = 0;
 
 	*change_map = false;
-	if (map_empty(iotlb)) {
-		mlx5_vdpa_destroy_mr(mvdev);
-		return 0;
-	}
 	mutex_lock(&mr->mkey_mtx);
 	if (mr->initialized) {
 		mlx5_vdpa_info(mvdev, "memory map update\n");
-- 
2.30.2

