Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CDF3A932
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388859AbfFIRFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388851AbfFIRFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1180620833;
        Sun,  9 Jun 2019 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099935;
        bh=NPh8xmvgyG34GCkiYvd3KgLYMQIkiPd2vg2HwW3rt84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ao99h1YfISA51a6cwh3wRuHMw3bnoTClqH4Nfro7D4PTClicXtaQO45TtbFArI7/N
         SOx4NLUZ7PpXOpQShYl6QWdhaep/L45bluQPiAn0c6RPQth2fjZ3dhBmDFC8fWdBrS
         r9zqndBxbqcmaMpsI4beVx5ZgNZyd/TyO7sfGbNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arend Van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Lei Zhang <leizh@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 218/241] brcmfmac: Add length checks on firmware events
Date:   Sun,  9 Jun 2019 18:42:40 +0200
Message-Id: <20190609164154.963777103@linuxfoundation.org>
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

From: Hante Meuleman <meuleman@broadcom.com>

commit 0aedbcaf6f182690790d98d90d5fe1e64c846c34 upstream.

Add additional length checks on firmware events to create more
robust code.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Lei Zhang <leizh@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 4.4:
 - Drop changes to brcmf_wowl_nd_results()
 - Adjust filenames]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |    5 +
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   57 +++--------------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |   68 ++++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   10 +++
 4 files changed, 82 insertions(+), 58 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -3331,6 +3331,11 @@ brcmf_notify_sched_scan_results(struct b
 
 	brcmf_dbg(SCAN, "Enter\n");
 
+	if (e->datalen < (sizeof(*pfn_result) + sizeof(*netinfo))) {
+		brcmf_dbg(SCAN, "Event data to small. Ignore\n");
+		return 0;
+	}
+
 	if (e->event_code == BRCMF_E_PFN_NET_LOST) {
 		brcmf_dbg(SCAN, "PFN NET LOST event. Do Nothing\n");
 		return 0;
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -26,50 +26,6 @@
 #include "fwil.h"
 
 /**
- * struct brcm_ethhdr - broadcom specific ether header.
- *
- * @subtype: subtype for this packet.
- * @length: TODO: length of appended data.
- * @version: version indication.
- * @oui: OUI of this packet.
- * @usr_subtype: subtype for this OUI.
- */
-struct brcm_ethhdr {
-	__be16 subtype;
-	__be16 length;
-	u8 version;
-	u8 oui[3];
-	__be16 usr_subtype;
-} __packed;
-
-struct brcmf_event_msg_be {
-	__be16 version;
-	__be16 flags;
-	__be32 event_type;
-	__be32 status;
-	__be32 reason;
-	__be32 auth_type;
-	__be32 datalen;
-	u8 addr[ETH_ALEN];
-	char ifname[IFNAMSIZ];
-	u8 ifidx;
-	u8 bsscfgidx;
-} __packed;
-
-/**
- * struct brcmf_event - contents of broadcom event packet.
- *
- * @eth: standard ether header.
- * @hdr: broadcom specific ether header.
- * @msg: common part of the actual event message.
- */
-struct brcmf_event {
-	struct ethhdr eth;
-	struct brcm_ethhdr hdr;
-	struct brcmf_event_msg_be msg;
-} __packed;
-
-/**
  * struct brcmf_fweh_queue_item - event item on event queue.
  *
  * @q: list element for queuing.
@@ -85,6 +41,7 @@ struct brcmf_fweh_queue_item {
 	u8 ifidx;
 	u8 ifaddr[ETH_ALEN];
 	struct brcmf_event_msg_be emsg;
+	u32 datalen;
 	u8 data[0];
 };
 
@@ -294,6 +251,11 @@ static void brcmf_fweh_event_worker(stru
 		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), event->data,
 				   min_t(u32, emsg.datalen, 64),
 				   "event payload, len=%d\n", emsg.datalen);
+		if (emsg.datalen > event->datalen) {
+			brcmf_err("event invalid length header=%d, msg=%d\n",
+				  event->datalen, emsg.datalen);
+			goto event_free;
+		}
 
 		/* special handling of interface event */
 		if (event->code == BRCMF_E_IF) {
@@ -439,7 +401,8 @@ int brcmf_fweh_activate_events(struct br
  * dispatch the event to a registered handler (using worker).
  */
 void brcmf_fweh_process_event(struct brcmf_pub *drvr,
-			      struct brcmf_event *event_packet)
+			      struct brcmf_event *event_packet,
+			      u32 packet_len)
 {
 	enum brcmf_fweh_event_code code;
 	struct brcmf_fweh_info *fweh = &drvr->fweh;
@@ -459,6 +422,9 @@ void brcmf_fweh_process_event(struct brc
 	if (code != BRCMF_E_IF && !fweh->evt_handler[code])
 		return;
 
+	if (datalen > BRCMF_DCMD_MAXLEN)
+		return;
+
 	if (in_interrupt())
 		alloc_flag = GFP_ATOMIC;
 
@@ -472,6 +438,7 @@ void brcmf_fweh_process_event(struct brc
 	/* use memcpy to get aligned event message */
 	memcpy(&event->emsg, &event_packet->msg, sizeof(event->emsg));
 	memcpy(event->data, data, datalen);
+	event->datalen = datalen;
 	memcpy(event->ifaddr, event_packet->eth.h_dest, ETH_ALEN);
 
 	brcmf_fweh_queue_event(fweh, event);
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -27,7 +27,6 @@
 struct brcmf_pub;
 struct brcmf_if;
 struct brcmf_cfg80211_info;
-struct brcmf_event;
 
 /* list of firmware events */
 #define BRCMF_FWEH_EVENT_ENUM_DEFLIST \
@@ -180,13 +179,55 @@ enum brcmf_fweh_event_code {
 /**
  * definitions for event packet validation.
  */
-#define BRCMF_EVENT_OUI_OFFSET		19
-#define BRCM_OUI			"\x00\x10\x18"
-#define DOT11_OUI_LEN			3
-#define BCMILCP_BCM_SUBTYPE_EVENT	1
+#define BRCM_OUI				"\x00\x10\x18"
+#define BCMILCP_BCM_SUBTYPE_EVENT		1
 
 
 /**
+ * struct brcm_ethhdr - broadcom specific ether header.
+ *
+ * @subtype: subtype for this packet.
+ * @length: TODO: length of appended data.
+ * @version: version indication.
+ * @oui: OUI of this packet.
+ * @usr_subtype: subtype for this OUI.
+ */
+struct brcm_ethhdr {
+	__be16 subtype;
+	__be16 length;
+	u8 version;
+	u8 oui[3];
+	__be16 usr_subtype;
+} __packed;
+
+struct brcmf_event_msg_be {
+	__be16 version;
+	__be16 flags;
+	__be32 event_type;
+	__be32 status;
+	__be32 reason;
+	__be32 auth_type;
+	__be32 datalen;
+	u8 addr[ETH_ALEN];
+	char ifname[IFNAMSIZ];
+	u8 ifidx;
+	u8 bsscfgidx;
+} __packed;
+
+/**
+ * struct brcmf_event - contents of broadcom event packet.
+ *
+ * @eth: standard ether header.
+ * @hdr: broadcom specific ether header.
+ * @msg: common part of the actual event message.
+ */
+struct brcmf_event {
+	struct ethhdr eth;
+	struct brcm_ethhdr hdr;
+	struct brcmf_event_msg_be msg;
+} __packed;
+
+/**
  * struct brcmf_event_msg - firmware event message.
  *
  * @version: version information.
@@ -256,34 +297,35 @@ void brcmf_fweh_unregister(struct brcmf_
 			   enum brcmf_fweh_event_code code);
 int brcmf_fweh_activate_events(struct brcmf_if *ifp);
 void brcmf_fweh_process_event(struct brcmf_pub *drvr,
-			      struct brcmf_event *event_packet);
+			      struct brcmf_event *event_packet,
+			      u32 packet_len);
 void brcmf_fweh_p2pdev_setup(struct brcmf_if *ifp, bool ongoing);
 
 static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
 					  struct sk_buff *skb)
 {
 	struct brcmf_event *event_packet;
-	u8 *data;
 	u16 usr_stype;
 
 	/* only process events when protocol matches */
 	if (skb->protocol != cpu_to_be16(ETH_P_LINK_CTL))
 		return;
 
+	if ((skb->len + ETH_HLEN) < sizeof(*event_packet))
+		return;
+
 	/* check for BRCM oui match */
 	event_packet = (struct brcmf_event *)skb_mac_header(skb);
-	data = (u8 *)event_packet;
-	data += BRCMF_EVENT_OUI_OFFSET;
-	if (memcmp(BRCM_OUI, data, DOT11_OUI_LEN))
+	if (memcmp(BRCM_OUI, &event_packet->hdr.oui[0],
+		   sizeof(event_packet->hdr.oui)))
 		return;
 
 	/* final match on usr_subtype */
-	data += DOT11_OUI_LEN;
-	usr_stype = get_unaligned_be16(data);
+	usr_stype = get_unaligned_be16(&event_packet->hdr.usr_subtype);
 	if (usr_stype != BCMILCP_BCM_SUBTYPE_EVENT)
 		return;
 
-	brcmf_fweh_process_event(drvr, event_packet);
+	brcmf_fweh_process_event(drvr, event_packet, skb->len + ETH_HLEN);
 }
 
 #endif /* FWEH_H_ */
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1365,6 +1365,11 @@ int brcmf_p2p_notify_action_frame_rx(str
 	u16 mgmt_type;
 	u8 action;
 
+	if (e->datalen < sizeof(*rxframe)) {
+		brcmf_dbg(SCAN, "Event data to small. Ignore\n");
+		return 0;
+	}
+
 	ch.chspec = be16_to_cpu(rxframe->chanspec);
 	cfg->d11inf.decchspec(&ch);
 	/* Check if wpa_supplicant has registered for this frame */
@@ -1862,6 +1867,11 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probere
 	brcmf_dbg(INFO, "Enter: event %d reason %d\n", e->event_code,
 		  e->reason);
 
+	if (e->datalen < sizeof(*rxframe)) {
+		brcmf_dbg(SCAN, "Event data to small. Ignore\n");
+		return 0;
+	}
+
 	ch.chspec = be16_to_cpu(rxframe->chanspec);
 	cfg->d11inf.decchspec(&ch);
 


