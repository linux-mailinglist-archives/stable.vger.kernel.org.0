Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B3D3CDFCF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345618AbhGSPMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345889AbhGSPJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43E1F611F2;
        Mon, 19 Jul 2021 15:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709793;
        bh=Kbh2t3UhUwFykH6852mSxWLXEXKjB4hI7B6a9yxTSOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoAF2OYzzUvSpdrazUdfAZJwQ+ZlyE74P3Bd0pRpaMlkXsCs1WRCVxyrij3wPkMUk
         TWm8yOEIHpGIhFGlKd46NAcxPvmp8FIL99lSGohxeDZlPlTmVisngsRyTQKPvtHoQm
         +4rysU2SimGqpDS53+Tx51qP5sT2aiuN3Tzpkl2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/149] virtio-blk: Fix memory leak among suspend/resume procedure
Date:   Mon, 19 Jul 2021 16:53:21 +0200
Message-Id: <20210719144923.413273582@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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



