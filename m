Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E196BA8FE0
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389418AbfIDSGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389414AbfIDSGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FA6F233FF;
        Wed,  4 Sep 2019 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620379;
        bh=JxnV7Tjf5ViCpK3hkF1FF4rvKTigY7AmnKFNREg/YRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WptQtUWClj9vGf5NEqVFbucX0hEdnqi0LHdgFJ6stSYbkPc9tSZYsMzFzF/DJzdfe
         b9L8W+IEDf84oQ3ZbHftAvqROGAFbRalKOBHLniw0wwD/uxxaCVO+34sC+pDlBaRrn
         fVp7Pruu1yPYpzR8M8WtRQgMj+XS0nWpIqI1uVF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 35/93] ipv6: Default fib6_type to RTN_UNICAST when not set
Date:   Wed,  4 Sep 2019 19:53:37 +0200
Message-Id: <20190904175306.324861996@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit c7036d97acd2527cef145b5ef9ad1a37ed21bbe6 ]

A user reported that routes are getting installed with type 0 (RTN_UNSPEC)
where before the routes were RTN_UNICAST. One example is from accel-ppp
which apparently still uses the ioctl interface and does not set
rtmsg_type. Another is the netlink interface where ipv6 does not require
rtm_type to be set (v4 does). Prior to the commit in the Fixes tag the
ipv6 stack converted type 0 to RTN_UNICAST, so restore that behavior.

Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3109,7 +3109,7 @@ static struct fib6_info *ip6_route_info_
 	rt->fib6_metric = cfg->fc_metric;
 	rt->fib6_nh.nh_weight = 1;
 
-	rt->fib6_type = cfg->fc_type;
+	rt->fib6_type = cfg->fc_type ? : RTN_UNICAST;
 
 	/* We cannot add true routes via loopback here,
 	   they would result in kernel looping; promote them to reject routes


