Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF703A028E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhFHTGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236852AbhFHTD1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E6E561925;
        Tue,  8 Jun 2021 18:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177948;
        bh=S62UvOcIL6GR9cIOkgaAcjLOlEL4L6W72ky7PUZPyJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1A3zft4BCWVL4Lawmbbhl29DLHIwKh6lLqU15PIdIXOpcrhtWHo9cPksyrByhrUsB
         dHkAffNdyuegy80S/4FFdXLk8DnmFjAB+V02fLP4gQZgbtAHw2ZYmGRhVC843Gxa8v
         sSeyGU924kNfzkKCy9IrG9hfSbhhGo22+FzUE8Zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 021/161] devlink: Correct VIRTUAL port to not have phys_port attributes
Date:   Tue,  8 Jun 2021 20:25:51 +0200
Message-Id: <20210608175946.169978930@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit b28d8f0c25a9b0355116cace5f53ea52bd4020c8 ]

Physical port name, port number attributes do not belong to virtual port
flavour. When VF or SF virtual ports are registered they incorrectly
append "np0" string in the netdevice name of the VF/SF.

Before this fix, VF netdevice name were ens2f0np0v0, ens2f0np0v1 for VF
0 and 1 respectively.

After the fix, they are ens2f0v0, ens2f0v1.

With this fix, reading /sys/class/net/ens2f0v0/phys_port_name returns
-EOPNOTSUPP.

Also devlink port show example for 2 VFs on one PF to ensure that any
physical port attributes are not exposed.

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false
pci/0000:06:00.3/196608: type eth netdev ens2f0v0 flavour virtual splittable false
pci/0000:06:00.4/262144: type eth netdev ens2f0v1 flavour virtual splittable false

This change introduces a netdevice name change on systemd/udev
version 245 and higher which honors phys_port_name sysfs file for
generation of netdevice name.

This also aligns to phys_port_name usage which is limited to switchdev
ports as described in [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/networking/switchdev.rst

Fixes: acf1ee44ca5d ("devlink: Introduce devlink port flavour virtual")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20210526200027.14008-1-parav@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..4c363fa7d4d1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -705,7 +705,6 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
-	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
 		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
 				attrs->phys.port_number))
 			return -EMSGSIZE;
@@ -8629,7 +8628,6 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
-	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
 		if (!attrs->split)
 			n = snprintf(name, len, "p%u", attrs->phys.port_number);
 		else
@@ -8670,6 +8668,8 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 		n = snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf,
 			     attrs->pci_sf.sf);
 		break;
+	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
+		return -EOPNOTSUPP;
 	}
 
 	if (n >= len)
-- 
2.30.2



