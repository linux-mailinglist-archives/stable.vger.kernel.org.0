Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459AB3ED61C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbhHPNQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240347AbhHPNPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 160EB632A3;
        Mon, 16 Aug 2021 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119570;
        bh=BrxAP1n3XrLK6AtpB1iXPo29xwVVZ/wr5Yi7vfnCZJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHB6CZDg5a8bI/Af5xUgp8junXhi45lBFD8eOC7yVVfdT1V1lbw7MwZEXMMxXQ9bf
         +5P0GJRcjAVzjzmtmJncb3Nv4bIVb5j6pOXVTohG1cRH+y20StuqxWKAG7PhUqfWX8
         pPEDsjWqd+QWspU40UqiCGofAlPSlMqa0u+cbyEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 077/151] bareudp: Fix invalid read beyond skbs linear data
Date:   Mon, 16 Aug 2021 15:01:47 +0200
Message-Id: <20210816125446.613978388@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 143a8526ab5fd4f8a0c4fe2a9cb28c181dc5a95f ]

Data beyond the UDP header might not be part of the skb's linear data.
Use skb_copy_bits() instead of direct access to skb->data+X, so that
we read the correct bytes even on a fragmented skb.

Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://lore.kernel.org/r/7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index edfad93e7b68..22e26458a86e 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -71,12 +71,18 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		family = AF_INET6;
 
 	if (bareudp->ethertype == htons(ETH_P_IP)) {
-		struct iphdr *iphdr;
+		__u8 ipversion;
 
-		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
-		if (iphdr->version == 4) {
-			proto = bareudp->ethertype;
-		} else if (bareudp->multi_proto_mode && (iphdr->version == 6)) {
+		if (skb_copy_bits(skb, BAREUDP_BASE_HLEN, &ipversion,
+				  sizeof(ipversion))) {
+			bareudp->dev->stats.rx_dropped++;
+			goto drop;
+		}
+		ipversion >>= 4;
+
+		if (ipversion == 4) {
+			proto = htons(ETH_P_IP);
+		} else if (ipversion == 6 && bareudp->multi_proto_mode) {
 			proto = htons(ETH_P_IPV6);
 		} else {
 			bareudp->dev->stats.rx_dropped++;
-- 
2.30.2



