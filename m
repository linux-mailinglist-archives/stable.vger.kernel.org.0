Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1612594B48
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351237AbiHPAO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356877AbiHPAM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:12:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DF6175E08;
        Mon, 15 Aug 2022 13:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 237DAB81197;
        Mon, 15 Aug 2022 20:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26062C433D6;
        Mon, 15 Aug 2022 20:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595380;
        bh=6JLjxT/Lu+DUMinJzcdWuuAg5ranlTsisFvAYUj8FuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWgFHBfHvMYZ0uumRqDUL4MAPA7zP5O7Vm6dPe3UyzS5CHWNycuiXHYtHLLL4KH+/
         wUWeDM+JbTAtoLe8e9BNllMxYeRVNWo/HQUxESzb9AFbrH1zxFfwx3tq+l4zoWG4da
         18YM1alGW3HR6h8Ji9W5Zz5vdQXKS8kDX0YiijCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0746/1157] coresight: syscfg: Update load and unload operations
Date:   Mon, 15 Aug 2022 20:01:42 +0200
Message-Id: <20220815180509.307913812@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 8add26f7ef33bba7984cb6ff7911c6aa970fe55a ]

The configfs system is a source of access to the config information in the
configuration and feature lists.

This can result in additional LOCKDEP issues as a result of the mutex
ordering between the config list mutex (cscfg_mutex) and the configfs
system mutexes.

As such we need to adjust how load/unload operations work to ensure correct
operation.

1) Previously the cscfg_mutex was held throughout the load/unload
operation. This is now only held during configuration list manipulations,
resulting in a multi-stage load/unload process.

2) All operations that manipulate the configfs representation of the
configurations and features are now separated out and run without the
cscfg_mutex being held. This avoids circular lock_dep issue with the
built-in configfs mutexes and semaphores

3) As the load and unload is now multi-stage, some parts under the
cscfg_mutex and others not:
i) A flag indicating a load / unload operation in progress is used to
serialise load / unload operations.
ii) activating any configuration not possible when unload is in progress.
iii) Configurations have an "available" flag set only after the last load
stage for the configuration is complete. Activation of the configuration
not possible till flag is set.

4) Following load/unload rules remain:
i) Unload prevented while any configuration is active remains.
ii) Unload in strict reverse order of load.
iii) Existing configurations can be activated while a new load operation
is underway. (by definition there can be no dependencies between an
existing configuration and a new loading one due to ii) above.)

Fixes: eb2ec49606c2 ("coresight: syscfg: Update load API for config loadable modules")
Reported-by: Suzuki Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Reviewed-and-tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20220628173004.30002-3-mike.leach@linaro.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-config.h    |   2 +
 .../hwtracing/coresight/coresight-syscfg.c    | 191 ++++++++++++++----
 .../hwtracing/coresight/coresight-syscfg.h    |  13 ++
 3 files changed, 165 insertions(+), 41 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-config.h b/drivers/hwtracing/coresight/coresight-config.h
