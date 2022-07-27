Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4493582EB1
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbiG0RQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241897AbiG0ROo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:14:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7835378208;
        Wed, 27 Jul 2022 09:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 255BFB821A6;
        Wed, 27 Jul 2022 16:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CA4C433C1;
        Wed, 27 Jul 2022 16:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940171;
        bh=Tw6UWWkLeLNhHN4n5Og//nBQliGEATcfi0b3897XIO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VA3U2LDjuDHisz5cmwhw/91Oy0a72eTBQmXOVFFQFmMMucWxE2FY27SFFSiQ25w5q
         25bUJ1M2s0F3E7f1sBVaErMoGREgSmHw8LEsv7wquHYzJeqRB26afRdXKBt0TZiWSu
         fCjZxtISQtNCrISkmKtcVzbpZ1kbcAr9LKGKOBMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/201] tcp: Fix data-races around sysctl_tcp_max_reordering.
Date:   Wed, 27 Jul 2022 18:10:34 +0200
Message-Id: <20220727161033.171437127@linuxfoundation.org>
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
index 6309a4eb3acd..2d21d8bf3b8c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1043,7 +1043,7 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 			 tp->undo_marker ? tp->undo_retrans : 0);
 #endif
 		tp->reordering = min_t(u32, (metric + mss - 1) / mss,
-				       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+				       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	}
 
 	/* This exciting event is worth to be remembered. 8) */
@@ -2022,7 +2022,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 		return;
 
 	tp->reordering = min_t(u32, tp->packets_out + addend,
-			       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	tp->reord_seen++;
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRENOREORDER);
 }
-- 
2.35.1



