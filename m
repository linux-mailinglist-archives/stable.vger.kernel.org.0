Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E106E46840A
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 11:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344248AbhLDKbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 05:31:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50414 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhLDKbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 05:31:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A416360BFB
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 10:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841A1C341C0;
        Sat,  4 Dec 2021 10:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638613687;
        bh=CeN1fLd+gSmzEFOIKDkCg3pzZwWOgkJtlFw+OtoC/T4=;
        h=Subject:To:Cc:From:Date:From;
        b=y6rH82jc63pP61/j7D5/pWrzQuG4tbC0ZqNcHeoTTuISOVC+1rp3T1FDvCuZtCz2J
         iSKcUSPbZgG95vIvKkEYTfEGrUxOgcTyCq4nTS1NnM391TDomxYb9ywNL9LsRmow1H
         apecPQ8PXb76XjOtzi71OAhfXhUwt+MRwGG6NT+U=
Subject: FAILED: patch "[PATCH] vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf" failed to apply to 4.4-stable tree
To:     ssuryaextr@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 04 Dec 2021 11:28:04 +0100
Message-ID: <1638613684143163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ee201011c1e1563c114a55c86eb164b236f18e84 Mon Sep 17 00:00:00 2001
From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Tue, 30 Nov 2021 11:26:37 -0500
Subject: [PATCH] vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf
 dev xmit

IPCB/IP6CB need to be initialized when processing outbound v4 or v6 pkts
in the codepath of vrf device xmit function so that leftover garbage
doesn't cause futher code that uses the CB to incorrectly process the
pkt.

One occasion of the issue might occur when MPLS route uses the vrf
device as the outgoing device such as when the route is added using "ip
-f mpls route add <label> dev <vrf>" command.

The problems seems to exist since day one. Hence I put the day one
commits on the Fixes tags.

Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20211130162637.3249-1-ssuryaextr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index ccf677015d5b..131c745dc701 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -497,6 +497,7 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 	/* strip the ethernet header added for pass through VRF device */
 	__skb_pull(skb, skb_network_offset(skb));
 
+	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	ret = vrf_ip6_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		dev->stats.tx_errors++;
@@ -579,6 +580,7 @@ static netdev_tx_t vrf_process_v4_outbound(struct sk_buff *skb,
 					       RT_SCOPE_LINK);
 	}
 
+	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 	ret = vrf_ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		vrf_dev->stats.tx_errors++;

