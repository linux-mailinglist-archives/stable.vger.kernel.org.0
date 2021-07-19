Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153CA3CDBE7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbhGSOu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344035AbhGSOsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 247DD613D2;
        Mon, 19 Jul 2021 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708372;
        bh=WRHelRLjnMA4hAxyeEiTdQ/LDMsClhlPHHEvqM4oXR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLvXabEQeN7YxoDUBjJK0u86OCgpKNOhzaIf4rPTGWsRvnmnnTFKHRjL2g/OvYD1y
         T9suuTUroy9Tqq4hNGrXQgLfFRuKgQY2fJli9wEyFoJzf30+b3PxufwmlIh8mR+omb
         D5TLMpubD2pdxzLp2v/ikmW3yecYH6nMBALAmEfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 284/315] virtio-blk: Fix memory leak among suspend/resume procedure
Date:   Mon, 19 Jul 2021 16:52:53 +0200
Message-Id: <20210719144952.774611166@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2f15e38fb3f8..437d43747c6d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -931,6 +931,8 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	blk_mq_quiesce_queue(vblk->disk->queue);
 
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
+
 	return 0;
 }
 
-- 
2.30.2



