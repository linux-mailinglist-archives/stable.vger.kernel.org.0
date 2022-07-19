Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D15579C06
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240527AbiGSMfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241181AbiGSMew (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420EC41D30;
        Tue, 19 Jul 2022 05:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7716617D4;
        Tue, 19 Jul 2022 12:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86978C341C6;
        Tue, 19 Jul 2022 12:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232779;
        bh=f9wDmODJ/BHd1ZbKTvLQBAdz9tLg5avMDweuF9WygG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HlVj4jKAynBCtNQ93dLi9mUNHAdZuCiAYRNaRR9ztPe65c6ywV9C6kmfzrHlO8G4
         yrqpEItyk5OwDahNuLGHddbfmm/s02OZ8gQ8yzbMuGxgYipCaeLgOt+0Ps+VSCYnku
         NTEOrP3oPOOm+5ZlOSm61tMMPLBYyXU35jYsbF7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/167] ipv4: Fix a data-race around sysctl_fib_sync_mem.
Date:   Tue, 19 Jul 2022 13:53:14 +0200
Message-Id: <20220719114702.552291994@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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

[ Upstream commit 73318c4b7dbd0e781aaababff17376b2894745c0 ]

While reading sysctl_fib_sync_mem, it can be changed concurrently.
So, we need to add READ_ONCE() to avoid a data-race.

Fixes: 9ab948a91b2c ("ipv4: Allow amount of dirty memory from fib resizing to be controllable")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_trie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index f7f74d5c14da..a9cd9c2bd84e 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -497,7 +497,7 @@ static void tnode_free(struct key_vector *tn)
 		tn = container_of(head, struct tnode, rcu)->kv;
 	}
 
-	if (tnode_free_size >= sysctl_fib_sync_mem) {
+	if (tnode_free_size >= READ_ONCE(sysctl_fib_sync_mem)) {
 		tnode_free_size = 0;
 		synchronize_rcu();
 	}
-- 
2.35.1



