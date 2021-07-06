Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2075A3BD172
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbhGFLjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237083AbhGFLfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08DC261E5F;
        Tue,  6 Jul 2021 11:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570723;
        bh=7TqA3fICyE5j+6j+x3Ixd7Q4PekYwAIpdQ7n4fQORYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlGseABzUrz+9EfWJEcIbzOKU/dBvaEooEkO7/K0A2VpyfSsk3F4+frlaewgUGhQ0
         RAlWyzirbZk7MDP51GhonR/WHsv9Wu1oyuCw+pflmtoJvkCtWnZP8tVUUOq7cZjQMW
         jAQHMknJBl4cWW5piukjEu215O1pt5y8yMYWcW179bwroOSARDJvq+iKIAX8MTCkAS
         TUwqmSqwzktob8YnZQdo8RCsM0wpOYAV66aBadYAgtn96o3VUiabcbhh9rUfT73FQv
         w4heApoeWUqp1TKCXv2hxd8CDZXtvcvUjXSvymyb4xzIDHoQWsWQWRuuqxCveoNM0J
         Gh+d6GydAZTEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 16/74] drm/virtio: Fix double free on probe failure
Date:   Tue,  6 Jul 2021 07:24:04 -0400
Message-Id: <20210706112502.2064236-16-sashal@kernel.org>
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

[ Upstream commit cec7f1774605a5ef47c134af62afe7c75c30b0ee ]

The virtio_gpu_init() will free vgdev and vgdev->vbufs on failure.
But such failure will be caught by virtio_gpu_probe() and then
virtio_gpu_release() will be called to do some cleanup which
will free vgdev and vgdev->vbufs again. So let's set dev->dev_private
to NULL to avoid double free.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210517084913.403-2-xieyongji@bytedance.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_kms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 5c0249d3bd53..0727791872f5 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -218,6 +218,7 @@ int virtio_gpu_init(struct drm_device *dev)
 err_vbufs:
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 err_vqs:
+	dev->dev_private = NULL;
 	kfree(vgdev);
 	return ret;
 }
-- 
2.30.2

