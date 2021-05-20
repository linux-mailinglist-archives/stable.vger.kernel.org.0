Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904DE38A80F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhETKqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237947AbhETKoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E773861C96;
        Thu, 20 May 2021 09:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504622;
        bh=JWBxnV+Asf0mk2kGN/PYA43yeYqpEAkA4ZyWW1vQK6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVhMKt5KkzEdghlUCmqECBtpHczeLoBWD/OTGfFeYvxLD7KZEZM0oHCUX+O4vcQhg
         w+1U8OmVhrYLYuc/sDRPqb0IYIKO+OCqNlTlBh+NRSQgSq3eixmS6CAOMxQaDmsYdc
         YKVfvM4soKHG+UO2Tx4rX56/BBZkzpYpyBa/XMUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 320/323] sit: proper dev_{hold|put} in ndo_[un]init methods
Date:   Thu, 20 May 2021 11:23:32 +0200
Message-Id: <20210520092131.211549239@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 6289a98f0817a4a457750d6345e754838eae9439 upstream.

After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
a warning [1]

Issue here is that:

- all dev_put() should be paired with a corresponding prior dev_hold().

- A driver doing a dev_put() in its ndo_uninit() MUST also
  do a dev_hold() in its ndo_init(), only when ndo_init()
  is returning 0.

Otherwise, register_netdevice() would call ndo_uninit()
in its error path and release a refcount too soon.

Fixes: 919067cc845f ("net: add CONFIG_PCPU_DEV_REFCNT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -209,8 +209,6 @@ static int ipip6_tunnel_create(struct ne
 
 	ipip6_tunnel_clone_6rd(dev, sitn);
 
-	dev_hold(dev);
-
 	ipip6_tunnel_link(sitn, t);
 	return 0;
 
@@ -1393,7 +1391,7 @@ static int ipip6_tunnel_init(struct net_
 		dev->tstats = NULL;
 		return err;
 	}
-
+	dev_hold(dev);
 	return 0;
 }
 


