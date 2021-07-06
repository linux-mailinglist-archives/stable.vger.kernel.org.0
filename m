Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92F3BD51C
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhGFMTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237079AbhGFLfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D801E61CDE;
        Tue,  6 Jul 2021 11:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570722;
        bh=18fgVgkfhPUIGec/6E1Vn564JtfINYGTaYagY/Gshxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8HAmqMgJFt/Q9bhhkm1jxMWHUJA10QcwyD++yHUft4tg/eGozbd2mf3C1nJobByS
         JVKTRbaLIDuII+98WeUAg3SEmNe/7DOU9NQ252dauAGUGdC4+h2x8SNpWnACxBWg9i
         EkwBn4Hs6pvy8G6Bbn7PURyxsv/pEXy5UwK+LB8AyfoAViySrm3juSlgPLPq1Ds0Bj
         /MBD2+0RxW/GjRqxQA71pAlgvbpQrJTbswHGU46rH2XBAh5U2mH4G1KRS1Fw0oUMFp
         gkmP601shn81XB8BMGswyzo+i7aQiTRm//zdSn+VEXjrTNZ27T49N813xRepxdZrgH
         mN4tPEwVdI03Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 15/74] drm/virtio: Fixes a potential NULL pointer dereference on probe failure
Date:   Tue,  6 Jul 2021 07:24:03 -0400
Message-Id: <20210706112502.2064236-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 6dcc05ab31eb..5c0249d3bd53 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -243,6 +243,9 @@ void virtio_gpu_deinit(struct drm_device *dev)
 	vgdev->vdev->config->reset(vgdev->vdev);
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 
+	if (!vgdev)
+		return;
+
 	virtio_gpu_modeset_fini(vgdev);
 	virtio_gpu_ttm_fini(vgdev);
 	virtio_gpu_free_vbufs(vgdev);
-- 
2.30.2

