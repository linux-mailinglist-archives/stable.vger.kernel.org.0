Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA24291B23
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgJRT3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732206AbgJRT2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:28:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A05D22267;
        Sun, 18 Oct 2020 19:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049281;
        bh=wDUYPS56b/18VlLZ2KLd4bd6O6ujEctojC7MEYgAW6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmFR4Nk1r9NuNN/GuVrgjpSA0kiXXoC3OVA6zhkbkeEyMbDPvnvXfsuwePNGxSbmt
         bFyTTnTR/EAS4Q/E6fP4f6xA3kmzbv6bEuwwXmnOYzqI3tVgEHuGTAtCoTGA/GzaiK
         TvKhvg3EmWenoAVYFGAMLgXwlNH4K26oWxdcaCqQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Horn <doughorn@google.com>, Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.4 27/33] Fix use after free in get_capset_info callback.
Date:   Sun, 18 Oct 2020 15:27:22 -0400
Message-Id: <20201018192728.4056577-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192728.4056577-1-sashal@kernel.org>
References: <20201018192728.4056577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Horn <doughorn@google.com>

[ Upstream commit e219688fc5c3d0d9136f8d29d7e0498388f01440 ]

If a response to virtio_gpu_cmd_get_capset_info takes longer than
five seconds to return, the callback will access freed kernel memory
in vg->capsets.

Signed-off-by: Doug Horn <doughorn@google.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200902210847.2689-2-gurchetansingh@chromium.org
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_kms.c |  2 ++
 drivers/gpu/drm/virtio/virtgpu_vq.c  | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 06496a1281622..476b9993b0682 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -113,8 +113,10 @@ static void virtio_gpu_get_capsets(struct virtio_gpu_device *vgdev,
 					 vgdev->capsets[i].id > 0, 5 * HZ);
 		if (ret == 0) {
 			DRM_ERROR("timed out waiting for cap set %d\n", i);
+			spin_lock(&vgdev->display_info_lock);
 			kfree(vgdev->capsets);
 			vgdev->capsets = NULL;
+			spin_unlock(&vgdev->display_info_lock);
 			return;
 		}
 		DRM_INFO("cap set %d: id %d, max-version %d, max-size %d\n",
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 772a5a3b0ce1a..18e8fcad6690b 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -596,9 +596,13 @@ static void virtio_gpu_cmd_get_capset_info_cb(struct virtio_gpu_device *vgdev,
 	int i = le32_to_cpu(cmd->capset_index);
 
 	spin_lock(&vgdev->display_info_lock);
-	vgdev->capsets[i].id = le32_to_cpu(resp->capset_id);
-	vgdev->capsets[i].max_version = le32_to_cpu(resp->capset_max_version);
-	vgdev->capsets[i].max_size = le32_to_cpu(resp->capset_max_size);
+	if (vgdev->capsets) {
+		vgdev->capsets[i].id = le32_to_cpu(resp->capset_id);
+		vgdev->capsets[i].max_version = le32_to_cpu(resp->capset_max_version);
+		vgdev->capsets[i].max_size = le32_to_cpu(resp->capset_max_size);
+	} else {
+		DRM_ERROR("invalid capset memory.");
+	}
 	spin_unlock(&vgdev->display_info_lock);
 	wake_up(&vgdev->resp_wq);
 }
-- 
2.25.1

