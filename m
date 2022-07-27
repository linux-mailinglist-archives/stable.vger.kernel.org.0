Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A756F582CEC
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbiG0QwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiG0QwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5066454656;
        Wed, 27 Jul 2022 09:33:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E147B61A73;
        Wed, 27 Jul 2022 16:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E885DC433D6;
        Wed, 27 Jul 2022 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939632;
        bh=Vtrb3hA6GkN7VLsNOm4H7j5c2K8Sro92wFOX7ixBafA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEMKTy94Goaj3Png2da0C0zVT9pgHt5cq3edKKpFhItysiex+vmjWA8gqJxiE4nyX
         KKL6hJ+5ABp3H6hFeMPIXjvUiLefs8ova4t5plBwB7U4s+wj1iDhHFyx1v+XOXia4k
         jZLr+zI7ywWFxO/9d7XN1PKbJCfuBimWu7X6yEJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/105] tcp: Fix data-races around keepalive sysctl knobs.
Date:   Wed, 27 Jul 2022 18:10:34 +0200
Message-Id: <20220727161013.995516807@linuxfoundation.org>
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

[ Upstream commit f2f316e287e6c2e3a1c5bab8d9b77ee03daa0463 ]

While reading sysctl_tcp_keepalive_(time|probes|intvl), they can be changed
concurrently.  Thus, we need to add READ_ONCE() to their readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 9 ++++++---
 net/smc/smc_llc.c | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 2a28e0925573..9ef9fd0677b5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1447,21 +1447,24 @@ static inline int keepalive_intvl_when(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
 
-	return tp->keepalive_intvl ? : net->ipv4.sysctl_tcp_keepalive_intvl;
+	return tp->keepalive_intvl ? :
+		READ_ONCE(net->ipv4.sysctl_tcp_keepalive_intvl);
 }
 
 static inline int keepalive_time_when(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
 
-	return tp->keepalive_time ? : net->ipv4.sysctl_tcp_keepalive_time;
+	return tp->keepalive_time ? :
+		READ_ONCE(net->ipv4.sysctl_tcp_keepalive_time);
 }
 
 static inline int keepalive_probes(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
 
-	return tp->keepalive_probes ? : net->ipv4.sysctl_tcp_keepalive_probes;
+	return tp->keepalive_probes ? :
+		READ_ONCE(net->ipv4.sysctl_tcp_keepalive_probes);
 }
 
 static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index ee1f0fdba085..0ef15f8fba90 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1787,7 +1787,7 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 	init_waitqueue_head(&lgr->llc_flow_waiter);
 	init_waitqueue_head(&lgr->llc_msg_waiter);
 	mutex_init(&lgr->llc_conf_mutex);
-	lgr->llc_testlink_time = net->ipv4.sysctl_tcp_keepalive_time;
+	lgr->llc_testlink_time = READ_ONCE(net->ipv4.sysctl_tcp_keepalive_time);
 }
 
 /* called after lgr was removed from lgr_list */
-- 
2.35.1



