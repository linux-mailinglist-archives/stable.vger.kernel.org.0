Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B245176DBB
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389239AbfGZPbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389243AbfGZPbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:31:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B1A322BF5;
        Fri, 26 Jul 2019 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155075;
        bh=p2jxfemamL9OThkkkhp5Ka0e+Tn3mOYTKn4IIiywrSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtM9E1JJ+pmzspkD09T8DahH6v0myefvbzWOwdKp98SQtvODnOqLHBJcEBYytTL0+
         xODiwhvrsr26R6VbLaCwBrOGPvHtF4on+1Mza9pPGz7v6oR70FtzSFLVSNo9Rhcyk2
         2m7kSgP0c6gaU5tI36tmRcmBiyHo3yhBGup56/0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hurley <john.hurley@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 12/62] net: openvswitch: fix csum updates for MPLS actions
Date:   Fri, 26 Jul 2019 17:24:24 +0200
Message-Id: <20190726152302.979936500@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -175,8 +175,7 @@ static void update_ethertype(struct sk_b
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
 		__be16 diff[] = { ~(hdr->h_proto), ethertype };
 
-		skb->csum = ~csum_partial((char *)diff, sizeof(diff),
-					~skb->csum);
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
 	}
 
 	hdr->h_proto = ethertype;
@@ -268,8 +267,7 @@ static int set_mpls(struct sk_buff *skb,
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
 		__be32 diff[] = { ~(stack->label_stack_entry), lse };
 
-		skb->csum = ~csum_partial((char *)diff, sizeof(diff),
-					  ~skb->csum);
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
 	}
 
 	stack->label_stack_entry = lse;


