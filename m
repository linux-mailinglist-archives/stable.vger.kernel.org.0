Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26433A931
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388868AbfFIRFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388860AbfFIRFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94FF206DF;
        Sun,  9 Jun 2019 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099938;
        bh=Q6TwShbaRr93ReNGInj9mWSnKJYeANtyn3UYp8dwIFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmQtdGmIaKIaOBDOptrMx+wQOqrspwcq6oEsA53jVydl9a3FPXssndkpc4ym5+n/q
         Mf6puVkXqHfBkG6535tvGzSoLWLu05n1OgkSar5dlcqwbGZp8IChl/21pSPtyNXvXv
         BTxWgupk2h8SW5FZWjdv6ZPAgppzUL7y0/agAda8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 219/241] brcmfmac: screening firmware event packet
Date:   Sun,  9 Jun 2019 18:42:41 +0200
Message-Id: <20190609164155.000453636@linuxfoundation.org>
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

From: Franky Lin <franky.lin@broadcom.com>

commit c56caa9db8abbbfb9e31325e0897705aa897db37 upstream.

Firmware uses asynchronized events as a communication method to the
host. The event packets are marked as ETH_P_LINK_CTL protocol type. For
SDIO and PCIe bus, this kind of packets are delivered through virtual
event channel not data channel. This patch adds a screening logic to
make sure the event handler only processes the events coming from the
correct channel.

Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 4.4 adjust filenames]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/bus.h    |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/core.c   |   46 ++++++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/core.h   |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c |   42 ++++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   |   32 ++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/usb.c    |    2 -
 6 files changed, 90 insertions(+), 39 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bus.h
@@ -214,7 +214,9 @@ bool brcmf_c_prec_enq(struct device *dev
 		      int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp);
+void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_evnt);
+/* Receive async event packet from firmware. Callee disposes of rxp. */
+void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
 
 /* Indication from bus module regarding presence/insertion of dongle. */
 int brcmf_attach(struct device *dev);
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -301,16 +301,17 @@ void brcmf_txflowblock(struct device *de
 	brcmf_fws_bus_blocked(drvr, state);
 }
 
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
+		    bool handle_event)
 {
-	skb->dev = ifp->ndev;
-	skb->protocol = eth_type_trans(skb, skb->dev);
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
 
 	if (skb->pkt_type == PACKET_MULTICAST)
 		ifp->stats.multicast++;
 
 	/* Process special event packets */
-	brcmf_fweh_process_skb(ifp->drvr, skb);
+	if (handle_event)
+		brcmf_fweh_process_skb(ifp->drvr, skb);
 
 	if (!(ifp->ndev->flags & IFF_UP)) {
 		brcmu_pkt_buf_free_skb(skb);
@@ -371,7 +372,7 @@ static void brcmf_rxreorder_process_info
 	/* validate flags and flow id */
 	if (flags == 0xFF) {
 		brcmf_err("invalid flags...so ignore this packet\n");
-		brcmf_netif_rx(ifp, pkt);
+		brcmf_netif_rx(ifp, pkt, false);
 		return;
 	}
 
@@ -383,7 +384,7 @@ static void brcmf_rxreorder_process_info
 		if (rfi == NULL) {
 			brcmf_dbg(INFO, "received flags to cleanup, but no flow (%d) yet\n",
 				  flow_id);
-			brcmf_netif_rx(ifp, pkt);
+			brcmf_netif_rx(ifp, pkt, false);
 			return;
 		}
 
@@ -408,7 +409,7 @@ static void brcmf_rxreorder_process_info
 		rfi = kzalloc(buf_size, GFP_ATOMIC);
 		if (rfi == NULL) {
 			brcmf_err("failed to alloc buffer\n");
-			brcmf_netif_rx(ifp, pkt);
+			brcmf_netif_rx(ifp, pkt, false);
 			return;
 		}
 
@@ -522,11 +523,11 @@ static void brcmf_rxreorder_process_info
 netif_rx:
 	skb_queue_walk_safe(&reorder_list, pkt, pnext) {
 		__skb_unlink(pkt, &reorder_list);
-		brcmf_netif_rx(ifp, pkt);
+		brcmf_netif_rx(ifp, pkt, false);
 	}
 }
 
-void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
+void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_evnt)
 {
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -550,7 +551,32 @@ void brcmf_rx_frame(struct device *dev,
 	if (rd->reorder)
 		brcmf_rxreorder_process_info(ifp, rd->reorder, skb);
 	else
-		brcmf_netif_rx(ifp, skb);
+		brcmf_netif_rx(ifp, skb, handle_evnt);
+}
+
+void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
+{
+	struct brcmf_if *ifp;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+	int ret;
+
+	brcmf_dbg(EVENT, "Enter: %s: rxp=%p\n", dev_name(dev), skb);
+
+	/* process and remove protocol-specific header */
+	ret = brcmf_proto_hdrpull(drvr, true, skb, &ifp);
+
+	if (ret || !ifp || !ifp->ndev) {
+		if (ret != -ENODATA && ifp)
+			ifp->stats.rx_errors++;
+		brcmu_pkt_buf_free_skb(skb);
+		return;
+	}
+
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
+
+	brcmf_fweh_process_skb(ifp->drvr, skb);
+	brcmu_pkt_buf_free_skb(skb);
 }
 
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -215,7 +215,8 @@ int brcmf_get_next_free_bsscfgidx(struct
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
+		    bool handle_event);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 
 #endif /* BRCMFMAC_CORE_H */
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -20,6 +20,7 @@
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
@@ -1076,28 +1077,13 @@ static void brcmf_msgbuf_rxbuf_event_pos
 }
 
 
