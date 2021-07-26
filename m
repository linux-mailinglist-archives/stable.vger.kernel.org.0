Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7703D61E2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhGZPdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233155AbhGZPcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D163660EB2;
        Mon, 26 Jul 2021 16:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315918;
        bh=lt7gDp/hN1IsxntOiOG0y7SZerHgnCH6tEfNFOCtDfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDZiKhU+Fe3r1I0vB6B8cih5CSEk5yLyN44c6z6OuMWQM41ChUeMwP66jgS9EwwH/
         iCyx3UZQHAy1GI9RKeezjiFtmRx5ZOjT4k+c1Zi0eYAldbIsbkGpNdQi0bTDSgZBsm
         /6NbOTU5KIBah/TadPxYqQB52KVLyTbKE1gxG25A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 118/223] ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions
Date:   Mon, 26 Jul 2021 17:38:30 +0200
Message-Id: <20210726153850.128151992@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8fb4792f091e608a0a1d353dfdf07ef55a719db5 ]

While running the self-tests on a KASAN enabled kernel, I observed a
slab-out-of-bounds splat very similar to the one reported in
commit 821bbf79fe46 ("ipv6: Fix KASAN: slab-out-of-bounds Read in
 fib6_nh_flush_exceptions").

We additionally need to take care of fib6_metrics initialization
failure when the caller provides an nh.

The fix is similar, explicitly free the route instead of calling
fib6_info_release on a half-initialized object.

Fixes: f88d8ea67fbdb ("ipv6: Plumb support for nexthop object in a fib6_info")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d417e514bd52..09e84161b731 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3642,7 +3642,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		err = PTR_ERR(rt->fib6_metrics);
 		/* Do not leave garbage there. */
 		rt->fib6_metrics = (struct dst_metrics *)&dst_default_metrics;
-		goto out;
+		goto out_free;
 	}
 
 	if (cfg->fc_flags & RTF_ADDRCONF)
-- 
2.30.2



