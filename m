Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DABF489158
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239793AbiAJHbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38554 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239837AbiAJH3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B78856112C;
        Mon, 10 Jan 2022 07:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0455C36AED;
        Mon, 10 Jan 2022 07:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799749;
        bh=LdRVj9U1Q7raK3+ObByonpixbYpKgLaY3Ae1V00Q6L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N27erKm4gOqYpiVtaSWy6k5MPpbn7pSU01A2WtXUZI2X2Yr1OqZ1PNmOJArAiYUTN
         3jXoIb9YkJ6EU5F77jd+eXu6THXvSzF9lYW1W+1F9jCcGY+pmsT4u5vLlOhplPXnrN
         +kQvGo+PK+Lu9hK55ekcKuf1JKxSWeBLO108Vg7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 17/34] ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
Date:   Mon, 10 Jan 2022 08:23:12 +0100
Message-Id: <20220110071816.234285432@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

commit 1ff15a710a862db1101b97810af14aedc835a86a upstream.

Make sure RTA_GATEWAY for IPv6 multipath route has enough bytes to hold
an IPv6 address.

Fixes: 6b9ea5a64ed5 ("ipv6: fix multipath route replace error recovery")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5307,7 +5307,11 @@ static int ip6_route_multipath_del(struc
 
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


