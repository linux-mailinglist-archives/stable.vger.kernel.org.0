Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F6E7F3F4
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405116AbfHBJns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405105AbfHBJnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56FD720679;
        Fri,  2 Aug 2019 09:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739026;
        bh=kQDSd5C6gERCxCxgSzMOS7qEiGp2QaPHthmfNLg5y/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaAfo/6gN7PhkIKyTLYtqFqDWh5a1UY81XTSwOzcl3IAbLQqFYA+KL/jpSC1aKYqu
         J7l2XP+Qp9R84f2XzliVNTMfucuSzdiu7uUki0mUAaVuulmpaKJmaAD4hiZWKJ/MMu
         topD+6jc8qF5WuTutnkoVItq2U9vHYKdJr7Az58Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Michael Scott <mike@foundries.io>,
        Josua Mayer <josua.mayer@jm0.eu>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/223] Bluetooth: 6lowpan: search for destination address in all peers
Date:   Fri,  2 Aug 2019 11:34:54 +0200
Message-Id: <20190802092243.282759182@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b188b03270b7f8568fc714101ce82fbf5e811c5a ]

Handle overlooked case where the target address is assigned to a peer
and neither route nor gateway exist.

For one peer, no checks are performed to see if it is meant to receive
packets for a given address.

As soon as there is a second peer however, checks are performed
to deal with routes and gateways for handling complex setups with
multiple hops to a target address.
This logic assumed that no route and no gateway imply that the
destination address can not be reached, which is false in case of a
direct peer.

Acked-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Tested-by: Michael Scott <mike@foundries.io>
Signed-off-by: Josua Mayer <josua.mayer@jm0.eu>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index de7b82ece499..21096c882223 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -187,10 +187,16 @@ static inline struct lowpan_peer *peer_lookup_dst(struct lowpan_btle_dev *dev,
 	}
 
 	if (!rt) {
-		nexthop = &lowpan_cb(skb)->gw;
-
-		if (ipv6_addr_any(nexthop))
-			return NULL;
+		if (ipv6_addr_any(&lowpan_cb(skb)->gw)) {
+			/* There is neither route nor gateway,
+			 * probably the destination is a direct peer.
+			 */
+			nexthop = daddr;
+		} else {
+			/* There is a known gateway
+			 */
+			nexthop = &lowpan_cb(skb)->gw;
+		}
 	} else {
 		nexthop = rt6_nexthop(rt, daddr);
 
-- 
2.20.1



