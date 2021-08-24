Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E13F65AF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239988AbhHXRPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239419AbhHXROB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:14:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4816761A79;
        Tue, 24 Aug 2021 17:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824492;
        bh=PSK/QdpHzg/o/1FMPRAN3Kb14JmkBECJZRd92lUNZR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZdsA1t9tpWIakCSquO+DxxpIDeZytyjsF+7TOEhJtOr9A35qVi8O5OPPB+nY/AYZ
         CS6dSSHa81sv49hoGkqUdrXAK7sDJOQtGJIv8zghy2JH2GAiTrRMEatjo/V42eE4r6
         5BKJcvwSnag7+8Mv0MmMBUk0vza/MnieWGueLlXAZm7ZLDNBEkR3VIV+G62dDmjYlb
         WA2Wc5Br+CnCwpRkEoT/UbRIuUYBBjtc4OeZyPKzJHLJgqdDhhDZDMOphsMdb0y4UK
         HjyKAjHUtblP/o1GWUoAYoIBgB9tLsBWAqg86oooUkO4VFvw08u54nyPc0yKKZhlbv
         AhxKVGTdP6VoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/61] iommu: Check if group is NULL before remove device
Date:   Tue, 24 Aug 2021 13:00:30 -0400
Message-Id: <20210824170106.710221-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 5aa95d8834e07907e64937d792c12ffef7fb271f ]

If probe_device is failing, iommu_group is not initialized because
iommu_group_add_device is not reached, so freeing it will result
in NULL pointer access.

iommu_bus_init
  ->bus_iommu_probe
      ->probe_iommu_group in for each:/* return -22 in fail case */
          ->iommu_probe_device
              ->__iommu_probe_device       /* return -22 here.*/
                  -> ops->probe_device          /* return -22 here.*/
                  -> iommu_group_get_for_dev
                        -> ops->device_group
                        -> iommu_group_add_device //good case
  ->remove_iommu_group  //in fail case, it will remove group
     ->iommu_release_device
         ->iommu_group_remove_device // here we don't have group

In my case ops->probe_device (mtk_iommu_probe_device from
mtk_iommu_v1.c) is due to failing fwspec->ops mismatch.

Fixes: d72e31c93746 ("iommu: IOMMU Groups")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20210731074737.4573-1-linux@fw-web.de
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 9d7232e26ecf..c5758fb696cc 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -775,6 +775,9 @@ void iommu_group_remove_device(struct device *dev)
 	struct iommu_group *group = dev->iommu_group;
 	struct group_device *tmp_device, *device = NULL;
 
+	if (!group)
+		return;
+
 	dev_info(dev, "Removing from iommu group %d\n", group->id);
 
 	/* Pre-notify listeners that a device is being removed. */
-- 
2.30.2

