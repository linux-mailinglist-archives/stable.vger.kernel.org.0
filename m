Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F99A582E8E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbiG0ROF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238131AbiG0RNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6525B78C;
        Wed, 27 Jul 2022 09:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B1D360D3B;
        Wed, 27 Jul 2022 16:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79991C433D6;
        Wed, 27 Jul 2022 16:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940135;
        bh=QMlouGdUSHtpzVpbNT1n810JgfCBDB50pAHdCH7HfUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6qaPdM/zUPU5HLzE8hYEhQFZ9D/iUNJj2ERHOjl15Pk72IjfSP+qu2by3veba5Q9
         OuVtDzWaOdmzsKeWd9WofJ0VyC2+MrVrk9GPSG2AGE0I9cKdihqweF+kcmasd6TBY5
         KgVD92X0dGFHqlljpSRvcSuMAedRvMqY8G8fIBaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/201] ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.
Date:   Wed, 27 Jul 2022 18:10:22 +0200
Message-Id: <20220727161032.665812955@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 8895a9c2ac76fb9d3922fed4fe092c8ec5e5cccc ]

While reading sysctl_fib_multipath_hash_fields, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: ce5c9c20d364 ("ipv4: Add a sysctl to control multipath hash fields")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 net/ipv4/route.c                                      | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6cdf0e232b1c..55de90d5ae59 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9606,7 +9606,7 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_mp_hash_inner_l3(config);
 		break;
 	case 3:
-		hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+		hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 		/* Outer */
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index ade6cb309c40..ca59b61fd3a3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1929,7 +1929,7 @@ static u32 fib_multipath_custom_hash_outer(const struct net *net,
 					   const struct sk_buff *skb,
 					   bool *p_has_inner)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys keys, hash_keys;
 
 	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
@@ -1958,7 +1958,7 @@ static u32 fib_multipath_custom_hash_inner(const struct net *net,
 					   const struct sk_buff *skb,
 					   bool has_inner)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys keys, hash_keys;
 
 	/* We assume the packet carries an encapsulation, but if none was
@@ -2018,7 +2018,7 @@ static u32 fib_multipath_custom_hash_skb(const struct net *net,
 static u32 fib_multipath_custom_hash_fl4(const struct net *net,
 					 const struct flowi4 *fl4)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys hash_keys;
 
 	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
-- 
2.35.1



