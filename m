Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730095D996
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfGCAr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:47:59 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:20844 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfGCAr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 20:47:59 -0400
X-IronPort-AV: E=Sophos;i="5.62,444,1554768000"; 
   d="scan'208";a="809025505"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Jul 2019 21:02:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 110F8A20BD;
        Tue,  2 Jul 2019 21:02:33 +0000 (UTC)
Received: from EX13D17UWC001.ant.amazon.com (10.43.162.188) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D17UWC001.ant.amazon.com (10.43.162.188) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 2 Jul 2019 21:02:32 +0000
Received: from localhost (172.23.204.141) by mail-relay.amazon.com
 (10.43.162.232) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 2 Jul 2019 21:02:32 +0000
From:   Balbir Singh <sblbir@amzn.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Balbir Singh <sblbir@amzn.com>
Subject: [backport to v4.14 CVE-2019-3900 3/7] vhost_net: introduce vhost_exceeds_weight()
Date:   Tue, 2 Jul 2019 21:02:06 +0000
Message-ID: <20190702210210.2375-4-sblbir@amzn.com>
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

[upstream - 272f35cba53d088085e5952fd81d7a133ab90789
Balbir - Backport to stable 4.14]

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Balbir Singh <sblbir@amzn.com>
---
 drivers/vhost/net.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 9fcf7bf25249..81b9c908ca56 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -446,6 +446,12 @@ static bool vhost_exceeds_maxpend(struct vhost_net *net)
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
@@ -550,7 +556,6 @@ static void handle_tx(struct vhost_net *net)
 			msg.msg_control = NULL;
 			ubufs = NULL;
 		}
-
 		total_len += len;
 		if (total_len < VHOST_NET_WEIGHT &&
 		    !vhost_vq_avail_empty(&net->dev, vq) &&
@@ -579,8 +584,7 @@ static void handle_tx(struct vhost_net *net)
 		else
 			vhost_zerocopy_signal_used(net, vq);
 		vhost_net_tx_packet(net);
-		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT)) {
+		if (unlikely(vhost_exceeds_weight(++sent_pkts, total_len))) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}
@@ -863,8 +867,7 @@ static void handle_rx(struct vhost_net *net)
 			vhost_log_write(vq, vq_log, log, vhost_len,
 					vq->iov, in);
 		total_len += vhost_len;
-		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
-		    unlikely(++recv_pkts >= VHOST_NET_PKT_WEIGHT)) {
+		if (unlikely(vhost_exceeds_weight(++recv_pkts, total_len))) {
 			vhost_poll_queue(&vq->poll);
 			goto out;
 		}
-- 
2.16.5