index 2e1670523461..6ba013975741 100644
--- a/drivers/hwtracing/coresight/coresight-config.h
+++ b/drivers/hwtracing/coresight/coresight-config.h
@@ -134,6 +134,7 @@ struct cscfg_feature_desc {
  * @active_cnt:		ref count for activate on this configuration.
  * @load_owner:		handle to load owner for dynamic load and unload of configs.
  * @fs_group:		reference to configfs group for dynamic unload.
+ * @available:		config can be activated - multi-stage load sets true on completion.
  */
 struct cscfg_config_desc {
 	const char *name;
@@ -148,6 +149,7 @@ struct cscfg_config_desc {
 	atomic_t active_cnt;
 	void *load_owner;
 	struct config_group *fs_group;
+	bool available;
 };
 
 /**
diff --git a/drivers/hwtracing/coresight/coresight-syscfg.c b/drivers/hwtracing/coresight/coresight-syscfg.c
index 17e728ab5c99..11138a9762b0 100644
--- a/drivers/hwtracing/coresight/coresight-syscfg.c
+++ b/drivers/hwtracing/coresight/coresight-syscfg.c
@@ -447,6 +447,8 @@ static void cscfg_unload_owned_cfgs_feats(void *load_owner)
 	struct cscfg_feature_desc *feat_desc, *feat_tmp;
 	struct cscfg_registered_csdev *csdev_item;
 
+	lockdep_assert_held(&cscfg_mutex);
+
 	/* remove from each csdev instance feature and config lists */
 	list_for_each_entry(csdev_item, &cscfg_mgr->csdev_desc_list, item) {
 		/*
@@ -460,7 +462,6 @@ static void cscfg_unload_owned_cfgs_feats(void *load_owner)
 	/* remove from the config descriptor lists */
 	list_for_each_entry_safe(config_desc, cfg_tmp, &cscfg_mgr->config_desc_list, item) {
 		if (config_desc->load_owner == load_owner) {
-			cscfg_configfs_del_config(config_desc);
 			etm_perf_del_symlink_cscfg(config_desc);
 			list_del(&config_desc->item);
 		}
@@ -469,12 +470,90 @@ static void cscfg_unload_owned_cfgs_feats(void *load_owner)
 	/* remove from the feature descriptor lists */
 	list_for_each_entry_safe(feat_desc, feat_tmp, &cscfg_mgr->feat_desc_list, item) {
 		if (feat_desc->load_owner == load_owner) {
-			cscfg_configfs_del_feature(feat_desc);
 			list_del(&feat_desc->item);
 		}
 	}
 }
 
+/*
+ * load the features and configs to the lists - called with list mutex held
+ */
+static int cscfg_load_owned_cfgs_feats(struct cscfg_config_desc **config_descs,
+				       struct cscfg_feature_desc **feat_descs,
+				       struct cscfg_load_owner_info *owner_info)
+{
+	int i, err;
+
+	lockdep_assert_held(&cscfg_mutex);
+
+	/* load features first */
+	if (feat_descs) {
+		for (i = 0; feat_descs[i]; i++) {
+			err = cscfg_load_feat(feat_descs[i]);
+			if (err) {
+				pr_err("coresight-syscfg: Failed to load feature %s\n",
+				       feat_descs[i]->name);
+				return err;
+			}
+			feat_descs[i]->load_owner = owner_info;
+		}
+	}
+
+	/* next any configurations to check feature dependencies */
+	if (config_descs) {
+		for (i = 0; config_descs[i]; i++) {
+			err = cscfg_load_config(config_descs[i]);
+			if (err) {
+				pr_err("coresight-syscfg: Failed to load configuration %s\n",
+				       config_descs[i]->name);
+				return err;
+			}
+			config_descs[i]->load_owner = owner_info;
+			config_descs[i]->available = false;
+		}
+	}
+	return 0;
+}
+
+/* set configurations as available to activate at the end of the load process */
+static void cscfg_set_configs_available(struct cscfg_config_desc **config_descs)
+{
+	int i;
+
+	lockdep_assert_held(&cscfg_mutex);
+
+	if (config_descs) {
+		for (i = 0; config_descs[i]; i++)
+			config_descs[i]->available = true;
+	}
+}
+
+/*
+ * Create and register each of the configurations and features with configfs.
+ * Called without mutex being held.
+ */
+static int cscfg_fs_register_cfgs_feats(struct cscfg_config_desc **config_descs,
+					struct cscfg_feature_desc **feat_descs)
+{
+	int i, err;
+
+	if (feat_descs) {
+		for (i = 0; feat_descs[i]; i++) {
+			err = cscfg_configfs_add_feature(feat_descs[i]);
+			if (err)
+				return err;
+		}
+	}
+	if (config_descs) {
+		for (i = 0; config_descs[i]; i++) {
+			err = cscfg_configfs_add_config(config_descs[i]);
+			if (err)
+				return err;
+		}
+	}
+	return 0;
+}
+
 /**
  * cscfg_load_config_sets - API function to load feature and config sets.
  *
@@ -497,57 +576,63 @@ int cscfg_load_config_sets(struct cscfg_config_desc **config_descs,
 			   struct cscfg_feature_desc **feat_descs,
 			   struct cscfg_load_owner_info *owner_info)
 {
-	int err = 0, i = 0;
+	int err = 0;
 
 	mutex_lock(&cscfg_mutex);
-
-	/* load features first */
-	if (feat_descs) {
-		while (feat_descs[i]) {
-			err = cscfg_load_feat(feat_descs[i]);
-			if (!err)
-				err = cscfg_configfs_add_feature(feat_descs[i]);
-			if (err) {
-				pr_err("coresight-syscfg: Failed to load feature %s\n",
-				       feat_descs[i]->name);
-				cscfg_unload_owned_cfgs_feats(owner_info);
-				goto exit_unlock;
-			}
-			feat_descs[i]->load_owner = owner_info;
-			i++;
-		}
+	if (cscfg_mgr->load_state != CSCFG_NONE) {
+		mutex_unlock(&cscfg_mutex);
+		return -EBUSY;
 	}
+	cscfg_mgr->load_state = CSCFG_LOAD;
 
-	/* next any configurations to check feature dependencies */
-	i = 0;
-	if (config_descs) {
-		while (config_descs[i]) {
-			err = cscfg_load_config(config_descs[i]);
-			if (!err)
-				err = cscfg_configfs_add_config(config_descs[i]);
-			if (err) {
-				pr_err("coresight-syscfg: Failed to load configuration %s\n",
-				       config_descs[i]->name);
-				cscfg_unload_owned_cfgs_feats(owner_info);
-				goto exit_unlock;
-			}
-			config_descs[i]->load_owner = owner_info;
-			i++;
-		}
-	}
+	/* first load and add to the lists */
+	err = cscfg_load_owned_cfgs_feats(config_descs, feat_descs, owner_info);
+	if (err)
+		goto err_clean_load;
 
 	/* add the load owner to the load order list */
 	list_add_tail(&owner_info->item, &cscfg_mgr->load_order_list);
 	if (!list_is_singular(&cscfg_mgr->load_order_list)) {
 		/* lock previous item in load order list */
 		err = cscfg_owner_get(list_prev_entry(owner_info, item));
-		if (err) {
-			cscfg_unload_owned_cfgs_feats(owner_info);
-			list_del(&owner_info->item);
-		}
+		if (err)
+			goto err_clean_owner_list;
 	}
 
+	/*
+	 * make visible to configfs - configfs manipulation must occur outside
+	 * the list mutex lock to avoid circular lockdep issues with configfs
+	 * built in mutexes and semaphores. This is safe as it is not possible
+	 * to start a new load/unload operation till the current one is done.
+	 */
+	mutex_unlock(&cscfg_mutex);
+
+	/* create the configfs elements */
+	err = cscfg_fs_register_cfgs_feats(config_descs, feat_descs);
+	mutex_lock(&cscfg_mutex);
+
+	if (err)
+		goto err_clean_cfs;
+
+	/* mark any new configs as available for activation */
+	cscfg_set_configs_available(config_descs);
+	goto exit_unlock;
+
+err_clean_cfs:
+	/* cleanup after error registering with configfs */
+	cscfg_fs_unregister_cfgs_feats(owner_info);
+
+	if (!list_is_singular(&cscfg_mgr->load_order_list))
+		cscfg_owner_put(list_prev_entry(owner_info, item));
+
+err_clean_owner_list:
+	list_del(&owner_info->item);
+
+err_clean_load:
+	cscfg_unload_owned_cfgs_feats(owner_info);
+
 exit_unlock:
+	cscfg_mgr->load_state = CSCFG_NONE;
 	mutex_unlock(&cscfg_mutex);
 	return err;
 }
@@ -564,6 +649,9 @@ EXPORT_SYMBOL_GPL(cscfg_load_config_sets);
  * 1) no configurations are active.
  * 2) the set being unloaded was the last to be loaded to maintain dependencies.
  *
+ * Once the unload operation commences, we disallow any configuration being
+ * made active until it is complete.
+ *
  * @owner_info:	Information on owner for set being unloaded.
  */
 int cscfg_unload_config_sets(struct cscfg_load_owner_info *owner_info)
@@ -572,6 +660,13 @@ int cscfg_unload_config_sets(struct cscfg_load_owner_info *owner_info)
 	struct cscfg_load_owner_info *load_list_item = NULL;
 
 	mutex_lock(&cscfg_mutex);
+	if (cscfg_mgr->load_state != CSCFG_NONE) {
+		mutex_unlock(&cscfg_mutex);
+		return -EBUSY;
+	}
+
+	/* unload op in progress also prevents activation of any config */
+	cscfg_mgr->load_state = CSCFG_UNLOAD;
 
 	/* cannot unload if anything is active */
 	if (atomic_read(&cscfg_mgr->sys_active_cnt)) {
@@ -592,7 +687,12 @@ int cscfg_unload_config_sets(struct cscfg_load_owner_info *owner_info)
 		goto exit_unlock;
 	}
 
-	/* unload all belonging to load_owner */
+	/* remove from configfs - again outside the scope of the list mutex */
+	mutex_unlock(&cscfg_mutex);
+	cscfg_fs_unregister_cfgs_feats(owner_info);
+	mutex_lock(&cscfg_mutex);
+
+	/* unload everything from lists belonging to load_owner */
 	cscfg_unload_owned_cfgs_feats(owner_info);
 
 	/* remove from load order list */
@@ -603,6 +703,7 @@ int cscfg_unload_config_sets(struct cscfg_load_owner_info *owner_info)
 	list_del(&owner_info->item);
 
 exit_unlock:
+	cscfg_mgr->load_state = CSCFG_NONE;
 	mutex_unlock(&cscfg_mutex);
 	return err;
 }
