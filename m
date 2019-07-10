Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF87648DD
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfGJPCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbfGJPCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:02:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 039F42064B;
        Wed, 10 Jul 2019 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562770966;
        bh=iDWaGuCyFWXcNVHxVD68Z0CNqAgj+ipuFl5jzHmj4kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ry5jxnTIsLHN8kFUiyUPGvn8wgjYz4kNq7bT2vJRzmzCiK2OFkeI0K/AjwYhujbGu
         pjl6z+HpwjjSZN+V9BONgpuiUyWoNrb7Jicd5EhYIf/8Xy9CsKrWF87Wp7qUyixY15
         D9b2Q6KRH5JPdt9aY/t1XSLhkQRBS9Up+PwCHA1E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.1 03/11] drm/virtio: move drm_connector_update_edid_property() call
Date:   Wed, 10 Jul 2019 11:02:30 -0400
Message-Id: <20190710150240.6984-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150240.6984-1-sashal@kernel.org>
References: <20190710150240.6984-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

[ Upstream commit 41de4be6f6efa4132b29af51158cd672d93f2543 ]

drm_connector_update_edid_property can sleep, we must not
call it while holding a spinlock.  Move the callsite.

Fixes: b4b01b4995fb ("drm/virtio: add edid support")
Reported-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Tested-by: Max Filippov <jcmvbkbc@gmail.com>
Tested-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20190405044602.2334-1-kraxel@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 6bc2008b0d0d..3ef24f89ef93 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -620,11 +620,11 @@ static void virtio_gpu_cmd_get_edid_cb(struct virtio_gpu_device *vgdev,
 	output = vgdev->outputs + scanout;
 
 	new_edid = drm_do_get_edid(&output->conn, virtio_get_edid_block, resp);
+	drm_connector_update_edid_property(&output->conn, new_edid);
 
 	spin_lock(&vgdev->display_info_lock);
 	old_edid = output->edid;
 	output->edid = new_edid;
-	drm_connector_update_edid_property(&output->conn, output->edid);
 	spin_unlock(&vgdev->display_info_lock);
 
 	kfree(old_edid);
-- 
2.20.1

