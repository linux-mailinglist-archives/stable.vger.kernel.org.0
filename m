Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E336579AD4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbiGSMUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239750AbiGSMTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:19:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CCE599CD;
        Tue, 19 Jul 2022 05:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 928D0B81B2D;
        Tue, 19 Jul 2022 12:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E549BC341CA;
        Tue, 19 Jul 2022 12:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232429;
        bh=odMzcP6B526YaN5bzmYNomjGHeZ1A39Dsgl49anFcoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fc6DqNeUE1K5ktPIFsAWveRDu1OROCknzZ7DKZdqG9ShguBEcrLL1Y8Ujmj5Q5XmS
         uowloNA8ZZASGJYKidftvgFO9aNNmoVoSEdM9+6jp4+0YkvQiZs4KPDG3i0WZE2CRj
         90eP8fADPdQsi0nlsKX9B9N8gEOVUWdeKl13kTj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/112] ipv4: Fix a data-race around sysctl_fib_sync_mem.
Date:   Tue, 19 Jul 2022 13:53:46 +0200
Message-Id: <20220719114631.578554321@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
index ffc5332f1390..a28f525e2c47 100644
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



