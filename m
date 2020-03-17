Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC43D187ED5
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCQK4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCQK4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:56:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765FC20714;
        Tue, 17 Mar 2020 10:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442589;
        bh=rJ+z3ahfuuDl0OQAcFKHw+9DSfilGsO4gskP2uEUtt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njQF2VDtZAz4c3ni/RmDdffeJLP6BYW2AOXXw8s72/mbmc8q7VfRC+gezNONJCAhJ
         FwwhaHenSYIQkA+5kdZHPKaldquSeIeDQpMRM33SiQnWzYePGmMNMVjauaMsbaB7X8
         bblmy6UdK2bfvgzr/n/3ijz8fEgr92o7Ldm/iZH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 15/89] net/packet: tpacket_rcv: do not increment ring index on drop
Date:   Tue, 17 Mar 2020 11:54:24 +0100
Message-Id: <20200317103301.716183895@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 46e4c421a053c36bf7a33dda2272481bcaf3eed3 ]

In one error case, tpacket_rcv drops packets after incrementing the
ring producer index.

If this happens, it does not update tp_status to TP_STATUS_USER and
thus the reader is stalled for an iteration of the ring, causing out
of order arrival.

The only such error path is when virtio_net_hdr_from_skb fails due
to encountering an unknown GSO type.

Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2260,6 +2260,13 @@ static int tpacket_rcv(struct sk_buff *s
 					TP_STATUS_KERNEL, (macoff+snaplen));
 	if (!h.raw)
 		goto drop_n_account;
+
+	if (do_vnet &&
+	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
+				    sizeof(struct virtio_net_hdr),
+				    vio_le(), true, 0))
+		goto drop_n_account;
+
 	if (po->tp_version <= TPACKET_V2) {
 		packet_increment_rx_head(po, &po->rx_ring);
 	/*
@@ -2272,12 +2279,6 @@ static int tpacket_rcv(struct sk_buff *s
 			status |= TP_STATUS_LOSING;
 	}
 
-	if (do_vnet &&
-	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
-				    sizeof(struct virtio_net_hdr),
-				    vio_le(), true, 0))
-		goto drop_n_account;
-
 	po->stats.stats1.tp_packets++;
 	if (copy_skb) {
 		status |= TP_STATUS_COPY;


