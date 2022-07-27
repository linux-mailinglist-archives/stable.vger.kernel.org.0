Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D18582E59
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbiG0RLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbiG0RLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:11:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD0374DDB;
        Wed, 27 Jul 2022 09:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90D14601C3;
        Wed, 27 Jul 2022 16:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DB3C433D7;
        Wed, 27 Jul 2022 16:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940091;
        bh=bU2/xVGvLwc56ejQkjV+akjbrJs3moE20KEfmebPPyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6O+Aq1BZK7rj4lFS4YxwN6H2vv0R0u09UQW1joLBAdITJcsM2LElYn5n/CIaS0lc
         9aoVBQssq1Bx6ON/e1KYwJi4apto6YxxWlPtsuQTPCAdqMzW2vUmjTzZ9PZ6Jeb84q
         v+QMv4uyzyTs2yO/ojdkw46lq7Ysp2i2YvqAEVKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/201] tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.
Date:   Wed, 27 Jul 2022 18:10:04 +0200
Message-Id: <20220727161031.886161020@linuxfoundation.org>
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

[ Upstream commit 021266ec640c7a4527e6cd4b7349a512b351de1d ]

While reading sysctl_tcp_fastopen_blackhole_timeout, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: cf1ef3f0719b ("net/tcp_fastopen: Disable active side TFO in certain scenarios")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 936544a4753e..6e0a8ef5e816 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -495,7 +495,7 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout))
 		return;
 
 	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
@@ -516,7 +516,8 @@ void tcp_fastopen_active_disable(struct sock *sk)
  */
 bool tcp_fastopen_active_should_disable(struct sock *sk)
 {
-	unsigned int tfo_bh_timeout = sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout;
+	unsigned int tfo_bh_timeout =
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout);
 	unsigned long timeout;
 	int tfo_da_times;
 	int multiplier;
-- 
2.35.1



