Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA5E58DDC7
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245749AbiHISF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbiHISEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:04:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F1D2714E;
        Tue,  9 Aug 2022 11:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81ADA6101C;
        Tue,  9 Aug 2022 18:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F6BC43470;
        Tue,  9 Aug 2022 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068141;
        bh=sTA3hE0yPZpR1noreH2827Yh1FajznPrRSsblFg38eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAUKcGdso4E0P/UUkfp2mAKANEyx1xj4dEx3ejmWok3pMWB+r0kCzoyV/eS3hj+q/
         G7VUcGiHX0ExGTH314GJrGhQNohLzqSpJ/9e5wXVoj6q8q4SPHLIA/4r7LIMJf9akw
         aqcpvxpif/EEysmVyFy8hFwPwuLKJDQkOCpijCDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/32] tcp: Fix a data-race around sysctl_tcp_autocorking.
Date:   Tue,  9 Aug 2022 20:00:07 +0200
Message-Id: <20220809175513.602497816@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 85225e6f0a76e6745bc841c9f25169c509b573d8 ]

While reading sysctl_tcp_autocorking, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: f54b311142a9 ("tcp: auto corking")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7acc0d07f148..768a7daab559 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -706,7 +706,7 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 				int size_goal)
 {
 	return skb->len < size_goal &&
-	       sock_net(sk)->ipv4.sysctl_tcp_autocorking &&
+	       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_autocorking) &&
 	       !tcp_rtx_queue_empty(sk) &&
 	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
 }
-- 
2.35.1



