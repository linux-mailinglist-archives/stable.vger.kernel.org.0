Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85793273057
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgIUQfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbgIUQfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:35:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA66423976;
        Mon, 21 Sep 2020 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706116;
        bh=udeTZEc6IGa5uDxuIfNPpIaDGgQ3vpPpJ1xO3oALjs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McSwEHJQyMZpDAGRd/velyN3XGQiRSc7fw//R9VrEoAU6utYPRqD6Nim2Tm03OXv/
         NdwZRFrPl60Hp5D6j3iOAFY2OB9/h6Pg7xB8nLkaCg671G5Km219EOeX3W2gitg5Sr
         lDWSQd/zreYahFCbw334VKnJ0Hov0m3KV9mUUC1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Andrew Boyer <andrew.boyer@dell.com>,
        Moni Shoua <monis@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 45/70] IB/rxe: Remove a pointless indirection layer
Date:   Mon, 21 Sep 2020 18:27:45 +0200
Message-Id: <20200921162037.185122908@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

[ Upstream commit 839f5ac0d806970a102117be03ef05272c50d20e ]

Neither rxe->ifc_ops nor any of the function pointers in struct
struct rxe_ifc_ops ever change. Hence remove the rxe->ifc_ops
indirection mechanism.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Andrew Boyer <andrew.boyer@dell.com>
Cc: Moni Shoua <monis@mellanox.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c       |  2 +-
 drivers/infiniband/sw/rxe/rxe_loc.h   | 20 +++++++++++--
 drivers/infiniband/sw/rxe/rxe_mcast.c |  4 +--
 drivers/infiniband/sw/rxe/rxe_net.c   | 43 ++++++++-------------------
 drivers/infiniband/sw/rxe/rxe_req.c   |  4 +--
 drivers/infiniband/sw/rxe/rxe_resp.c  |  4 +--
 drivers/infiniband/sw/rxe/rxe_verbs.c | 10 +++----
 drivers/infiniband/sw/rxe/rxe_verbs.h | 22 --------------
 8 files changed, 42 insertions(+), 67 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index c11d33a30183c..9f62345855321 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -175,7 +175,7 @@ static int rxe_init_ports(struct rxe_dev *rxe)
 		return -ENOMEM;
 
 	port->pkey_tbl[0] = 0xffff;
-	port->port_guid = rxe->ifc_ops->port_guid(rxe);
+	port->port_guid = rxe_port_guid(rxe);
 
 	spin_lock_init(&port->port_lock);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 73849a5a91b3a..cd7663062d015 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -141,6 +141,22 @@ void rxe_mem_cleanup(void *arg);
 
 int advance_dma_data(struct rxe_dma_info *dma, unsigned int length);
 
+/* rxe_net.c */
+int rxe_loopback(struct sk_buff *skb);
+int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
+	     struct sk_buff *skb);
+__be64 rxe_port_guid(struct rxe_dev *rxe);
+struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
+				int paylen, struct rxe_pkt_info *pkt);
+int rxe_prepare(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
+		struct sk_buff *skb, u32 *crc);
+enum rdma_link_layer rxe_link_layer(struct rxe_dev *rxe, unsigned int port_num);
+const char *rxe_parent_name(struct rxe_dev *rxe, unsigned int port_num);
+struct device *rxe_dma_device(struct rxe_dev *rxe);
+__be64 rxe_node_guid(struct rxe_dev *rxe);
+int rxe_mcast_add(struct rxe_dev *rxe, union ib_gid *mgid);
+int rxe_mcast_delete(struct rxe_dev *rxe, union ib_gid *mgid);
+
 /* rxe_qp.c */
 int rxe_qp_chk_init(struct rxe_dev *rxe, struct ib_qp_init_attr *init);
 
