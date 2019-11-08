Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF50F56B4
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391891AbfKHTKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730571AbfKHTKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C89F21D7B;
        Fri,  8 Nov 2019 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240229;
        bh=djHxPYlKVZJ1U1PE20hloh4vtR7zK3P9vL7Sm2fJw40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElPnqhnMq6IAYtVRiYjQC0tlBvu5F4zPS/guVtSUGOpVMXA96IQSN9gf313Au5oXJ
         +gVXTP8BjvD/S+uVv1Z68zxFfFEjziAlh9ifF+gQAf+mmd7WDm2jTi6lYiqFNTFZ54
         uxfldvTGir4rd0xktRtJs83/ijhNFrPv9umV9uoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 116/140] mlxsw: core: Unpublish devlink parameters during reload
Date:   Fri,  8 Nov 2019 19:50:44 +0100
Message-Id: <20191108174912.115991691@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit b7265a0df82c1716bf788096217083ed65a8bb14 ]

The devlink parameter "acl_region_rehash_interval" is a runtime
parameter whose value is stored in a dynamically allocated memory. While
reloading the driver, this memory is freed and then allocated again. A
use-after-free might happen if during this time frame someone tries to
retrieve its value.

Since commit 070c63f20f6c ("net: devlink: allow to change namespaces
during reload") the use-after-free can be reliably triggered when
reloading the driver into a namespace, as after freeing the memory (via
reload_down() callback) all the parameters are notified.

Fix this by unpublishing and then re-publishing the parameters during
reload.

Fixes: 98bbf70c1c41 ("mlxsw: spectrum: add "acl_region_rehash_interval" devlink param")
Fixes: 7c62cfb8c574 ("devlink: publish params only after driver init is done")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1128,7 +1128,7 @@ __mlxsw_core_bus_device_register(const s
 	if (err)
 		goto err_thermal_init;
 
-	if (mlxsw_driver->params_register && !reload)
+	if (mlxsw_driver->params_register)
 		devlink_params_publish(devlink);
 
 	return 0;
@@ -1201,7 +1201,7 @@ void mlxsw_core_bus_device_unregister(st
 			return;
 	}
 
-	if (mlxsw_core->driver->params_unregister && !reload)
+	if (mlxsw_core->driver->params_unregister)
 		devlink_params_unpublish(devlink);
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);


