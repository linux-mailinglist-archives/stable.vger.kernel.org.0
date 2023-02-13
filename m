Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2DD694926
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjBMO4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBMO4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:56:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C111CF62
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B423F6113A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88E3C433D2;
        Mon, 13 Feb 2023 14:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300153;
        bh=Xn2s9b9zvceMPwGSnwMVIypGjOYtD7ureubCOqCepBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7uvSJbxazhT4TjI0CoOSxaVediylsy39R662oZgGpkg6src5Ufy5yooIfg8b1vcX
         o9jWNbhw1rPNc40+qb2nL3il+ogfMLeZWEKqnKntGWPeCSAcXDalf4seuNGiY4JI1W
         XA9haiyAk8Tl5eQBEYVTwvXxSkiYuUrTnvmnWBCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daan De Meyer <daandemeyer@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 084/114] btrfs: free device in btrfs_close_devices for a single device filesystem
Date:   Mon, 13 Feb 2023 15:48:39 +0100
Message-Id: <20230213144746.501714669@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -408,6 +408,7 @@ void btrfs_free_device(struct btrfs_devi
 static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
+
 	WARN_ON(fs_devices->opened);
 	while (!list_empty(&fs_devices->devices)) {
 		device = list_entry(fs_devices->devices.next,
@@ -1194,9 +1195,22 @@ void btrfs_close_devices(struct btrfs_fs
 
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


