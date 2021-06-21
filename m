Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706AB3AEE3E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhFUQ1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhFUQZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C02F6135D;
        Mon, 21 Jun 2021 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292508;
        bh=JbuhIyJAfer9NYMXoCW3Mmlkoj5LbRexQF9JMmMicYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R26EW/SA63Kq6CpmyOIFAKaybWbzy9nhwxQP4sRKK9sOYoZD9r5KffY8eiCW9apJr
         yJ9FZTZh5iIg3GyblvEfugpARHwbuiivzby59YAi9eHQKlW3sutnwPmeU7tOKyDYQ3
         Z8oClOHlfOnAz0dVmIcYKfLZX3L+FMPF7UGZWQ+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/146] rtnetlink: Fix regression in bridge VLAN configuration
Date:   Mon, 21 Jun 2021 18:14:16 +0200
Message-Id: <20210621154912.160944460@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit d2e381c4963663bca6f30c3b996fa4dbafe8fcb5 ]

Cited commit started returning errors when notification info is not
filled by the bridge driver, resulting in the following regression:

 # ip link add name br1 type bridge vlan_filtering 1
 # bridge vlan add dev br1 vid 555 self pvid untagged
 RTNETLINK answers: Invalid argument

As long as the bridge driver does not fill notification info for the
bridge device itself, an empty notification should not be considered as
an error. This is explained in commit 59ccaaaa49b5 ("bridge: dont send
notification when skb->len == 0 in rtnl_bridge_notify").

Fix by removing the error and add a comment to avoid future bugs.

Fixes: a8db57c1d285 ("rtnetlink: Fix missing error code in rtnl_bridge_notify()")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 83894723ebee..dd4659246405 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4842,10 +4842,12 @@ static int rtnl_bridge_notify(struct net_device *dev)
 	if (err < 0)
 		goto errout;
 
-	if (!skb->len) {
-		err = -EINVAL;
+	/* Notification info is only filled for bridge ports, not the bridge
+	 * device itself. Therefore, a zero notification length is valid and
+	 * should not result in an error.
+	 */
+	if (!skb->len)
 		goto errout;
-	}
 
 	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
 	return 0;
-- 
2.30.2



