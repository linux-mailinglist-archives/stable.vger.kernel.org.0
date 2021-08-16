Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44A43ED53A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbhHPNKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237376AbhHPNIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBB12632AC;
        Mon, 16 Aug 2021 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119240;
        bh=qGu3CLCmhtrCGx81GWXSHiehqdKRJDpU76xkkAtqJL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zfq1PvG9liQv0ZKCblBEHeqOa6LkGY6Hsk1uJ7Lhg2bhDTcLJCpgEPNooVwV5/6FQ
         O2m7kWCUuAi/NLkby3hwtXziGdWCJFxrBsHuXDdBIzjLl2Ed2q/BrEETQWZisdzeVl
         nJTkVFZ2uzGv+JBx5Ricj7axy+WxFvxEij3LiEAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/96] bareudp: Fix invalid read beyond skbs linear data
Date:   Mon, 16 Aug 2021 15:01:57 +0200
Message-Id: <20210816125436.524906425@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
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
index 59c1724bcd0e..39b128205f25 100644
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



