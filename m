Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88304891A7
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbiAJHeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:34:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60560 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbiAJHcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A129FB81208;
        Mon, 10 Jan 2022 07:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3639C36AED;
        Mon, 10 Jan 2022 07:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799940;
        bh=IWDSQyEn1gvvs88sj42JoA8oCzbf87RCIuKJS851JSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2ZgngDv9kxyoWDn9XxiCJf9KMFneVfQ4a3aLtoT2Rxl7TSopF00QO/WA5kLNpmJk
         Ig5+8WKjj4kbfmBUcrGoc2RbkKJNRHda+79BA8404i3rBlR7Tk27ASBh4lmY5pjOHm
         drxlWwn9CgJldtwTA17lraEI76erkWLRV8tSn/+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 23/72] ipv6: Check attribute length for RTA_GATEWAY when deleting multipath route
Date:   Mon, 10 Jan 2022 08:23:00 +0100
Message-Id: <20220110071822.354269152@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
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
@@ -5453,7 +5453,11 @@ static int ip6_route_multipath_del(struc
 
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


