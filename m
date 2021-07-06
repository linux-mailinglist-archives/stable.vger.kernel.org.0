Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119473BCBF9
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhGFLSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbhGFLRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4037961C29;
        Tue,  6 Jul 2021 11:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570093;
        bh=IFG7ElW86piU0V3nsWrsJoKtuF6YvL1FgXA/ieXfuD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TO3pSh++VJu+8pd3SginiIBelM8oxhazXljr4voF4vjeF2ujTCoDnTcuShBjt/5t5
         UZIYBVrH0lsgUcNGyu8u4pBo5QxyKX/FTXamrj8Uj683RKo2CLxPYt6CKJqg6znP8U
         cBnm9MZUkzodesmFpbq0USbqu/UVKWrXBwd4BXVYQ9JInfzrLE4FFahNnNEi/n0IE0
         OqMZZDOYSXRGcdBp0tFvSt0H9djKsoQYQ/p/Yf2R9a0+umX7mMaYNPY03jmX74HzEL
         /OfrDHadTlkmAI7GI39B6/TAmJ2npcsrGIhXnpo4XPjtWkBzb6TdUOK63K4zp9Pqwc
         rO84nPGTVTiAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.13 031/189] drm/virtio: Fix double free on probe failure
Date:   Tue,  6 Jul 2021 07:11:31 -0400
Message-Id: <20210706111409.2058071-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index aa532ad31a23..f3379059f324 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -234,6 +234,7 @@ int virtio_gpu_init(struct drm_device *dev)
 err_vbufs:
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 err_vqs:
+	dev->dev_private = NULL;
 	kfree(vgdev);
 	return ret;
 }
-- 
2.30.2

