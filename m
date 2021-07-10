Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381FA3C390A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhGJX5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234112AbhGJX4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C65D3613FC;
        Sat, 10 Jul 2021 23:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961129;
        bh=NtwPwY13+UkNy05MJKmtncoXJxnnGqWgemsC1i4b/Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VckpmkrQsqTYd3fyz0pG+Q69Oi0D6elgbfQfkkDJaaWgf5UKmu/3+ty1kRhcFRM2H
         wwxDfm6nOtVf2J9DRehSFFpflzO4MWkiARH/W9Ew1redyNy5RfyJLq92qUaYldcJQL
         ArSaWKPv6EwJdMQoJ4XzsAieA8jbVmdwHxBwb2JbJcjQ4xOk8jxJZJ2hbsWNdeH2TW
         onJhk1h1DNwPE8ikOw0qtRZHpLGnQ6sZJ4dkFyEHCzm4MhajDItbSIoyEsbbF73NX3
         k7MsobBqmH2EYcgVbTpXZoy88bhV1x5/TALr9h4Aiu7mRuBEGi/SF2fgIbF1RE5B1F
         aC/bOcrOQD7yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/22] virtio-blk: Fix memory leak among suspend/resume procedure
Date:   Sat, 10 Jul 2021 19:51:41 -0400
Message-Id: <20210710235143.3222129-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235143.3222129-1-sashal@kernel.org>
References: <20210710235143.3222129-1-sashal@kernel.org>
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
index c2d9459ec5d1..dac1769146d7 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -944,6 +944,8 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	blk_mq_quiesce_queue(vblk->disk->queue);
 
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
+
 	return 0;
 }
 
-- 
2.30.2

