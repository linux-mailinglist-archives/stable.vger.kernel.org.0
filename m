Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7400A19B317
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389255AbgDAQmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389305AbgDAQmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:42:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8BE20BED;
        Wed,  1 Apr 2020 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759325;
        bh=yLdvskkSCkggu6QF1hhBAR6HeanrIgFx9HHqmZNppvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfTsvcN54C1NL40RGfWVIR5xjdF/PekhVa6N7izy9Xu/9MUN10ZetVwNV02JZVRew
         PeVQAd96ceuEx6DrkHIolIA2USKkUcL0nd8Dt69HBNtJ3++4dDZEaI15ZC9gwzDfEr
         EBrHNyPS13kjgvbo+NZTqIr7sFcYOWGnkH/aJCNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 047/148] Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"
Date:   Wed,  1 Apr 2020 18:17:19 +0200
Message-Id: <20200401161557.475847079@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 2271c9500434af2a26b2c9eadeb3c0b075409fb5.

This patch shouldn't have been backported to 4.14.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index e0cea5c05f0e2..03e4fcdfeab73 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -996,23 +996,24 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
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



