Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446073A8EB
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbfFIRFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388874AbfFIRFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4D1204EC;
        Sun,  9 Jun 2019 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099941;
        bh=O0bCKYpH+BVzEgsvH+gaU+Kaa6oGj5jTz6m4w1pO4O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbMQ60tU0kNhfj5DEjteChv0FxlkXT1Ug78Y+CzMYoFsql9MRHNkzZMKIuHMBsAB5
         Zs0To5G5neuR+9cqNbX121lQzggbo4P+VSc/wgQ+EySZuV5hVbRe22Wotttt0l2nim
         v/yppkkVuCldtgXi+7RTOTfpl1+3on9IPuRgghPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 220/241] brcmfmac: revise handling events in receive path
Date:   Sun,  9 Jun 2019 18:42:42 +0200
Message-Id: <20190609164155.032219304@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arend van Spriel <arend@broadcom.com>

commit 9c349892ccc90c6de2baaa69cc78449f58082273 upstream.

Move event handling out of brcmf_netif_rx() avoiding the need
to pass a flag. This flag is only ever true for USB hosts as
other interface use separate brcmf_rx_event() function.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 4.4 as dependency of commit a4176ec356c7
 "brcmfmac: add subtype check for event handling in data path"
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/bus.h    |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/core.c   |   32 +++++++++++------------
 drivers/net/wireless/brcm80211/brcmfmac/core.h   |    3 --
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c |    2 -
 4 files changed, 19 insertions(+), 20 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bus.h
@@ -214,7 +214,7 @@ bool brcmf_c_prec_enq(struct device *dev
 		      int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_evnt);
+void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_event);
 /* Receive async event packet from firmware. Callee disposes of rxp. */
 void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
 
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -301,18 +301,11 @@ void brcmf_txflowblock(struct device *de
 	brcmf_fws_bus_blocked(drvr, state);
 }
 
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
-		    bool handle_event)
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
-	skb->protocol = eth_type_trans(skb, ifp->ndev);
-
 	if (skb->pkt_type == PACKET_MULTICAST)
 		ifp->stats.multicast++;
 
-	/* Process special event packets */
-	if (handle_event)
-		brcmf_fweh_process_skb(ifp->drvr, skb);
-
 	if (!(ifp->ndev->flags & IFF_UP)) {
 		brcmu_pkt_buf_free_skb(skb);
 		return;
@@ -372,7 +365,7 @@ static void brcmf_rxreorder_process_info
 	/* validate flags and flow id */
 	if (flags == 0xFF) {
 		brcmf_err("invalid flags...so ignore this packet\n");
-		brcmf_netif_rx(ifp, pkt, false);
+		brcmf_netif_rx(ifp, pkt);
 		return;
 	}
 
@@ -384,7 +377,7 @@ static void brcmf_rxreorder_process_info
 		if (rfi == NULL) {
 			brcmf_dbg(INFO, "received flags to cleanup, but no flow (%d) yet\n",
 				  flow_id);
-			brcmf_netif_rx(ifp, pkt, false);
+			brcmf_netif_rx(ifp, pkt);
 			return;
 		}
 
@@ -409,7 +402,7 @@ static void brcmf_rxreorder_process_info
 		rfi = kzalloc(buf_size, GFP_ATOMIC);
 		if (rfi == NULL) {
 			brcmf_err("failed to alloc buffer\n");
-			brcmf_netif_rx(ifp, pkt, false);
+			brcmf_netif_rx(ifp, pkt);
 			return;
 		}
 
@@ -523,11 +516,11 @@ static void brcmf_rxreorder_process_info
 netif_rx:
 	skb_queue_walk_safe(&reorder_list, pkt, pnext) {
 		__skb_unlink(pkt, &reorder_list);
-		brcmf_netif_rx(ifp, pkt, false);
+		brcmf_netif_rx(ifp, pkt);
 	}
 }
 
-void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_evnt)
+void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_event)
 {
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -547,11 +540,18 @@ void brcmf_rx_frame(struct device *dev,
 		return;
 	}
 
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
+
 	rd = (struct brcmf_skb_reorder_data *)skb->cb;
-	if (rd->reorder)
+	if (rd->reorder) {
 		brcmf_rxreorder_process_info(ifp, rd->reorder, skb);
-	else
-		brcmf_netif_rx(ifp, skb, handle_evnt);
+	} else {
+		/* Process special event packets */
+		if (handle_event)
+			brcmf_fweh_process_skb(ifp->drvr, skb);
+
+		brcmf_netif_rx(ifp, skb);
+	}
 }
 
 void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -215,8 +215,7 @@ int brcmf_get_next_free_bsscfgidx(struct
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
-		    bool handle_event);
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 
 #endif /* BRCMFMAC_CORE_H */
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1155,7 +1155,7 @@ brcmf_msgbuf_process_rx_complete(struct
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
-	brcmf_netif_rx(ifp, skb, false);
+	brcmf_netif_rx(ifp, skb);
 }
 
 


