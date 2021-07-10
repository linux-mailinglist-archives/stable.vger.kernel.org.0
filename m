Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CF23C38C8
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhGJX4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233335AbhGJXzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C70761402;
        Sat, 10 Jul 2021 23:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961101;
        bh=qHclCUiD/FAMElbZW4VKMO6R/swMk2HSVvU0lbPiUZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=si6LdNlFwADPmnr9XXVuwFvquJbPqYuDph3p7WEd/ThERk0MDQqXG3lar4mxEI41I
         3mAZQDGTgYqTRFAw+3/Y5pxHKxZkMUojZLZ+XtvA6Psgh7FnUKMq19mXJ+uUnI4DUz
         hQm179ZbShBJ6SaydWWNsFoB27xTN8yPdRHG4QDQhj9DJWXWpKxeOBsy+BoiEDyfXx
         X8uq+8RwKs6KM7Ahv7mLC5FRzfxPKIp4YNLNi4LMfg/zKRZ73SfnqSbMGmhV25kvZO
         axqQzQuAbCv7vv2AYaLOZ4lBwLSZEP4raJ4iNJ/b4nzzxvkVHyzEUgalasVa/3ELgM
         IePItKbkca3tA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 27/28] virtio_console: Assure used length from device is limited
Date:   Sat, 10 Jul 2021 19:51:06 -0400
Message-Id: <20210710235107.3221840-27-sashal@kernel.org>
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
index 5eabbf73fdef..b453029487a1 100644
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
@@ -1714,7 +1714,7 @@ static void control_work_handler(struct work_struct *work)
 	while ((buf = virtqueue_get_buf(vq, &len))) {
 		spin_unlock(&portdev->c_ivq_lock);
 
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 
 		handle_control_message(vq->vdev, portdev, buf);
-- 
2.30.2

