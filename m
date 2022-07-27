Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B22582E95
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiG0ROz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241583AbiG0RNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:13:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1CB5B79F;
        Wed, 27 Jul 2022 09:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1914601CE;
        Wed, 27 Jul 2022 16:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A880BC433C1;
        Wed, 27 Jul 2022 16:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940133;
        bh=l1ue5a0jyDSRmPddXPGgCmTdqIau5TtnOYUWQww6OZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pu33QJ+LBJ1Z6PVTe+RvOZVl8+Dep7Uz+nwWn6HD6yQi0yw9N7I+m738ACwNR/4P0
         i8ccO6CTlTVeiRSELqmvciQPYUIleuNE16hHffdDxlfcIZ+LtotBc3/N6bf6TAt2gL
         vUQGTvT/g8YLD7DWnLkt3tRLkPwF8sKdLJqWl3us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/201] ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.
Date:   Wed, 27 Jul 2022 18:10:21 +0200
Message-Id: <20220727161032.626425136@linuxfoundation.org>
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

[ Upstream commit 7998c12a08c97cc26660532c9f90a34bd7d8da5a ]

While reading sysctl_fib_multipath_hash_policy, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: bf4e0a3db97e ("net: ipv4: add support for ECMP hash policy choice")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 net/ipv4/route.c                                      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d17156c11ef8..6cdf0e232b1c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9588,7 +9588,7 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 	unsigned long *fields = config->fields;
 	u32 hash_fields;
 
-	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	switch (READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_policy)) {
 	case 0:
 		mlxsw_sp_mp4_hash_outer_addr(config);
 		break;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 7f08a30256c5..ade6cb309c40 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2048,7 +2048,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 	struct flow_keys hash_keys;
 	u32 mhash = 0;
 
-	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	switch (READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_policy)) {
 	case 0:
 		memset(&hash_keys, 0, sizeof(hash_keys));
 		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
-- 
2.35.1



