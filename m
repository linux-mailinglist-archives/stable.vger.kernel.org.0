Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B782AB8F9
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgKINBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729897AbgKINBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:01:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 885ED20684;
        Mon,  9 Nov 2020 13:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926870;
        bh=IOpUOWbEHzWTd+mSrHG24Hs3VW4Mb13lm8I156txMsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFzakXGruS7a6KClFOMPAKAPfKoAR8/FxNMKxoX3fTNS9ShHSlZIw1CWnlJ28LUxp
         +JbiciJ8GtN8vc4RCS9hCUtf1ulVRKcvE2mOXTJzhkoSRXtwxkyiyuWFv+Gmy0xoU/
         5MSYnVCN4cycF8b4mlCZ7+xdlLuvjB3M070srmBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/117] drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values
Date:   Mon,  9 Nov 2020 13:54:18 +0100
Message-Id: <20201109125027.175457855@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 8306266c1d51aac9aa7aa907fe99032a58c6382c ]

The fr_hard_header function is used to prepend the header to skbs before
transmission. It is used in 3 situations:
1) When a control packet is generated internally in this driver;
2) When a user sends an skb on an Ethernet-emulating PVC device;
3) When a user sends an skb on a normal PVC device.

These 3 situations need to be handled differently by fr_hard_header.
Different headers should be prepended to the skb in different situations.

Currently fr_hard_header distinguishes these 3 situations using
skb->protocol. For situation 1 and 2, a special skb->protocol value
will be assigned before calling fr_hard_header, so that it can recognize
these 2 situations. All skb->protocol values other than these special ones
are treated by fr_hard_header as situation 3.

However, it is possible that in situation 3, the user sends an skb with
one of the special skb->protocol values. In this case, fr_hard_header
would incorrectly treat it as situation 1 or 2.

This patch tries to solve this issue by using skb->dev instead of
skb->protocol to distinguish between these 3 situations. For situation
1, skb->dev would be NULL; for situation 2, skb->dev->type would be
ARPHRD_ETHER; and for situation 3, skb->dev->type would be ARPHRD_DLCI.

This way fr_hard_header would be able to distinguish these 3 situations
correctly regardless what skb->protocol value the user tries to use in
situation 3.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_fr.c | 98 ++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index bba19d068207a..487605d2b389d 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -275,63 +275,69 @@ static inline struct net_device **get_dev_p(struct pvc_device *pvc,
 
 static int fr_hard_header(struct sk_buff **skb_p, u16 dlci)
 {
-	u16 head_len;
 	struct sk_buff *skb = *skb_p;
 
-	switch (skb->protocol) {
-	case cpu_to_be16(NLPID_CCITT_ANSI_LMI):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_CCITT_ANSI_LMI;
-		break;
-
-	case cpu_to_be16(NLPID_CISCO_LMI):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_CISCO_LMI;
-		break;
-
-	case cpu_to_be16(ETH_P_IP):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_IP;
-		break;
-
-	case cpu_to_be16(ETH_P_IPV6):
-		head_len = 4;
-		skb_push(skb, head_len);
-		skb->data[3] = NLPID_IPV6;
-		break;
-
-	case cpu_to_be16(ETH_P_802_3):
-		head_len = 10;
-		if (skb_headroom(skb) < head_len) {
-			struct sk_buff *skb2 = skb_realloc_headroom(skb,
-								    head_len);
+	if (!skb->dev) { /* Control packets */
+		switch (dlci) {
+		case LMI_CCITT_ANSI_DLCI:
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_CCITT_ANSI_LMI;
+			break;
+
+		case LMI_CISCO_DLCI:
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_CISCO_LMI;
+			break;
+
+		default:
+			return -EINVAL;
+		}
+
+	} else if (skb->dev->type == ARPHRD_DLCI) {
+		switch (skb->protocol) {
+		case htons(ETH_P_IP):
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_IP;
+			break;
+
+		case htons(ETH_P_IPV6):
+			skb_push(skb, 4);
+			skb->data[3] = NLPID_IPV6;
+			break;
+
+		default:
+			skb_push(skb, 10);
+			skb->data[3] = FR_PAD;
+			skb->data[4] = NLPID_SNAP;
+			/* OUI 00-00-00 indicates an Ethertype follows */
+			skb->data[5] = 0x00;
+			skb->data[6] = 0x00;
+			skb->data[7] = 0x00;
+			/* This should be an Ethertype: */
+			*(__be16 *)(skb->data + 8) = skb->protocol;
+		}
+
+	} else if (skb->dev->type == ARPHRD_ETHER) {
+		if (skb_headroom(skb) < 10) {
+			struct sk_buff *skb2 = skb_realloc_headroom(skb, 10);
 			if (!skb2)
 				return -ENOBUFS;
 			dev_kfree_skb(skb);
 			skb = *skb_p = skb2;
 		}
-		skb_push(skb, head_len);
+		skb_push(skb, 10);
 		skb->data[3] = FR_PAD;
 		skb->data[4] = NLPID_SNAP;
-		skb->data[5] = FR_PAD;
+		/* OUI 00-80-C2 stands for the 802.1 organization */
+		skb->data[5] = 0x00;
 		skb->data[6] = 0x80;
 		skb->data[7] = 0xC2;
+		/* PID 00-07 stands for Ethernet frames without FCS */
 		skb->data[8] = 0x00;
-		skb->data[9] = 0x07; /* bridged Ethernet frame w/out FCS */
-		break;
+		skb->data[9] = 0x07;
 
-	default:
-		head_len = 10;
-		skb_push(skb, head_len);
-		skb->data[3] = FR_PAD;
-		skb->data[4] = NLPID_SNAP;
-		skb->data[5] = FR_PAD;
-		skb->data[6] = FR_PAD;
-		skb->data[7] = FR_PAD;
-		*(__be16*)(skb->data + 8) = skb->protocol;
+	} else {
+		return -EINVAL;
 	}
 
 	dlci_to_q922(skb->data, dlci);
@@ -427,8 +433,8 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 				skb_put(skb, pad);
 				memset(skb->data + len, 0, pad);
 			}
-			skb->protocol = cpu_to_be16(ETH_P_802_3);
 		}
+		skb->dev = dev;
 		if (!fr_hard_header(&skb, pvc->dlci)) {
 			dev->stats.tx_bytes += skb->len;
 			dev->stats.tx_packets++;
@@ -496,10 +502,8 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	memset(skb->data, 0, len);
 	skb_reserve(skb, 4);
 	if (lmi == LMI_CISCO) {
-		skb->protocol = cpu_to_be16(NLPID_CISCO_LMI);
 		fr_hard_header(&skb, LMI_CISCO_DLCI);
 	} else {
-		skb->protocol = cpu_to_be16(NLPID_CCITT_ANSI_LMI);
 		fr_hard_header(&skb, LMI_CCITT_ANSI_DLCI);
 	}
 	data = skb_tail_pointer(skb);
-- 
2.27.0



