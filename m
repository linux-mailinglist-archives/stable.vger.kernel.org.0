Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78AD3D5FE0
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbhGZPT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236711AbhGZPTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:19:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C08260F8F;
        Mon, 26 Jul 2021 15:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315181;
        bh=K1ADPbmNrthRVbeq//bPPCUL+SkUW8YFVKW9/cweEkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djp8WabsyRK44QSpHDt8Qi+9OQbgUVG4nw0mIRb29ASdi0qY13mf07ofHKJ0pgSh1
         KMV4s/Rz+Bct68LIOwNGIA8O+mIVYnSG8CXhD1QGxrGsp+/sycH0zgtV8lIQg6ZkCY
         6ex0dmveIsa9WANaS7BSVNmHlmJCBCF/HksIwqZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/108] ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions
Date:   Mon, 26 Jul 2021 17:39:00 +0200
Message-Id: <20210726153833.585864785@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
index b903fe28ce50..d6fc22f7d7a6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3655,7 +3655,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		err = PTR_ERR(rt->fib6_metrics);
 		/* Do not leave garbage there. */
 		rt->fib6_metrics = (struct dst_metrics *)&dst_default_metrics;
-		goto out;
+		goto out_free;
 	}
 
 	if (cfg->fc_flags & RTF_ADDRCONF)
-- 
2.30.2



