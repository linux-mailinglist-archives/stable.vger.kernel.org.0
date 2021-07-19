Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B38A3CE546
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347073AbhGSPs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349388AbhGSPpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0713A613B0;
        Mon, 19 Jul 2021 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711887;
        bh=SlIeBwGAAJ/eYlwVLrKmTH7lzNfL1PotuC4Ic6N5HSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqcc1nNiI/D5z3wHuXLo2pBxSVxm8UdxWWMIoMVNy6WktVeZUrSP5q2rEknDndivj
         UGb2cpiz3uKFHZUrvwhzUjLYXN5bhbHAUkdRtU7l++qoJEXlf8ENMgVjUO2JNQEzBk
         hX1HeDIffFVZ28yq6hXEi2sCX22wPWnVKmud0DRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 170/292] virtio_net: Fix error handling in virtnet_restore()
Date:   Mon, 19 Jul 2021 16:53:52 +0200
Message-Id: <20210719144948.090926692@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 3f2869cace829fb4b80fc53b3ddaa7f4ba9acbf1 ]

Do some cleanups in virtnet_restore() when virtnet_cpu_notif_add() failed.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20210517084516.332-1-xieyongji@bytedance.com
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f7ce341bb328..db9a876035ec 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3229,8 +3229,11 @@ static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
 
 	err = virtnet_cpu_notif_add(vi);
-	if (err)
+	if (err) {
+		virtnet_freeze_down(vdev);
+		remove_vq_common(vi);
 		return err;
+	}
 
 	return 0;
 }
-- 
2.30.2



