Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767AE27B9E8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgI2BeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727684AbgI2Bbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641E522204;
        Tue, 29 Sep 2020 01:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343098;
        bh=qXb6Y9XUnzi9/zukmXKj2kpt6Tds0wmhLaiPB/O+H/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StUk9lnMnGPWaT1B8RspDJqMvPsGW4bmUgKwgew9lKcL5/C8yAD2USrsqk12snQJD
         kGNaIsiOSdgEbdpgbIDzXX/iGIXyC5VEkXsM2Xd7aC5dIJioTrFC7a8yuJs+I0/ey/
         wrLRWNni6R/rN5GWyRF7uc1eg4lwKrVCDNTE2C3I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 06/11] regmap: debugfs: Fix handling of name string for debugfs init delays
Date:   Mon, 28 Sep 2020 21:31:24 -0400
Message-Id: <20200929013129.2406832-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013129.2406832-1-sashal@kernel.org>
References: <20200929013129.2406832-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 94cc89eb8fa5039fcb6e3e3d50f929ddcccee095 ]

In regmap_debugfs_init the initialisation of the debugfs is delayed
if the root node isn't ready yet. Most callers of regmap_debugfs_init
pass the name from the regmap_config, which is considered temporary
ie. may be unallocated after the regmap_init call returns. This leads
to a potential use after free, where config->name has been freed by
the time it is used in regmap_debugfs_initcall.

This situation can be seen on Zynq, where the architecture init_irq
callback registers a syscon device, using a local variable for the
regmap_config. As init_irq is very early in the platform bring up the
regmap debugfs root isn't ready yet. Although this doesn't crash it
does result in the debugfs entry not having the correct name.

Regmap already sets map->name from config->name on the regmap_init
path and the fact that a separate field is used to pass the name
to regmap_debugfs_init appears to be an artifact of the debugfs
name being added before the map name. As such this patch updates
regmap_debugfs_init to use map->name, which is already duplicated from
the config avoiding the issue.

