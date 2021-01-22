Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77903300538
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbhAVOWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbhAVOVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4762A23B45;
        Fri, 22 Jan 2021 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324946;
        bh=31LOSbmR6QwdwU9SQDi+l8K3VkBNb6s9Kg5DwS7glx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7iz665GJmJBvV6h2ML844NHaz6RenHEy6SP8YzUtHe34TsUM5R9lck4LvNuFxGIA
         XufdbqbRQiBuHf9EZ93PeiLJ/Je9M7twAg2KlslnUU9oXqohv/fxO1E0zSBErL1Ebk
         BDuywglbOfsPvlyBXUdfeI3Y/pRXBWKCNNzT3Ols=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
Subject: [PATCH 4.19 15/22] net: sit: unregister_netdevice on newlinks error path
Date:   Fri, 22 Jan 2021 15:12:33 +0100
Message-Id: <20210122135732.514609761@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 47e4bb147a96f1c9b4e7691e7e994e53838bfff8 ]

We need to unregister the netdevice if config failed.
.ndo_uninit takes care of most of the heavy lifting.

This was uncovered by recent commit c269a24ce057 ("net: make
free_netdev() more lenient with unregistering devices").
Previously the partially-initialized device would be left
in the system.

Reported-and-tested-by: syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
Fixes: e2f1f072db8d ("sit: allow to configure 6rd tunnels via netlink")
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20210114012947.2515313-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1596,8 +1596,11 @@ static int ipip6_newlink(struct net *src
 	}
 
 #ifdef CONFIG_IPV6_SIT_6RD
-	if (ipip6_netlink_6rd_parms(data, &ip6rd))
+	if (ipip6_netlink_6rd_parms(data, &ip6rd)) {
 		err = ipip6_tunnel_update_6rd(nt, &ip6rd);
+		if (err < 0)
+			unregister_netdevice_queue(dev, NULL);
+	}
 #endif
 
 	return err;


