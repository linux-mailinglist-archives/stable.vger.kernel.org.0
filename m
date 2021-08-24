Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515183F63CC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhHXQ6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234493AbhHXQ5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 775DD613D5;
        Tue, 24 Aug 2021 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824214;
        bh=OWv4pztDXHe3JrHRZgzm18Ls8IPbMxziOUGEkTlFsLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzFvfyuh63fGROF5lEt8WBUMH8QRDw6s2S2p6q2b14wiSNlde6lkw5oWTJc15GaDL
         UR3jociwVyk9DEA5WfYsiDM2EDtMamMKDhGN254IQHhWZ+YCj86e044C9JfhuBO8Yn
         aozQsGnlwtAcqEgLl8bFx/xmVWtW9ZW9njcVXWLiNHpH+oMuhA7E6ZIWWtV4S4eUAp
         oOvkTwaCp6cbWXhnwBxo22MEnoy90cf4UEj8uRAY8VzZLw+qC9iuvLsrQafWU9ZwaD
         MbBS3vTzDCmxftf+IAt6u09C1W61CmPlvKxmQoyIva1umAJxG+MvCQ7v1R5OUuCeEs
         qJqffg5zQG22w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 046/127] vdpa/mlx5: Avoid destroying MR on empty iotlb
Date:   Tue, 24 Aug 2021 12:54:46 -0400
Message-Id: <20210824165607.709387-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index cfa56a58b271..0ca39ef20c6d 100644
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

