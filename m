Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284AE4ABB09
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357514AbiBGLZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380053AbiBGLQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:16:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFD3C043181;
        Mon,  7 Feb 2022 03:16:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA79B6126D;
        Mon,  7 Feb 2022 11:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D25C004E1;
        Mon,  7 Feb 2022 11:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232591;
        bh=o/ZNOAPcIGvXq3/CIUTi7zup2mMwGX6Ts/hJORWowYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rt9gjz05EcTvsV74nJi0B4M1/3TYh/EdX31T5+MGtBSCGATG4ExuvxYvqPoIyZMLt
         ObUwo6NeX21c+KHvwtjdWWJzTts67kPiz4p3FGiz5D/EG1+lLl5J4tqIqbNS/rcRPm
         30PNlrMhJ4tzk2qSBlTanLlgdoeQihfK73s5WYuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/86] ipv6_tunnel: Rate limit warning messages
Date:   Mon,  7 Feb 2022 12:05:50 +0100
Message-Id: <20220207103758.429629742@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -1005,14 +1005,14 @@ int ip6_tnl_xmit_ctl(struct ip6_tnl *t,
 
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


