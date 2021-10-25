Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCFE43A1A5
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbhJYTkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236994AbhJYTic (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C8E260C4B;
        Mon, 25 Oct 2021 19:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190476;
        bh=XnBsKMRo77dC9aiZbEfpmcyL+1eRXEmIsjIUkI9xPJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBTZpT2+Zf0VIBOwkj/f9fczcnOLdISs83mGxga2aQVEjDzMAthpaGeGH9YqpWjSk
         iuux5Qu6JMTpZCFDAyTAjaWjSCxKS0e/+0AkhC8ZTq1QCkNpYBuJ/Hws6LjhezZ2mw
         BoQtEBKESDSpCfeKsE3eYYfw/QWp+3au60VZwrBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 67/95] net: bridge: mcast: use multicast_membership_interval for IGMPv3
Date:   Mon, 25 Oct 2021 21:15:04 +0200
Message-Id: <20211025191006.633209256@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit fac3cb82a54a4b7c49c932f96ef196cf5774344c upstream.

When I added IGMPv3 support I decided to follow the RFC for computing
the GMI dynamically:
" 8.4. Group Membership Interval

   The Group Membership Interval is the amount of time that must pass
   before a multicast router decides there are no more members of a
   group or a particular source on a network.

   This value MUST be ((the Robustness Variable) times (the Query
   Interval)) plus (one Query Response Interval)."

But that actually is inconsistent with how the bridge used to compute it
for IGMPv2, where it was user-configurable that has a correct default value
but it is up to user-space to maintain it. This would make it consistent
with the other timer values which are also maintained correct by the user
instead of being dynamically computed. It also changes back to the previous
user-expected GMI behaviour for IGMPv3 queries which were supported before
IGMPv3 was added. Note that to properly compute it dynamically we would
need to add support for "Robustness Variable" which is currently missing.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: 0436862e417e ("net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOURCES report")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_private.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -931,9 +931,7 @@ static inline unsigned long br_multicast
 
 static inline unsigned long br_multicast_gmi(const struct net_bridge *br)
 {
-	/* use the RFC default of 2 for QRV */
-	return 2 * br->multicast_query_interval +
-	       br->multicast_query_response_interval;
+	return br->multicast_membership_interval;
 }
 #else
 static inline int br_multicast_rcv(struct net_bridge *br,


