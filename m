Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE47226A90
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgGTPxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730515AbgGTPxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:53:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00C532065E;
        Mon, 20 Jul 2020 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260413;
        bh=qvGXchyGWLymBMEHc9gzvLWJ07Wcs5sTZbCN5VHoK9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuhsUHFlplFWOPBXoUGqcJLpeToz2HOTPXwL4Eip6l4UUo6XZhnS1MFFukmTXMxBj
         PKSKwTi7dgVkMcl0vD86i+77//7XM60MtVgaIDi73PdaFKR2tc8Aqw1FrxlGfDiXn4
         g5/fCMsMH/Mufi568yuWJsjXcFPfsruhCDAGYc5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/133] regmap: debugfs: Dont sleep while atomic for fast_io regmaps
Date:   Mon, 20 Jul 2020 17:36:53 +0200
Message-Id: <20200720152806.931980695@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 299632e54b2e692d2830af84be51172480dc1e26 ]

If a regmap has "fast_io" set then its lock function uses a spinlock.
That doesn't work so well with the functions:
* regmap_cache_only_write_file()
* regmap_cache_bypass_write_file()

Both of the above functions have the pattern:
1. Lock the regmap.
2. Call:
   debugfs_write_file_bool()
     copy_from_user()
       __might_fault()
         __might_sleep()

Let's reorder things a bit so that we do all of our sleepable
functions before we grab the lock.

Fixes: d3dc5430d68f ("regmap: debugfs: Allow writes to cache state settings")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200715164611.1.I35b3533e8a80efde0cec1cc70f71e1e74b2fa0da@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-debugfs.c | 52 ++++++++++++++++------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index c9687c8b23478..056e34ce1eddd 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -453,29 +453,31 @@ static ssize_t regmap_cache_only_write_file(struct file *file,
 {
 	struct regmap *map = container_of(file->private_data,
 					  struct regmap, cache_only);
-	ssize_t result;
-	bool was_enabled, require_sync = false;
+	bool new_val, require_sync = false;
 	int err;
 
-	map->lock(map->lock_arg);
+	err = kstrtobool_from_user(user_buf, count, &new_val);
+	/* Ignore malforned data like debugfs_write_file_bool() */
+	if (err)
+		return count;
 
-	was_enabled = map->cache_only;
+	err = debugfs_file_get(file->f_path.dentry);
+	if (err)
+		return err;
 
-	result = debugfs_write_file_bool(file, user_buf, count, ppos);
-	if (result < 0) {
-		map->unlock(map->lock_arg);
-		return result;
-	}
+	map->lock(map->lock_arg);
 
-	if (map->cache_only && !was_enabled) {
+	if (new_val && !map->cache_only) {
 		dev_warn(map->dev, "debugfs cache_only=Y forced\n");
 		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
-	} else if (!map->cache_only && was_enabled) {
+	} else if (!new_val && map->cache_only) {
 		dev_warn(map->dev, "debugfs cache_only=N forced: syncing cache\n");
 		require_sync = true;
 	}
+	map->cache_only = new_val;
 
 	map->unlock(map->lock_arg);
+	debugfs_file_put(file->f_path.dentry);
 
 	if (require_sync) {
 		err = regcache_sync(map);
@@ -483,7 +485,7 @@ static ssize_t regmap_cache_only_write_file(struct file *file,
 			dev_err(map->dev, "Failed to sync cache %d\n", err);
 	}
 
-	return result;
+	return count;
 }
 
 static const struct file_operations regmap_cache_only_fops = {
@@ -498,28 +500,32 @@ static ssize_t regmap_cache_bypass_write_file(struct file *file,
 {
 	struct regmap *map = container_of(file->private_data,
 					  struct regmap, cache_bypass);
-	ssize_t result;
-	bool was_enabled;
+	bool new_val;
+	int err;
 
-	map->lock(map->lock_arg);
+	err = kstrtobool_from_user(user_buf, count, &new_val);
+	/* Ignore malforned data like debugfs_write_file_bool() */
+	if (err)
+		return count;
 
-	was_enabled = map->cache_bypass;
+	err = debugfs_file_get(file->f_path.dentry);
+	if (err)
+		return err;
 
-	result = debugfs_write_file_bool(file, user_buf, count, ppos);
-	if (result < 0)
-		goto out;
+	map->lock(map->lock_arg);
 
-	if (map->cache_bypass && !was_enabled) {
+	if (new_val && !map->cache_bypass) {
 		dev_warn(map->dev, "debugfs cache_bypass=Y forced\n");
 		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
-	} else if (!map->cache_bypass && was_enabled) {
+	} else if (!new_val && map->cache_bypass) {
 		dev_warn(map->dev, "debugfs cache_bypass=N forced\n");
 	}
+	map->cache_bypass = new_val;
 
-out:
 	map->unlock(map->lock_arg);
+	debugfs_file_put(file->f_path.dentry);
 
-	return result;
+	return count;
 }
 
 static const struct file_operations regmap_cache_bypass_fops = {
-- 
2.25.1



