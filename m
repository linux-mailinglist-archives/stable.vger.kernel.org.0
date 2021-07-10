Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5AD3C385E
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhGJXyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhGJXxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8896C613E8;
        Sat, 10 Jul 2021 23:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961062;
        bh=7XQ3Ut6MFTQjVKXo1NJiJp/Vt5b8y90oKq9E7EL1Kis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRC875A1H6RbyvQH2cjd0yKUguh1LpDc1Ex9zd9MOxY491jhDzDTqsuQi12KQbmU4
         muAajvh44EP+WGS6Eke9WSZ6aW/9/BxAlDIWmt7kVdpl0ShBXURKl0FhVhDDHKpQJu
         iR81AIeABEnp44kFzLWFQDwJVvmCJkuF/mndbddlA9aGY154IlDfV7SUxmc+sSO6ub
         zOV8WLyof3n1XGwSVEHmOjQfNy14/T/dYDB4zEVMFLTULurlwXRORkVpkN9gZWAXvc
         3KsMbnexZnrQokFP2THmOaPUfQwa7GT+HLH6WPyWGkzcbS0NNMW7iki6EFmJf3Kioz
         V4gA0tZwPQu/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 34/37] virtio-blk: Fix memory leak among suspend/resume procedure
Date:   Sat, 10 Jul 2021 19:50:12 -0400
Message-Id: <20210710235016.3221124-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
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

