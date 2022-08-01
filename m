Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021CE58688B
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiHALtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiHALtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:49:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8A83F31C;
        Mon,  1 Aug 2022 04:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF95661210;
        Mon,  1 Aug 2022 11:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D9EC433D6;
        Mon,  1 Aug 2022 11:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354520;
        bh=jSo4xF4m8OnK0v74bY7eInmtx1SwCGLzwrI1ExsX8p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhWdgH3IrIAPpQWphhXM8vRxLJlXKbidAIoPLQ3E2xrt09su+ZhuT/6mYkXPx236I
         nILjyF/xS7hXW0Uu/dEVQlH0t6xrfDoj3MYxKuyaiAR7x0YxPEq7sXC5epLmGRPI7r
         i1JKnDXaJX4HACpJxaeK3GH889Twn4HJfo9hMkq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/34] tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.
Date:   Mon,  1 Aug 2022 13:47:04 +0200
Message-Id: <20220801114128.948187739@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
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

[ Upstream commit 79f55473bfc8ac51bd6572929a679eeb4da22251 ]

While reading sysctl_tcp_comp_sack_nr, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 9c21d2fc41c0 ("tcp: add tcp_comp_sack_nr sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f8fa036cfae2..f4e00ff909da 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5303,7 +5303,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	}
 
 	if (!tcp_is_sack(tp) ||
-	    tp->compressed_ack >= sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr)
+	    tp->compressed_ack >= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_nr))
 		goto send_now;
 
 	if (tp->compressed_ack_rcv_nxt != tp->rcv_nxt) {
-- 
2.35.1



