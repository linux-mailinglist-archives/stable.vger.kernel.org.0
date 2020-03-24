Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA2D190EBD
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgCXNOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCXNOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:14:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA5D20775;
        Tue, 24 Mar 2020 13:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055672;
        bh=icfb2E8g/sTtAmG5KbiNV7ekMZ/qvVOl+O0LTz8aq1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh0NoQU4cVdcPm0pOs6I/S7VZXN3YgYW4wbsXEPcOwPDR1HwmWykQixkbFsWbtsNh
         LbxgTeL5xcM8valt1OhET4dq/3yX2/PP/M1ZZOpzNTR7bzEWRG3dki+qziNn/eGsgt
         RTbtJ7+Qi0stq8KvJFW+2qL7nUFk6rGlWEg2TIHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/65] Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"
Date:   Tue, 24 Mar 2020 14:11:19 +0100
Message-Id: <20200324130804.049745053@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 91c5f99d131ed3b231aaef7d4ed6799085b095a3.

This patch shouldn't have been backported to 4.19.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 7f5ee6bb44300..9f895083bc0aa 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -993,23 +993,24 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 				   struct sk_buff *skb)
 {
 	int orig_iif = skb->skb_iif;
-	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
-	bool is_ndisc = ipv6_ndisc_frame(skb);
+	bool need_strict;
 
-	/* loopback, multicast & non-ND link-local traffic; do not push through
-	 * packet taps again. Reset pkt_type for upper layers to process skb
+	/* loopback traffic; do not push through packet taps again.
+	 * Reset pkt_type for upper layers to process skb
 	 */
-	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
+	if (skb->pkt_type == PACKET_LOOPBACK) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
-		if (skb->pkt_type == PACKET_LOOPBACK)
-			skb->pkt_type = PACKET_HOST;
+		skb->pkt_type = PACKET_HOST;
 		goto out;
 	}
 
-	/* if packet is NDISC then keep the ingress interface */
-	if (!is_ndisc) {
+	/* if packet is NDISC or addressed to multicast or link-local
+	 * then keep the ingress interface
+	 */
+	need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
+	if (!ipv6_ndisc_frame(skb) && !need_strict) {
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
-- 
2.20.1



