Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C8F582B82
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbiG0QfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbiG0QeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0AA55097;
        Wed, 27 Jul 2022 09:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5DDD619FE;
        Wed, 27 Jul 2022 16:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE72AC433C1;
        Wed, 27 Jul 2022 16:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939215;
        bh=dMztBhjROoIEkA2hYgIClMgpARqNyyRZ4ceGRDt6saI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gxqoh2ucWtV/1sM/KWDtA1PN1doslhJAJc1BhCRxwR77MjC2DiM6l2sKUxHLqwjNk
         yDc7ZIfUVxTqSAQOkYtwX8d4MmXTSw1gxSUqe9Xtta5j76B9OKs548WIAoK3JPXMQm
         Qya7Zfq+GVgfZYQms2Fo8ADVa+bsHbLjZYvqpdEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/62] tcp: Fix a data-race around sysctl_tcp_tw_reuse.
Date:   Wed, 27 Jul 2022 18:10:31 +0200
Message-Id: <20220727161005.059321286@linuxfoundation.org>
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

[ Upstream commit cbfc6495586a3f09f6f07d9fb3c7cafe807e3c55 ]

While reading sysctl_tcp_tw_reuse, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2719c60f285b..ddc1af8731e3 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -110,10 +110,10 @@ static u32 tcp_v4_init_ts_off(const struct net *net, const struct sk_buff *skb)
 
 int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 {
+	int reuse = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_tw_reuse);
 	const struct inet_timewait_sock *tw = inet_twsk(sktw);
 	const struct tcp_timewait_sock *tcptw = tcp_twsk(sktw);
 	struct tcp_sock *tp = tcp_sk(sk);
-	int reuse = sock_net(sk)->ipv4.sysctl_tcp_tw_reuse;
 
 	if (reuse == 2) {
 		/* Still does not detect *everything* that goes through
-- 
2.35.1



