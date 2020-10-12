Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EAB28B68A
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgJLNe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730260AbgJLNeb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 019D420678;
        Mon, 12 Oct 2020 13:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509670;
        bh=z3+prIcdo/jLC3VpEESws0UfaJtKsVE6ehu/FanrpjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFYZffnbPXv1kavoyxBOBTmDLS1P9Xgv7HSuOUwJ0U+mZM76BLNG0iP4Dh4cfazas
         ZK6ouPXrvcmy5aiFG5kzb06rdgj8Igduf0+soWA+K3eg82YxNjOXkdGPcl/cdkLrgf
         p1RQ82AzU95zbQr1rLCt8AjXr8V7MCj8GGP8u2EE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Cohen <orcohen@paloaltonetworks.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Nuernberger <snu@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Amit Shah <aams@amazon.com>
Subject: [PATCH 4.9 17/54] net/packet: fix overflow in tpacket_rcv
Date:   Mon, 12 Oct 2020 15:26:39 +0200
Message-Id: <20201012132630.392196471@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Or Cohen <orcohen@paloaltonetworks.com>

commit acf69c946233259ab4d64f8869d4037a198c7f06 upstream.

Using tp_reserve to calculate netoff can overflow as
tp_reserve is unsigned int and netoff is unsigned short.

This may lead to macoff receving a smaller value then
sizeof(struct virtio_net_hdr), and if po->has_vnet_hdr
is set, an out-of-bounds write will occur when
calling virtio_net_hdr_from_skb.

The bug is fixed by converting netoff to unsigned int
and checking if it exceeds USHRT_MAX.

This addresses CVE-2020-14386

Fixes: 8913336a7e8d ("packet: add PACKET_RESERVE sockopt")
Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ snu: backported to pre-5.3, changed tp_drops counting/locking ]
Signed-off-by: Stefan Nuernberger <snu@amazon.com>
CC: David Woodhouse <dwmw@amazon.co.uk>
CC: Amit Shah <aams@amazon.com>
CC: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2161,7 +2161,8 @@ static int tpacket_rcv(struct sk_buff *s
 	int skb_len = skb->len;
 	unsigned int snaplen, res;
 	unsigned long status = TP_STATUS_USER;
-	unsigned short macoff, netoff, hdrlen;
+	unsigned short macoff, hdrlen;
+	unsigned int netoff;
 	struct sk_buff *copy_skb = NULL;
 	struct timespec ts;
 	__u32 ts_status;
@@ -2223,6 +2224,12 @@ static int tpacket_rcv(struct sk_buff *s
 		}
 		macoff = netoff - maclen;
 	}
+	if (netoff > USHRT_MAX) {
+		spin_lock(&sk->sk_receive_queue.lock);
+		po->stats.stats1.tp_drops++;
+		spin_unlock(&sk->sk_receive_queue.lock);
+		goto drop_n_restore;
+	}
 	if (po->tp_version <= TPACKET_V2) {
 		if (macoff + snaplen > po->rx_ring.frame_size) {
 			if (po->copy_thresh &&


