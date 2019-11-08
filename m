Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C76FF567A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391245AbfKHTJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391738AbfKHTJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1117420673;
        Fri,  8 Nov 2019 19:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240145;
        bh=gXIrIpHgfxXzKWXdKVXOIuIfmFXJaHKIE9oR2oniOSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAqPo4ODirEJkxmpkWSsQX9xaBSc3h5Td+9koOCQzXk3Y93zPPt/ZKTmVbHO3XhkV
         z8X0JvWF4ZHjNygtn+sZ6eEWnO/ve6zPrIcJY/onIy1Kt9/q0992T73ldkFAvGvart
         dnicRJHuSWnSMCcJPmdzCD7qvb0FpFKXoydYQpl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Beniamino Galvani <bgalvani@redhat.com>
Subject: [PATCH 5.3 103/140] ipv4: fix route update on metric change.
Date:   Fri,  8 Nov 2019 19:50:31 +0100
Message-Id: <20191108174911.442423763@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
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
@@ -1147,7 +1147,7 @@ void fib_modify_prefix_metric(struct in_
 	if (!(dev->flags & IFF_UP) ||
 	    ifa->ifa_flags & (IFA_F_SECONDARY | IFA_F_NOPREFIXROUTE) ||
 	    ipv4_is_zeronet(prefix) ||
-	    prefix == ifa->ifa_local || ifa->ifa_prefixlen == 32)
+	    (prefix == ifa->ifa_local && ifa->ifa_prefixlen == 32))
 		return;
 
 	/* add the new */


