Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151D53C396B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhGJX7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233235AbhGJX7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D351C61433;
        Sat, 10 Jul 2021 23:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961197;
        bh=nTT+xchQK5zW6cns9KJcPWUUEfrXKrOpcI7iLsIGi1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dt7bIVdFGrkeGrhe7pvTOD+fUK2voE7K8TLWSMGDUazJJnYg0x0zEKWG28uwvWOvO
         mYvjsJtEDlMi4s4wV1KZZYiJjAbnj4iAojdXjzLF1VZhDIRGxH//jMsMfs/2crzWEh
         1Y3WWv31VVpBiq7vXEHS56dd9oSw0hNJV4qm2fSBq/2UHCrQLdVbKYTmdNCBSz/yRM
         nD/LWkhiCCJmDyva9yWyaWdi+3BKezT8hk2LZm05NOi2pgOJ98/RbeMb6OJZt3dR3s
         6dIWTf2hYjh5y8rAW0oE8i6zghVE4oqbFZ8ZkCKNQAMeEQr4so0IhvCN/XNO7Kipg6
         Y8OBfbVC7U3ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/12] virtio-blk: Fix memory leak among suspend/resume procedure
Date:   Sat, 10 Jul 2021 19:53:01 -0400
Message-Id: <20210710235302.3222809-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235302.3222809-1-sashal@kernel.org>
References: <20210710235302.3222809-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit b71ba22e7c6c6b279c66f53ee7818709774efa1f ]

The vblk->vqs should be freed before we call init_vqs()
in virtblk_restore().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20210517084332.280-1-xieyongji@bytedance.com
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index bdc3efacd0d2..2bcc2bc64149 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -808,6 +808,8 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	blk_mq_stop_hw_queues(vblk->disk->queue);
 
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
+
 	return 0;
 }
 
-- 
2.30.2

