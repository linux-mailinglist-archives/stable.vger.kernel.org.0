Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F255944B1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347299AbiHOV7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244496AbiHOV7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:59:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A6F10E949;
        Mon, 15 Aug 2022 12:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6EFB8CE12E0;
        Mon, 15 Aug 2022 19:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4428DC433D7;
        Mon, 15 Aug 2022 19:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592071;
        bh=2wEmTjhGcMoUyc8RMh2YSMUxxlVkaz9yxKNpzM825EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyQKfJvsf780D38RU/nEGg67JKrC4cP3dhVedXYpW4JQ2V7Nnh1G07JAd6+mLSjOJ
         YLE0HkWshrDttOa6apW1cdtKj6BAswEm13PCpv7pOOzoi4lb2Rxim58twjLVRfKx8G
         Ky7biVM90Y1HayZqL/MTMn8zRLBQVUVv5i0AV/5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0697/1095] coresight: configfs: Fix unload of configurations on module exit
Date:   Mon, 15 Aug 2022 20:01:36 +0200
Message-Id: <20220815180458.210907254@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

[ Upstream commit 199380decc5f9188a9e65676031950f1734aaffe ]

Any loaded configurations must be correctly unloaded on coresight module
exit, or issues can arise with nested locking in the configfs directory
code if built with CONFIG_LOCKDEP.

Prior to this patch, the preloaded configuration configfs directory entries
were being unloaded by the recursive code in
configfs_unregister_subsystem().

However, when built with CONFIG_LOCKDEP, this caused a nested lock warning,
which was not mitigated by the LOCKDEP dependent code in fs/configfs/dir.c
designed to prevent this, due to the different directory levels for the
root of the directory being removed.

As the preloaded (and all other) configurations are registered after
configfs_register_subsystem(), we now explicitly unload them before the
call to configfs_unregister_subsystem().

The new routine cscfg_unload_cfgs_on_exit() iterates through the load
owner list to unload any remaining configurations that were not unloaded
by the user before the module exits. This covers both the
CSCFG_OWNER_PRELOAD and CSCFG_OWNER_MODULE owner types, and will be
extended to cover future load owner types for CoreSight configurations.

Fixes: eb2ec49606c2 ("coresight: syscfg: Update load API for config loadable modules")
Reported-by: Suzuki Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Reviewed-and-tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20220628173004.30002-2-mike.leach@linaro.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-syscfg.c    | 104 ++++++++++++++++--
 1 file changed, 93 insertions(+), 11 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-syscfg.c b/drivers/hwtracing/coresight/coresight-syscfg.c
index 11850fd8c3b5..17e728ab5c99 100644
--- a/drivers/hwtracing/coresight/coresight-syscfg.c
+++ b/drivers/hwtracing/coresight/coresight-syscfg.c
@@ -414,6 +414,27 @@ static void cscfg_remove_owned_csdev_features(struct coresight_device *csdev, vo
 	}
 }
 
+/*
+ * Unregister all configuration and features from configfs owned by load_owner.
+ * Although this is called without the list mutex being held, it is in the
+ * context of an unload operation which are strictly serialised,
+ * so the lists cannot change during this call.
+ */
+static void cscfg_fs_unregister_cfgs_feats(void *load_owner)
+{
+	struct cscfg_config_desc *config_desc;
+	struct cscfg_feature_desc *feat_desc;
+
+	list_for_each_entry(config_desc, &cscfg_mgr->config_desc_list, item) {
+		if (config_desc->load_owner == load_owner)
+			cscfg_configfs_del_config(config_desc);
+	}
+	list_for_each_entry(feat_desc, &cscfg_mgr->feat_desc_list, item) {
+		if (feat_desc->load_owner == load_owner)
+			cscfg_configfs_del_feature(feat_desc);
+	}
+}
+
 /*
  * removal is relatively easy - just remove from all lists, anything that
  * matches the owner. Memory for the descriptors will be managed by the owner,
@@ -1022,8 +1043,10 @@ struct device *cscfg_device(void)
 /* Must have a release function or the kernel will complain on module unload */
 static void cscfg_dev_release(struct device *dev)
 {
+	mutex_lock(&cscfg_mutex);
 	kfree(cscfg_mgr);
 	cscfg_mgr = NULL;
+	mutex_unlock(&cscfg_mutex);
 }
 
 /* a device is needed to "own" some kernel elements such as sysfs entries.  */
@@ -1042,6 +1065,13 @@ static int cscfg_create_device(void)
 	if (!cscfg_mgr)
 		goto create_dev_exit_unlock;
 
