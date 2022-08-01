Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FBA5869B6
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiHAMFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiHAMFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:05:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797933DBC9;
        Mon,  1 Aug 2022 04:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04441B81177;
        Mon,  1 Aug 2022 11:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607D3C433D6;
        Mon,  1 Aug 2022 11:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354877;
        bh=QCM+pkoBB3k0TyrYAg7KgYY8WjHYnJqZJO075BhLf2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHc9dFVxKxx6Th2YhTD3/u44JeuKGHjLIEwsKJaKACQgWKqQOg6WBhHLIP1ukPqMU
         9YnRrCxkFPePC930LUDYE91f/Vcpgh9BCPV74IKjZRtUOKR0V4CgC525oJZUaDoLkf
         HQtvoD4zrplJgYsFSabW9p/H+PpuohLbY5GC9Z6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 53/69] ipv4: Fix data-races around sysctl_fib_notify_on_flag_change.
Date:   Mon,  1 Aug 2022 13:47:17 +0200
Message-Id: <20220801114136.635281463@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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

[ Upstream commit 96b9bd8c6d125490f9adfb57d387ef81a55a103e ]

While reading sysctl_fib_notify_on_flag_change, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_trie.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index a9cd9c2bd84e..19c6e7b93d3d 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1037,6 +1037,7 @@ fib_find_matching_alias(struct net *net, const struct fib_rt_info *fri)
 
 void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 {
+	u8 fib_notify_on_flag_change;
 	struct fib_alias *fa_match;
 	struct sk_buff *skb;
 	int err;
@@ -1058,14 +1059,16 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	WRITE_ONCE(fa_match->offload, fri->offload);
 	WRITE_ONCE(fa_match->trap, fri->trap);
 
+	fib_notify_on_flag_change = READ_ONCE(net->ipv4.sysctl_fib_notify_on_flag_change);
+
 	/* 2 means send notifications only if offload_failed was changed. */
-	if (net->ipv4.sysctl_fib_notify_on_flag_change == 2 &&
+	if (fib_notify_on_flag_change == 2 &&
 	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
 	WRITE_ONCE(fa_match->offload_failed, fri->offload_failed);
 
-	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
+	if (!fib_notify_on_flag_change)
 		goto out;
 
 	skb = nlmsg_new(fib_nlmsg_size(fa_match->fa_info), GFP_ATOMIC);
-- 
2.35.1



