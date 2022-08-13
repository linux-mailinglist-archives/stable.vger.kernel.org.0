Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFD4591A87
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbiHMNPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239474AbiHMNPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:15:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7563F275CA
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AB95B80108
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81190C433C1;
        Sat, 13 Aug 2022 13:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660396538;
        bh=vaWMAFJtuKmPGulb697wqkja1uy4X3AcaID23eIMO6U=;
        h=Subject:To:Cc:From:Date:From;
        b=kDup4yrOTbVm7B0MEEt2aldMv02GT8Dw+9xmlEJVHEtT87urR928bqQqWJmGpbQGF
         b4Hz/Iut/zHzTMIKBc8DDM+wYNXYT66UMMhvDO2B9JgxCovqyIwlOEZ48Qr3+OBkAq
         zO2l+n5GrYYMvOlXqRogM52u4urYoCAKm0h4jobs=
Subject: FAILED: patch "[PATCH] btrfs: reject log replay if there is unsupported RO compat" failed to apply to 4.14-stable tree
To:     wqu@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 15:15:30 +0200
Message-ID: <16603965307297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dc4d31684974d140250f3ee612c3f0cab13b3146 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Tue, 7 Jun 2022 19:48:24 +0800
Subject: [PATCH] btrfs: reject log replay if there is unsupported RO compat
 flag

[BUG]
If we have a btrfs image with dirty log, along with an unsupported RO
compatible flag:

log_root		30474240
...
compat_flags		0x0
compat_ro_flags		0x40000003
			( FREE_SPACE_TREE |
			  FREE_SPACE_TREE_VALID |
			  unknown flag: 0x40000000 )

Then even if we can only mount it RO, we will still cause metadata
update for log replay:

  BTRFS info (device dm-1): flagging fs with big metadata feature
  BTRFS info (device dm-1): using free space tree
  BTRFS info (device dm-1): has skinny extents
  BTRFS info (device dm-1): start tree-log replay

This is definitely against RO compact flag requirement.

[CAUSE]
RO compact flag only forces us to do RO mount, but we will still do log
replay for plain RO mount.

Thus this will result us to do log replay and update metadata.

This can be very problematic for new RO compat flag, for example older
kernel can not understand v2 cache, and if we allow metadata update on
RO mount and invalidate/corrupt v2 cache.

[FIX]
Just reject the mount unless rescue=nologreplay is provided:

  BTRFS error (device dm-1): cannot replay dirty log with unsupport optional features (0x40000000), try rescue=nologreplay instead

We don't want to set rescue=nologreply directly, as this would make the
end user to read the old data, and cause confusion.

Since the such case is really rare, we're mostly fine to just reject the
mount with an error message, which also includes the proper workaround.

CC: stable@vger.kernel.org #4.9+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ed1d92b370db..32b88a227734 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3556,6 +3556,20 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		err = -EINVAL;
 		goto fail_alloc;
 	}
+	/*
+	 * We have unsupported RO compat features, although RO mounted, we
+	 * should not cause any metadata write, including log replay.
+	 * Or we could screw up whatever the new feature requires.
+	 */
+	if (unlikely(features && btrfs_super_log_root(disk_super) &&
+		     !btrfs_test_opt(fs_info, NOLOGREPLAY))) {
+		btrfs_err(fs_info,
+"cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
+			  features);
+		err = -EINVAL;
+		goto fail_alloc;
+	}
+
 
 	if (sectorsize < PAGE_SIZE) {
 		struct btrfs_subpage_info *subpage_info;

