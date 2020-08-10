Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987C2240A3F
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgHJPjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgHJPYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:24:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B3F20855;
        Mon, 10 Aug 2020 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073074;
        bh=XIOPiU9pReU8C1/DtvyOdHT6x/7y7MOglg4Mnvds7/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUGGVOukXQskX0Hbv6UQat0yg4QsitLfQYIPwnso/O9SJ3NTGKwcNaEGsgu2YK/OT
         zZZugYgLQdEyEDvCpx7UOUz5wAKVLdbSN57r6aA/UKvjcrz7vh86LoEpfw1quTfXnr
         +3KF9m7+7KINizicR+WjGLIe5G7FdvdwZPW+vjw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 57/79] ipv6: Fix nexthop refcnt leak when creating ipv6 route info
Date:   Mon, 10 Aug 2020 17:21:16 +0200
Message-Id: <20200810151815.067815727@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 706ec919164622ff5ce822065472d0f30a9e9dd2 ]

ip6_route_info_create() invokes nexthop_get(), which increases the
refcount of the "nh".

When ip6_route_info_create() returns, local variable "nh" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
ip6_route_info_create(). When nexthops can not be used with source
routing, the function forgets to decrease the refcnt increased by
nexthop_get(), causing a refcnt leak.

Fix this issue by pulling up the error source routing handling when
nexthops can not be used with source routing.

Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3677,14 +3677,14 @@ static struct fib6_info *ip6_route_info_
 	rt->fib6_src.plen = cfg->fc_src_len;
 #endif
 	if (nh) {
-		if (!nexthop_get(nh)) {
-			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
-			goto out;
-		}
 		if (rt->fib6_src.plen) {
 			NL_SET_ERR_MSG(extack, "Nexthops can not be used with source routing");
 			goto out;
 		}
+		if (!nexthop_get(nh)) {
+			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
+			goto out;
+		}
 		rt->nh = nh;
 		fib6_nh = nexthop_fib6_nh(rt->nh);
 	} else {


