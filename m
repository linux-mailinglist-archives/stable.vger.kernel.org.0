Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49761CABFF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgEHMsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbgEHMst (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D09C821473;
        Fri,  8 May 2020 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942128;
        bh=gI8pMIvh5jN8BWPY6uAaQ6DrV5F1LYg7eIi5Fw+94Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5/LECh5Vlxx9uqDnllvOW04/bJ/esz4JSHlS6xB9HbckMJdGPTH8SqP1kKW2jybk
         77Yc5avwbzq9XlG/+gjOCNjg9TjMN8sqUs/Tj/m2K6dhzwbeannuwPTjj36BLapeAu
         l72EoGslCJVZ3BaG8B4EcAQOkWHLqxaqTMZeIfTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Pravin Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 307/312] net: skbuff: Remove errornous length validation in skb_vlan_pop()
Date:   Fri,  8 May 2020 14:34:58 +0200
Message-Id: <20200508123146.094231743@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shmulik Ladkani <shmulik.ladkani@ravellosystems.com>

commit 636c2628086e40c86dac7ddc84a1c4b4fcccc6e3 upstream.

In 93515d53b1
  "net: move vlan pop/push functions into common code"
skb_vlan_pop was moved from its private location in openvswitch to
skbuff common code.

In case skb has non hw-accel vlan tag, the original 'pop_vlan()' assured
that skb->len is sufficient (if skb->len < VLAN_ETH_HLEN then pop was
considered a no-op).

This validation was moved as is into the new common 'skb_vlan_pop'.

Alas, in its original location (openvswitch), there was a guarantee that
'data' points to the mac_header, therefore the 'skb->len < VLAN_ETH_HLEN'
condition made sense.
However there's no such guarantee in the generic 'skb_vlan_pop'.

For short packets received in rx path going through 'skb_vlan_pop',
this causes 'skb_vlan_pop' to fail pop-ing a valid vlan hdr (in the non
hw-accel case) or to fail moving next tag into hw-accel tag.

Remove the 'skb->len < VLAN_ETH_HLEN' condition entirely:
It is superfluous since inner '__skb_vlan_pop' already verifies there
are VLAN_ETH_HLEN writable bytes at the mac_header.

Note this presents a slight change to skb_vlan_pop() users:
In case total length is smaller than VLAN_ETH_HLEN, skb_vlan_pop() now
returns an error, as opposed to previous "no-op" behavior.
Existing callers (e.g. tc act vlan, ovs) usually drop the packet if
'skb_vlan_pop' fails.

Fixes: 93515d53b1 ("net: move vlan pop/push functions into common code")
Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Pravin Shelar <pshelar@ovn.org>
Reviewed-by: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skbuff.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4451,9 +4451,8 @@ int skb_vlan_pop(struct sk_buff *skb)
 	if (likely(skb_vlan_tag_present(skb))) {
 		skb->vlan_tci = 0;
 	} else {
-		if (unlikely((skb->protocol != htons(ETH_P_8021Q) &&
-			      skb->protocol != htons(ETH_P_8021AD)) ||
-			     skb->len < VLAN_ETH_HLEN))
+		if (unlikely(skb->protocol != htons(ETH_P_8021Q) &&
+			     skb->protocol != htons(ETH_P_8021AD)))
 			return 0;
 
 		err = __skb_vlan_pop(skb, &vlan_tci);
@@ -4461,9 +4460,8 @@ int skb_vlan_pop(struct sk_buff *skb)
 			return err;
 	}
 	/* move next vlan tag to hw accel tag */
-	if (likely((skb->protocol != htons(ETH_P_8021Q) &&
-		    skb->protocol != htons(ETH_P_8021AD)) ||
-		   skb->len < VLAN_ETH_HLEN))
+	if (likely(skb->protocol != htons(ETH_P_8021Q) &&
+		   skb->protocol != htons(ETH_P_8021AD)))
 		return 0;
 
 	vlan_proto = skb->protocol;