This does however leave two lose ends, both regmap_attach_dev and
regmap_reinit_cache can be called after a regmap is registered and
would have had the effect of applying a new name to the debugfs
entries. In both of these cases it was chosen to update the map
name. In the case of regmap_attach_dev there are 3 users that
currently use this function to update the name, thus doing so avoids
changes for those users and it seems reasonable that attaching
a device would want to set the name of the map. In the case of
regmap_reinit_cache the primary use-case appears to be devices that
need some register access to identify the device (for example devices
in the same family) and then update the cache to match the exact
hardware. Whilst no users do currently update the name here, given the
use-case it seemed reasonable the name might want to be updated once
the device is better identified.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200917120828.12987-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/internal.h       |  4 +--
 drivers/base/regmap/regmap-debugfs.c |  7 ++---
 drivers/base/regmap/regmap.c         | 44 +++++++++++++++++++++-------
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index a6bf34d6394ed..24e8c4d2fb7b3 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -217,7 +217,7 @@ struct regmap_field {
 
 #ifdef CONFIG_DEBUG_FS
 extern void regmap_debugfs_initcall(void);
-extern void regmap_debugfs_init(struct regmap *map, const char *name);
+extern void regmap_debugfs_init(struct regmap *map);
 extern void regmap_debugfs_exit(struct regmap *map);
 
 static inline void regmap_debugfs_disable(struct regmap *map)
@@ -227,7 +227,7 @@ static inline void regmap_debugfs_disable(struct regmap *map)
 
 #else
 static inline void regmap_debugfs_initcall(void) { }
-static inline void regmap_debugfs_init(struct regmap *map, const char *name) { }
+static inline void regmap_debugfs_init(struct regmap *map) { }
 static inline void regmap_debugfs_exit(struct regmap *map) { }
 static inline void regmap_debugfs_disable(struct regmap *map) { }
 #endif
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 182b1908edec2..f2f038a72e858 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -21,7 +21,6 @@
 
 struct regmap_debugfs_node {
 	struct regmap *map;
-	const char *name;
 	struct list_head link;
 };
 
@@ -540,11 +539,12 @@ static const struct file_operations regmap_cache_bypass_fops = {
 	.write = regmap_cache_bypass_write_file,
 };
 
-void regmap_debugfs_init(struct regmap *map, const char *name)
+void regmap_debugfs_init(struct regmap *map)
 {
 	struct rb_node *next;
 	struct regmap_range_node *range_node;
 	const char *devname = "dummy";
+	const char *name = map->name;
 
 	/*
 	 * Userspace can initiate reads from the hardware over debugfs.
@@ -565,7 +565,6 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 		if (!node)
 			return;
 		node->map = map;
-		node->name = name;
 		mutex_lock(&regmap_debugfs_early_lock);
 		list_add(&node->link, &regmap_debugfs_early_list);
 		mutex_unlock(&regmap_debugfs_early_lock);
@@ -687,7 +686,7 @@ void regmap_debugfs_initcall(void)
 
 	mutex_lock(&regmap_debugfs_early_lock);
 	list_for_each_entry_safe(node, tmp, &regmap_debugfs_early_list, link) {
-		regmap_debugfs_init(node->map, node->name);
+		regmap_debugfs_init(node->map);
 		list_del(&node->link);
 		kfree(node);
 	}
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d26b485ccc7d0..ca385641598b0 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -564,14 +564,34 @@ static void regmap_range_exit(struct regmap *map)
 	kfree(map->selector_work_buf);
 }
 
+static int regmap_set_name(struct regmap *map, const struct regmap_config *config)
+{
+	if (config->name) {
+		const char *name = kstrdup_const(config->name, GFP_KERNEL);
+
+		if (!name)
+			return -ENOMEM;
+
+		kfree_const(map->name);
+		map->name = name;
+	}
+
+	return 0;
+}
+
 int regmap_attach_dev(struct device *dev, struct regmap *map,
 		      const struct regmap_config *config)
 {
 	struct regmap **m;
+	int ret;
 
 	map->dev = dev;
 
-	regmap_debugfs_init(map, config->name);
+	ret = regmap_set_name(map, config);
+	if (ret)
+		return ret;
+
+	regmap_debugfs_init(map);
 
 	/* Add a devres resource for dev_get_regmap() */
 	m = devres_alloc(dev_get_regmap_release, sizeof(*m), GFP_KERNEL);
@@ -662,9 +682,9 @@ struct regmap *__regmap_init(struct device *dev,
 			     const char *lock_name)
 {
 	struct regmap *map;
-	int ret = -EINVAL;
 	enum regmap_endian reg_endian, val_endian;
 	int i, j;
+	int ret;
 
 	if (!config)
 		goto err;
@@ -675,13 +695,9 @@ struct regmap *__regmap_init(struct device *dev,
 		goto err;
 	}
 
-	if (config->name) {
-		map->name = kstrdup_const(config->name, GFP_KERNEL);
-		if (!map->name) {
-			ret = -ENOMEM;
-			goto err_map;
-		}
-	}
+	ret = regmap_set_name(map, config);
+	if (ret)
+		goto err_map;
 
 	if (config->disable_locking) {
 		map->lock = map->unlock = regmap_lock_unlock_none;
@@ -1122,7 +1138,7 @@ struct regmap *__regmap_init(struct device *dev,
 		if (ret != 0)
 			goto err_regcache;
 	} else {
-		regmap_debugfs_init(map, config->name);
+		regmap_debugfs_init(map);
 	}
 
 	return map;
@@ -1282,6 +1298,8 @@ EXPORT_SYMBOL_GPL(regmap_field_free);
  */
 int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 {
+	int ret;
+
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 
@@ -1293,7 +1311,11 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 	map->readable_noinc_reg = config->readable_noinc_reg;
 	map->cache_type = config->cache_type;
 
-	regmap_debugfs_init(map, config->name);
+	ret = regmap_set_name(map, config);
+	if (ret)
+		return ret;
+
+	regmap_debugfs_init(map);
 
 	map->cache_bypass = false;
 	map->cache_only = false;
-- 
2.25.1

