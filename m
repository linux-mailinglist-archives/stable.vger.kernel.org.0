Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA8130331F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbhAZEqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:46:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbhAYSnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CAA82063A;
        Mon, 25 Jan 2021 18:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600155;
        bh=o83ylCUfxbzbCq5XjeXyQwxE4Ttl85gv0/ylqg955+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn2Z4AvFm8KydDqyE1RNcQZ0yu+WGYYJzfREWAVkVS6c0L//cPL7sdfHTZOnyznCk
         OgblGKJK3UcxBClzP+CEyQCrgDH3bPK99PS5AKYDLRHNXSy8l+prD85RjSrgZUQQHI
         /tBToqJA1ybgLiXC5oXToVC4Ck7rRb/d1od1fzEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 52/58] ipv6: create multicast route with RTPROT_KERNEL
Date:   Mon, 25 Jan 2021 19:39:53 +0100
Message-Id: <20210125183158.939467569@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

commit a826b04303a40d52439aa141035fca5654ccaccd upstream.

The ff00::/8 multicast route is created without specifying the fc_protocol
field, so the default RTPROT_BOOT value is used:

  $ ip -6 -d route
  unicast ::1 dev lo proto kernel scope global metric 256 pref medium
  unicast fe80::/64 dev eth0 proto kernel scope global metric 256 pref medium
  unicast ff00::/8 dev eth0 proto boot scope global metric 256 pref medium

As the documentation says, this value identifies routes installed during
boot, but the route is created when interface is set up.
Change the value to RTPROT_KERNEL which is a better value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/addrconf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2397,6 +2397,7 @@ static void addrconf_add_mroute(struct n
 		.fc_flags = RTF_UP,
 		.fc_type = RTN_UNICAST,
 		.fc_nlinfo.nl_net = dev_net(dev),
+		.fc_protocol = RTPROT_KERNEL,
 	};
 
 	ipv6_addr_set(&cfg.fc_dst, htonl(0xFF000000), 0, 0, 0);


