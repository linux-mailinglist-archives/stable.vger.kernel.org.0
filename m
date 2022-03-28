Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9174EA033
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343924AbiC1Trt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbiC1Tq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:46:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEEC692A5;
        Mon, 28 Mar 2022 12:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E29D4B81205;
        Mon, 28 Mar 2022 19:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99058C34112;
        Mon, 28 Mar 2022 19:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496595;
        bh=VEzzR77h+TVNn8t6F21fg2748P4148M/vVkJolOx9t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enhHz1DOCQEqSTVIe+7W3Ka8n6JjyiOaxFj8WQdl7uWWW0K0UTuT5qbaKlSChjdH6
         oeFVNrDNnjh4ulxABtx9MXIHmt9u1XFJRkJzK0YUmLcuC0SKb/10Rp4zbKZuXD5/cP
         yUFEaB06Uf0IeeM2Ej21gi5rYhs5n97rF5kfQ3gekc1iC7TesuwIpmL4TuO5M9XW+D
         2/V/efpOUWsNzCssNQy4CH5/Ln0j52uHJGIQ4KkEZCyEetXOvFaeq81snRDBuRaOEr
         f7cKSWgCvCswOFMSCQsZWo4GYfhgrIJybmhh2EE89n3eywcyeQcjjLY8i4C0t4K20X
         y0XcwMBFsS98w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/16] btrfs: harden identification of a stale device
Date:   Mon, 28 Mar 2022 15:42:54 -0400
Message-Id: <20220328194300.1586178-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194300.1586178-1-sashal@kernel.org>
References: <20220328194300.1586178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit 770c79fb65506fc7c16459855c3839429f46cb32 ]

Identifying and removing the stale device from the fs_uuids list is done
by btrfs_free_stale_devices().  btrfs_free_stale_devices() in turn
depends on device_path_matched() to check if the device appears in more
than one btrfs_device structure.

The matching of the device happens by its path, the device path. However,
when device mapper is in use, the dm device paths are nothing but a link
to the actual block device, which leads to the device_path_matched()
failing to match.

Fix this by matching the dev_t as provided by lookup_bdev() instead of
plain string compare of the device paths.

Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 06a1a7c2254c..33bd94ee4690 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -530,15 +530,48 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
 	return ret;
 }
 
-static bool device_path_matched(const char *path, struct btrfs_device *device)
+/*
+ * Check if the device in the path matches the device in the given struct device.
+ *
+ * Returns:
+ *   true  If it is the same device.
+ *   false If it is not the same device or on error.
+ */
+static bool device_matched(const struct btrfs_device *device, const char *path)
 {
-	int found;
+	char *device_name;
+	dev_t dev_old;
+	dev_t dev_new;
+	int ret;
+
+	/*
+	 * If we are looking for a device with the matching dev_t, then skip
+	 * device without a name (a missing device).
+	 */
+	if (!device->name)
+		return false;
+
+	device_name = kzalloc(BTRFS_PATH_NAME_MAX, GFP_KERNEL);
+	if (!device_name)
+		return false;
 
 	rcu_read_lock();
-	found = strcmp(rcu_str_deref(device->name), path);
+	scnprintf(device_name, BTRFS_PATH_NAME_MAX, "%s", rcu_str_deref(device->name));
 	rcu_read_unlock();
 
-	return found == 0;
+	ret = lookup_bdev(device_name, &dev_old);
+	kfree(device_name);
+	if (ret)
+		return false;
+
+	ret = lookup_bdev(path, &dev_new);
+	if (ret)
+		return false;
+
+	if (dev_old == dev_new)
+		return true;
+
+	return false;
 }
 
 /*
@@ -571,9 +604,7 @@ static int btrfs_free_stale_devices(const char *path,
 					 &fs_devices->devices, dev_list) {
 			if (skip_device && skip_device == device)
 				continue;
-			if (path && !device->name)
-				continue;
-			if (path && !device_path_matched(path, device))
+			if (path && !device_matched(device, path))
 				continue;
 			if (fs_devices->opened) {
 				/* for an already deleted device return 0 */
-- 
2.34.1

