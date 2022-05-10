Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048A352199A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiEJNty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244872AbiEJNrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE681B090B;
        Tue, 10 May 2022 06:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5012CE1EF0;
        Tue, 10 May 2022 13:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3322C385C6;
        Tue, 10 May 2022 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189536;
        bh=qwSQxW4053RPG9LwGxHuLd7tkBgQhDyBH+bD/XchwME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j75TrZCSP9UI0QUb08CaX/lPx7fqh+AALvRVuuvNnmYSwqRt7Z8ZQuq4noQ0nthQS
         uv/jTwRKJ6dSCN8Lzot7yh0J1IAxoQiwbXcldpP/trJzdhPyA89FKVucniGlCA+s+U
         4vmbx22pe7nliWADDIjHknBrPVsUgbGCCPMH519I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 080/135] btrfs: force v2 space cache usage for subpage mount
Date:   Tue, 10 May 2022 15:07:42 +0200
Message-Id: <20220510130742.705596847@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 9f73f1aef98b2fa7252c0a89be64840271ce8ea0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3415,6 +3415,17 @@ int __cold open_ctree(struct super_block
 	}
 
 	if (sectorsize != PAGE_SIZE) {
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


