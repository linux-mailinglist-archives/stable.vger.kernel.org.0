Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6707C19B319
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389348AbgDAQmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388565AbgDAQmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:42:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AD8D206F8;
        Wed,  1 Apr 2020 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759329;
        bh=I2x8+J3MZzR4qZRNlhzJ5TIhe/rgzKwxLo1kd3B50pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NaXZMQDps52K9t4m5yjG8MCI4Cx5lTCQ775XkeSI/Rkzk0fNEyBAAfbsGbFysacF
         tuqQEHFD1S3Ff3v3vKbniq818HTbYsWDnw9yp1TpZ3QWB/QU0OmlhDjc9l0FLRN5ac
         RcYU5iXkuWsfWv+/Cy9+xVJMerdCmiLonv3RLcU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/148] Revert "ipv6: Fix handling of LLA with VRF and sockets bound to VRF"
Date:   Wed,  1 Apr 2020 18:17:20 +0200
Message-Id: <20200401161557.592880291@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 0293f8d1bdd21b3eb71032edb5832f9090dea48e.

This patch shouldn't have been backported to 4.14.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5ec73cf386dfe..7b4ce3f9e2f4e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -718,7 +718,6 @@ static void tcp_v6_init_req(struct request_sock *req,
 			    const struct sock *sk_listener,
 			    struct sk_buff *skb)
 {
-	bool l3_slave = ipv6_l3mdev_skb(TCP_SKB_CB(skb)->header.h6.flags);
 	struct inet_request_sock *ireq = inet_rsk(req);
 	const struct ipv6_pinfo *np = inet6_sk(sk_listener);
 
@@ -726,7 +725,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
 
 	/* So that link locals have meaning */
-	if ((!sk_listener->sk_bound_dev_if || l3_slave) &&
+	if (!sk_listener->sk_bound_dev_if &&
 	    ipv6_addr_type(&ireq->ir_v6_rmt_addr) & IPV6_ADDR_LINKLOCAL)
 		ireq->ir_iif = tcp_v6_iif(skb);
 
-- 
2.20.1



