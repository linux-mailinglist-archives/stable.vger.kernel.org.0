Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8976951F800
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbiEIJWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbiEIIs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:48:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F906AE258
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:45:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EA98B8103B
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555DCC385AB;
        Mon,  9 May 2022 08:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652085902;
        bh=V/ZH1AV7DP4RgLQtBH70w5Y08mXuw+ruOqTKfNgCtKo=;
        h=Subject:To:Cc:From:Date:From;
        b=UC001sQlvFnFRm6DViCt4BUYMXGU1h29btAP2fPFGjrMHQFc16NzbWlQtv6pOGW0g
         J7CJHL8muS0ChXaBLvPfvfx+YChQ+2WG+tACu5ea0aqnAaa4zDymit1P+Kzo3/nF9F
         HqlnmsNT/cJFOrC9DUpj+NTj+Vtb9NscuKIp39+g=
Subject: FAILED: patch "[PATCH] btrfs: force v2 space cache usage for subpage mount" failed to apply to 5.15-stable tree
To:     wqu@suse.com, blnxfsl@bluematt.me, dsterba@suse.com,
        josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:44:54 +0200
Message-ID: <16520858942205@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9f73f1aef98b2fa7252c0a89be64840271ce8ea0 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Fri, 1 Apr 2022 15:29:37 +0800
Subject: [PATCH] btrfs: force v2 space cache usage for subpage mount

[BUG]
For a 4K sector sized btrfs with v1 cache enabled and only mounted on
systems with 4K page size, if it's mounted on subpage (64K page size)
systems, it can cause the following warning on v1 space cache:

 BTRFS error (device dm-1): csum mismatch on free space cache
 BTRFS warning (device dm-1): failed to load free space cache for block group 84082688, rebuilding it now

Although not a big deal, as kernel can rebuild it without problem, such
warning will bother end users, especially if they want to switch the
same btrfs seamlessly between different page sized systems.

[CAUSE]
V1 free space cache is still using fixed PAGE_SIZE for various bitmap,
like BITS_PER_BITMAP.

Such hard-coded PAGE_SIZE usage will cause various mismatch, from v1
cache size to checksum.

Thus kernel will always reject v1 cache with a different PAGE_SIZE with
csum mismatch.

[FIX]
Although we should fix v1 cache, it's already going to be marked
deprecated soon.

And we have v2 cache based on metadata (which is already fully subpage
compatible), and it has almost everything superior than v1 cache.

So just force subpage mount to use v2 cache on mount.

Reported-by: Matt Corallo <blnxfsl@bluematt.me>
CC: stable@vger.kernel.org # 5.15+
Link: https://lore.kernel.org/linux-btrfs/61aa27d1-30fc-c1a9-f0f4-9df544395ec3@bluematt.me/
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 20e70eb88465..3e0acc362233 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3657,6 +3657,17 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (sectorsize < PAGE_SIZE) {
 		struct btrfs_subpage_info *subpage_info;
 
+		/*
+		 * V1 space cache has some hardcoded PAGE_SIZE usage, and is
+		 * going to be deprecated.
+		 *
+		 * Force to use v2 cache for subpage case.
+		 */
+		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
+		btrfs_set_and_info(fs_info, FREE_SPACE_TREE,
+			"forcing free space tree for sector size %u with page size %lu",
+			sectorsize, PAGE_SIZE);
+
 		btrfs_warn(fs_info,
 		"read-write for sector size %u with page size %lu is experimental",
 			   sectorsize, PAGE_SIZE);

