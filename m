Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58383582E05
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbiG0RGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiG0RFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:05:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6578C6F7DA;
        Wed, 27 Jul 2022 09:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7371B601D6;
        Wed, 27 Jul 2022 16:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F83FC433D6;
        Wed, 27 Jul 2022 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939970;
        bh=gtY/Rqy/GVzMeNvc/9VE/6vVIldRHE5s4g5Il/UMIFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fkf/7GRlLWWYOJlt9u5IOeSqzPVRMLFMC+nb430ZVlRtF+3F6po949kXl7uDbyemx
         bjpyjiQfXsU92YOMWCY4kgroLjtAEeYC4U2DxpL9aNxF9mvfBf3+mbOYmX1yVyI4hg
         I88zMlR92d5+eHXjR51n177XYAnlKGUGE2J2cPck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/201] tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
Date:   Wed, 27 Jul 2022 18:09:24 +0200
Message-Id: <20220727161029.407078794@linuxfoundation.org>
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

[ Upstream commit 1a0008f9df59451d0a17806c1ee1a19857032fa8 ]

While reading sysctl_tcp_fwmark_accept, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 84f39b08d786 ("net: support marking accepting TCP sockets")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_sock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index defd77baf74a..33344d54ad65 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -107,7 +107,8 @@ static inline struct inet_request_sock *inet_rsk(const struct request_sock *sk)
 
 static inline u32 inet_request_mark(const struct sock *sk, struct sk_buff *skb)
 {
-	if (!sk->sk_mark && sock_net(sk)->ipv4.sysctl_tcp_fwmark_accept)
+	if (!sk->sk_mark &&
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fwmark_accept))
 		return skb->mark;
 
 	return sk->sk_mark;
-- 
2.35.1



