Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953E9431786
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhJRLiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhJRLiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:38:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7C4E60E76;
        Mon, 18 Oct 2021 11:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634557001;
        bh=KfDZq2juUL/AkbwCpvxs9Cw6G0ym9SmleT4iejZiRHU=;
        h=Subject:To:Cc:From:Date:From;
        b=CB470qqBP3B1yw6Xo7yV2sBz/EQrb+50YI5Rd1cQ8+ac2BLEtiU7K0A/DRfkDPceS
         qi+C2l+k85e6Yhs6crOlI6Q2aduW2EBkWwFjFUAOVYFFKoeOgwbtGcuO8Slw5yNsoa
         CL7MNKKy10BqBPT9Rr1S6mxMC2547uBJKMTKIZ/E=
Subject: FAILED: patch "[PATCH] net: dsa: tag_ocelot_8021q: fix inability to inject STP BPDUs" failed to apply to 5.14-stable tree
To:     vladimir.oltean@nxp.com, f.fainelli@gmail.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:36:38 +0200
Message-ID: <1634556998186225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 43ba33b4f143965a451cfdc1e826b61f6933c887 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 12 Oct 2021 14:40:43 +0300
Subject: [PATCH] net: dsa: tag_ocelot_8021q: fix inability to inject STP BPDUs
 into BLOCKING ports

When setting up a bridge with stp_state 1, topology changes are not
detected and loops are not blocked. This is because the standard way of
transmitting a packet, based on VLAN IDs redirected by VCAP IS2 to the
right egress port, does not override the port STP state (in the case of
Ocelot switches, that's really the PGID_SRC masks).

To force a packet to be injected into a port that's BLOCKING, we must
send it as a control packet, which means in the case of this tagger to
send it using the manual register injection method. We already do this
for PTP frames, extend the logic to apply to any link-local MAC DA.

Fixes: 7c83a7c539ab ("net: dsa: add a second tagger for Ocelot switches based on tag_8021q")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index d05c352f96e5..3412051981d7 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -42,8 +42,9 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	struct ethhdr *hdr = eth_hdr(skb);
 
-	if (ocelot_ptp_rew_op(skb))
+	if (ocelot_ptp_rew_op(skb) || is_link_local_ether_addr(hdr->h_dest))
 		return ocelot_defer_xmit(dp, skb);
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,

