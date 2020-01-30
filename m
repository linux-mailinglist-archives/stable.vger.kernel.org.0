Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADF114E157
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgA3Sng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbgA3Snb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FC7A2083E;
        Thu, 30 Jan 2020 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409809;
        bh=N5y1muu8N21M0FsvptEApXfStVYRWbQEbqqaQyDIb50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgzycVbpg3OEnAxp2CfCiaVvizI6/hNldp+MtPLYnKYUf1Zqe7nTE32t8nhcdXTdX
         FJZLfJOkNU1MRKPBmLClbaP2Sq2hDaMOCap0ujnEzTny5Xun9diTGvJBiPoZPeHw4x
         3S11ODs/nayaOsfiGx6wbm2g/GuKvPLry2TKcDtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 040/110] udp: segment looped gso packets correctly
Date:   Thu, 30 Jan 2020 19:38:16 +0100
Message-Id: <20200130183620.104536345@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 6cd021a58c18a1731f7e47f83e172c0c302d65e5 ]

Multicast and broadcast packets can be looped from egress to ingress
pre segmentation with dev_loopback_xmit. That function unconditionally
sets ip_summed to CHECKSUM_UNNECESSARY.

udp_rcv_segment segments gso packets in the udp rx path. Segmentation
usually executes on egress, and does not expect packets of this type.
__udp_gso_segment interprets !CHECKSUM_PARTIAL as CHECKSUM_NONE. But
the offsets are not correct for gso_make_checksum.

UDP GSO packets are of type CHECKSUM_PARTIAL, with their uh->check set
to the correct pseudo header checksum. Reset ip_summed to this type.
(CHECKSUM_PARTIAL is allowed on ingress, see comments in skbuff.h)

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/udp.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -476,6 +476,9 @@ static inline struct sk_buff *udp_rcv_se
 	if (!inet_get_convert_csum(sk))
 		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 
+	if (skb->pkt_type == PACKET_LOOPBACK)
+		skb->ip_summed = CHECKSUM_PARTIAL;
+
 	/* the GSO CB lays after the UDP one, no need to save and restore any
 	 * CB fragment
 	 */


