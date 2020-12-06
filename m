Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6459F2D03EA
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgLFLla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:41:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbgLFLl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:41:29 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 01/39] devlink: Hold rtnl lock while reading netdev attributes
Date:   Sun,  6 Dec 2020 12:17:05 +0100
Message-Id: <20201206111554.745251350@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit b187c9b4178b87954dbc94e78a7094715794714f ]

A netdevice of a devlink port can be moved to different net namespace
than its parent devlink instance.
This scenario occurs when devlink reload is not used.

When netdevice is undergoing migration to net namespace, its ifindex
and name may change.

In such use case, devlink port query may read stale netdev attributes.

Fix it by reading them under rtnl lock.

Fixes: bfcd3a466172 ("Introduce devlink infrastructure")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -562,6 +562,8 @@ static int devlink_nl_port_fill(struct s
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
 		goto nla_put_failure;
 
+	/* Hold rtnl lock while accessing port's netdev attributes. */
+	rtnl_lock();
 	spin_lock_bh(&devlink_port->type_lock);
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
 		goto nla_put_failure_type_locked;
@@ -588,6 +590,7 @@ static int devlink_nl_port_fill(struct s
 			goto nla_put_failure_type_locked;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
+	rtnl_unlock();
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
 
@@ -596,6 +599,7 @@ static int devlink_nl_port_fill(struct s
 
 nla_put_failure_type_locked:
 	spin_unlock_bh(&devlink_port->type_lock);
+	rtnl_unlock();
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;


