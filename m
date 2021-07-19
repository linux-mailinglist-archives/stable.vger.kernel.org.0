Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068963CE15E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349168AbhGSPZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347231AbhGSPRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:17:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CB41613F5;
        Mon, 19 Jul 2021 15:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710279;
        bh=7XQ3Ut6MFTQjVKXo1NJiJp/Vt5b8y90oKq9E7EL1Kis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1Eg/qYUulOtMPgigK0zirf0Rtpov8VJSbVNsml4dIQ+qv+wvlEp69YVNBex66Y3i
         ECgC7pFOAJIHLtvoTt+PJYObGj/RiVQH0AOzh8bcTQdJ5Iqu+uS0WXUWMREHu4PVa4
         Ub4/y73a+z7sbcBfVHqsaMR/MlBGt9w3JXcoWGIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/243] virtio-blk: Fix memory leak among suspend/resume procedure
Date:   Mon, 19 Jul 2021 16:52:52 +0200
Message-Id: <20210719144945.530657606@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index a314b9382442..42acf9587ef3 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -946,6 +946,8 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	blk_mq_quiesce_queue(vblk->disk->queue);
 
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
+
 	return 0;
 }
 
-- 
2.30.2



