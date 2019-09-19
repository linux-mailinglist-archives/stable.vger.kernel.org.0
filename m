Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8E2B8546
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392753AbfISWTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:32946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392452AbfISWTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:19:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B584820678;
        Thu, 19 Sep 2019 22:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931559;
        bh=eRqoDxPhzvVbfx3W3pJb3IwRfIRBOVWrUZjCX5SJ9ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B43Kgd1PQ0Pk17am7g9gr5SaWL+4zQZlkNPjFeC8ZuDKa0zE86Was6GhAtdwHq8UB
         Sfy+ikWwSJMyTi7vTwCGf/XNKkVGN9+7nfhVPULafwvJZjXwJkdVH8mUNVzmuxJlxI
         xWibVcRJnoVZNcmbuhhhGf7nqI0hNR9D7V/qlx9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 03/74] ipv6: Fix the link time qualifier of ping_v6_proc_exit_net()
Date:   Fri, 20 Sep 2019 00:03:16 +0200
Message-Id: <20190919214801.207325640@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d23dbc479a8e813db4161a695d67da0e36557846 ]

The '.exit' functions from 'pernet_operations' structure should be marked
as __net_exit, not __net_init.

Fixes: d862e5461423 ("net: ipv6: Implement /proc/net/icmp6.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -239,7 +239,7 @@ static int __net_init ping_v6_proc_init_
 	return ping_proc_register(net, &ping_v6_seq_afinfo);
 }
 
-static void __net_init ping_v6_proc_exit_net(struct net *net)
+static void __net_exit ping_v6_proc_exit_net(struct net *net)
 {
 	return ping_proc_unregister(net, &ping_v6_seq_afinfo);
 }


