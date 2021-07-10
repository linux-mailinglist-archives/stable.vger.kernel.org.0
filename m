Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE653C38BC
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhGJX4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233965AbhGJXzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F7C5613F9;
        Sat, 10 Jul 2021 23:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961099;
        bh=Kbh2t3UhUwFykH6852mSxWLXEXKjB4hI7B6a9yxTSOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0w9WX7ikdVmJZ2CYe+GAF15zWDzgRtRKLl4z0HIzdtHS4o/n/PbpsXt7cssU4RWX
         kzlp+qVd+508TOBTs2V+I7GkLVtxTOxsWlXf2kczMKH/I7GN3pjSCj8kp2n+w2JgE1
         ecA0UcoueOUGHwhrtBzkaFTxnQPuzKdGSWe2nNly8O59vLaUgazIW5b+yAaSQkHCo1
         YqriV+vn6ooq1HCEqylU26bjjCi7vbeLX3lfYYpcZevbJFRg53pytJy3ydgbbJw+Wj
         Zma7YVWz/M/k/WIZZAWDy5OjmovM1WKwZs++tLE81K4Q4POXXlYVz6OOjXw1Et3n/R
         nuA+Ujq0aT0vQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/28] virtio-blk: Fix memory leak among suspend/resume procedure
Date:   Sat, 10 Jul 2021 19:51:04 -0400
Message-Id: <20210710235107.3221840-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
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
index 2eeb2bcb488d..816eb2db7308 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1057,6 +1057,8 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	blk_mq_quiesce_queue(vblk->disk->queue);
 
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
+
 	return 0;
 }
 
-- 
2.30.2

