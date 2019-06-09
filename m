Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169943A8EF
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbfFIRFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388881AbfFIRFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:05:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115DB206DF;
        Sun,  9 Jun 2019 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099949;
        bh=pTgCCLvUilwsvMaZM1gPMD/TqLSr8BzBWLhRt3UynTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpEV1/MHh8u1qKn9bbEtm+5jm8w6VgPnfAu6Ag4eN9EJ69CxMwjhIMfnZRPlAJUa4
         073OM2rJ4LzRSiRNrFRxyf7YaHeRB9poazoQ6WCEn8eu+0t3X4Ih6oSDuqlm29Gjxl
         jisZTq+0zapz88JQ0+NgR869FP/dnDxDRNoafDlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 223/241] brcmfmac: add subtype check for event handling in data path
Date:   Sun,  9 Jun 2019 18:42:45 +0200
Message-Id: <20190609164155.129121944@linuxfoundation.org>
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

From: Arend van Spriel <arend.vanspriel@broadcom.com>

commit a4176ec356c73a46c07c181c6d04039fafa34a9f upstream.

For USB there is no separate channel being used to pass events
from firmware to the host driver and as such are passed over the
data path. In order to detect mock event messages an additional
check is needed on event subtype. This check is added conditionally
using unlikely() keyword.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 4.4: adjust filenames]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c   |    5 +++--
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h   |   16 ++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c |    2 +-
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -548,7 +548,8 @@ void brcmf_rx_frame(struct device *dev,
 	} else {
 		/* Process special event packets */
 		if (handle_event)
-			brcmf_fweh_process_skb(ifp->drvr, skb);
+			brcmf_fweh_process_skb(ifp->drvr, skb,
+					       BCMILCP_SUBTYPE_VENDOR_LONG);
 
 		brcmf_netif_rx(ifp, skb);
 	}
@@ -575,7 +576,7 @@ void brcmf_rx_event(struct device *dev,
 
 	skb->protocol = eth_type_trans(skb, ifp->ndev);
 
-	brcmf_fweh_process_skb(ifp->drvr, skb);
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
 	brcmu_pkt_buf_free_skb(skb);
 }
 
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -181,7 +181,7 @@ enum brcmf_fweh_event_code {
  */
 #define BRCM_OUI				"\x00\x10\x18"
 #define BCMILCP_BCM_SUBTYPE_EVENT		1
-
+#define BCMILCP_SUBTYPE_VENDOR_LONG		32769
 
 /**
  * struct brcm_ethhdr - broadcom specific ether header.
@@ -302,10 +302,10 @@ void brcmf_fweh_process_event(struct brc
 void brcmf_fweh_p2pdev_setup(struct brcmf_if *ifp, bool ongoing);
 
 static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
-					  struct sk_buff *skb)
+					  struct sk_buff *skb, u16 stype)
 {
 	struct brcmf_event *event_packet;
-	u16 usr_stype;
+	u16 subtype, usr_stype;
 
 	/* only process events when protocol matches */
 	if (skb->protocol != cpu_to_be16(ETH_P_LINK_CTL))
@@ -314,8 +314,16 @@ static inline void brcmf_fweh_process_sk
 	if ((skb->len + ETH_HLEN) < sizeof(*event_packet))
 		return;
 
-	/* check for BRCM oui match */
 	event_packet = (struct brcmf_event *)skb_mac_header(skb);
+
+	/* check subtype if needed */
+	if (unlikely(stype)) {
+		subtype = get_unaligned_be16(&event_packet->hdr.subtype);
+		if (subtype != stype)
+			return;
+	}
+
+	/* check for BRCM oui match */
 	if (memcmp(BRCM_OUI, &event_packet->hdr.oui[0],
 		   sizeof(event_packet->hdr.oui)))
 		return;
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1112,7 +1112,7 @@ static void brcmf_msgbuf_process_event(s
 
 	skb->protocol = eth_type_trans(skb, ifp->ndev);
 
-	brcmf_fweh_process_skb(ifp->drvr, skb);
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
 
 exit:
 	brcmu_pkt_buf_free_skb(skb);


