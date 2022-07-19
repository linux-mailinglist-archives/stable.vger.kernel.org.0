Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B15579A0E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbiGSMK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238841AbiGSMJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:09:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36A1509EB;
        Tue, 19 Jul 2022 05:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAB3AB81B1A;
        Tue, 19 Jul 2022 12:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12225C341C6;
        Tue, 19 Jul 2022 12:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232161;
        bh=6RR38/EO1Yf7uvlde6hC/b2KINkzaAPGRa+sJ5gwtM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swdyifoThLUZtciVG2PEppap4Gp8VHB3XiVxvK5ytKF8/a1FLzQpvQA2oZodnwEmh
         Zld3zBuuQqmhMwyA7YY9r8bFLNnpurAaFkuVPJUuuxPaixxTLeVaS++0l3HAff4nyl
         DgcsMhTk1X1J2BIQguhoTubDri6iTCbdsrBQbYU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/71] icmp: Fix a data-race around sysctl_icmp_ratelimit.
Date:   Tue, 19 Jul 2022 13:53:57 +0200
Message-Id: <20220719114555.600277625@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 2a4eb714841f288cf51c7d942d98af6a8c6e4b01 ]

While reading sysctl_icmp_ratelimit, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index a590ff81e5f8..e05e972445fe 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -328,7 +328,8 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 
 	vif = l3mdev_master_ifindex(dst->dev);
 	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif, 1);
-	rc = inet_peer_xrlim_allow(peer, net->ipv4.sysctl_icmp_ratelimit);
+	rc = inet_peer_xrlim_allow(peer,
+				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
 	if (peer)
 		inet_putpeer(peer);
 out:
-- 
2.35.1



