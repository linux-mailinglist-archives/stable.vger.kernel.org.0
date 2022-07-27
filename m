Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2202C5830D9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242944AbiG0RnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbiG0Rmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:42:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6349D62A45;
        Wed, 27 Jul 2022 09:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC70C61748;
        Wed, 27 Jul 2022 16:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0727EC433D6;
        Wed, 27 Jul 2022 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940728;
        bh=nE0ZGl0fvIwXNuurVCSkbU/ykXts7IWIG215q8LiHyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zByXmEdf08SAp6mADNcxqDedl5VDrvAZCwqe+EgiXppWI3du+Wrk1amIHIRHgHB6J
         fgnSoRjubS086bbE6PCiNVeNN5X4Ptni1vDqOl2m0gLYc/dw7rVxMEr2xo/hat+fiu
         RSyFrdKB/DuzHUKM1kPBkiYx2Th+Ym199CHKv4+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 126/158] tcp: Fix data-races around sysctl_tcp_max_reordering.
Date:   Wed, 27 Jul 2022 18:13:10 +0200
Message-Id: <20220727161026.462814413@linuxfoundation.org>
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
index f200dd654e05..19b186a4a8e8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1051,7 +1051,7 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 			 tp->undo_marker ? tp->undo_retrans : 0);
 #endif
 		tp->reordering = min_t(u32, (metric + mss - 1) / mss,
-				       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+				       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	}
 
 	/* This exciting event is worth to be remembered. 8) */
@@ -2030,7 +2030,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 		return;
 
 	tp->reordering = min_t(u32, tp->packets_out + addend,
-			       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	tp->reord_seen++;
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRENOREORDER);
 }
-- 
2.35.1



