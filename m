Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DCF3C3984
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhGKAAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 20:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231642AbhGJX61 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0431461436;
        Sat, 10 Jul 2021 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961181;
        bh=SpbH99waIHWnRMoF0oYxp765ixe9wOOqLld2vMvrrgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZDce41uq7OExYfiHu5ahh9rlTGPTl+9YxA82oKH2QPgkMUT+tPHgucXyTpVOYOy5
         AgXEpJv65CTPqN4GvQPPRl2GyezcxH6Z5egLRruDO+0Ti4gp5voGM3EkfgQI+kz6/e
         GraJ8y/34gicIsss9eOin1PK7iH5qiXJf7aAPlKwiR+SiB3DaQBEiDv4rin7btoyd4
         VsJFo1TQZawWcmnQaEHvTZu0tsfMyYvrua3+3xgAE9d/T70oKER//xCIZc84ARu4b1
         FosNENcOyqQxFdGInaorI2a0ybnV8rmbNCtvxwqdcLY7FQXXZ+bxQFkZsRPyjFtHi4
         EJBcXCRY6p71A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 16/16] virtio_console: Assure used length from device is limited
Date:   Sat, 10 Jul 2021 19:52:40 -0400
Message-Id: <20210710235240.3222618-16-sashal@kernel.org>
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
index 4ec08c7a7b65..2632b0fdb1b5 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -492,7 +492,7 @@ static struct port_buffer *get_inbuf(struct port *port)
 
 	buf = virtqueue_get_buf(port->in_vq, &len);
 	if (buf) {
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 		port->stats.bytes_received += len;
 	}
@@ -1758,7 +1758,7 @@ static void control_work_handler(struct work_struct *work)
 	while ((buf = virtqueue_get_buf(vq, &len))) {
 		spin_unlock(&portdev->c_ivq_lock);
 
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 
 		handle_control_message(vq->vdev, portdev, buf);
-- 
2.30.2

