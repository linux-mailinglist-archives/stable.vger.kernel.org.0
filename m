Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33993CE33C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbhGSPg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236397AbhGSPcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 381F761415;
        Mon, 19 Jul 2021 16:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711022;
        bh=y1sY3euYtBZvP8OHnxjT729dgnQjvBrBmXfJxI2ZmLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVG5alQdkmAhM3m+L3cjSfG9IPd3DG3PV1IER13kAN75SnStTFL9duNo8XkeIQrDA
         7vkfcFl08BvZ4UwFFF76HjivUoAdangyAnumrG2oSMkvvLyWKFGvpI6x8dpoBIBSvc
         vd7loXzWwaNvWtVBgPTb6HNZo40hiUXYkY3qhmGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 197/351] virtio_console: Assure used length from device is limited
Date:   Mon, 19 Jul 2021 16:52:23 +0200
Message-Id: <20210719144951.482643127@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit d00d8da5869a2608e97cfede094dfc5e11462a46 ]

The buf->len might come from an untrusted device. This
ensures the value would not exceed the size of the buffer
to avoid data corruption or loss.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210525125622.1203-1-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 59dfd9c421a1..7eaf303a7a86 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -475,7 +475,7 @@ static struct port_buffer *get_inbuf(struct port *port)
 
 	buf = virtqueue_get_buf(port->in_vq, &len);
 	if (buf) {
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 		port->stats.bytes_received += len;
 	}
@@ -1709,7 +1709,7 @@ static void control_work_handler(struct work_struct *work)
 	while ((buf = virtqueue_get_buf(vq, &len))) {
 		spin_unlock(&portdev->c_ivq_lock);
 
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 
 		handle_control_message(vq->vdev, portdev, buf);
-- 
2.30.2



