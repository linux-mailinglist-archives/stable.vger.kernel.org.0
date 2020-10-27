Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6072829B14E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901892AbgJ0O2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896736AbgJ0O2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:28:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20FD22202;
        Tue, 27 Oct 2020 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808931;
        bh=oqR8DdE8DKB7AGWOWa8Cw+KmmLMLLWUWC5mJLsNP6xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFm1VI7Jy7ldpIvccduouOLxBXaHf4Olzajdg/r4CL95BqgaY/hU4imkjLDeeyB6s
         v9IhMG10ashb6YtTnjZMI9Uz9wPNJ8kgtLeNou5jv/Ei1YGKqHVrju2l7XccrnxnJH
         B4IjMUZkIzMw0bdkRrxosS3DNgEsh/LADuF58eHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Brunner <tobias@strongswan.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 003/408] ipv4: Restore flowi4_oif update before call to xfrm_lookup_route
Date:   Tue, 27 Oct 2020 14:49:01 +0100
Message-Id: <20201027135455.196459512@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
@@ -2728,10 +2728,12 @@ struct rtable *ip_route_output_flow(stru
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


