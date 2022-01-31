Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247304A44CB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376673AbiAaLcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379429AbiAaLaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:30:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54413C0617BC;
        Mon, 31 Jan 2022 03:20:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A28B82A5C;
        Mon, 31 Jan 2022 11:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED60C340E8;
        Mon, 31 Jan 2022 11:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628038;
        bh=16Eq/lpWWXdcNk6xXNLp8lLAp5bdW0/R1zVW2JRPpCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/n4+rnhVmPE6Zw/gQVje07vpSwemmqzkmUqf7vzyO641VMHG+jcyem4+Qx8QXrBK
         M7Ri0JLiI9R9AcdLvlGKvDoqjfrPjDf/ehwlPVTL++0/NvMKJa6+FLEsXGxlWRbM+l
         AUa+AlSO2230BkvPPytEZ40aoCwtLEEDesuQ0T30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 106/200] ipv6_tunnel: Rate limit warning messages
Date:   Mon, 31 Jan 2022 11:56:09 +0100
Message-Id: <20220131105237.145792058@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit 6cee105e7f2ced596373951d9ea08dacc3883c68 upstream.

The warning messages can be invoked from the data path for every packet
transmitted through an ip6gre netdev, leading to high CPU utilization.

Fix that by rate limiting the messages.

Fixes: 09c6bbf090ec ("[IPV6]: Do mandatory IPv6 tunnel endpoint checks in realtime")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1036,14 +1036,14 @@ int ip6_tnl_xmit_ctl(struct ip6_tnl *t,
 
 		if (unlikely(!ipv6_chk_addr_and_flags(net, laddr, ldev, false,
 						      0, IFA_F_TENTATIVE)))
-			pr_warn("%s xmit: Local address not yet configured!\n",
-				p->name);
+			pr_warn_ratelimited("%s xmit: Local address not yet configured!\n",
+					    p->name);
 		else if (!(p->flags & IP6_TNL_F_ALLOW_LOCAL_REMOTE) &&
 			 !ipv6_addr_is_multicast(raddr) &&
 			 unlikely(ipv6_chk_addr_and_flags(net, raddr, ldev,
 							  true, 0, IFA_F_TENTATIVE)))
-			pr_warn("%s xmit: Routing loop! Remote address found on this node!\n",
-				p->name);
+			pr_warn_ratelimited("%s xmit: Routing loop! Remote address found on this node!\n",
+					    p->name);
 		else
 			ret = 1;
 		rcu_read_unlock();


