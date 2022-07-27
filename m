Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F430582D2D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbiG0QzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbiG0Qyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:54:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4F862A70;
        Wed, 27 Jul 2022 09:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4E9D4CE230F;
        Wed, 27 Jul 2022 16:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDE3C433C1;
        Wed, 27 Jul 2022 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939743;
        bh=D613NYS3RItS9SkfSXwFD6OJEOqctu9XNqKGGC5B9Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZH4m6NDTrQ9eVE98d1rGva7ZBWNn4gT7UI5l4hGVcc2lkQQ36IpeXASlv8SYQhfce
         7RPk4UgKleLgAxgvXSIXTeyQYS0MKdos+QGHAw/voczApAgp0UBocmt9nd40aSWPHr
         8YHVpo35FvBlG3hDm4WFr+vZY/c777TQfSFAQqNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/105] tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.
Date:   Wed, 27 Jul 2022 18:10:42 +0200
Message-Id: <20220727161014.339107685@linuxfoundation.org>
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
index ed7aa6ae7b51..39fb037ce5f3 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -506,7 +506,7 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout))
 		return;
 
 	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
@@ -527,7 +527,8 @@ void tcp_fastopen_active_disable(struct sock *sk)
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



