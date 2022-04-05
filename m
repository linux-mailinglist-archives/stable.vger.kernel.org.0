Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8AB4F31BC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiDEIjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbiDEIZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:25:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379B4640E;
        Tue,  5 Apr 2022 01:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BB12CE1BFD;
        Tue,  5 Apr 2022 08:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE50BC385A0;
        Tue,  5 Apr 2022 08:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146839;
        bh=/o9fNK5bqR6kftZu/EOWCZug70FUBtUshjvzfQYlfQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdQMgXma0xOYGFdk6akLh3eXFckUSsBE3Op1FYvVRba7Pyonh4X/TiNNlim1V3NiD
         SqOknx/K5YzhS9t1cUjIQ4z7K+11vuOsBHWnMpxQlV1rUTNgELvWMmIMYtrXS9BPtd
         BuACIraGmkejl9BF6JaCrksbuEKb1clVpgC1lofA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0880/1126] btrfs: harden identification of a stale device
Date:   Tue,  5 Apr 2022 09:27:07 +0200
Message-Id: <20220405070433.360745294@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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
index b07d382d53a8..24e559d90b6a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -534,15 +534,48 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
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
@@ -575,9 +608,7 @@ static int btrfs_free_stale_devices(const char *path,
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



