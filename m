Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3D4A40C7
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348383AbiAaLAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:00:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60464 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358392AbiAaK73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:59:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F6A560A75;
        Mon, 31 Jan 2022 10:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D745C340E8;
        Mon, 31 Jan 2022 10:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626768;
        bh=hIfUf3yN1UNeN2vT8cU48/YWdF/Y5IljBCJYrJJAObw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KW62loPjZ7aGyngYfcTL7pSMSaRyiwcrA+v/0Xg3oDaL44Avfec/j+ORItfvncVXI
         7eW7HaHaKYmSknMMVKS+YedaMlH4Hm39D8XX0xGKpv6oB2ZsFA38UUT+eRp/b/PuMa
         MZ0FUG51yY5EJqkLG4w6nVmyFpwbTLnY0f+8tf5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/64] ipv6_tunnel: Rate limit warning messages
Date:   Mon, 31 Jan 2022 11:56:17 +0100
Message-Id: <20220131105216.758612243@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
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
@@ -1000,14 +1000,14 @@ int ip6_tnl_xmit_ctl(struct ip6_tnl *t,
 
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


