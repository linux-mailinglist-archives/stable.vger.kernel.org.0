Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2BD1D8082
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgERRkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbgERRkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86EA32083E;
        Mon, 18 May 2020 17:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823603;
        bh=VgB+B0Gdlag8jOFRayjeRepY0r8rjjvg0pgak1xnbZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVNNFESfFE7JB5ojVm2aXYPERfhyuxzZFa3jPW+ueS0UDqbXz4fl8EYp82Bdpfvly
         VwVXUg4G3ftNM2hdhn6aV0SLaHhGiUoLOBHsAojhWL9A+xfqUDFhIe8KgXFOU3pHJC
         c08HLq0rgo/N1jB9m7U7WOiYYVyV825aHqojQWD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hurley <john.hurley@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 47/86] net: openvswitch: fix csum updates for MPLS actions
Date:   Mon, 18 May 2020 19:36:18 +0200
Message-Id: <20200518173500.146019004@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>

[ Upstream commit 0e3183cd2a64843a95b62f8bd4a83605a4cf0615 ]

Skbs may have their checksum value populated by HW. If this is a checksum
calculated over the entire packet then the CHECKSUM_COMPLETE field is
marked. Changes to the data pointer on the skb throughout the network
stack still try to maintain this complete csum value if it is required
through functions such as skb_postpush_rcsum.

The MPLS actions in Open vSwitch modify a CHECKSUM_COMPLETE value when
changes are made to packet data without a push or a pull. This occurs when
the ethertype of the MAC header is changed or when MPLS lse fields are
modified.

The modification is carried out using the csum_partial function to get the
csum of a buffer and add it into the larger checksum. The buffer is an
inversion of the data to be removed followed by the new data. Because the
csum is calculated over 16 bits and these values align with 16 bits, the
effect is the removal of the old value from the CHECKSUM_COMPLETE and
addition of the new value.

However, the csum fed into the function and the outcome of the
calculation are also inverted. This would only make sense if it was the
new value rather than the old that was inverted in the input buffer.

Fix the issue by removing the bit inverts in the csum_partial calculation.

The bug was verified and the fix tested by comparing the folded value of
the updated CHECKSUM_COMPLETE value with the folded value of a full
software checksum calculation (reset skb->csum to 0 and run
skb_checksum_complete(skb)). Prior to the fix the outcomes differed but
after they produce the same result.

Fixes: 25cd9ba0abc0 ("openvswitch: Add basic MPLS support to kernel")
Fixes: bc7cc5999fd3 ("openvswitch: update checksum in {push,pop}_mpls")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index fd6c587b6a040..828fdced4ecd8 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -143,8 +143,7 @@ static void update_ethertype(struct sk_buff *skb, struct ethhdr *hdr,
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
 		__be16 diff[] = { ~(hdr->h_proto), ethertype };
 
-		skb->csum = ~csum_partial((char *)diff, sizeof(diff),
-					~skb->csum);
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
 	}
 
 	hdr->h_proto = ethertype;
@@ -227,8 +226,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
 		__be32 diff[] = { ~(*stack), lse };
 
-		skb->csum = ~csum_partial((char *)diff, sizeof(diff),
-					  ~skb->csum);
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
 	}
 
 	*stack = lse;
-- 
2.20.1



