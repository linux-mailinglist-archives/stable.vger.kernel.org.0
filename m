Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C771232D15
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgG3IGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgG3IGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:06:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14472070B;
        Thu, 30 Jul 2020 08:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096362;
        bh=5Q75XYJ0+4WSl8OLlYOpZ3g+ZdE2t0a75uavtgAgzxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtrRtrcGDyWarK5EYX4TCE4DRRXWvt4MDLdWWf2qYC+iwgCS4N0MV33w/NpvfCIGj
         QJEY/FK1CJ3mJ4TYxgUriCzdkQ7/iG8NsTU85oQWO5D+j11xgk6A64o2WNeBvTt4SH
         L1QZdLoU8RHAZ36eZz8Tu74u0+w407Sl+qSt1R2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 07/19] net: udp: Fix wrong clean up for IS_UDPLITE macro
Date:   Thu, 30 Jul 2020 10:04:09 +0200
Message-Id: <20200730074420.877165924@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.502923740@linuxfoundation.org>
References: <20200730074420.502923740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit b0a422772fec29811e293c7c0e6f991c0fd9241d ]

We can't use IS_UDPLITE to replace udp_sk->pcflag when UDPLITE_RECV_CC is
checked.

Fixes: b2bf1e2659b1 ("[UDP]: Clean up for IS_UDPLITE macro")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    2 +-
 net/ipv6/udp.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2045,7 +2045,7 @@ static int udp_queue_rcv_one_skb(struct
 	/*
 	 * 	UDP-Lite specific tests, ignored on UDP sockets
 	 */
-	if ((is_udplite & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
+	if ((up->pcflag & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
 
 		/*
 		 * MIB statistics other than incrementing the error count are
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -643,7 +643,7 @@ static int udpv6_queue_rcv_one_skb(struc
 	/*
 	 * UDP-Lite specific tests, ignored on UDP sockets (see net/ipv4/udp.c).
 	 */
-	if ((is_udplite & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
+	if ((up->pcflag & UDPLITE_RECV_CC)  &&  UDP_SKB_CB(skb)->partial_cov) {
 
 		if (up->pcrlen == 0) {          /* full coverage was set  */
 			net_dbg_ratelimited("UDPLITE6: partial coverage %d while full coverage %d requested\n",


