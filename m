Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4145A49C7
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiH2L3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiH2L3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066C97A745;
        Mon, 29 Aug 2022 04:17:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F58B80F10;
        Mon, 29 Aug 2022 11:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1DFC433C1;
        Mon, 29 Aug 2022 11:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771235;
        bh=yjoZOiEcvdnTyVB/vFAkaEAvDwwad/7SbJUYxTfTwBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coHuRp3gXTLNNKa/hLQLyUuHvXBEF5rcxbjPRiuQGiXxZYtYmureWJGiOA59oo/F4
         ZnhK4CdJK3XlkRXNl/H4J+jXtH9/7mfpdLkR6sjidbMxyywppaOQlMPkuJJN3ZpxOb
         4+XXoRXw4+F4M6B909wesUyNbXPbaZjK1ZSC+lv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/136] net: Fix data-races around sysctl_max_skb_frags.
Date:   Mon, 29 Aug 2022 12:59:09 +0200
Message-Id: <20220829105808.008903886@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 657b991afb89d25fe6c4783b1b75a8ad4563670d ]

While reading sysctl_max_skb_frags, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 5f74f82ea34c ("net:Add sysctl_max_skb_frags")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c       | 4 ++--
 net/mptcp/protocol.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 52f51717f02f3..0ebef2a5950cd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -991,7 +991,7 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 
 	i = skb_shinfo(skb)->nr_frags;
 	can_coalesce = skb_can_coalesce(skb, i, page, offset);
-	if (!can_coalesce && i >= sysctl_max_skb_frags) {
+	if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
 		tcp_mark_push(tp, skb);
 		goto new_segment;
 	}
@@ -1344,7 +1344,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			if (!skb_can_coalesce(skb, i, pfrag->page,
 					      pfrag->offset)) {
-				if (i >= sysctl_max_skb_frags) {
+				if (i >= READ_ONCE(sysctl_max_skb_frags)) {
 					tcp_mark_push(tp, skb);
 					goto new_segment;
 				}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a089791414bfb..5df60a4b09304 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1317,7 +1317,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
 		i = skb_shinfo(skb)->nr_frags;
 		can_coalesce = skb_can_coalesce(skb, i, dfrag->page, offset);
-		if (!can_coalesce && i >= sysctl_max_skb_frags) {
+		if (!can_coalesce && i >= READ_ONCE(sysctl_max_skb_frags)) {
 			tcp_mark_push(tcp_sk(ssk), skb);
 			goto alloc_skb;
 		}
-- 
2.35.1



