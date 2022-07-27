Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B1C5830B9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbiG0RlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbiG0Rk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEE961D98;
        Wed, 27 Jul 2022 09:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE40960D3B;
        Wed, 27 Jul 2022 16:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4514C433D6;
        Wed, 27 Jul 2022 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940687;
        bh=sSY7dCyFkJhDPqPhL1QYXNCCoC4XKFtB7Dmnqf7/TrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spExzINp1Zbt6DUE3nMx8X7pJNEW326ZMW7RUXWbd6SGIcgK0qKDmXwo9u6K8OFmw
         PBnGkc7cpWqIA6GyQONZSMPvWOzQ6MOyBFOeXZtjG+J/kydMs1zN5+qzp3HwejTwBB
         kqFO6FvekcDHelseYnYwjI0GS0wmIarUie2cdA+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 113/158] ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.
Date:   Wed, 27 Jul 2022 18:12:57 +0200
Message-Id: <20220727161025.999900903@linuxfoundation.org>
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
index 994bd2e14e55..6bcb0f1b0816 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10263,7 +10263,7 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 	unsigned long *fields = config->fields;
 	u32 hash_fields;
 
-	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	switch (READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_policy)) {
 	case 0:
 		mlxsw_sp_mp4_hash_outer_addr(config);
 		break;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 8363e575c455..907cb11cbea5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2047,7 +2047,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 	struct flow_keys hash_keys;
 	u32 mhash = 0;
 
-	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	switch (READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_policy)) {
 	case 0:
 		memset(&hash_keys, 0, sizeof(hash_keys));
 		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
-- 
2.35.1



