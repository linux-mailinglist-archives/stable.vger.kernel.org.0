Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28123CDC1F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbhGSOv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344278AbhGSOso (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB8461073;
        Mon, 19 Jul 2021 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708450;
        bh=erJ9aSIfprXFO6o/cmgrtnUepYazan/PLqTzcf7Z+N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/otOqxcOtWtCIGigywYvsE5ilguSBqZbRqFDTi4ljy0XqmLQoYAYYHv5IQfVD7YL
         lCFnO3RMbiIXFbHwLwvcwE+4RQyKDfuTGtP0Wq5vnHC+x/V+g/qdmV/JNyNGQkCeYO
         N5IefJRjL75jKajaoHcDRTuB39vaXGyXFWpo2LqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 315/315] net: bridge: multicast: fix PIM hello router port marking race
Date:   Mon, 19 Jul 2021 16:53:24 +0200
Message-Id: <20210719144953.844806034@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit 04bef83a3358946bfc98a5ecebd1b0003d83d882 upstream.

When a PIM hello packet is received on a bridge port with multicast
snooping enabled, we mark it as a router port automatically, that
includes adding that port the router port list. The multicast lock
protects that list, but it is not acquired in the PIM message case
leading to a race condition, we need to take it to fix the race.

Cc: stable@vger.kernel.org
Fixes: 91b02d3d133b ("bridge: mcast: add router port on PIM hello message")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1763,7 +1763,9 @@ static void br_multicast_pim(struct net_
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv4_rcv(struct net_bridge *br,


