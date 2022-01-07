Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008A948789D
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347749AbiAGN6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:58:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35284 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347748AbiAGN6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:58:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A794C61E70
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901A6C36AE0;
        Fri,  7 Jan 2022 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641563886;
        bh=twmLBPcsO9V7GtT056PgLmm2WEQhplwojebeVMT/UNE=;
        h=Subject:To:Cc:From:Date:From;
        b=qKH6ED5ocRp0G7pddkOsAqg7sXOyl3kweKiUydpW6wuns78Kymaeg8dZl+5G3y+Ee
         SJ8lhaAMMtHZs0kq7ISZG9BE3yF17LZVe/rMvEOVlv28NjmFdSHYl6qLjdkS7KWNcW
         6szes1SwQxgWwUV1bMIzVlVdbRJf5qilIL/1N9Yg=
Subject: FAILED: patch "[PATCH] ipv6: Check attribute length for RTA_GATEWAY when deleting" failed to apply to 4.4-stable tree
To:     dsahern@kernel.org, davem@davemloft.net, roopa@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:57:13 +0100
Message-ID: <164156383360106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ff15a710a862db1101b97810af14aedc835a86a Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@kernel.org>
Date: Thu, 30 Dec 2021 17:36:34 -0700
Subject: [PATCH] ipv6: Check attribute length for RTA_GATEWAY when deleting
 multipath route

Make sure RTA_GATEWAY for IPv6 multipath route has enough bytes to hold
an IPv6 address.

Fixes: 6b9ea5a64ed5 ("ipv6: fix multipath route replace error recovery")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d16599c225b8..b311c0bc9983 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5453,7 +5453,11 @@ static int ip6_route_multipath_del(struct fib6_config *cfg,
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				nla_memcpy(&r_cfg.fc_gateway, nla, 16);
+				err = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+							extack);
+				if (err)
+					return err;
+
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 		}

