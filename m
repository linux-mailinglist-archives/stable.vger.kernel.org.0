Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F213CD0BB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbhGSIqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235278AbhGSIqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B32CF6115B;
        Mon, 19 Jul 2021 09:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626686849;
        bh=BjqLjnIz6ZYRH3h62PZWLfjTprbzzbbl7wg4u5z3WQw=;
        h=Subject:To:Cc:From:Date:From;
        b=oFck4/v9BEbSAXcMG0lAYQ1e43W65mkxuLSd6LlGxfanXMGTDvevzCspWuk2fgYEY
         eeP+YDZOT0jPMUphdQ2tyeyy+kSKSmoJ46fYSN3gllbBkfn0qsAkLsmZPr9hu/NSBu
         QFIoMW2uwQO29qIs6hykZuMPi+26pB/n9GTQJ+NI=
Subject: FAILED: patch "[PATCH] net: bridge: multicast: fix PIM hello router port marking" failed to apply to 5.12-stable tree
To:     nikolay@nvidia.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 11:27:24 +0200
Message-ID: <162668684411072@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 04bef83a3358946bfc98a5ecebd1b0003d83d882 Mon Sep 17 00:00:00 2001
From: Nikolay Aleksandrov <nikolay@nvidia.com>
Date: Sun, 11 Jul 2021 12:56:28 +0300
Subject: [PATCH] net: bridge: multicast: fix PIM hello router port marking
 race

When a PIM hello packet is received on a bridge port with multicast
snooping enabled, we mark it as a router port automatically, that
includes adding that port the router port list. The multicast lock
protects that list, but it is not acquired in the PIM message case
leading to a race condition, we need to take it to fix the race.

Cc: stable@vger.kernel.org
Fixes: 91b02d3d133b ("bridge: mcast: add router port on PIM hello message")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 53c3a9d80d9c..3bbbc6d7b7c3 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3264,7 +3264,9 @@ static void br_multicast_pim(struct net_bridge *br,
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_ip4_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,

