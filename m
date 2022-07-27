Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A04582D37
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiG0QzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240929AbiG0Qx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63DAE018;
        Wed, 27 Jul 2022 09:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7762661A8E;
        Wed, 27 Jul 2022 16:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ED3C433D6;
        Wed, 27 Jul 2022 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939709;
        bh=M6AONKyL0tFCZ5RKN2Eas+gEs2kZW2p0VNpEZVYJ17Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4l1R5IPXAIapKEbkislQpBERZl7TPQ2+HQVZudu4mE4gM9/vRAtCVzD6IA+q5tA4
         vFaoEllIFQTZSgflvSedk2hnfbimwznsaZX9R1ANFjscrX+TU4p5Jil8Kn6xiOiVvk
         DT3P5nwfk+geqJ8ntFtA1KJ5A1+WqhTgcGRg4vck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/105] tcp: Fix data-races around sysctl_tcp_max_reordering.
Date:   Wed, 27 Jul 2022 18:11:02 +0200
Message-Id: <20220727161015.113093328@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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

[ Upstream commit a11e5b3e7a59fde1a90b0eaeaa82320495cf8cae ]

While reading sysctl_tcp_max_reordering, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: dca145ffaa8d ("tcp: allow for bigger reordering level")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c89452761b3f..d817f8c31c9c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1011,7 +1011,7 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 			 tp->undo_marker ? tp->undo_retrans : 0);
 #endif
 		tp->reordering = min_t(u32, (metric + mss - 1) / mss,
-				       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+				       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	}
 
 	/* This exciting event is worth to be remembered. 8) */
@@ -1990,7 +1990,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 		return;
 
 	tp->reordering = min_t(u32, tp->packets_out + addend,
-			       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	tp->reord_seen++;
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRENOREORDER);
 }
-- 
2.35.1



