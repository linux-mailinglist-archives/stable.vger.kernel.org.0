Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4102252198B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiEJNt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343517AbiEJNsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BF32AED8D;
        Tue, 10 May 2022 06:36:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB70E618C1;
        Tue, 10 May 2022 13:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0806C385C2;
        Tue, 10 May 2022 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189790;
        bh=ICoUCWveMjVxL0JXl/i8DtIZOEvJ3uy+U5E1ZTjNeo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTTVYKZ8lHuGqO2EBTh/OgDTbPLjDY/7r/JVwNZt1X4Qm818us/odsweZ2EngjAzZ
         z3LmWHXJIj0l/OalpiMFmF6uKRYz7KW5WwVkLFp4/I73yVHdVKJCieJXtqSZWWICmT
         EdGj4aGodP2FMLsKtJvjrzCdDQw1Soc5LdLKkg1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 029/140] btrfs: force v2 space cache usage for subpage mount
Date:   Tue, 10 May 2022 15:06:59 +0200
Message-Id: <20220510130742.446962329@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
@@ -3569,6 +3569,17 @@ int __cold open_ctree(struct super_block
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


