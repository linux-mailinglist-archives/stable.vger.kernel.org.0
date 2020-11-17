Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D213C2B63CB
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgKQNlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733165AbgKQNlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4CFF206A5;
        Tue, 17 Nov 2020 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620498;
        bh=9+ncCqJJpbFKUYLc0d9uLHM+Il62XQEZkE3Tu1iWE5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toBYG0UkAH86xvemPHKoM9AozYAnyJebB6jgzppMswRzy3/gwON4EjENIe2Ht7maE
         TDK9Wt9U4xEyvFssR0UFpp0zmi1uD3pwy24Zj4BZSzKiRK0B23zWdMv2ljUov23LgC
         xdYE/Loms3OSGVLezqBLtTb92L1IyEHpR4KLnrWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 239/255] ethtool: netlink: add missing netdev_features_change() call
Date:   Tue, 17 Nov 2020 14:06:19 +0100
Message-Id: <20201117122150.569161863@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 413691384a37fe27f43460226c4160e33140e638 ]

After updating userspace Ethtool from 5.7 to 5.9, I noticed that
NETDEV_FEAT_CHANGE is no more raised when changing netdev features
through Ethtool.
That's because the old Ethtool ioctl interface always calls
netdev_features_change() at the end of user request processing to
inform the kernel that our netdevice has some features changed, but
the new Netlink interface does not. Instead, it just notifies itself
with ETHTOOL_MSG_FEATURES_NTF.
Replace this ethtool_notify() call with netdev_features_change(), so
the kernel will be aware of any features changes, just like in case
with the ioctl interface. This does not omit Ethtool notifications,
as Ethtool itself listens to NETDEV_FEAT_CHANGE and drops
ETHTOOL_MSG_FEATURES_NTF on it
(net/ethtool/netlink.c:ethnl_netdev_event()).

>From v1 [1]:
- dropped extra new line as advised by Jakub;
- no functional changes.

[1] https://lore.kernel.org/netdev/AlZXQ2o5uuTVHCfNGOiGgJ8vJ3KgO5YIWAnQjH0cDE@cp3-web-009.plabs.ch

Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET request")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Link: https://lore.kernel.org/r/ahA2YWXYICz5rbUSQqNG4roJ8OlJzzYQX7PTiG80@cp4-web-028.plabs.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/features.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -296,7 +296,7 @@ int ethnl_set_features(struct sk_buff *s
 					  active_diff_mask, compact);
 	}
 	if (mod)
-		ethtool_notify(dev, ETHTOOL_MSG_FEATURES_NTF, NULL);
+		netdev_features_change(dev);
 
 out_rtnl:
 	rtnl_unlock();


