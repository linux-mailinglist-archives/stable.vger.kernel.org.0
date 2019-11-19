Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E4510190D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfKSFWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbfKSFWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5236B21939;
        Tue, 19 Nov 2019 05:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140954;
        bh=6icoMpvlZKEX/tSX+7s6u8Q+/PUACauLc2VxSg+cLuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ME+7/0mXu5SrXR1V3NnfZaIasaJ5/6dO2yuHeffF87vTpZLKndkMxkt4Q3vkppqnT
         qAAa0yMjO+B8j2wv5QllzMamlim4FzZ6BToBtB12Zo23TFBNbhKWR4BjPt/S0Nd86I
         Ej1f2Bw/ma+aYnV4xYsSeh3rJlVh3PUFqbUo0w3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shalom Toledo <shalomt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 05/48] mlxsw: core: Enable devlink reload only on probe
Date:   Tue, 19 Nov 2019 06:19:25 +0100
Message-Id: <20191119050951.850109484@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit 73a533ecf0af5f73ff72dd7c96d1c8598ca93649 ]

Call devlink enable only during probe time and avoid deadlock
during reload.

Reported-by: Shalom Toledo <shalomt@mellanox.com>
Fixes: 5a508a254bed ("devlink: disallow reload operation during device cleanup")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Tested-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c |    5 +++--
 net/core/devlink.c                         |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1128,10 +1128,11 @@ __mlxsw_core_bus_device_register(const s
 	if (err)
 		goto err_thermal_init;
 
-	if (mlxsw_driver->params_register) {
+	if (mlxsw_driver->params_register)
 		devlink_params_publish(devlink);
+
+	if (!reload)
 		devlink_reload_enable(devlink);
-	}
 
 	return 0;
 
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5559,7 +5559,7 @@ EXPORT_SYMBOL_GPL(devlink_register);
 void devlink_unregister(struct devlink *devlink)
 {
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(devlink) &&
+	WARN_ON(devlink->ops->reload &&
 		devlink->reload_enabled);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 	list_del(&devlink->list);


