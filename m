Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FA138A1D6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhETJfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232478AbhETJdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:33:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4112A61279;
        Thu, 20 May 2021 09:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502933;
        bh=j/RXrYRZb7AUWpnUJVgtc9C+bR3V8FmRalDuy/IbEEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXuSSb1Ueqsio/f6NK/YDgHUNQEd8omXuW+2hf4fXUqcBTUSjSN/CjOD+kW+d9o6j
         ZVyPINabosiGFq67+9EVRzS7xa5kF7xUnKL4sQYbL6ssYTq+CH2M3plXPuu9jkG6Xi
         aRbbAf4S7pBhdwSBLAOmNefMB4+WHVHsK+FQfpoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 32/37] sit: proper dev_{hold|put} in ndo_[un]init methods
Date:   Thu, 20 May 2021 11:22:53 +0200
Message-Id: <20210520092053.335721768@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
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
@@ -211,8 +211,6 @@ static int ipip6_tunnel_create(struct ne
 
 	ipip6_tunnel_clone_6rd(dev, sitn);
 
-	dev_hold(dev);
-
 	ipip6_tunnel_link(sitn, t);
 	return 0;
 
@@ -1408,7 +1406,7 @@ static int ipip6_tunnel_init(struct net_
 		dev->tstats = NULL;
 		return err;
 	}
-
+	dev_hold(dev);
 	return 0;
 }
 


