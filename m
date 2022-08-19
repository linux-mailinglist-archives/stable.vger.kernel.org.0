Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735A459A06B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352031AbiHSQS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352193AbiHSQPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:15:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED9910446F;
        Fri, 19 Aug 2022 08:59:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 098BF61644;
        Fri, 19 Aug 2022 15:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C64C433C1;
        Fri, 19 Aug 2022 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924744;
        bh=u0HsNN8rMYruFAvZHEvP0r2fe53rUhzO3lCv1NuR+A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGtQfe/FHZCT3gNwIS08lh92af1Nta7SuYB2DpwedsgvlKSo8t5TwATegNIteeSvH
         UltlNxusgzc4p5J0vIunJ+IFp9ZmFDaZVB/sNMws03jNazbWdA12cYUZXn8AZ/46eF
         gsOiP6XhIo5kdXrs6hTa4wbwnPcG4PrdQDDNvmFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/545] wireguard: allowedips: dont corrupt stack when detecting overflow
Date:   Fri, 19 Aug 2022 17:40:38 +0200
Message-Id: <20220819153841.324199211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit c31b14d86dfe7174361e8c6e5df6c2c3a4d5918c ]

In case push_rcu() and related functions are buggy, there's a
WARN_ON(len >= 128), which the selftest tries to hit by being tricky. In
case it is hit, we shouldn't corrupt the kernel's stack, though;
otherwise it may be hard to even receive the report that it's buggy. So
conditionalize the stack write based on that WARN_ON()'s return value.

Note that this never *actually* happens anyway. The WARN_ON() in the
first place is bounded by IS_ENABLED(DEBUG), and isn't expected to ever
actually hit. This is just a debugging sanity check.

Additionally, hoist the constant 128 into a named enum,
MAX_ALLOWEDIPS_BITS, so that it's clear why this value is chosen.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/all/CAHk-=wjJZGA6w_DxA+k7Ejbqsq+uGK==koPai3sqdsfJqemvag@mail.gmail.com/
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/allowedips.c          | 9 ++++++---
 drivers/net/wireguard/selftest/allowedips.c | 6 +++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 9a4c8ff32d9d..5bf7822c53f1 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -6,6 +6,8 @@
 #include "allowedips.h"
 #include "peer.h"
 
+enum { MAX_ALLOWEDIPS_BITS = 128 };
+
 static struct kmem_cache *node_cache;
 
 static void swap_endian(u8 *dst, const u8 *src, u8 bits)
@@ -40,7 +42,8 @@ static void push_rcu(struct allowedips_node **stack,
 		     struct allowedips_node __rcu *p, unsigned int *len)
 {
 	if (rcu_access_pointer(p)) {
-		WARN_ON(IS_ENABLED(DEBUG) && *len >= 128);
+		if (WARN_ON(IS_ENABLED(DEBUG) && *len >= MAX_ALLOWEDIPS_BITS))
+			return;
 		stack[(*len)++] = rcu_dereference_raw(p);
 	}
 }
@@ -52,7 +55,7 @@ static void node_free_rcu(struct rcu_head *rcu)
 
 static void root_free_rcu(struct rcu_head *rcu)
 {
-	struct allowedips_node *node, *stack[128] = {
+	struct allowedips_node *node, *stack[MAX_ALLOWEDIPS_BITS] = {
 		container_of(rcu, struct allowedips_node, rcu) };
 	unsigned int len = 1;
 
@@ -65,7 +68,7 @@ static void root_free_rcu(struct rcu_head *rcu)
 
 static void root_remove_peer_lists(struct allowedips_node *root)
 {
-	struct allowedips_node *node, *stack[128] = { root };
+	struct allowedips_node *node, *stack[MAX_ALLOWEDIPS_BITS] = { root };
 	unsigned int len = 1;
 
 	while (len > 0 && (node = stack[--len])) {
diff --git a/drivers/net/wireguard/selftest/allowedips.c b/drivers/net/wireguard/selftest/allowedips.c
index e173204ae7d7..41db10f9be49 100644
--- a/drivers/net/wireguard/selftest/allowedips.c
+++ b/drivers/net/wireguard/selftest/allowedips.c
@@ -593,10 +593,10 @@ bool __init wg_allowedips_selftest(void)
 	wg_allowedips_remove_by_peer(&t, a, &mutex);
 	test_negative(4, a, 192, 168, 0, 1);
 
-	/* These will hit the WARN_ON(len >= 128) in free_node if something
-	 * goes wrong.
+	/* These will hit the WARN_ON(len >= MAX_ALLOWEDIPS_BITS) in free_node
+	 * if something goes wrong.
 	 */
-	for (i = 0; i < 128; ++i) {
+	for (i = 0; i < MAX_ALLOWEDIPS_BITS; ++i) {
 		part = cpu_to_be64(~(1LLU << (i % 64)));
 		memset(&ip, 0xff, 16);
 		memcpy((u8 *)&ip + (i < 64) * 8, &part, 8);
-- 
2.35.1



