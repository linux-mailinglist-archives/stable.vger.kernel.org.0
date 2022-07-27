Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA2B5830C3
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242769AbiG0Rlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242754AbiG0RlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:41:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B62788F04;
        Wed, 27 Jul 2022 09:51:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37039B821BE;
        Wed, 27 Jul 2022 16:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E357C433C1;
        Wed, 27 Jul 2022 16:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940690;
        bh=8bZ0b7bWiHjQAOrjYWtzLe7K+pj3Y+wOjeW+dTBZ99o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O86Xt74J3e0oOTxZ4lMV5PMcuABrOIhbBcY18Cytr0FsxiWsWOwadZgWsN8waG4NW
         CIDsLDzmMnliSdsoKFTZmF6pfbEPycXNTTk/xarfXqQYMy25pdyTvoT3fBeeZaY5AF
         Aq2Mwg+jMKN3h2m2ajWFmEJ+dAXIyf1s7PN+HcZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 114/158] ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.
Date:   Wed, 27 Jul 2022 18:12:58 +0200
Message-Id: <20220727161026.048539202@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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
index 6bcb0f1b0816..c00d6c4ed37c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10281,7 +10281,7 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_mp_hash_inner_l3(config);
 		break;
 	case 3:
-		hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+		hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 		/* Outer */
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 907cb11cbea5..02a0a397a2f3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1928,7 +1928,7 @@ static u32 fib_multipath_custom_hash_outer(const struct net *net,
 					   const struct sk_buff *skb,
 					   bool *p_has_inner)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys keys, hash_keys;
 
 	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
@@ -1957,7 +1957,7 @@ static u32 fib_multipath_custom_hash_inner(const struct net *net,
 					   const struct sk_buff *skb,
 					   bool has_inner)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys keys, hash_keys;
 
 	/* We assume the packet carries an encapsulation, but if none was
@@ -2017,7 +2017,7 @@ static u32 fib_multipath_custom_hash_skb(const struct net *net,
 static u32 fib_multipath_custom_hash_fl4(const struct net *net,
 					 const struct flowi4 *fl4)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys hash_keys;
 
 	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
-- 
2.35.1



