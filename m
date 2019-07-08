Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A756621EE
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbfGHPUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387626AbfGHPUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:20:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90A7A2175B;
        Mon,  8 Jul 2019 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599244;
        bh=xsjJ86Q+T5GaIDll6gOOCctVm7yc0BwsqYC21t7R8X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUv+pfSi/FTQrG24Vrnz3bZy/CLGY43y9Ieiw0CC59UZl9mLds4FxSJujkf0zFj8t
         ec06qjSQGr0cMZtTFurppnlvmvK2QlR5zFDZIo6Es3259OYIGYLzHr9UzME81SKQLz
         YL+bbbzI6s22Yd+0wNr8oDFbaeHdAtK//DsERLfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 052/102] af_packet: Block execution of tasks waiting for transmit to complete in AF_PACKET
Date:   Mon,  8 Jul 2019 17:12:45 +0200
Message-Id: <20190708150529.134836691@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 89ed5b519004a7706f50b70f611edbd3aaacff2c ]

When an application is run that:
a) Sets its scheduler to be SCHED_FIFO
and
b) Opens a memory mapped AF_PACKET socket, and sends frames with the
MSG_DONTWAIT flag cleared, its possible for the application to hang
forever in the kernel.  This occurs because when waiting, the code in
tpacket_snd calls schedule, which under normal circumstances allows
other tasks to run, including ksoftirqd, which in some cases is
responsible for freeing the transmitted skb (which in AF_PACKET calls a
destructor that flips the status bit of the transmitted frame back to
available, allowing the transmitting task to complete).

However, when the calling application is SCHED_FIFO, its priority is
such that the schedule call immediately places the task back on the cpu,
preventing ksoftirqd from freeing the skb, which in turn prevents the
transmitting task from detecting that the transmission is complete.

We can fix this by converting the schedule call to a completion
mechanism.  By using a completion queue, we force the calling task, when
it detects there are no more frames to send, to schedule itself off the
cpu until such time as the last transmitted skb is freed, allowing
forward progress to be made.

Tested by myself and the reporter, with good results

Change Notes:

V1->V2:
	Enhance the sleep logic to support being interruptible and
allowing for honoring to SK_SNDTIMEO (Willem de Bruijn)

V2->V3:
	Rearrage the point at which we wait for the completion queue, to
avoid needing to check for ph/skb being null at the end of the loop.
Also move the complete call to the skb destructor to avoid needing to
modify __packet_set_status.  Also gate calling complete on
packet_read_pending returning zero to avoid multiple calls to complete.
(Willem de Bruijn)

	Move timeo computation within loop, to re-fetch the socket
timeout since we also use the timeo variable to record the return code
from the wait_for_complete call (Neil Horman)

V3->V4:
	Willem has requested that the control flow be restored to the
previous state.  Doing so lets us eliminate the need for the
po->wait_on_complete flag variable, and lets us get rid of the
packet_next_frame function, but introduces another complexity.
Specifically, but using the packet pending count, we can, if an
applications calls sendmsg multiple times with MSG_DONTWAIT set, each
set of transmitted frames, when complete, will cause
tpacket_destruct_skb to issue a complete call, for which there will
never be a wait_on_completion call.  This imbalance will lead to any
future call to wait_for_completion here to return early, when the frames
they sent may not have completed.  To correct this, we need to re-init
the completion queue on every call to tpacket_snd before we enter the
loop so as to ensure we wait properly for the frames we send in this
iteration.

	Change the timeout and interrupted gotos to out_put rather than
out_status so that we don't try to free a non-existant skb
	Clean up some extra newlines (Willem de Bruijn)

Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   20 +++++++++++++++++---
 net/packet/internal.h  |    1 +
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2399,6 +2399,9 @@ static void tpacket_destruct_skb(struct
 
 		ts = __packet_set_timestamp(po, ph, skb);
 		__packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
+
+		if (!packet_read_pending(&po->tx_ring))
+			complete(&po->skb_completion);
 	}
 
 	sock_wfree(skb);
@@ -2629,7 +2632,7 @@ static int tpacket_parse_header(struct p
 
 static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 {
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct net_device *dev;
 	struct virtio_net_hdr *vnet_hdr = NULL;
 	struct sockcm_cookie sockc;
@@ -2644,6 +2647,7 @@ static int tpacket_snd(struct packet_soc
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
+	long timeo = 0;
 
 	mutex_lock(&po->pg_vec_lock);
 
@@ -2690,12 +2694,21 @@ static int tpacket_snd(struct packet_soc
 	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
+	reinit_completion(&po->skb_completion);
+
 	do {
 		ph = packet_current_frame(po, &po->tx_ring,
 					  TP_STATUS_SEND_REQUEST);
 		if (unlikely(ph == NULL)) {
-			if (need_wait && need_resched())
-				schedule();
+			if (need_wait && skb) {
+				timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
+				timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
+				if (timeo <= 0) {
+					err = !timeo ? -ETIMEDOUT : -ERESTARTSYS;
+					goto out_put;
+				}
+			}
+			/* check for additional frames */
 			continue;
 		}
 
@@ -3249,6 +3262,7 @@ static int packet_create(struct net *net
 	sock_init_data(sock, sk);
 
 	po = pkt_sk(sk);
+	init_completion(&po->skb_completion);
 	sk->sk_family = PF_PACKET;
 	po->num = proto;
 	po->xmit = dev_queue_xmit;
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -125,6 +125,7 @@ struct packet_sock {
 	unsigned int		tp_hdrlen;
 	unsigned int		tp_reserve;
 	unsigned int		tp_tstamp;
+	struct completion	skb_completion;
 	struct net_device __rcu	*cached_dev;
 	int			(*xmit)(struct sk_buff *skb);
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;


