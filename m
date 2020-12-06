Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E5A2D042A
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgLFLng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729177AbgLFLng (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:36 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 02/46] devlink: Make sure devlink instance and port are in same net namespace
Date:   Sun,  6 Dec 2020 12:17:10 +0100
Message-Id: <20201206111556.560207616@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit a7b43649507dae4e55ff0087cad4e4dd1c6d5b99 ]

When devlink reload operation is not used, netdev of an Ethernet port may
be present in different net namespace than the net namespace of the
devlink instance.

Ensure that both the devlink instance and devlink port netdev are located
in same net namespace.

Fixes: 070c63f20f6c ("net: devlink: allow to change namespaces during reload")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -626,9 +626,10 @@ static int devlink_nl_port_fill(struct s
 			devlink_port->desired_type))
 		goto nla_put_failure_type_locked;
 	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
+		struct net *net = devlink_net(devlink_port->devlink);
 		struct net_device *netdev = devlink_port->type_dev;
 
-		if (netdev &&
+		if (netdev && net_eq(net, dev_net(netdev)) &&
 		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
 				 netdev->ifindex) ||
 		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,


