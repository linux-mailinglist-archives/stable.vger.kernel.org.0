Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095A269CD4D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjBTNsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjBTNsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73EFF09
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:47:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F07760E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336E0C433EF;
        Mon, 20 Feb 2023 13:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900877;
        bh=PsH748ApA7nAeYmOtVc2MaWKu0p5zL5Vv5yzfBw8p+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqnMMxdaCZizU9Lfo4Vaz6DrZ18HBU4Z4bIsIzVRwr8Qx1qVsvpi08/zQJ6P8UfJ+
         28Sdsw4L9cbLwKj/9x3yZHe5iYsfrybusad9Cv2nsPUwgksHK5w6cV0l8he6njFy3N
         JUzOu1eopdkp5ep56iosT6QfAz32TxgBH88KU82M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daan De Meyer <daandemeyer@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 100/156] btrfs: free device in btrfs_close_devices for a single device filesystem
Date:   Mon, 20 Feb 2023 14:35:44 +0100
Message-Id: <20230220133606.668832255@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -354,6 +354,7 @@ void btrfs_free_device(struct btrfs_devi
 static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
+
 	WARN_ON(fs_devices->opened);
 	while (!list_empty(&fs_devices->devices)) {
 		device = list_entry(fs_devices->devices.next,
@@ -1401,6 +1402,17 @@ int btrfs_close_devices(struct btrfs_fs_
 	if (!fs_devices->opened) {
 		seed_devices = fs_devices->seed;
 		fs_devices->seed = NULL;
+
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
 	}
 	mutex_unlock(&uuid_mutex);
 


