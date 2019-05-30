Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16D12EBD1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbfE3DQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbfE3DQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4034E245D7;
        Thu, 30 May 2019 03:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186176;
        bh=SHD36+BY1QvaEGUkOypXBRfC8ohz3yaLFqEMSfO4UWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V37Zz8wa1tzTCiWI5RH2ugAdK96UGS0OUpU00x/v5NFt6PTB6oQJjcVu3qXRQc0RG
         AIt82ZEW7wplkOQz9pU+tzTEL88PEV16hbShxBddro0tbpK7bq2Wk7l0MkPG+7ka2Z
         DkDSKtUdCfvEZT1CW899BUFN7//x+1b7lPi+qbSI=
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
Subject: [PATCH 4.19 029/276] brcmfmac: add subtype check for event handling in data path
Date:   Wed, 29 May 2019 20:03:07 -0700
Message-Id: <20190530030525.996904578@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c   |    5 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h   |   16 ++++++++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c |    2 -
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -464,7 +464,8 @@ void brcmf_rx_frame(struct device *dev,
 	} else {
 		/* Process special event packets */
 		if (handle_event)
-			brcmf_fweh_process_skb(ifp->drvr, skb);
+			brcmf_fweh_process_skb(ifp->drvr, skb,
+					       BCMILCP_SUBTYPE_VENDOR_LONG);
 
 		brcmf_netif_rx(ifp, skb);
 	}
@@ -481,7 +482,7 @@ void brcmf_rx_event(struct device *dev,
 	if (brcmf_rx_hdrpull(drvr, skb, &ifp))
 		return;
 
-	brcmf_fweh_process_skb(ifp->drvr, skb);
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
 	brcmu_pkt_buf_free_skb(skb);
 }
 
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
@@ -211,7 +211,7 @@ enum brcmf_fweh_event_code {
  */
 #define BRCM_OUI				"\x00\x10\x18"
 #define BCMILCP_BCM_SUBTYPE_EVENT		1
-
+#define BCMILCP_SUBTYPE_VENDOR_LONG		32769
 
 /**
  * struct brcm_ethhdr - broadcom specific ether header.
@@ -334,10 +334,10 @@ void brcmf_fweh_process_event(struct brc
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
@@ -346,8 +346,16 @@ static inline void brcmf_fweh_process_sk
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
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1116,7 +1116,7 @@ static void brcmf_msgbuf_process_event(s
 
 	skb->protocol = eth_type_trans(skb, ifp->ndev);
 
-	brcmf_fweh_process_skb(ifp->drvr, skb);
+	brcmf_fweh_process_skb(ifp->drvr, skb, 0);
 
 exit:
 	brcmu_pkt_buf_free_skb(skb);


