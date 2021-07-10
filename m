Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F323C3847
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhGJXyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233453AbhGJXxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93228610A2;
        Sat, 10 Jul 2021 23:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961054;
        bh=CcTgJfVEmbNFgL0EvxomN/vMbIEdDbKcKAhs6s8IAmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5MsQ8W2SD5ViYI5Q16oDMuvkre6kkoTiEfxCBt0zFKQhEvdv9JeKm6w6+O5RKr4T
         7VbimkfxTdJe+RC7CImdCAcPi70PTFSM6x2XtLnpXapsywWTrpRGYhqsslKk4kk6jy
         CNJl/iYMPfWZ6Jq3cSjtqroTK7ct9uiUC8Mw8ZqqnpDO/MIF7mpWY/jL/X1ffHrzwQ
         kiIfMmDgvYwCXUQkQorHJlx062UAJoepudW6m44FPxT0dcBMA/NoByYKv9qkpud3I6
         FLvhYgn1yFafz2S2QwQa+6vpoXTF8XV9zh75SpvMhENt6DL2me/X+6jOcB9f+TQlJj
         Pa3hIsBiGjZKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 28/37] drm/amdkfd: fix sysfs kobj leak
Date:   Sat, 10 Jul 2021 19:50:06 -0400
Message-Id: <20210710235016.3221124-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit dcdb4d904b4bd3078fe8d4d24b1658560d6078ef ]

3 cases of kobj leak, which causes memory leak:

kobj_type must have release() method to free memory from release
callback. Don't need NULL default_attrs to init kobj.

sysfs files created under kobj_status should be removed with kobj_status
as parent kobject.

Remove queue sysfs files when releasing queue from process MMU notifier
release callback.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           | 14 ++++++--------
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  1 +
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 65803e153a22..d243e60c6eef 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -452,13 +452,9 @@ static const struct sysfs_ops procfs_stats_ops = {
 	.show = kfd_procfs_stats_show,
 };
 
-static struct attribute *procfs_stats_attrs[] = {
-	NULL
-};
-
 static struct kobj_type procfs_stats_type = {
 	.sysfs_ops = &procfs_stats_ops,
-	.default_attrs = procfs_stats_attrs,
+	.release = kfd_procfs_kobj_release,
 };
 
 int kfd_procfs_add_queue(struct queue *q)
@@ -973,9 +969,11 @@ static void kfd_process_wq_release(struct work_struct *work)
 		list_for_each_entry(pdd, &p->per_device_data, per_device_list) {
 			sysfs_remove_file(p->kobj, &pdd->attr_vram);
 			sysfs_remove_file(p->kobj, &pdd->attr_sdma);
-			sysfs_remove_file(p->kobj, &pdd->attr_evict);
-			if (pdd->dev->kfd2kgd->get_cu_occupancy != NULL)
-				sysfs_remove_file(p->kobj, &pdd->attr_cu_occupancy);
+
+			sysfs_remove_file(pdd->kobj_stats, &pdd->attr_evict);
+			if (pdd->dev->kfd2kgd->get_cu_occupancy)
+				sysfs_remove_file(pdd->kobj_stats,
+						  &pdd->attr_cu_occupancy);
 			kobject_del(pdd->kobj_stats);
 			kobject_put(pdd->kobj_stats);
 			pdd->kobj_stats = NULL;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index eb1635ac8988..43c07ac2c6fc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -153,6 +153,7 @@ void pqm_uninit(struct process_queue_manager *pqm)
 		if (pqn->q && pqn->q->gws)
 			amdgpu_amdkfd_remove_gws_from_process(pqm->process->kgd_process_info,
 				pqn->q->gws);
+		kfd_procfs_del_queue(pqn->q);
 		uninit_queue(pqn->q);
 		list_del(&pqn->process_queue_list);
 		kfree(pqn);
-- 
2.30.2

