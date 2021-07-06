Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8313BD26A
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhGFLmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237634AbhGFLgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AA2C61DEB;
        Tue,  6 Jul 2021 11:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570938;
        bh=D3kqwDzce5vvFp6UQZfFYga72P7A8DidK38IYwhSQG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mV8CNEkcr8JZH74lH/IECovIRSvGZCmvz5fTCp8oIo3QLBHFY7EodzbNx1vBmrXka
         I0MGLp+lAG61H04XjxKmU8aK134CZ2lRhjziPSqvqBGRSATl09jaWAh1f5YTULjL23
         fnqDaPt4YbVEwu6buKr+vdytLAaeC0ZWjr06GvngTTqroAo5NI8qcpof0Q92UgBeII
         +Bc9AcJWXaH19NyaT2bStG64AGCfYQ3kvGHbsL21tjNK7FacE28jE0SPqDFqnC3oyh
         Vne2L/Wml6xXP6c7M0QfuunUMAW79sRsz5uapE++Zo10N01oxurVTkLeNnz0Dkslj0
         uWotDJxQ1GJbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 08/35] drm/virtio: Fixes a potential NULL pointer dereference on probe failure
Date:   Tue,  6 Jul 2021 07:28:20 -0400
Message-Id: <20210706112848.2066036-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 17f46f488a5d82c5568e6e786cd760bba1c2ee09 ]

The dev->dev_private might not be allocated if virtio_gpu_pci_quirk()
or virtio_gpu_init() failed. In this case, we should avoid the cleanup
in virtio_gpu_release().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210517084913.403-1-xieyongji@bytedance.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_kms.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index ba7855da7c7f..d8b2027730d0 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -258,6 +258,9 @@ int virtio_gpu_driver_unload(struct drm_device *dev)
 	flush_work(&vgdev->config_changed_work);
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 
+	if (!vgdev)
+		return;
+
 	virtio_gpu_modeset_fini(vgdev);
 	virtio_gpu_ttm_fini(vgdev);
 	virtio_gpu_free_vbufs(vgdev);
-- 
2.30.2

