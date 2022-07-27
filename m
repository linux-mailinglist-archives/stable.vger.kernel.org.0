Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9BA583056
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242544AbiG0Rg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241660AbiG0RfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:35:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDBB84EC1;
        Wed, 27 Jul 2022 09:49:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5126461479;
        Wed, 27 Jul 2022 16:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590A8C433C1;
        Wed, 27 Jul 2022 16:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940584;
        bh=gX6oXyQi67phvXUaazyn0diBkW1dXjvmKBx9Z8YVdKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWra0OkK04PeEgA4z/6F51be0TsfAIgUuKeSpmCkJcE/dmcfXVKN36lCgWtg9qHYh
         wPPgSCNU960Bp8QMDRLrzfXEICacw/DqXE68y87VqAlP9UbxjFFtXzrfPDcygXVnQq
         KH426haxxnjKrPcFGfTpfcnLyF005OOTdGSthj5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 076/158] tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.
Date:   Wed, 27 Jul 2022 18:12:20 +0200
Message-Id: <20220727161024.557121363@linuxfoundation.org>
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
index 0acdb5473850..825b216d11f5 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -489,7 +489,7 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout))
 		return;
 
 	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
@@ -510,7 +510,8 @@ void tcp_fastopen_active_disable(struct sock *sk)
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



