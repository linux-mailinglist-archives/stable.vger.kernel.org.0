Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A4C187EF0
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgCQK5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgCQK5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:57:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFACA2073E;
        Tue, 17 Mar 2020 10:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442639;
        bh=0b8pZmZ/OTVVO3rW73gqiFUh8nfq83lmvUswxOVfALo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yTnarO7bDgDbOiPbjpLHKOCSFd5ZwWaBrjUsVWYjbs1AiCC6OcMEexjxAy7zeSjgZ
         KetN4YtFu2YKjH3LWJ/FVs2hvmo5+/6EHrUH/aOzPQwHWMBBrhhGz304bpTmQqdlew
         6ZxuPvO+QILeB5uegRTNH1JG8iQSyhXjKwPOApU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 06/89] ipv6/addrconf: call ipv6_mc_up() for non-Ethernet interface
Date:   Tue, 17 Mar 2020 11:54:15 +0100
Message-Id: <20200317103300.567404501@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 60380488e4e0b95e9e82aa68aa9705baa86de84c ]

Rafał found an issue that for non-Ethernet interface, if we down and up
frequently, the memory will be consumed slowly.

The reason is we add allnodes/allrouters addressed in multicast list in
ipv6_add_dev(). When link down, we call ipv6_mc_down(), store all multicast
addresses via mld_add_delrec(). But when link up, we don't call ipv6_mc_up()
for non-Ethernet interface to remove the addresses. This makes idev->mc_tomb
getting bigger and bigger. The call stack looks like:

addrconf_notify(NETDEV_REGISTER)
	ipv6_add_dev
		ipv6_dev_mc_inc(ff01::1)
		ipv6_dev_mc_inc(ff02::1)
		ipv6_dev_mc_inc(ff02::2)

addrconf_notify(NETDEV_UP)
	addrconf_dev_config
		/* Alas, we support only Ethernet autoconfiguration. */
		return;

addrconf_notify(NETDEV_DOWN)
	addrconf_ifdown
		ipv6_mc_down
			igmp6_group_dropped(ff02::2)
				mld_add_delrec(ff02::2)
			igmp6_group_dropped(ff02::1)
			igmp6_group_dropped(ff01::1)

After investigating, I can't found a rule to disable multicast on
non-Ethernet interface. In RFC2460, the link could be Ethernet, PPP, ATM,
tunnels, etc. In IPv4, it doesn't check the dev type when calls ip_mc_up()
in inetdev_event(). Even for IPv6, we don't check the dev type and call
ipv6_add_dev(), ipv6_dev_mc_inc() after register device.

So I think it's OK to fix this memory consumer by calling ipv6_mc_up() for
non-Ethernet interface.

v2: Also check IFF_MULTICAST flag to make sure the interface supports
    multicast

Reported-by: Rafał Miłecki <zajec5@gmail.com>
Tested-by: Rafał Miłecki <zajec5@gmail.com>
Fixes: 74235a25c673 ("[IPV6] addrconf: Fix IPv6 on tuntap tunnels")
Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3291,6 +3291,10 @@ static void addrconf_dev_config(struct n
 	    (dev->type != ARPHRD_NONE) &&
 	    (dev->type != ARPHRD_RAWIP)) {
 		/* Alas, we support only Ethernet autoconfiguration. */
+		idev = __in6_dev_get(dev);
+		if (!IS_ERR_OR_NULL(idev) && dev->flags & IFF_UP &&
+		    dev->flags & IFF_MULTICAST)
+			ipv6_mc_up(idev);
 		return;
 	}
 


