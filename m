Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E04190EBF
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgCXNOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCXNOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:14:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DC9208D6;
        Tue, 24 Mar 2020 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055674;
        bh=1PYz75fQhDi1f0xikc1C0S6f1Q7fc1lQY/Z6btMUpkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtbmbHghP/RPrjXQ/kzrvMUDcMfXhwqkTVOACschTH+swDos9Hl50ckrgOIlerNWs
         gVfXgms2aBVilq9nL6jEESF1E6wv/UvrPwXuXYTVKNnfP6rwuxKraKFYAoAIwJ2ysu
         Mj/JgT6ene4jVEzmwjN5Nlcq4KyMNkBHBMeLZTxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/65] Revert "ipv6: Fix handling of LLA with VRF and sockets bound to VRF"
Date:   Tue, 24 Mar 2020 14:11:20 +0100
Message-Id: <20200324130804.142978887@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 2b3541ffdd05198b329d21920a0f606009a1058b.

This patch shouldn't have been backported to 4.19.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c5f4e89b6ff30..7b0c2498f461b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -734,7 +734,6 @@ static void tcp_v6_init_req(struct request_sock *req,
 			    const struct sock *sk_listener,
 			    struct sk_buff *skb)
 {
-	bool l3_slave = ipv6_l3mdev_skb(TCP_SKB_CB(skb)->header.h6.flags);
 	struct inet_request_sock *ireq = inet_rsk(req);
 	const struct ipv6_pinfo *np = inet6_sk(sk_listener);
 
@@ -742,7 +741,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
 
 	/* So that link locals have meaning */
-	if ((!sk_listener->sk_bound_dev_if || l3_slave) &&
+	if (!sk_listener->sk_bound_dev_if &&
 	    ipv6_addr_type(&ireq->ir_v6_rmt_addr) & IPV6_ADDR_LINKLOCAL)
 		ireq->ir_iif = tcp_v6_iif(skb);
 
-- 
2.20.1



