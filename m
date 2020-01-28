Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF55014B9AE
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbgA1OYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:24:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730145AbgA1OY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B94724686;
        Tue, 28 Jan 2020 14:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221467;
        bh=U7KFAaLtlV+YU5BPWP95GtvN00quRSfQ7ja0XbUw8LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08uIz6wFbmsYWecjIRQPFOUOns7Xrw5KOS0A0VoaTvvvAcCS4ua/ZDZ4GxH1S9LHW
         p51GVBedYzkNmH9a5qDak2B6vUgj0Z4PgJRGekBU/k2lwIjykjSkF8DaJXDRPTBMEH
         aGuse9UDepQX4FD5YLk0svfcHXziPH6q9aQlgwq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Dauchy <w.dauchy@criteo.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 237/271] net, ip6_tunnel: fix namespaces move
Date:   Tue, 28 Jan 2020 15:06:26 +0100
Message-Id: <20200128135910.191879594@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Dauchy <w.dauchy@criteo.com>

[ Upstream commit 5311a69aaca30fa849c3cc46fb25f75727fb72d0 ]

in the same manner as commit d0f418516022 ("net, ip_tunnel: fix
namespaces move"), fix namespace moving as it was broken since commit
8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnel"), but for
ipv6 this time; there is no reason to keep it for ip6_tunnel.

Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnel")
Signed-off-by: William Dauchy <w.dauchy@criteo.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1861,10 +1861,8 @@ static int ip6_tnl_dev_init(struct net_d
 	if (err)
 		return err;
 	ip6_tnl_link_config(t);
-	if (t->parms.collect_md) {
-		dev->features |= NETIF_F_NETNS_LOCAL;
+	if (t->parms.collect_md)
 		netif_keep_dst(dev);
-	}
 	return 0;
 }
 


