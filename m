Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8140D13A6C2
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbgANKNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733177AbgANKNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:13:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9584824676;
        Tue, 14 Jan 2020 10:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996802;
        bh=GURjCkQXhvN6A8ITcpvkb4aTOpidvb99jtlwFtYYkw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqvd+DFqLV3vXWuekfkmVrOfRZdyFguC4BwVtiYOu1dUW74Gdcclqw76L2lS/GwoE
         XSeaRwaJJ0gM7kO+RVO6ZHTAP6sXr+NJ4s/lTPut605ZtbjV0QfqbsD33UImRPlMxZ
         jCQirevrnYWTPNSIFyx8m+JZbEP/VCznkBJKUPN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 14/28] can: can_dropped_invalid_skb(): ensure an initialized headroom in outgoing CAN sk_buffs
Date:   Tue, 14 Jan 2020 11:02:16 +0100
Message-Id: <20200114094342.248083959@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
References: <20200114094336.845958665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit e7153bf70c3496bac00e7e4f395bb8d8394ac0ea upstream.

KMSAN sysbot detected a read access to an untinitialized value in the
headroom of an outgoing CAN related sk_buff. When using CAN sockets this
area is filled appropriately - but when using a packet socket this
initialization is missing.

The problematic read access occurs in the CAN receive path which can
only be triggered when the sk_buff is sent through a (virtual) CAN
interface. So we check in the sending path whether we need to perform
the missing initializations.

Fixes: d3b58c47d330d ("can: replace timestamp as unique skb attribute")
Reported-by: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: linux-stable <stable@vger.kernel.org> # >= v4.1
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/can/dev.h |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -17,6 +17,7 @@
 #include <linux/can/error.h>
 #include <linux/can/led.h>
 #include <linux/can/netlink.h>
+#include <linux/can/skb.h>
 #include <linux/netdevice.h>
 
 /*
@@ -81,6 +82,36 @@ struct can_priv {
 #define get_can_dlc(i)		(min_t(__u8, (i), CAN_MAX_DLC))
 #define get_canfd_dlc(i)	(min_t(__u8, (i), CANFD_MAX_DLC))
 
+/* Check for outgoing skbs that have not been created by the CAN subsystem */
+static inline bool can_skb_headroom_valid(struct net_device *dev,
+					  struct sk_buff *skb)
+{
+	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine */
+	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
+		return false;
+
+	/* af_packet does not apply CAN skb specific settings */
+	if (skb->ip_summed == CHECKSUM_NONE) {
+		/* init headroom */
+		can_skb_prv(skb)->ifindex = dev->ifindex;
+		can_skb_prv(skb)->skbcnt = 0;
+
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		/* preform proper loopback on capable devices */
+		if (dev->flags & IFF_ECHO)
+			skb->pkt_type = PACKET_LOOPBACK;
+		else
+			skb->pkt_type = PACKET_HOST;
+
+		skb_reset_mac_header(skb);
+		skb_reset_network_header(skb);
+		skb_reset_transport_header(skb);
+	}
+
+	return true;
+}
+
 /* Drop a given socketbuffer if it does not contain a valid CAN frame. */
 static inline bool can_dropped_invalid_skb(struct net_device *dev,
 					  struct sk_buff *skb)
@@ -98,6 +129,9 @@ static inline bool can_dropped_invalid_s
 	} else
 		goto inval_skb;
 
+	if (!can_skb_headroom_valid(dev, skb))
+		goto inval_skb;
+
 	return false;
 
 inval_skb:


