Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E9B14E2BA
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgA3Sxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730104AbgA3SlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:41:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B6532083E;
        Thu, 30 Jan 2020 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409670;
        bh=K8igG2FZ35MzN0n/Pwa1jQ7h33f0VDfkIrulaFMrG4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EY37o6aWHjSXy9YD7Cpnqxt456IoM77mTYq/mTyjVKppeOlkX59t74xKDBpx6GiCw
         9+NturfnS7LmAVG4/w6fdr5Ur2ACbOsCMSUfTg/HdI9MzQ5HODDX1hCc99I4fayiCI
         BD+1IjivT27iPIJdXvwKO4cerBwqk7VLQgHfyl4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephen Worley <sworley@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 44/56] net: include struct nhmsg size in nh nlmsg size
Date:   Thu, 30 Jan 2020 19:39:01 +0100
Message-Id: <20200130183617.045356862@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Worley <sworley@cumulusnetworks.com>

[ Upstream commit f9e95555757915fc194288862d2978e370fe316b ]

Include the size of struct nhmsg size when calculating
how much of a payload to allocate in a new netlink nexthop
notification message.

Without this, we will fail to fill the skbuff at certain nexthop
group sizes.

You can reproduce the failure with the following iproute2 commands:

ip link add dummy1 type dummy
ip link add dummy2 type dummy
ip link add dummy3 type dummy
ip link add dummy4 type dummy
ip link add dummy5 type dummy
ip link add dummy6 type dummy
ip link add dummy7 type dummy
ip link add dummy8 type dummy
ip link add dummy9 type dummy
ip link add dummy10 type dummy
ip link add dummy11 type dummy
ip link add dummy12 type dummy
ip link add dummy13 type dummy
ip link add dummy14 type dummy
ip link add dummy15 type dummy
ip link add dummy16 type dummy
ip link add dummy17 type dummy
ip link add dummy18 type dummy
ip link add dummy19 type dummy

ip ro add 1.1.1.1/32 dev dummy1
ip ro add 1.1.1.2/32 dev dummy2
ip ro add 1.1.1.3/32 dev dummy3
ip ro add 1.1.1.4/32 dev dummy4
ip ro add 1.1.1.5/32 dev dummy5
ip ro add 1.1.1.6/32 dev dummy6
ip ro add 1.1.1.7/32 dev dummy7
ip ro add 1.1.1.8/32 dev dummy8
ip ro add 1.1.1.9/32 dev dummy9
ip ro add 1.1.1.10/32 dev dummy10
ip ro add 1.1.1.11/32 dev dummy11
ip ro add 1.1.1.12/32 dev dummy12
ip ro add 1.1.1.13/32 dev dummy13
ip ro add 1.1.1.14/32 dev dummy14
ip ro add 1.1.1.15/32 dev dummy15
ip ro add 1.1.1.16/32 dev dummy16
ip ro add 1.1.1.17/32 dev dummy17
ip ro add 1.1.1.18/32 dev dummy18
ip ro add 1.1.1.19/32 dev dummy19

ip next add id 1 via 1.1.1.1 dev dummy1
ip next add id 2 via 1.1.1.2 dev dummy2
ip next add id 3 via 1.1.1.3 dev dummy3
ip next add id 4 via 1.1.1.4 dev dummy4
ip next add id 5 via 1.1.1.5 dev dummy5
ip next add id 6 via 1.1.1.6 dev dummy6
ip next add id 7 via 1.1.1.7 dev dummy7
ip next add id 8 via 1.1.1.8 dev dummy8
ip next add id 9 via 1.1.1.9 dev dummy9
ip next add id 10 via 1.1.1.10 dev dummy10
ip next add id 11 via 1.1.1.11 dev dummy11
ip next add id 12 via 1.1.1.12 dev dummy12
ip next add id 13 via 1.1.1.13 dev dummy13
ip next add id 14 via 1.1.1.14 dev dummy14
ip next add id 15 via 1.1.1.15 dev dummy15
ip next add id 16 via 1.1.1.16 dev dummy16
ip next add id 17 via 1.1.1.17 dev dummy17
ip next add id 18 via 1.1.1.18 dev dummy18
ip next add id 19 via 1.1.1.19 dev dummy19

ip next add id 1111 group 1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19
ip next del id 1111

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Stephen Worley <sworley@cumulusnetworks.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -321,7 +321,9 @@ static size_t nh_nlmsg_size_single(struc
 
 static size_t nh_nlmsg_size(struct nexthop *nh)
 {
-	size_t sz = nla_total_size(4);    /* NHA_ID */
+	size_t sz = NLMSG_ALIGN(sizeof(struct nhmsg));
+
+	sz += nla_total_size(4); /* NHA_ID */
 
 	if (nh->is_group)
 		sz += nh_nlmsg_size_grp(nh);


