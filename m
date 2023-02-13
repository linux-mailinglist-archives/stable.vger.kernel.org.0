Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFE469499E
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjBMPAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjBMPAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F001C33E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:59:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3525261158
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AFCC4339B;
        Mon, 13 Feb 2023 14:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300367;
        bh=gGrkoPG7eZlzk4P8vCjgfEw0jxjGzIy17upITtw5/vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIs8pTIBBmPLVH0lAQXLYeDEFC9ksFSzS0uZJFVbydtqYKm77yO1wJ0Mcry9xBDpN
         JSNvbqnIm89cl25FsWrHdA/z/2LRBE5oOeAcv71JdABMWcvRoUSdRE0XdR3THqfBEA
         FU3nlN7teP6o34sCDyCYJDpKtPvwbTlttDf8GZP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daan De Meyer <daandemeyer@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 52/67] btrfs: free device in btrfs_close_devices for a single device filesystem
Date:   Mon, 13 Feb 2023 15:49:33 +0100
Message-Id: <20230213144734.861686734@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Jain <anand.jain@oracle.com>

commit 5f58d783fd7823b2c2d5954d1126e702f94bfc4c upstream.

We have this check to make sure we don't accidentally add older devices
that may have disappeared and re-appeared with an older generation from
being added to an fs_devices (such as a replace source device). This
makes sense, we don't want stale disks in our file system. However for
single disks this doesn't really make sense.

I've seen this in testing, but I was provided a reproducer from a
project that builds btrfs images on loopback devices. The loopback
device gets cached with the new generation, and then if it is re-used to
generate a new file system we'll fail to mount it because the new fs is
"older" than what we have in cache.

Fix this by freeing the cache when closing the device for a single device
filesystem. This will ensure that the mount command passed device path is
scanned successfully during the next mount.

CC: stable@vger.kernel.org # 5.10+
Reported-by: Daan De Meyer <daandemeyer@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -409,6 +409,7 @@ void btrfs_free_device(struct btrfs_devi
 static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
+
 	WARN_ON(fs_devices->opened);
 	while (!list_empty(&fs_devices->devices)) {
 		device = list_entry(fs_devices->devices.next,
@@ -1221,9 +1222,22 @@ void btrfs_close_devices(struct btrfs_fs
 
 	mutex_lock(&uuid_mutex);
 	close_fs_devices(fs_devices);
-	if (!fs_devices->opened)
+	if (!fs_devices->opened) {
 		list_splice_init(&fs_devices->seed_list, &list);
 
+		/*
+		 * If the struct btrfs_fs_devices is not assembled with any
+		 * other device, it can be re-initialized during the next mount
+		 * without the needing device-scan step. Therefore, it can be
+		 * fully freed.
+		 */
+		if (fs_devices->num_devices == 1) {
+			list_del(&fs_devices->fs_list);
+			free_fs_devices(fs_devices);
+		}
+	}
+
+
 	list_for_each_entry_safe(fs_devices, tmp, &list, seed_list) {
 		close_fs_devices(fs_devices);
 		list_del(&fs_devices->seed_list);


