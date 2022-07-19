Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D9E579A56
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbiGSMNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238948AbiGSMMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF49474E9;
        Tue, 19 Jul 2022 05:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B143EB81B32;
        Tue, 19 Jul 2022 12:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D47C341C6;
        Tue, 19 Jul 2022 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232233;
        bh=o5U7igLke337Ep7nyfJCFAfHS2q9vvxycoNcd3ZqOCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYltjtvkAE5pGG5nt48tteIOwcMvt1edRq1xLEldhXey4X3GdymPQJh6SVob0FeyX
         k6wyyqhZQhIat6JNvUpggHYo0DRFSeMkHrbuG8Vg13e3O2yi/ggscMF5EhoZqHrJrU
         k7KKw/4JEBFCek9Bdqr++KtAZizyIiCi5stcvzdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/71] ipv4: Fix a data-race around sysctl_fib_sync_mem.
Date:   Tue, 19 Jul 2022 13:53:53 +0200
Message-Id: <20220719114555.238251125@linuxfoundation.org>
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
index 51673d00bbea..a1f830da4ad3 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -500,7 +500,7 @@ static void tnode_free(struct key_vector *tn)
 		tn = container_of(head, struct tnode, rcu)->kv;
 	}
 
-	if (tnode_free_size >= sysctl_fib_sync_mem) {
+	if (tnode_free_size >= READ_ONCE(sysctl_fib_sync_mem)) {
 		tnode_free_size = 0;
 		synchronize_rcu();
 	}
-- 
2.35.1



