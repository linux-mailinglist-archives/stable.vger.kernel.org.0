Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815EF395F7A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhEaOLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233523AbhEaOJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:09:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87EE261978;
        Mon, 31 May 2021 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468424;
        bh=mNwr+HzfC4M0ik/EdHwOkFoR2hjHbnfTkCkUq9ygx8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKdHfmcxQmYETOokAOWmq1g78It8KhBoaQT540DzEUG9ZWVxCzzUvdJzgh8cY72An
         M0+w9T+BGPnVPeSSbhCc3f93nN4vaZ0xCpahkPvtUyR82DQets5zXhrdK9St8Q052z
         pf50MFlOE9ekTmVQlROrfl9HMKYD3ERti+PKuKVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/252] net: hsr: fix mac_len checks
Date:   Mon, 31 May 2021 15:15:03 +0200
Message-Id: <20210531130706.091204690@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>

[ Upstream commit 48b491a5cc74333c4a6a82fe21cea42c055a3b0b ]

Commit 2e9f60932a2c ("net: hsr: check skb can contain struct hsr_ethhdr
in fill_frame_info") added the following which resulted in -EINVAL
always being returned:
	if (skb->mac_len < sizeof(struct hsr_ethhdr))
		return -EINVAL;

mac_len was not being set correctly so this check completely broke
HSR/PRP since it was always 14, not 20.

Set mac_len correctly and modify the mac_len checks to test in the
correct places since sometimes it is legitimately 14.

Fixes: 2e9f60932a2c ("net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info")
Signed-off-by: George McCollister <george.mccollister@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c  |  2 ++
 net/hsr/hsr_forward.c | 30 +++++++++++++++++++++---------
 net/hsr/hsr_forward.h |  8 ++++----
 net/hsr/hsr_main.h    |  4 ++--
 net/hsr/hsr_slave.c   | 11 +++++------
 5 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 6f4c34b6a5d6..fec1b014c0a2 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -218,6 +218,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (master) {
 		skb->dev = master->dev;
 		skb_reset_mac_header(skb);
+		skb_reset_mac_len(skb);
 		hsr_forward_skb(skb, master);
 	} else {
 		atomic_long_inc(&dev->tx_dropped);
@@ -261,6 +262,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
 		goto out;
 
 	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
 
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 90c72e4c0a8f..baf4765be6d7 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -451,25 +451,31 @@ static void handle_std_frame(struct sk_buff *skb,
 	}
 }
 
-void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame)
+int hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			struct hsr_frame_info *frame)
 {
 	if (proto == htons(ETH_P_PRP) ||
 	    proto == htons(ETH_P_HSR)) {
+		/* Check if skb contains hsr_ethhdr */
+		if (skb->mac_len < sizeof(struct hsr_ethhdr))
+			return -EINVAL;
+
 		/* HSR tagged frame :- Data or Supervision */
 		frame->skb_std = NULL;
 		frame->skb_prp = NULL;
 		frame->skb_hsr = skb;
 		frame->sequence_nr = hsr_get_skb_sequence_nr(skb);
-		return;
+		return 0;
 	}
 
 	/* Standard frame or PRP from master port */
 	handle_std_frame(skb, frame);
+
+	return 0;
 }
 
-void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame)
+int prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			struct hsr_frame_info *frame)
 {
 	/* Supervision frame */
 	struct prp_rct *rct = skb_get_PRP_rct(skb);
@@ -480,9 +486,11 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
 		frame->skb_std = NULL;
 		frame->skb_prp = skb;
 		frame->sequence_nr = prp_get_skb_sequence_nr(rct);
-		return;
+		return 0;
 	}
 	handle_std_frame(skb, frame);
+
+	return 0;
 }
 
 static int fill_frame_info(struct hsr_frame_info *frame,
@@ -492,9 +500,10 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 	struct hsr_vlan_ethhdr *vlan_hdr;
 	struct ethhdr *ethhdr;
 	__be16 proto;
+	int ret;
 
-	/* Check if skb contains hsr_ethhdr */
-	if (skb->mac_len < sizeof(struct hsr_ethhdr))
+	/* Check if skb contains ethhdr */
+	if (skb->mac_len < sizeof(struct ethhdr))
 		return -EINVAL;
 
 	memset(frame, 0, sizeof(*frame));
@@ -521,7 +530,10 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 
 	frame->is_from_san = false;
 	frame->port_rcv = port;
-	hsr->proto_ops->fill_frame_info(proto, skb, frame);
+	ret = hsr->proto_ops->fill_frame_info(proto, skb, frame);
+	if (ret)
+		return ret;
+
 	check_local_dest(port->hsr, skb, frame);
 
 	return 0;
diff --git a/net/hsr/hsr_forward.h b/net/hsr/hsr_forward.h
index 618140d484ad..008f45786f06 100644
--- a/net/hsr/hsr_forward.h
+++ b/net/hsr/hsr_forward.h
@@ -23,8 +23,8 @@ struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 struct sk_buff *prp_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port);
 bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port);
-void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame);
-void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
-			 struct hsr_frame_info *frame);
+int prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			struct hsr_frame_info *frame);
+int hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
+			struct hsr_frame_info *frame);
 #endif /* __HSR_FORWARD_H */
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index f79ca55d6986..9a25a5d349ae 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -192,8 +192,8 @@ struct hsr_proto_ops {
 					       struct hsr_port *port);
 	struct sk_buff * (*create_tagged_frame)(struct hsr_frame_info *frame,
 						struct hsr_port *port);
-	void (*fill_frame_info)(__be16 proto, struct sk_buff *skb,
-				struct hsr_frame_info *frame);
+	int (*fill_frame_info)(__be16 proto, struct sk_buff *skb,
+			       struct hsr_frame_info *frame);
 	bool (*invalid_dan_ingress_frame)(__be16 protocol);
 	void (*update_san_info)(struct hsr_node *node, bool is_sup);
 };
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 36d5fcf09c61..aecc05a28fa1 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -58,12 +58,11 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 		goto finish_pass;
 
 	skb_push(skb, ETH_HLEN);
-
-	if (skb_mac_header(skb) != skb->data) {
-		WARN_ONCE(1, "%s:%d: Malformed frame at source port %s)\n",
-			  __func__, __LINE__, port->dev->name);
-		goto finish_consume;
-	}
+	skb_reset_mac_header(skb);
+	if ((!hsr->prot_version && protocol == htons(ETH_P_PRP)) ||
+	    protocol == htons(ETH_P_HSR))
+		skb_set_network_header(skb, ETH_HLEN + HSR_HLEN);
+	skb_reset_mac_len(skb);
 
 	hsr_forward_skb(skb, port);
 
-- 
2.30.2