@@ -256,9 +272,9 @@ static inline int rxe_xmit_packet(struct rxe_dev *rxe, struct rxe_qp *qp,
 
 	if (pkt->mask & RXE_LOOPBACK_MASK) {
 		memcpy(SKB_TO_PKT(skb), pkt, sizeof(*pkt));
-		err = rxe->ifc_ops->loopback(skb);
+		err = rxe_loopback(skb);
 	} else {
-		err = rxe->ifc_ops->send(rxe, pkt, skb);
+		err = rxe_send(rxe, pkt, skb);
 	}
 
 	if (err) {
diff --git a/drivers/infiniband/sw/rxe/rxe_mcast.c b/drivers/infiniband/sw/rxe/rxe_mcast.c
index fa95544ca7e01..890eb6d5c471e 100644
--- a/drivers/infiniband/sw/rxe/rxe_mcast.c
+++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
@@ -61,7 +61,7 @@ int rxe_mcast_get_grp(struct rxe_dev *rxe, union ib_gid *mgid,
 
 	rxe_add_key(grp, mgid);
 
-	err = rxe->ifc_ops->mcast_add(rxe, mgid);
+	err = rxe_mcast_add(rxe, mgid);
 	if (err)
 		goto err2;
 
@@ -186,5 +186,5 @@ void rxe_mc_cleanup(void *arg)
 	struct rxe_dev *rxe = grp->rxe;
 
 	rxe_drop_key(grp);
-	rxe->ifc_ops->mcast_delete(rxe, &grp->mgid);
+	rxe_mcast_delete(rxe, &grp->mgid);
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index d19e003e8381e..e392612345282 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -102,17 +102,17 @@ static __be64 rxe_mac_to_eui64(struct net_device *ndev)
 	return eui64;
 }
 
-static __be64 node_guid(struct rxe_dev *rxe)
+__be64 rxe_node_guid(struct rxe_dev *rxe)
 {
 	return rxe_mac_to_eui64(rxe->ndev);
 }
 
-static __be64 port_guid(struct rxe_dev *rxe)
+__be64 rxe_port_guid(struct rxe_dev *rxe)
 {
 	return rxe_mac_to_eui64(rxe->ndev);
 }
 
-static struct device *dma_device(struct rxe_dev *rxe)
+struct device *rxe_dma_device(struct rxe_dev *rxe)
 {
 	struct net_device *ndev;
 
@@ -124,7 +124,7 @@ static struct device *dma_device(struct rxe_dev *rxe)
 	return ndev->dev.parent;
 }
 
-static int mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
+int rxe_mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
 {
 	int err;
 	unsigned char ll_addr[ETH_ALEN];
@@ -135,7 +135,7 @@ static int mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
 	return err;
 }
 
-static int mcast_delete(struct rxe_dev *rxe, union ib_gid *mgid)
+int rxe_mcast_delete(struct rxe_dev *rxe, union ib_gid *mgid)
 {
 	int err;
 	unsigned char ll_addr[ETH_ALEN];
@@ -399,8 +399,8 @@ static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 	return 0;
 }
 
-static int prepare(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
-		   struct sk_buff *skb, u32 *crc)
+int rxe_prepare(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
+		struct sk_buff *skb, u32 *crc)
 {
 	int err = 0;
 	struct rxe_av *av = rxe_get_av(pkt);
@@ -426,8 +426,7 @@ static void rxe_skb_tx_dtor(struct sk_buff *skb)
 		rxe_run_task(&qp->req.task, 1);
 }
 
-static int send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
-		struct sk_buff *skb)
+int rxe_send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt, struct sk_buff *skb)
 {
 	struct sk_buff *nskb;
 	struct rxe_av *av;
@@ -462,7 +461,7 @@ static int send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 	return 0;
 }
 
-static int loopback(struct sk_buff *skb)
+int rxe_loopback(struct sk_buff *skb)
 {
 	return rxe_rcv(skb);
 }
@@ -472,8 +471,8 @@ static inline int addr_same(struct rxe_dev *rxe, struct rxe_av *av)
 	return rxe->port.port_guid == av->grh.dgid.global.interface_id;
 }
 
