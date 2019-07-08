Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72D362460
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388575AbfGHPZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388571AbfGHPZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:25:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68471216C4;
        Mon,  8 Jul 2019 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599522;
        bh=K6PGeGX2uGzbM2XUPHDUbzymPuucyvKYsiYoANA47CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQDKm6SqvFhgP2reQ3G2J7Win5IagIyoVGI+/aT/JzprphtMXvH1zbXEjAg3m1agE
         qedGF2WCbEx79osHfL67trpO60MjpHXlFJC6rppv0ss60lEzorGn4ydq1426W0oJMy
         d89/qYTtxL24U4KUBv4iOioYs5sActQPXXOYw8k0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Balbir Singh <sblbir@amzn.com>
Subject: [PATCH 4.14 43/56] vhost_net: introduce vhost_exceeds_weight()
Date:   Mon,  8 Jul 2019 17:13:35 +0200
Message-Id: <20190708150523.719177265@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

commit 272f35cba53d088085e5952fd81d7a133ab90789 upstream.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Balbir Singh <sblbir@amzn.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/net.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -446,6 +446,12 @@ static bool vhost_exceeds_maxpend(struct
 		== nvq->done_idx;
 }
 
+static bool vhost_exceeds_weight(int pkts, int total_len)
+{
+	return total_len >= VHOST_NET_WEIGHT ||
+	       pkts >= VHOST_NET_PKT_WEIGHT;
+}
+
 /* Expects to be always run from workqueue - which acts as
  * read-size critical section for our kind of RCU. */
 static void handle_tx(struct vhost_net *net)
@@ -550,7 +556,6 @@ static void handle_tx(struct vhost_net *
 			msg.msg_control = NULL;
 			ubufs = NULL;
 		}
-
 		total_len += len;
 		if (total_len < VHOST_NET_WEIGHT &&
 		    !vhost_vq_avail_empty(&net->dev, vq) &&
@@ -579,8 +584,7 @@ static void handle_tx(struct vhost_net *
 		else
 			vhost_zerocopy_signal_used(net, vq);
 		vhost_net_tx_packet(net);
-		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT)) {
+		if (unlikely(vhost_exceeds_weight(++sent_pkts, total_len))) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}
@@ -863,8 +867,7 @@ static void handle_rx(struct vhost_net *
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++recv_pkts >= VHOST_NET_PKT_WEIGHT)) {
+		if (unlikely(vhost_exceeds_weight(++recv_pkts, total_len))) {
 			vhost_poll_queue(&vq->poll);
 			goto out;
 		}


