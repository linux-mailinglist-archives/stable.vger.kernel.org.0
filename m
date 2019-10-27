Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24C7E669C
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfJ0VNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730288AbfJ0VNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:13:33 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0BC214AF;
        Sun, 27 Oct 2019 21:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210811;
        bh=1wAiKYZzxhCvOyXOT3yy5K9vPW5JV2UVEbFsyb8UxJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ph7NU+BZjj7LXHOCh+oJKjv8klkzIu+FKdV3I6urvZPBgLPFZ+DB0r903gvv9oTFb
         h1mrBi3+cPx45zb8ebHsW4KCopbqTkYzO8SbPM/FML80FhyULffYcYlRxMBPemv+t+
         zMV6WEojlgrNc+x+NiT6Vusm5SOhiS1kziV9FmBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <weiwan@google.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 25/93] ipv4: fix race condition between route lookup and invalidation
Date:   Sun, 27 Oct 2019 22:00:37 +0100
Message-Id: <20191027203256.322396995@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <weiwan@google.com>

[ Upstream commit 5018c59607a511cdee743b629c76206d9c9e6d7b ]

Jesse and Ido reported the following race condition:
<CPU A, t0> - Received packet A is forwarded and cached dst entry is
taken from the nexthop ('nhc->nhc_rth_input'). Calls skb_dst_set()

<t1> - Given Jesse has busy routers ("ingesting full BGP routing tables
from multiple ISPs"), route is added / deleted and rt_cache_flush() is
called

<CPU B, t2> - Received packet B tries to use the same cached dst entry
from t0, but rt_cache_valid() is no longer true and it is replaced in
rt_cache_route() by the newer one. This calls dst_dev_put() on the
original dst entry which assigns the blackhole netdev to 'dst->dev'

<CPU A, t3> - dst_input(skb) is called on packet A and it is dropped due
to 'dst->dev' being the blackhole netdev

There are 2 issues in the v4 routing code:
1. A per-netns counter is used to do the validation of the route. That
means whenever a route is changed in the netns, users of all routes in
the netns needs to redo lookup. v6 has an implementation of only
updating fn_sernum for routes that are affected.
2. When rt_cache_valid() returns false, rt_cache_route() is called to
throw away the current cache, and create a new one. This seems
unnecessary because as long as this route does not change, the route
cache does not need to be recreated.

To fully solve the above 2 issues, it probably needs quite some code
changes and requires careful testing, and does not suite for net branch.

So this patch only tries to add the deleted cached rt into the uncached
list, so user could still be able to use it to receive packets until
it's done.

Fixes: 95c47f9cf5e0 ("ipv4: call dst_dev_put() properly")
Signed-off-by: Wei Wang <weiwan@google.com>
Reported-by: Ido Schimmel <idosch@idosch.org>
Reported-by: Jesse Hathaway <jesse@mbuki-mvuki.org>
Tested-by: Jesse Hathaway <jesse@mbuki-mvuki.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1476,7 +1476,7 @@ static bool rt_cache_route(struct fib_nh
 	prev = cmpxchg(p, orig, rt);
 	if (prev == orig) {
 		if (orig) {
-			dst_dev_put(&orig->dst);
+			rt_add_uncached_list(orig);
 			dst_release(&orig->dst);
 		}
 	} else {


