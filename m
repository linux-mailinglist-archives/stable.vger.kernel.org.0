Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7012ED41
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgABW0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729635AbgABW0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:26:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D06222253D;
        Thu,  2 Jan 2020 22:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003983;
        bh=4cj++FVsf3T8jdjkxRESByTCeCSbAi1bhmBHuAKL6Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsIiuMt7CLTnLQj5NPfW5EefK9sMCfQtTipMme2uaIEnOIp/a0gX36U0nXYbPljJD
         l547u+TQXQihJtmjXV9zqzOfZ9MjlAWs68+8avyJVOS1WUzqYB4AOv6K8C9uk0rhkV
         Oz7L4fpMRQ6y4XeSnQkTlR6hINcjrPOf1nb6cews=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 80/91] ip6_gre: do not confirm neighbor when do pmtu update
Date:   Thu,  2 Jan 2020 23:08:02 +0100
Message-Id: <20200102220449.619515237@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 675d76ad0ad5bf41c9a129772ef0aba8f57ea9a7 ]

When we do ipv6 gre pmtu update, we will also do neigh confirm currently.
This will cause the neigh cache be refreshed and set to REACHABLE before
xmit.

But if the remote mac address changed, e.g. device is deleted and recreated,
we will not able to notice this and still use the old mac address as the neigh
cache is REACHABLE.

Fix this by disable neigh confirm when do pmtu update

v5: No change.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reported-by: Jianlin Shi <jishi@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -527,7 +527,7 @@ static netdev_tx_t __gre6_xmit(struct sk
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (dst && dst_mtu(dst) > dst->dev->mtu)
-		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, true);
+		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, false);
 
 	return ip6_tnl_xmit(skb, dev, dsfield, fl6, encap_limit, pmtu,
 			    NEXTHDR_GRE);