@@ -780,8 +881,15 @@ static int _cscfg_activate_config(unsigned long cfg_hash)
 	struct cscfg_config_desc *config_desc;
 	int err = -EINVAL;
 
+	if (cscfg_mgr->load_state == CSCFG_UNLOAD)
+		return -EBUSY;
+
 	list_for_each_entry(config_desc, &cscfg_mgr->config_desc_list, item) {
 		if ((unsigned long)config_desc->event_ea->var == cfg_hash) {
+			/* if we happen upon a partly loaded config, can't use it */
+			if (config_desc->available == false)
+				return -EBUSY;
+
 			/* must ensure that config cannot be unloaded in use */
 			err = cscfg_owner_get(config_desc->load_owner);
 			if (err)
@@ -1071,6 +1179,7 @@ static int cscfg_create_device(void)
 	INIT_LIST_HEAD(&cscfg_mgr->config_desc_list);
 	INIT_LIST_HEAD(&cscfg_mgr->load_order_list);
 	atomic_set(&cscfg_mgr->sys_active_cnt, 0);
+	cscfg_mgr->load_state = CSCFG_NONE;
 
 	/* setup the device */
 	dev = cscfg_device();
diff --git a/drivers/hwtracing/coresight/coresight-syscfg.h b/drivers/hwtracing/coresight/coresight-syscfg.h
index 9106ffab4833..66e2db890d82 100644
--- a/drivers/hwtracing/coresight/coresight-syscfg.h
+++ b/drivers/hwtracing/coresight/coresight-syscfg.h
@@ -12,6 +12,17 @@
 
 #include "coresight-config.h"
 
+/*
+ * Load operation types.
+ * When loading or unloading, another load operation cannot be run.
+ * When unloading configurations cannot be activated.
+ */
+enum cscfg_load_ops {
+	CSCFG_NONE,
+	CSCFG_LOAD,
+	CSCFG_UNLOAD
+};
+
 /**
  * System configuration manager device.
  *
@@ -30,6 +41,7 @@
  * @cfgfs_subsys:	configfs subsystem used to manage configurations.
  * @sysfs_active_config:Active config hash used if CoreSight controlled from sysfs.
  * @sysfs_active_preset:Active preset index used if CoreSight controlled from sysfs.
+ * @load_state:		A multi-stage load/unload operation is in progress.
  */
 struct cscfg_manager {
 	struct device dev;
@@ -41,6 +53,7 @@ struct cscfg_manager {
 	struct configfs_subsystem cfgfs_subsys;
 	u32 sysfs_active_config;
 	int sysfs_active_preset;
+	enum cscfg_load_ops load_state;
 };
 
 /* get reference to dev in cscfg_manager */
-- 
2.35.1



