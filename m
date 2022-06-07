Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE1B540604
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347084AbiFGRc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348087AbiFGRbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8215F11E49A;
        Tue,  7 Jun 2022 10:29:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2272060BC6;
        Tue,  7 Jun 2022 17:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31621C385A5;
        Tue,  7 Jun 2022 17:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622955;
        bh=pwRozGQKNNA1j1GZLpy9hiTpHM2CP4DBqKn95EEHNbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zK2c2KO3f3m4tTWNd2c26fCIUnPuyzQkQqKLxOvGvywznBvHfd5PZ5D9Hifu+tnsQ
         jBun/hvMNwNTixERMiptPgI1ejC8G4Hdg3UEF3jwkf2EAknbIJT0x12EKyKNB0JYt0
         1F5Xb6OL+XqpCZYKPwmcqp4VvnjV5ovwZJI029uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/452] thermal/drivers/core: Use a char pointer for the cooling device name
Date:   Tue,  7 Jun 2022 19:01:38 +0200
Message-Id: <20220607164915.741497011@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 58483761810087e5ffdf36e84ac1bf26df909097 ]

We want to have any kind of name for the cooling devices as we do no
longer want to rely on auto-numbering. Let's replace the cooling
device's fixed array by a char pointer to be allocated dynamically
when registering the cooling device, so we don't limit the length of
the name.

Rework the error path at the same time as we have to rollback the
allocations in case of error.

Tested with a dummy device having the name:
 "Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch"

A village on the island of Anglesey (Wales), known to have the longest
name in Europe.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20210314111333.16551-1-daniel.lezcano@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    |  2 +-
 drivers/thermal/thermal_core.c                | 38 +++++++++++--------
 include/linux/thermal.h                       |  2 +-
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 7ec1d0ee9bee..ecd1856bef5e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -133,7 +133,7 @@ static int mlxsw_get_cooling_device_idx(struct mlxsw_thermal *thermal,
 	/* Allow mlxsw thermal zone binding to an external cooling device */
 	for (i = 0; i < ARRAY_SIZE(mlxsw_thermal_external_allowed_cdev); i++) {
 		if (strnstr(cdev->type, mlxsw_thermal_external_allowed_cdev[i],
-			    sizeof(cdev->type)))
+			    strlen(cdev->type)))
 			return 0;
 	}
 
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index d9e34ac37662..1abef64ccb5f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1092,10 +1092,7 @@ __thermal_cooling_device_register(struct device_node *np,
 {
 	struct thermal_cooling_device *cdev;
 	struct thermal_zone_device *pos = NULL;
-	int result;
-
-	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
-		return ERR_PTR(-EINVAL);
+	int ret;
 
 	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
 	    !ops->set_cur_state)
@@ -1105,14 +1102,17 @@ __thermal_cooling_device_register(struct device_node *np,
 	if (!cdev)
 		return ERR_PTR(-ENOMEM);
 
-	result = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
-	if (result < 0) {
-		kfree(cdev);
-		return ERR_PTR(result);
+	ret = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
+	if (ret < 0)
+		goto out_kfree_cdev;
+	cdev->id = ret;
+
+	cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
+	if (!cdev->type) {
+		ret = -ENOMEM;
+		goto out_ida_remove;
 	}
 
-	cdev->id = result;
-	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
 	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
 	cdev->np = np;
@@ -1122,12 +1122,9 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->devdata = devdata;
 	thermal_cooling_device_setup_sysfs(cdev);
 	dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
-	result = device_register(&cdev->device);
-	if (result) {
-		ida_simple_remove(&thermal_cdev_ida, cdev->id);
-		put_device(&cdev->device);
-		return ERR_PTR(result);
-	}
+	ret = device_register(&cdev->device);
+	if (ret)
+		goto out_kfree_type;
 
 	/* Add 'this' new cdev to the global cdev list */
 	mutex_lock(&thermal_list_lock);
@@ -1145,6 +1142,14 @@ __thermal_cooling_device_register(struct device_node *np,
 	mutex_unlock(&thermal_list_lock);
 
 	return cdev;
+
+out_kfree_type:
+	kfree(cdev->type);
+	put_device(&cdev->device);
+out_ida_remove:
+	ida_simple_remove(&thermal_cdev_ida, cdev->id);
+out_kfree_cdev:
+	return ERR_PTR(ret);
 }
 
 /**
@@ -1303,6 +1308,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 	ida_simple_remove(&thermal_cdev_ida, cdev->id);
 	device_del(&cdev->device);
 	thermal_cooling_device_destroy_sysfs(cdev);
+	kfree(cdev->type);
 	put_device(&cdev->device);
 }
 EXPORT_SYMBOL_GPL(thermal_cooling_device_unregister);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 176d9454e8f3..7097d4dcfdd0 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -92,7 +92,7 @@ struct thermal_cooling_device_ops {
 
 struct thermal_cooling_device {
 	int id;
-	char type[THERMAL_NAME_LENGTH];
+	char *type;
 	struct device device;
 	struct device_node *np;
 	void *devdata;
-- 
2.35.1