-static void
-brcmf_msgbuf_rx_skb(struct brcmf_msgbuf *msgbuf, struct sk_buff *skb,
-		    u8 ifidx)
-{
-	struct brcmf_if *ifp;
-
-	ifp = brcmf_get_ifp(msgbuf->drvr, ifidx);
-	if (!ifp || !ifp->ndev) {
-		brcmf_err("Received pkt for invalid ifidx %d\n", ifidx);
-		brcmu_pkt_buf_free_skb(skb);
-		return;
-	}
-	brcmf_netif_rx(ifp, skb);
-}
-
-
 static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 {
 	struct msgbuf_rx_event *event;
 	u32 idx;
 	u16 buflen;
 	struct sk_buff *skb;
+	struct brcmf_if *ifp;
 
 	event = (struct msgbuf_rx_event *)buf;
 	idx = le32_to_cpu(event->msg.request_id);
@@ -1117,7 +1103,19 @@ static void brcmf_msgbuf_process_event(s
 
 	skb_trim(skb, buflen);
 
-	brcmf_msgbuf_rx_skb(msgbuf, skb, event->msg.ifidx);
+	ifp = brcmf_get_ifp(msgbuf->drvr, event->msg.ifidx);
+	if (!ifp || !ifp->ndev) {
+		brcmf_err("Received pkt for invalid ifidx %d\n",
+			  event->msg.ifidx);
+		goto exit;
+	}
+
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
+
+	brcmf_fweh_process_skb(ifp->drvr, skb);
+
+exit:
+	brcmu_pkt_buf_free_skb(skb);
 }
 
 
@@ -1129,6 +1127,7 @@ brcmf_msgbuf_process_rx_complete(struct
 	u16 data_offset;
 	u16 buflen;
 	u32 idx;
+	struct brcmf_if *ifp;
 
 	brcmf_msgbuf_update_rxbufpost_count(msgbuf, 1);
 
@@ -1149,7 +1148,14 @@ brcmf_msgbuf_process_rx_complete(struct
 
 	skb_trim(skb, buflen);
 
-	brcmf_msgbuf_rx_skb(msgbuf, skb, rx_complete->msg.ifidx);
+	ifp = brcmf_get_ifp(msgbuf->drvr, rx_complete->msg.ifidx);
+	if (!ifp || !ifp->ndev) {
+		brcmf_err("Received pkt for invalid ifidx %d\n",
+			  rx_complete->msg.ifidx);
+		brcmu_pkt_buf_free_skb(skb);
+		return;
+	}
+	brcmf_netif_rx(ifp, skb, false);
 }
 
 
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -1394,6 +1394,17 @@ static inline u8 brcmf_sdio_getdatoffset
 	return (u8)((hdrvalue & SDPCM_DOFFSET_MASK) >> SDPCM_DOFFSET_SHIFT);
 }
 
+static inline bool brcmf_sdio_fromevntchan(u8 *swheader)
+{
+	u32 hdrvalue;
+	u8 ret;
+
+	hdrvalue = *(u32 *)swheader;
+	ret = (u8)((hdrvalue & SDPCM_CHANNEL_MASK) >> SDPCM_CHANNEL_SHIFT);
+
+	return (ret == SDPCM_EVENT_CHANNEL);
+}
+
 static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 			      struct brcmf_sdio_hdrinfo *rd,
 			      enum brcmf_sdio_frmtype type)
@@ -1754,7 +1765,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf
 					   pfirst->len, pfirst->next,
 					   pfirst->prev);
 			skb_unlink(pfirst, &bus->glom);
-			brcmf_rx_frame(bus->sdiodev->dev, pfirst);
+			if (brcmf_sdio_fromevntchan(pfirst->data))
+				brcmf_rx_event(bus->sdiodev->dev, pfirst);
+			else
+				brcmf_rx_frame(bus->sdiodev->dev, pfirst,
+					       false);
 			bus->sdcnt.rxglompkts++;
 		}
 
@@ -2081,18 +2096,19 @@ static uint brcmf_sdio_readframes(struct
 		__skb_trim(pkt, rd->len);
 		skb_pull(pkt, rd->dat_offset);
 
+		if (pkt->len == 0)
+			brcmu_pkt_buf_free_skb(pkt);
+		else if (rd->channel == SDPCM_EVENT_CHANNEL)
+			brcmf_rx_event(bus->sdiodev->dev, pkt);
+		else
+			brcmf_rx_frame(bus->sdiodev->dev, pkt,
+				       false);
+
 		/* prepare the descriptor for the next read */
 		rd->len = rd->len_nxtfrm << 4;
 		rd->len_nxtfrm = 0;
 		/* treat all packet as event if we don't know */
 		rd->channel = SDPCM_EVENT_CHANNEL;
-
-		if (pkt->len == 0) {
-			brcmu_pkt_buf_free_skb(pkt);
-			continue;
-		}
-
-		brcmf_rx_frame(bus->sdiodev->dev, pkt);
 	}
 
 	rxcount = maxframes - rxleft;
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -502,7 +502,7 @@ static void brcmf_usb_rx_complete(struct
 
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
 		skb_put(skb, urb->actual_length);
-		brcmf_rx_frame(devinfo->dev, skb);
+		brcmf_rx_frame(devinfo->dev, skb, true);
 		brcmf_usb_rx_refill(devinfo, req);
 	} else {
 		brcmu_pkt_buf_free_skb(skb);


