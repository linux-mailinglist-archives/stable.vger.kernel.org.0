Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E0E582D31
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbiG0QyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240864AbiG0Qwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC94A4D17D;
        Wed, 27 Jul 2022 09:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A6B661A24;
        Wed, 27 Jul 2022 16:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930F3C433D6;
        Wed, 27 Jul 2022 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939690;
        bh=HyQgHOeOFZ3XVC2J1qYJZurG46tm1pEbA9bEGX1Ibdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAMRoBzNCIGmVZY4NrlD/Uj26qlNuy1B239GZVsMY8xFLaMoC5K98MwAx0Iac4ttA
         qzbArAvv2/vv2ZxQL71jOtT9HAm1bPLsxvs0pZ19CZIQEKw9syU2yb8CPc5C+NUOgg
         /xq+b4puh7R9Go+PEFwnMsbS7AV9A9wxGNRfAndU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/105] tcp: Fix data-races around sysctl_tcp_recovery.
Date:   Wed, 27 Jul 2022 18:10:56 +0200
Message-Id: <20220727161014.859504799@linuxfoundation.org>
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

[ Upstream commit e7d2ef837e14a971a05f60ea08c47f3fed1a36e4 ]

While reading sysctl_tcp_recovery, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 4f41b1c58a32 ("tcp: use RACK to detect losses")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c    | 3 ++-
 net/ipv4/tcp_recovery.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8ac3acde08b4..1dc1d62093b3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2055,7 +2055,8 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
 
 static bool tcp_is_rack(const struct sock *sk)
 {
-	return sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION;
+	return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		TCP_RACK_LOSS_DETECTION;
 }
 
 /* If we detect SACK reneging, forget all SACK information
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 31fc178f42c0..21fc9859d421 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -19,7 +19,8 @@ static u32 tcp_rack_reo_wnd(const struct sock *sk)
 			return 0;
 
 		if (tp->sacked_out >= tp->reordering &&
-		    !(sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_NO_DUPTHRESH))
+		    !(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		      TCP_RACK_NO_DUPTHRESH))
 			return 0;
 	}
 
@@ -190,7 +191,8 @@ void tcp_rack_update_reo_wnd(struct sock *sk, struct rate_sample *rs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_STATIC_REO_WND ||
+	if ((READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+	     TCP_RACK_STATIC_REO_WND) ||
 	    !rs->prior_delivered)
 		return;
 
-- 
2.35.1



