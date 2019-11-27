Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C4810B80E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfK0UjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728897AbfK0UjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:39:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2465121569;
        Wed, 27 Nov 2019 20:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887159;
        bh=8lr5WI3hKp8J6pf8q7kwThSAqJKzrjvFPMvna7Gwtuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1AO7A2ukK77RQFiUdhAWgIrY2Uxx7rbIDVWfUHPSVHzIq3TgrC+aBFHD/9ofw6HO
         EAibsQuIsr/t42IdCAgmtdAbZDXWEeSj+v6JeYgVP9bflr+UB6vnZh1QGoGMFuzs5w
         LuBsW0+w5JFx33oR6R7yF9STOiED1vR9HxW+P2ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 120/132] virtio_console: drop custom control queue cleanup
Date:   Wed, 27 Nov 2019 21:31:51 +0100
Message-Id: <20191127203032.645412707@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 61a8950c5c5708cf2068b29ffde94e454e528208 ]

We now cleanup all VQs on device removal - no need
to handle the control VQ specially.

Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 1b002e1391f0a..bc4a804048205 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1987,21 +1987,6 @@ static void remove_vqs(struct ports_device *portdev)
 	kfree(portdev->out_vqs);
 }
 
-static void remove_controlq_data(struct ports_device *portdev)
-{
-	struct port_buffer *buf;
-	unsigned int len;
-
-	if (!use_multiport(portdev))
-		return;
-
-	while ((buf = virtqueue_get_buf(portdev->c_ivq, &len)))
-		free_buf(buf, true);
-
-	while ((buf = virtqueue_detach_unused_buf(portdev->c_ivq)))
-		free_buf(buf, true);
-}
-
 /*
  * Once we're further in boot, we get probed like any other virtio
  * device.
@@ -2162,7 +2147,6 @@ static void virtcons_remove(struct virtio_device *vdev)
 	 * have to just stop using the port, as the vqs are going
 	 * away.
 	 */
-	remove_controlq_data(portdev);
 	remove_vqs(portdev);
 	kfree(portdev);
 }
@@ -2207,7 +2191,6 @@ static int virtcons_freeze(struct virtio_device *vdev)
 	 */
 	if (use_multiport(portdev))
 		virtqueue_disable_cb(portdev->c_ivq);
-	remove_controlq_data(portdev);
 
 	list_for_each_entry(port, &portdev->ports, list) {
 		virtqueue_disable_cb(port->in_vq);
-- 
2.20.1



