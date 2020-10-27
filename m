Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7835529AF8C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755177AbgJ0OLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755304AbgJ0OJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:09:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B1D722202;
        Tue, 27 Oct 2020 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807758;
        bh=PtGfbtTFMFgjFc/XBeHgpda1ZtNlEE8DfzdWgAD87tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvJlKbzWwOnBMRjqy2Zz1CX7q1C/+oRn6ljed9UmRzF4M2EvJMv32n6+F0iqg7PA0
         wrpPTcM8I2m8AZxWREmVUk4Eadh+c0Q3ylwI6aOqeI4OdRhwUcmu7i+ZZSN9MHj0ne
         fPGOyrNte7x1bsk+LZ/zGf0c4LbvYTOCsgXNjy7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Brunner <tobias@strongswan.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 003/191] ipv4: Restore flowi4_oif update before call to xfrm_lookup_route
Date:   Tue, 27 Oct 2020 14:47:38 +0100
Message-Id: <20201027134909.880485611@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 874fb9e2ca949b443cc419a4f2227cafd4381d39 ]

Tobias reported regressions in IPsec tests following the patch
referenced by the Fixes tag below. The root cause is dropping the
reset of the flowi4_oif after the fib_lookup. Apparently it is
needed for xfrm cases, so restore the oif update to ip_route_output_flow
right before the call to xfrm_lookup_route.

Fixes: 2fbc6e89b2f1 ("ipv4: Update exception handling for multipath routes via same device")
Reported-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2603,10 +2603,12 @@ struct rtable *ip_route_output_flow(stru
 	if (IS_ERR(rt))
 		return rt;
 
-	if (flp4->flowi4_proto)
+	if (flp4->flowi4_proto) {
+		flp4->flowi4_oif = rt->dst.dev->ifindex;
 		rt = (struct rtable *)xfrm_lookup_route(net, &rt->dst,
 							flowi4_to_flowi(flp4),
 							sk, 0);
+	}
 
 	return rt;
 }


