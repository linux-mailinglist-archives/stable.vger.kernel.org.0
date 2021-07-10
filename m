Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37D13C396A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhGJX7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233748AbhGJX7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C23D613F9;
        Sat, 10 Jul 2021 23:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961198;
        bh=er0SduiRWDtUZFVT+JqXZo1go7bIbj2776gLF2zIl3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0bU5sPIZKVw3nh5WFjKsm7251bZvyGLigjenbWxZ6+/mT600qKwLbhMr5sLxKo8e
         YI0UqtWtLlMf1QchYvt2nxFBULlORnTNPmd1494yiFsDgsdKZt/PGPtcIP6qFzRZw0
         rfLNKXAuxfyyNg3GKxPWLIADSo/5t9BoNFhZVnf7wKxyOwYelS8wwDNnZrCUGOBI/L
         YaPlmocok+2kNSIDZfw94S/Hdp0rRNeNwFonXGlCouqJMRcHuMnlrXDC5neyGolcxf
         H3j1tpi8brMadPdK9JS7Q1bbwNXNeeo/N1if8FQts+sRiqiFnwVZqxAlkkL09hArNX
         OOJhHuMOMVwTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.4 12/12] virtio_console: Assure used length from device is limited
Date:   Sat, 10 Jul 2021 19:53:02 -0400
Message-Id: <20210710235302.3222809-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235302.3222809-1-sashal@kernel.org>
References: <20210710235302.3222809-1-sashal@kernel.org>
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
index 226ccb7891d4..c2f1c921cb2c 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -487,7 +487,7 @@ static struct port_buffer *get_inbuf(struct port *port)
 
 	buf = virtqueue_get_buf(port->in_vq, &len);
 	if (buf) {
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 		port->stats.bytes_received += len;
 	}
@@ -1752,7 +1752,7 @@ static void control_work_handler(struct work_struct *work)
 	while ((buf = virtqueue_get_buf(vq, &len))) {
 		spin_unlock(&portdev->c_ivq_lock);
 
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 
 		handle_control_message(vq->vdev, portdev, buf);
-- 
2.30.2

