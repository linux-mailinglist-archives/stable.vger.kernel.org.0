Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB1A8FDE
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389060AbfIDSGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389009AbfIDSGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A27DC2341B;
        Wed,  4 Sep 2019 18:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620377;
        bh=10SmcO7SscMmpFFI6wyywl1ZMi6GyIKfshtpKjOFLMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ty3uHvett3K5ykwVcs8gp3bMiAKx10y6XWGUbRZWfdklvHsq3hwwNl/mdU/h2hrOF
         ajNYQlA5A7N2ae/rLTK70J+rlZh95DJzdNhUru05/ZTbI2Cwgr21x8CzcjkFry6Grf
         ASbBp+Yw78Xy4Vy9FrgMP+JuiEViLlCJMj+SK88E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 34/93] ipv6/addrconf: allow adding multicast addr if IFA_F_MCAUTOJOIN is set
Date:   Wed,  4 Sep 2019 19:53:36 +0200
Message-Id: <20190904175306.241995841@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit f17f7648a49aa6728649ddf79bdbcac4f1970ce4 ]

In commit 93a714d6b53d ("multicast: Extend ip address command to enable
multicast group join/leave on") we added a new flag IFA_F_MCAUTOJOIN
to make user able to add multicast address on ethernet interface.

This works for IPv4, but not for IPv6. See the inet6_addr_add code.

static int inet6_addr_add()
{
	...
	if (cfg->ifa_flags & IFA_F_MCAUTOJOIN) {
		ipv6_mc_config(net->ipv6.mc_autojoin_sk, true...)
	}

	ifp = ipv6_add_addr(idev, cfg, true, extack); <- always fail with maddr
	if (!IS_ERR(ifp)) {
		...
	} else if (cfg->ifa_flags & IFA_F_MCAUTOJOIN) {
		ipv6_mc_config(net->ipv6.mc_autojoin_sk, false...)
	}
}

But in ipv6_add_addr() it will check the address type and reject multicast
address directly. So this feature is never worked for IPv6.

We should not remove the multicast address check totally in ipv6_add_addr(),
but could accept multicast address only when IFA_F_MCAUTOJOIN flag supplied.

v2: update commit description

Fixes: 93a714d6b53d ("multicast: Extend ip address command to enable multicast group join/leave on")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -995,7 +995,8 @@ ipv6_add_addr(struct inet6_dev *idev, st
 	int err = 0;
 
 	if (addr_type == IPV6_ADDR_ANY ||
-	    addr_type & IPV6_ADDR_MULTICAST ||
+	    (addr_type & IPV6_ADDR_MULTICAST &&
+	     !(cfg->ifa_flags & IFA_F_MCAUTOJOIN)) ||
 	    (!(idev->dev->flags & IFF_LOOPBACK) &&
 	     addr_type & IPV6_ADDR_LOOPBACK))
 		return ERR_PTR(-EADDRNOTAVAIL);


