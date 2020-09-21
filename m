Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668B3272D82
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgIUQku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgIUQkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2BF02076B;
        Mon, 21 Sep 2020 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706448;
        bh=YbppTdWlxx/FTRZZv/C9QIPvs5yjmNUCKUWmNw5uvHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zWFCmXPy44xzOs/56Pf4NpXIlZqupuPXUj9lsSIYdf4Nsiwo6JuZiJpvwJCY3c5TX
         FyqvYctvyFheAqEspms9EP1rU0hcwAX2ftp50miDqgLTEIrOFVG55lIroVszIk1CAk
         JBYk+tC0LEszd/HENCMQ/eHcbpyCyftdJPwNaOXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH 4.19 01/49] dsa: Allow forwarding of redirected IGMP traffic
Date:   Mon, 21 Sep 2020 18:27:45 +0200
Message-Id: <20200921162034.720626706@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

commit 1ed9ec9b08addbd8d3e36d5f4a652d8590a6ddb7 upstream.

The driver for Marvell switches puts all ports in IGMP snooping mode
which results in all IGMP/MLD frames that ingress on the ports to be
forwarded to the CPU only.

The bridge code in the kernel can then interpret these frames and act
upon them, for instance by updating the mdb in the switch to reflect
multicast memberships of stations connected to the ports. However,
the IGMP/MLD frames must then also be forwarded to other ports of the
bridge so external IGMP queriers can track membership reports, and
external multicast clients can receive query reports from foreign IGMP
queriers.

Currently, this is impossible as the EDSA tagger sets offload_fwd_mark
on the skb when it unwraps the tagged frames, and that will make the
switchdev layer prevent the skb from egressing on any other port of
the same switch.

To fix that, look at the To_CPU code in the DSA header and make
forwarding of the frame possible for trapped IGMP packets.

Introduce some #defines for the frame types to make the code a bit more
comprehensive.

This was tested on a Marvell 88E6352 variant.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/dsa/tag_edsa.c |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -17,6 +17,16 @@
 #define DSA_HLEN	4
 #define EDSA_HLEN	8
 
+#define FRAME_TYPE_TO_CPU	0x00
+#define FRAME_TYPE_FORWARD	0x03
+
+#define TO_CPU_CODE_MGMT_TRAP		0x00
+#define TO_CPU_CODE_FRAME2REG		0x01
+#define TO_CPU_CODE_IGMP_MLD_TRAP	0x02
+#define TO_CPU_CODE_POLICY_TRAP		0x03
+#define TO_CPU_CODE_ARP_MIRROR		0x04
+#define TO_CPU_CODE_POLICY_MIRROR	0x05
+
 static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -81,6 +91,8 @@ static struct sk_buff *edsa_rcv(struct s
 				struct packet_type *pt)
 {
 	u8 *edsa_header;
+	int frame_type;
+	int code;
 	int source_device;
 	int source_port;
 
@@ -95,8 +107,29 @@ static struct sk_buff *edsa_rcv(struct s
 	/*
 	 * Check that frame type is either TO_CPU or FORWARD.
 	 */
-	if ((edsa_header[0] & 0xc0) != 0x00 && (edsa_header[0] & 0xc0) != 0xc0)
+	frame_type = edsa_header[0] >> 6;
+
+	switch (frame_type) {
+	case FRAME_TYPE_TO_CPU:
+		code = (edsa_header[1] & 0x6) | ((edsa_header[2] >> 4) & 1);
+
+		/*
+		 * Mark the frame to never egress on any port of the same switch
+		 * unless it's a trapped IGMP/MLD packet, in which case the
+		 * bridge might want to forward it.
+		 */
+		if (code != TO_CPU_CODE_IGMP_MLD_TRAP)
+			skb->offload_fwd_mark = 1;
+
+		break;
+
+	case FRAME_TYPE_FORWARD:
+		skb->offload_fwd_mark = 1;
+		break;
+
+	default:
 		return NULL;
+	}
 
 	/*
 	 * Determine source device and port.
@@ -160,8 +193,6 @@ static struct sk_buff *edsa_rcv(struct s
 			2 * ETH_ALEN);
 	}
 
-	skb->offload_fwd_mark = 1;
-
 	return skb;
 }
 


