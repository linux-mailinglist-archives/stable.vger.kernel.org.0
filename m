Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F781582B5E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbiG0Qc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiG0QcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:32:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD6652FCB;
        Wed, 27 Jul 2022 09:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0007FB821BF;
        Wed, 27 Jul 2022 16:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58435C43140;
        Wed, 27 Jul 2022 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939136;
        bh=Ah/hhKtg8RhQI3Os/uogsJTfd+tyUxBuQgNvDHm/FgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJx3f9KzrxlNlWUdTEz5KF4YsKO9vnmm/5qIDESWgL7TvPaFvCg6oMqPKliLUIF2K
         Tu8tzwJ2O7pi1ui5JroK/z9ru4m+3jjr0yuiHXQZXGrze4cGSwtD3XwY4YZ98QDgAh
         npXrqa2PGTB9IILcth6jAywkMj0velmPR/wT/itE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/62] tcp: Fix data-races around sysctl_tcp_recovery.
Date:   Wed, 27 Jul 2022 18:10:35 +0200
Message-Id: <20220727161005.221488139@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
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
index afe195e03a95..731c4d220905 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1938,7 +1938,8 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
 
 static bool tcp_is_rack(const struct sock *sk)
 {
-	return sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION;
+	return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		TCP_RACK_LOSS_DETECTION;
 }
 
 /* If we detect SACK reneging, forget all SACK information
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 0d96decba13d..61969bb9395c 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -33,7 +33,8 @@ static u32 tcp_rack_reo_wnd(const struct sock *sk)
 			return 0;
 
 		if (tp->sacked_out >= tp->reordering &&
-		    !(sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_NO_DUPTHRESH))
+		    !(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		      TCP_RACK_NO_DUPTHRESH))
 			return 0;
 	}
 
@@ -203,7 +204,8 @@ void tcp_rack_update_reo_wnd(struct sock *sk, struct rate_sample *rs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_STATIC_REO_WND ||
+	if ((READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+	     TCP_RACK_STATIC_REO_WND) ||
 	    !rs->prior_delivered)
 		return;
 
-- 
2.35.1



