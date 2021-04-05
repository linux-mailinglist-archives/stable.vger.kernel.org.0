Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C7B353FBB
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239621AbhDEJOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239606AbhDEJN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 906DE60FE4;
        Mon,  5 Apr 2021 09:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614032;
        bh=tCNla3+2PHUFCElDaycALAjYMZUrNU0v4ZgFdr1DPI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQ+Kw2Wxn6CaLMdwcokcz5tOrFoaNsNAKPpOVQJ07ezlTwzpntbvitb+Ob9e2I3tE
         sofK2OYmnMw1WQIxLOQm11MtR7rjCwl6YzP6nhuEI630GoBHFrJGKAHbdiPENtomvI
         x8tDiAnpT5WiaUvWtEhxNC5ia+zzybiLc/OHnxeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 057/152] netdevsim: dev: Initialize FIB module after debugfs
Date:   Mon,  5 Apr 2021 10:53:26 +0200
Message-Id: <20210405085036.125264153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f57ab5b75f7193e194c83616cd104f41c8350f68 ]

Initialize the dummy FIB offload module after debugfs, so that the FIB
module could create its own directory there.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/dev.c | 40 +++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 816af1f55e2c..dbeb29fa16e8 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1012,23 +1012,25 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	nsim_dev->fw_update_status = true;
 	nsim_dev->fw_update_overwrite_mask = 0;
 
-	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
-	if (IS_ERR(nsim_dev->fib_data))
-		return PTR_ERR(nsim_dev->fib_data);
-
 	nsim_devlink_param_load_driverinit_values(devlink);
 
 	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
 	if (err)
-		goto err_fib_destroy;
+		return err;
 
 	err = nsim_dev_traps_init(devlink);
 	if (err)
 		goto err_dummy_region_exit;
 
+	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
+	if (IS_ERR(nsim_dev->fib_data)) {
+		err = PTR_ERR(nsim_dev->fib_data);
+		goto err_traps_exit;
+	}
+
 	err = nsim_dev_health_init(nsim_dev, devlink);
 	if (err)
-		goto err_traps_exit;
+		goto err_fib_destroy;
 
 	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
 	if (err)
@@ -1043,12 +1045,12 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 
 err_health_exit:
 	nsim_dev_health_exit(nsim_dev);
+err_fib_destroy:
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_traps_exit:
 	nsim_dev_traps_exit(devlink);
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
-err_fib_destroy:
-	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	return err;
 }
 
@@ -1080,15 +1082,9 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_devlink_free;
 
-	nsim_dev->fib_data = nsim_fib_create(devlink, NULL);
-	if (IS_ERR(nsim_dev->fib_data)) {
-		err = PTR_ERR(nsim_dev->fib_data);
-		goto err_resources_unregister;
-	}
-
 	err = devlink_register(devlink, &nsim_bus_dev->dev);
 	if (err)
-		goto err_fib_destroy;
+		goto err_resources_unregister;
 
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
@@ -1108,9 +1104,15 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_traps_exit;
 
+	nsim_dev->fib_data = nsim_fib_create(devlink, NULL);
+	if (IS_ERR(nsim_dev->fib_data)) {
+		err = PTR_ERR(nsim_dev->fib_data);
+		goto err_debugfs_exit;
+	}
+
 	err = nsim_dev_health_init(nsim_dev, devlink);
 	if (err)
-		goto err_debugfs_exit;
+		goto err_fib_destroy;
 
 	err = nsim_bpf_dev_init(nsim_dev);
 	if (err)
@@ -1128,6 +1130,8 @@ err_bpf_dev_exit:
 	nsim_bpf_dev_exit(nsim_dev);
 err_health_exit:
 	nsim_dev_health_exit(nsim_dev);
+err_fib_destroy:
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
 err_traps_exit:
@@ -1139,8 +1143,6 @@ err_params_unregister:
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
 	devlink_unregister(devlink);
-err_fib_destroy:
-	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 err_resources_unregister:
 	devlink_resources_unregister(devlink, NULL);
 err_devlink_free:
@@ -1157,10 +1159,10 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	debugfs_remove(nsim_dev->take_snapshot);
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
+	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 	nsim_dev_traps_exit(devlink);
 	nsim_dev_dummy_region_exit(nsim_dev);
 	mutex_destroy(&nsim_dev->port_list_lock);
-	nsim_fib_destroy(devlink, nsim_dev->fib_data);
 }
 
 void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
-- 
2.30.1



