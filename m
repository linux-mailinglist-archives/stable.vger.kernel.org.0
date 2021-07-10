Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729693C3967
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhGJX7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233461AbhGJX60 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB12361434;
        Sat, 10 Jul 2021 23:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961180;
        bh=qe3Gf6gXUqjrNfTGZ+MpZXhbBEVK9NZ5viLV5Q8xl/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxLeS+kNAwu11dDtEcB7tWEHxgAQIROdbTdQ+DcGBXhJIde/PxwudGhil7k2CejvI
         5S+4MaybOkhlkSbvwwBYG77YhV1oAMKknlHcPt72KC2hP7JcFkhZ8OndTseJqplcU2
         B/PiuKdmcBMm9Ddd0SCVjKt/ybKAdefIVvYDP8pjd86WN4/K0dkDsw4UW+8wH6NSSE
         Rgpy8raBdwCU6xnjOvO2f0TtBmbbXDUwuLYziZMLXegUN1TRXz3Bj7IZSFUtBey5rq
         NY/XXVI1aQXomAGGSzBuKXvY4F/e7cLODALb9qGvzle1fkC0PgwROeCnMf4SCNhEks
         3IvTlLejyFFVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/16] virtio-blk: Fix memory leak among suspend/resume procedure
Date:   Sat, 10 Jul 2021 19:52:39 -0400
Message-Id: <20210710235240.3222618-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235240.3222618-1-sashal@kernel.org>
References: <20210710235240.3222618-1-sashal@kernel.org>
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
index e57a1f6e39d5..302260e9002c 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -800,6 +800,8 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	blk_mq_stop_hw_queues(vblk->disk->queue);
 
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
+
 	return 0;
 }
 
-- 
2.30.2

