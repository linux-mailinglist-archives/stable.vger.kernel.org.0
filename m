Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D661018FD
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKSFXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbfKSFXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:23:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 114B82231A;
        Tue, 19 Nov 2019 05:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141017;
        bh=ot8YQMOjdWQCQ8H+b5ivcfntlpqgPW+01EAoQHUxv5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVeEtSYicoGshRnK2lnbwToBbbdAtgNGljNA1uulaLXheat6omvxhNK/7skAeP+dF
         XmZzt74CV9v/v0lT4EdN+vThHHds1yiH+Y5JD1LUkl4OzU8fxQ+6xEiMalenKTuX1R
         xZLy9PlTxBGLAc8ItI5POvdu1yv9QSF09pOJcKaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 009/422] devlink: disallow reload operation during device cleanup
Date:   Tue, 19 Nov 2019 06:13:26 +0100
Message-Id: <20191119051400.803594450@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit 5a508a254bed9a2e36a5fb96c9065532a6bf1e9c ]

There is a race between driver code that does setup/cleanup of device
and devlink reload operation that in some drivers works with the same
code. Use after free could we easily obtained by running:

while true; do
        echo "0000:00:10.0" >/sys/bus/pci/drivers/mlxsw_spectrum2/bind
        devlink dev reload pci/0000:00:10.0 &
        echo "0000:00:10.0" >/sys/bus/pci/drivers/mlxsw_spectrum2/unbind
done

Fix this by enabling reload only after setup of device is complete and
disabling it at the beginning of the cleanup process.

Reported-by: Ido Schimmel <idosch@mellanox.com>
Fixes: 2d8dc5bbf4e7 ("devlink: Add support for reload")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c  |    3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c |    4 ++
 drivers/net/netdevsim/netdev.c             |    5 +++
 include/net/devlink.h                      |    3 ++
 net/core/devlink.c                         |   39 ++++++++++++++++++++++++++++-
 5 files changed, 53 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3982,6 +3982,7 @@ static int mlx4_init_one(struct pci_dev
 	if (ret)
 		goto err_params_unregister;
 
+	devlink_reload_enable(devlink);
 	pci_save_state(pdev);
 	return 0;
 
@@ -4093,6 +4094,8 @@ static void mlx4_remove_one(struct pci_d
 	struct devlink *devlink = priv_to_devlink(priv);
 	int active_vfs = 0;
 
+	devlink_reload_disable(devlink);
+
 	if (mlx4_is_slave(dev))
 		persist->interface_state |= MLX4_INTERFACE_STATE_NOWAIT;
 
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1054,6 +1054,8 @@ int mlxsw_core_bus_device_register(const
 		if (err)
 			goto err_driver_init;
 	}
+	if (!reload)
+		devlink_reload_enable(devlink);
 
 	return 0;
 
@@ -1088,6 +1090,8 @@ void mlxsw_core_bus_device_unregister(st
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
+	if (!reload)
+		devlink_reload_disable(devlink);
 	if (mlxsw_core->reload_fail) {
 		if (!reload)
 			/* Only the parts that were not de-initialized in the
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -23,6 +23,7 @@
 #include <net/pkt_cls.h>
 #include <net/rtnetlink.h>
 #include <net/switchdev.h>
+#include <net/devlink.h>
 
 #include "netdevsim.h"
 
@@ -221,6 +222,8 @@ static int nsim_init(struct net_device *
 		goto err_unreg_dev;
 
 	nsim_ipsec_init(ns);
+	if (ns->devlink)
+		devlink_reload_enable(ns->devlink);
 
 	return 0;
 
@@ -243,6 +246,8 @@ static void nsim_uninit(struct net_devic
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
+	if (ns->devlink)
+		devlink_reload_disable(ns->devlink);
 	nsim_ipsec_teardown(ns);
 	nsim_devlink_teardown(ns);
 	debugfs_remove_recursive(ns->ddir);
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -35,6 +35,7 @@ struct devlink {
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock;
+	u8 reload_enabled:1;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -477,6 +478,8 @@ struct ib_device;
 struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
+void devlink_reload_enable(struct devlink *devlink);
+void devlink_reload_disable(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2643,7 +2643,7 @@ static int devlink_nl_cmd_reload(struct
 	struct devlink *devlink = info->user_ptr[0];
 	int err;
 
-	if (!devlink->ops->reload)
+	if (!devlink->ops->reload || !devlink->reload_enabled)
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
@@ -3889,6 +3889,8 @@ EXPORT_SYMBOL_GPL(devlink_register);
 void devlink_unregister(struct devlink *devlink)
 {
 	mutex_lock(&devlink_mutex);
+	WARN_ON(devlink->ops->reload &&
+		devlink->reload_enabled);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 	list_del(&devlink->list);
 	mutex_unlock(&devlink_mutex);
@@ -3896,6 +3898,41 @@ void devlink_unregister(struct devlink *
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
 /**
+ *	devlink_reload_enable - Enable reload of devlink instance
+ *
+ *	@devlink: devlink
+ *
+ *	Should be called at end of device initialization
+ *	process when reload operation is supported.
+ */
+void devlink_reload_enable(struct devlink *devlink)
+{
+	mutex_lock(&devlink_mutex);
+	devlink->reload_enabled = true;
+	mutex_unlock(&devlink_mutex);
+}
+EXPORT_SYMBOL_GPL(devlink_reload_enable);
+
+/**
+ *	devlink_reload_disable - Disable reload of devlink instance
+ *
+ *	@devlink: devlink
+ *
+ *	Should be called at the beginning of device cleanup
+ *	process when reload operation is supported.
+ */
+void devlink_reload_disable(struct devlink *devlink)
+{
+	mutex_lock(&devlink_mutex);
+	/* Mutex is taken which ensures that no reload operation is in
+	 * progress while setting up forbidded flag.
+	 */
+	devlink->reload_enabled = false;
+	mutex_unlock(&devlink_mutex);
+}
+EXPORT_SYMBOL_GPL(devlink_reload_disable);
+
+/**
  *	devlink_free - Free devlink instance resources
  *
  *	@devlink: devlink