-static struct sk_buff *init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				   int paylen, struct rxe_pkt_info *pkt)
+struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
+				int paylen, struct rxe_pkt_info *pkt)
 {
 	unsigned int hdr_len;
 	struct sk_buff *skb;
@@ -512,31 +511,16 @@ static struct sk_buff *init_packet(struct rxe_dev *rxe, struct rxe_av *av,
  * this is required by rxe_cfg to match rxe devices in
  * /sys/class/infiniband up with their underlying ethernet devices
  */
-static char *parent_name(struct rxe_dev *rxe, unsigned int port_num)
+const char *rxe_parent_name(struct rxe_dev *rxe, unsigned int port_num)
 {
 	return rxe->ndev->name;
 }
 
-static enum rdma_link_layer link_layer(struct rxe_dev *rxe,
-				       unsigned int port_num)
+enum rdma_link_layer rxe_link_layer(struct rxe_dev *rxe, unsigned int port_num)
 {
 	return IB_LINK_LAYER_ETHERNET;
 }
 
-static struct rxe_ifc_ops ifc_ops = {
-	.node_guid	= node_guid,
-	.port_guid	= port_guid,
-	.dma_device	= dma_device,
-	.mcast_add	= mcast_add,
-	.mcast_delete	= mcast_delete,
-	.prepare	= prepare,
-	.send		= send,
-	.loopback	= loopback,
-	.init_packet	= init_packet,
-	.parent_name	= parent_name,
-	.link_layer	= link_layer,
-};
-
 struct rxe_dev *rxe_net_add(struct net_device *ndev)
 {
 	int err;
@@ -546,7 +530,6 @@ struct rxe_dev *rxe_net_add(struct net_device *ndev)
 	if (!rxe)
 		return NULL;
 
-	rxe->ifc_ops = &ifc_ops;
 	rxe->ndev = ndev;
 
 	err = rxe_add(rxe, ndev->mtu);
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 6fb771290c566..5a2d7b0050f4c 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -412,7 +412,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 
 	/* init skb */
 	av = rxe_get_av(pkt);
-	skb = rxe->ifc_ops->init_packet(rxe, av, paylen, pkt);
+	skb = rxe_init_packet(rxe, av, paylen, pkt);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -483,7 +483,7 @@ static int fill_packet(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 	u32 *p;
 	int err;
 
-	err = rxe->ifc_ops->prepare(rxe, pkt, skb, &crc);
+	err = rxe_prepare(rxe, pkt, skb, &crc);
 	if (err)
 		return err;
 
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 5bfea23f3b60c..5733d9d2fcdcc 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -600,7 +600,7 @@ static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 	pad = (-payload) & 0x3;
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
 
-	skb = rxe->ifc_ops->init_packet(rxe, &qp->pri_av, paylen, ack);
+	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
 	if (!skb)
 		return NULL;
 
@@ -629,7 +629,7 @@ static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 	if (ack->mask & RXE_ATMACK_MASK)
 		atmack_set_orig(ack, qp->resp.atomic_orig);
 
-	err = rxe->ifc_ops->prepare(rxe, ack, skb, &crc);
+	err = rxe_prepare(rxe, ack, skb, &crc);
 	if (err) {
 		kfree_skb(skb);
 		return NULL;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index ef13082d6ca1a..26d66431f95b7 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -234,7 +234,7 @@ static enum rdma_link_layer rxe_get_link_layer(struct ib_device *dev,
 {
 	struct rxe_dev *rxe = to_rdev(dev);
 
-	return rxe->ifc_ops->link_layer(rxe, port_num);
+	return rxe_link_layer(rxe, port_num);
 }
 
 static struct ib_ucontext *rxe_alloc_ucontext(struct ib_device *dev,
@@ -1194,10 +1194,8 @@ static ssize_t rxe_show_parent(struct device *device,
 {
 	struct rxe_dev *rxe = container_of(device, struct rxe_dev,
 					   ib_dev.dev);
-	char *name;
 
-	name = rxe->ifc_ops->parent_name(rxe, 1);
-	return snprintf(buf, 16, "%s\n", name);
+	return snprintf(buf, 16, "%s\n", rxe_parent_name(rxe, 1));
 }
 
 static DEVICE_ATTR(parent, S_IRUGO, rxe_show_parent, NULL);
@@ -1219,9 +1217,9 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->node_type = RDMA_NODE_IB_CA;
 	dev->phys_port_cnt = 1;
 	dev->num_comp_vectors = RXE_NUM_COMP_VECTORS;
-	dev->dma_device = rxe->ifc_ops->dma_device(rxe);
+	dev->dma_device = rxe_dma_device(rxe);
 	dev->local_dma_lkey = 0;
-	dev->node_guid = rxe->ifc_ops->node_guid(rxe);
+	dev->node_guid = rxe_node_guid(rxe);
 	dev->dma_ops = &rxe_dma_mapping_ops;
 
 	dev->uverbs_abi_ver = RXE_UVERBS_ABI_VERSION;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index dee3853163b60..d4a84f49dfd80 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -373,26 +373,6 @@ struct rxe_port {
 	u32			qp_gsi_index;
 };
 
-/* callbacks from rdma_rxe to network interface layer */
-struct rxe_ifc_ops {
-	void (*release)(struct rxe_dev *rxe);
-	__be64 (*node_guid)(struct rxe_dev *rxe);
-	__be64 (*port_guid)(struct rxe_dev *rxe);
-	struct device *(*dma_device)(struct rxe_dev *rxe);
-	int (*mcast_add)(struct rxe_dev *rxe, union ib_gid *mgid);
-	int (*mcast_delete)(struct rxe_dev *rxe, union ib_gid *mgid);
-	int (*prepare)(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
-		       struct sk_buff *skb, u32 *crc);
-	int (*send)(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
-		    struct sk_buff *skb);
-	int (*loopback)(struct sk_buff *skb);
-	struct sk_buff *(*init_packet)(struct rxe_dev *rxe, struct rxe_av *av,
-				       int paylen, struct rxe_pkt_info *pkt);
-	char *(*parent_name)(struct rxe_dev *rxe, unsigned int port_num);
-	enum rdma_link_layer (*link_layer)(struct rxe_dev *rxe,
-					   unsigned int port_num);
-};
-
 struct rxe_dev {
 	struct ib_device	ib_dev;
 	struct ib_device_attr	attr;
@@ -401,8 +381,6 @@ struct rxe_dev {
 	struct kref		ref_cnt;
 	struct mutex	usdev_lock;
 
-	struct rxe_ifc_ops	*ifc_ops;
-
 	struct net_device	*ndev;
 
 	int			xmit_errors;
-- 
2.25.1



