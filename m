Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043C45D995
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfGCAr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:47:59 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:43173 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfGCAr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:47:59 -0400
X-IronPort-AV: E=Sophos;i="5.62,444,1554768000"; 
   d="scan'208";a="809025506"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Jul 2019 21:02:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS id 80ABCA1C92;
        Tue,  2 Jul 2019 21:02:33 +0000 (UTC)
Received: from EX13D25UWC004.ant.amazon.com (10.43.162.201) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D25UWC004.ant.amazon.com (10.43.162.201) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from localhost (172.23.204.141) by mail-relay.amazon.com
 (10.43.162.232) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 21:02:32 +0000
From:   Balbir Singh <sblbir@amzn.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Balbir Singh <sblbir@amzn.com>
Subject: [backport to v4.14 CVE-2019-3900 6/7] vhost: vsock: add weight support
Date:   Tue, 2 Jul 2019 21:02:09 +0000
Message-ID: <20190702210210.2375-7-sblbir@amzn.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20190702210210.2375-1-sblbir@amzn.com>
References: <20190702210210.2375-1-sblbir@amzn.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

This patch will check the weight and exit the loop if we exceeds the
weight. This is useful for preventing vsock kthread from hogging cpu
which is guest triggerable. The weight can help to avoid starving the
request from on direction while another direction is being processed.

The value of weight is picked from vhost-net.

This addresses CVE-2019-3900.

[upstream e79b431fb901ba1106670bcc80b9b617b25def7d]
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Balbir Singh <sblbir@amzn.com>
---
 drivers/vhost/vsock.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index d67663983656..5b9db5deffbb 100644
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
2.16.5

