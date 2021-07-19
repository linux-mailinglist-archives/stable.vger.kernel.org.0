Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A753CDC14
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241126AbhGSOvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344039AbhGSOsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531F1613ED;
        Mon, 19 Jul 2021 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708377;
        bh=aPhoA6wAfhnZudDGAdxrZd7Up25mGNliT/992tTLk04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gxnyE+QK8RbAng2JLvHDJe+cFQrS4kjeJCEf8Ckk4WiOkP0wb1YP+Fis1RPEy6XQ
         CQTkUsPZkdXRUT+6ob7KMiq08a/jAFc6yUJiiR/FAoscs+EEQ4Rsdn35vPN/0docKS
         P3DTu2dG1rkKqFy2dgiFHjjRvOUwLSpRUFafXAFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 286/315] virtio_console: Assure used length from device is limited
Date:   Mon, 19 Jul 2021 16:52:55 +0200
Message-Id: <20210719144952.844424424@linuxfoundation.org>
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
index 6a57237e46db..0fb3a8e62e62 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -489,7 +489,7 @@ static struct port_buffer *get_inbuf(struct port *port)
 
 	buf = virtqueue_get_buf(port->in_vq, &len);
 	if (buf) {
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 		port->stats.bytes_received += len;
 	}
@@ -1755,7 +1755,7 @@ static void control_work_handler(struct work_struct *work)
 	while ((buf = virtqueue_get_buf(vq, &len))) {
 		spin_unlock(&portdev->c_ivq_lock);
 
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 
 		handle_control_message(vq->vdev, portdev, buf);
-- 
2.30.2