+	/* initialise the cscfg_mgr structure */
+	INIT_LIST_HEAD(&cscfg_mgr->csdev_desc_list);
+	INIT_LIST_HEAD(&cscfg_mgr->feat_desc_list);
+	INIT_LIST_HEAD(&cscfg_mgr->config_desc_list);
+	INIT_LIST_HEAD(&cscfg_mgr->load_order_list);
+	atomic_set(&cscfg_mgr->sys_active_cnt, 0);
+
 	/* setup the device */
 	dev = cscfg_device();
 	dev->release = cscfg_dev_release;
@@ -1056,17 +1086,73 @@ static int cscfg_create_device(void)
 	return err;
 }
 
-static void cscfg_clear_device(void)
+/*
+ * Loading and unloading is generally on user discretion.
+ * If exiting due to coresight module unload, we need to unload any configurations that remain,
+ * before we unregister the configfs intrastructure.
+ *
+ * Do this by walking the load_owner list and taking appropriate action, depending on the load
+ * owner type.
+ */
+static void cscfg_unload_cfgs_on_exit(void)
 {
-	struct cscfg_config_desc *cfg_desc;
+	struct cscfg_load_owner_info *owner_info = NULL;
 
+	/*
+	 * grab the mutex - even though we are exiting, some configfs files
+	 * may still be live till we dump them, so ensure list data is
+	 * protected from a race condition.
+	 */
 	mutex_lock(&cscfg_mutex);
-	list_for_each_entry(cfg_desc, &cscfg_mgr->config_desc_list, item) {
-		etm_perf_del_symlink_cscfg(cfg_desc);
+	while (!list_empty(&cscfg_mgr->load_order_list)) {
+
+		/* remove in reverse order of loading */
+		owner_info = list_last_entry(&cscfg_mgr->load_order_list,
+					     struct cscfg_load_owner_info, item);
+
+		/* action according to type */
+		switch (owner_info->type) {
+		case CSCFG_OWNER_PRELOAD:
+			/*
+			 * preloaded  descriptors are statically allocated in
+			 * this module - just need to unload dynamic items from
+			 * csdev lists, and remove from configfs directories.
+			 */
+			pr_info("cscfg: unloading preloaded configurations\n");
+			break;
+
+		case  CSCFG_OWNER_MODULE:
+			/*
+			 * this is an error - the loadable module must have been unloaded prior
+			 * to the coresight module unload. Therefore that module has not
+			 * correctly unloaded configs in its own exit code.
+			 * Nothing to do other than emit an error string as the static descriptor
+			 * references we need to unload will have disappeared with the module.
+			 */
+			pr_err("cscfg: ERROR: prior module failed to unload configuration\n");
+			goto list_remove;
+		}
+
+		/* remove from configfs - outside the scope of the list mutex */
+		mutex_unlock(&cscfg_mutex);
+		cscfg_fs_unregister_cfgs_feats(owner_info);
+		mutex_lock(&cscfg_mutex);
+
+		/* Next unload from csdev lists. */
+		cscfg_unload_owned_cfgs_feats(owner_info);
+
+list_remove:
+		/* remove from load order list */
+		list_del(&owner_info->item);
 	}
+	mutex_unlock(&cscfg_mutex);
+}
+
+static void cscfg_clear_device(void)
+{
+	cscfg_unload_cfgs_on_exit();
 	cscfg_configfs_release(cscfg_mgr);
 	device_unregister(cscfg_device());
-	mutex_unlock(&cscfg_mutex);
 }
 
 /* Initialise system config management API device  */
@@ -1074,20 +1160,16 @@ int __init cscfg_init(void)
 {
 	int err = 0;
 
+	/* create the device and init cscfg_mgr */
 	err = cscfg_create_device();
 	if (err)
 		return err;
 
+	/* initialise configfs subsystem */
 	err = cscfg_configfs_init(cscfg_mgr);
 	if (err)
 		goto exit_err;
 
-	INIT_LIST_HEAD(&cscfg_mgr->csdev_desc_list);
-	INIT_LIST_HEAD(&cscfg_mgr->feat_desc_list);
-	INIT_LIST_HEAD(&cscfg_mgr->config_desc_list);
-	INIT_LIST_HEAD(&cscfg_mgr->load_order_list);
-	atomic_set(&cscfg_mgr->sys_active_cnt, 0);
-
 	/* preload built-in configurations */
 	err = cscfg_preload(THIS_MODULE);
 	if (err)
-- 
2.35.1



