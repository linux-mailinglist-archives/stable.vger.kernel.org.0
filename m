Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593C232E99D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhCEMdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhCEMdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D6865004;
        Fri,  5 Mar 2021 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947604;
        bh=KKFEiqyIJJSnu8U2sU9rD4d5UqVxif6VaTUmGfcFVes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MqDcuq14wre4q7ceGwC/LiMaAjQjR+ConNeNejkgd/ZqWKY3eGg4kGHQcOTlx/sfk
         jnAxDWYD0eDYhxYmnOJq7bhtm0ML+Nme7H9AVrwyAUZRzvHOdrv4mzHP4a8OR7dDVh
         Go4sU6dmL0+Cnc3lt6iK4chGnUh+VMnqr0X9hvEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 18/72] net: bridge: use switchdev for port flags set through sysfs too
Date:   Fri,  5 Mar 2021 13:21:20 +0100
Message-Id: <20210305120858.232117675@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 8043c845b63a2dd88daf2d2d268a33e1872800f0 upstream.

Looking through patchwork I don't see that there was any consensus to
use switchdev notifiers only in case of netlink provided port flags but
not sysfs (as a sort of deprecation, punishment or anything like that),
so we should probably keep the user interface consistent in terms of
functionality.

http://patchwork.ozlabs.org/project/netdev/patch/20170605092043.3523-3-jiri@resnulli.us/
http://patchwork.ozlabs.org/project/netdev/patch/20170608064428.4785-3-jiri@resnulli.us/

Fixes: 3922285d96e7 ("net: bridge: Add support for offloading port attributes")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_sysfs_if.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -55,9 +55,8 @@ static BRPORT_ATTR(_name, 0644,					\
 static int store_flag(struct net_bridge_port *p, unsigned long v,
 		      unsigned long mask)
 {
-	unsigned long flags;
-
-	flags = p->flags;
+	unsigned long flags = p->flags;
+	int err;
 
 	if (v)
 		flags |= mask;
@@ -65,6 +64,10 @@ static int store_flag(struct net_bridge_
 		flags &= ~mask;
 
 	if (flags != p->flags) {
+		err = br_switchdev_set_port_flag(p, flags, mask);
+		if (err)
+			return err;
+
 		p->flags = flags;
 		br_port_flags_change(p, mask);
 	}


