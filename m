Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2921E32EAA7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhCEMjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:39:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232173AbhCEMjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:39:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5412F65036;
        Fri,  5 Mar 2021 12:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947956;
        bh=qsz5KHx9FNVq5F9ZnKwKyjXB7UmEbWzyQ4rF3vJMPBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlEnFpBSs18pSCzrBlnli/WB0zPWE2ctKuCb6ThWgMN/ZdiM0lxvc8GRCEWlXierZ
         3YZ/yOSbFpl2BAEwMquT1Bj360mTZrPaW2kFwkOPO4/qQB4+xUcT6iJTVF0G3xsxIq
         6SHszIWZa62nKV1T6o4fyP+zBEQgVDGhQef08sr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 17/39] net: bridge: use switchdev for port flags set through sysfs too
Date:   Fri,  5 Mar 2021 13:22:16 +0100
Message-Id: <20210305120852.634618568@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
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
@@ -50,9 +50,8 @@ static BRPORT_ATTR(_name, S_IRUGO | S_IW
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
@@ -60,6 +59,10 @@ static int store_flag(struct net_bridge_
 		flags &= ~mask;
 
 	if (flags != p->flags) {
+		err = br_switchdev_set_port_flag(p, flags, mask);
+		if (err)
+			return err;
+
 		p->flags = flags;
 		br_port_flags_change(p, mask);
 	}


