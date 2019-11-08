Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049C5F5588
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbfKHTDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:03:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388022AbfKHTDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:03:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05BD82067B;
        Fri,  8 Nov 2019 19:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239781;
        bh=TUrUciSb5fnOaR4RAMaZK/FODS3qYZt8EiWHPQ01NMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSMO8DPuqZCC79N0pcFvXLw9uv5J8jB1Hj10GilDTccAFb/SS7fv4l2h6kKpwMF3h
         sKayUitMocJVv/wJ/AKEbnQ2UlS+l32k7qWuYep9mjn48h7FCdo2rLkrzG/cKJ95CW
         9KWMqQuS7hZiqMn45c5K6M7Z2JkFsq8aq0TaWwMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Beniamino Galvani <bgalvani@redhat.com>
Subject: [PATCH 4.19 59/79] ipv4: fix route update on metric change.
Date:   Fri,  8 Nov 2019 19:50:39 +0100
Message-Id: <20191108174819.973196720@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0b834ba00ab5337e938c727e216e1f5249794717 ]

Since commit af4d768ad28c ("net/ipv4: Add support for specifying metric
of connected routes"), when updating an IP address with a different metric,
the associated connected route is updated, too.

Still, the mentioned commit doesn't handle properly some corner cases:

$ ip addr add dev eth0 192.168.1.0/24
$ ip addr add dev eth0 192.168.2.1/32 peer 192.168.2.2
$ ip addr add dev eth0 192.168.3.1/24
$ ip addr change dev eth0 192.168.1.0/24 metric 10
$ ip addr change dev eth0 192.168.2.1/32 peer 192.168.2.2 metric 10
$ ip addr change dev eth0 192.168.3.1/24 metric 10
$ ip -4 route
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.0
192.168.2.2 dev eth0 proto kernel scope link src 192.168.2.1
192.168.3.0/24 dev eth0 proto kernel scope link src 192.168.2.1 metric 10

Only the last route is correctly updated.

The problem is the current test in fib_modify_prefix_metric():

	if (!(dev->flags & IFF_UP) ||
	    ifa->ifa_flags & (IFA_F_SECONDARY | IFA_F_NOPREFIXROUTE) ||
	    ipv4_is_zeronet(prefix) ||
	    prefix == ifa->ifa_local || ifa->ifa_prefixlen == 32)

Which should be the logical 'not' of the pre-existing test in
fib_add_ifaddr():

	if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
	    (prefix != addr || ifa->ifa_prefixlen < 32))

To properly negate the original expression, we need to change the last
logical 'or' to a logical 'and'.

Fixes: af4d768ad28c ("net/ipv4: Add support for specifying metric of connected routes")
Reported-and-suggested-by: Beniamino Galvani <bgalvani@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_frontend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -946,7 +946,7 @@ void fib_modify_prefix_metric(struct in_
 	if (!(dev->flags & IFF_UP) ||
 	    ifa->ifa_flags & (IFA_F_SECONDARY | IFA_F_NOPREFIXROUTE) ||
 	    ipv4_is_zeronet(prefix) ||
-	    prefix == ifa->ifa_local || ifa->ifa_prefixlen == 32)
+	    (prefix == ifa->ifa_local && ifa->ifa_prefixlen == 32))
 		return;
 
 	/* add the new */


