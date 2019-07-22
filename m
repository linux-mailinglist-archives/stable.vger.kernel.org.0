Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1EF7007A
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 15:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfGVNDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 09:03:19 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41900 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfGVNDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 09:03:19 -0400
Received: by mail-ed1-f67.google.com with SMTP id p15so40516401eds.8
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 06:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9416KP4bRPA2SRRygbtsvE+dD6DraObbEzL0FuWURb8=;
        b=KnPkyCuJ1bXnvk+UQD8w0JQKgcaqDOdW7UUjsPIYbo6RQ+0q6rcwZurFANz/TBbqYU
         nYArN34rwTak0dOE27rDcRJTCYAWci05GBlWP8L2iYcX7iqDHT5yEBycpsDcFgVY6SW1
         UlWm63HwNTPkuTuV1Dk3Z0jJj5JSu82FNz2uZsW94DOBDdHk2ZCxpqoR9d4iHyPd3kcu
         7MGfRIY2p+8ORho/6YcWosGpVhJz0l/di3/8OMR05tnIMzbzw7DZaYtaXtrbblaQ5BZb
         GJcNaWEV8QGgVsKN/OaZCi1QkknG2/8brjUNXbbn3+6D7i+KdCVoDlsXZHiduOTDzLIZ
         7FNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9416KP4bRPA2SRRygbtsvE+dD6DraObbEzL0FuWURb8=;
        b=lrtr3zmAFSnMeADSfcUeGjAwDiETDX7uPcXI7NdzNQChQwxsd6Kltd43niBLHZu9u4
         ugai6iAftbftBzJi/V+lZ6xN2GAlWm1Xo99ZCKCuJVSF+iKK9x8cYrB3XeQqcr56JuAk
         ih5wQDDNSjicu15iJAu4wIDMFrJ5l7cfcD3QEb+4Zv3XvTWwvXWF5ZCv0Qfwk5zlkQtw
         wKv8xsCYCqtHchGq7n++91jIpV14bBpVDpIQd4pjjxPrsPe9+vUhtdX55TXmIWE4IyPU
         raVfnesLNz5a2mOdNNQJ/AHtOOZTURu2RYARfzDCYtfSLLKdpa1r38waPHbn1j8acsYu
         qBaA==
X-Gm-Message-State: APjAAAXx3bZnJ4OUH7Cw1vWo47z+9Xz3JeShY6RVEUUjzh8XqJoRmfkE
        OUZRcWc6ZwFvVqozZrOgy88=
X-Google-Smtp-Source: APXvYqyV/u0liAILkQSs2E3DwxopRuh5MYIUway21fLBvieFonDBLXZRzgRIE9ZDBvO6S3f2JXGSpQ==
X-Received: by 2002:a50:8bfa:: with SMTP id n55mr61670731edn.9.1563800597576;
        Mon, 22 Jul 2019 06:03:17 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([62.217.45.26])
        by smtp.gmail.com with ESMTPSA id v12sm7996085ejj.52.2019.07.22.06.03.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 06:03:17 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.19 3/4] vhost: vsock: add weight support
Date:   Mon, 22 Jul 2019 15:03:12 +0200
Message-Id: <20190722130313.18562-4-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722130313.18562-1-jinpuwang@gmail.com>
References: <20190722130313.18562-1-jinpuwang@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

commit e79b431fb901ba1106670bcc80b9b617b25def7d upstream.

This patch will check the weight and exit the loop if we exceeds the
weight. This is useful for preventing vsock kthread from hogging cpu
which is guest triggerable. The weight can help to avoid starving the
request from on direction while another direction is being processed.

The value of weight is picked from vhost-net.

This addresses CVE-2019-3900.

Cc: Stefan Hajnoczi <stefanha@redhat.com>
Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
[jwang: backport to 4.19]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/vhost/vsock.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 58c5c82bc0be..bab495d73195 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -86,6 +86,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			    struct vhost_virtqueue *vq)
 {
 	struct vhost_virtqueue *tx_vq = &vsock->vqs[VSOCK_VQ_TX];
+	int pkts = 0, total_len = 0;
 	bool added = false;
 	bool restart_tx = false;
 
@@ -97,7 +98,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 	/* Avoid further vmexits, we're already processing the virtqueue */
 	vhost_disable_notify(&vsock->dev, vq);
 
-	for (;;) {
+	do {
 		struct virtio_vsock_pkt *pkt;
 		struct iov_iter iov_iter;
 		unsigned out, in;
@@ -182,8 +183,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
 
+		total_len += pkt->len;
 		virtio_transport_free_pkt(pkt);
-	}
+	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 	if (added)
 		vhost_signal(&vsock->dev, vq);
 
@@ -358,7 +360,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
 						 dev);
 	struct virtio_vsock_pkt *pkt;
-	int head;
+	int head, pkts = 0, total_len = 0;
 	unsigned int out, in;
 	bool added = false;
 
@@ -368,7 +370,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		goto out;
 
 	vhost_disable_notify(&vsock->dev, vq);
-	for (;;) {
+	do {
 		u32 len;
 
 		if (!vhost_vsock_more_replies(vsock)) {
@@ -409,9 +411,11 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		else
 			virtio_transport_free_pkt(pkt);
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + len);
+		len += sizeof(pkt->hdr);
+		vhost_add_used(vq, head, len);
+		total_len += len;
 		added = true;
-	}
+	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 
 no_more_replies:
 	if (added)
-- 
2.17.1

