Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268F1226A36
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgGTQbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731847AbgGTP5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:57:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECDA1206E9;
        Mon, 20 Jul 2020 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260627;
        bh=Lq/iLVlTUmFV6X6/WutpskWczPlTAuL7l95c3MwIo78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AueYldwUEpI3ap9II8cdgK0NfV55vti3wb2ALbie3KNIB++Xi32spJNnujjShgrAg
         apZkMwAaMfroIMMy3s0yayyBJ8KXTXYc2UN7d2Tnn0yfynOifv/xNwQyOQ0Xa11PfD
         /aG5U7Tx6FJCLLHIMvQj5tBud5iUQ4l/j7cZLcu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, thomas.gambier@nexedi.com,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 009/215] ipv6: Fix use of anycast address with loopback
Date:   Mon, 20 Jul 2020 17:34:51 +0200
Message-Id: <20200720152820.606913284@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit aea23c323d89836bcdcee67e49def997ffca043b ]

Thomas reported a regression with IPv6 and anycast using the following
reproducer:

    echo 1 >  /proc/sys/net/ipv6/conf/all/forwarding
    ip -6 a add fc12::1/16 dev lo
    sleep 2
    echo "pinging lo"
    ping6 -c 2 fc12::

The conversion of addrconf_f6i_alloc to use ip6_route_info_create missed
the use of fib6_is_reject which checks addresses added to the loopback
interface and sets the REJECT flag as needed. Update fib6_is_reject for
loopback checks to handle RTF_ANYCAST addresses.

Fixes: c7a1ce397ada ("ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create")
Reported-by: thomas.gambier@nexedi.com
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3409,7 +3409,7 @@ static bool fib6_is_reject(u32 flags, st
 	if ((flags & RTF_REJECT) ||
 	    (dev && (dev->flags & IFF_LOOPBACK) &&
 	     !(addr_type & IPV6_ADDR_LOOPBACK) &&
-	     !(flags & RTF_LOCAL)))
+	     !(flags & (RTF_ANYCAST | RTF_LOCAL))))
 		return true;
 
 	return false;


