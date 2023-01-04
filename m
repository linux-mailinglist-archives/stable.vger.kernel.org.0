Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856A165D327
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbjADMxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjADMxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:53:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A94519C08
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 254E1B8162F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D425C43392;
        Wed,  4 Jan 2023 12:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836793;
        bh=bz8aT1ZlIwZxzWPREiOLetu990GjfZUO2HUb1trIhIo=;
        h=Subject:To:Cc:From:Date:From;
        b=S9Mbq4SzIy0feCF3nfxkIc8H7xkEdsNLeiZR80CN/eol30NXLyqsio8okNm0C6ii7
         sRHAe2unHf/E+wZXLHIXo6gGBAubeGHtwxenT0HDfTmskgvKxNuLNH+ov5angnobRd
         sEpKSCUgPAT6Tpy1HIOq7EowbF3NAOSVKDOJoBTE=
Subject: FAILED: patch "[PATCH] btrfs: fix extent map use-after-free when handling missing" failed to apply to 4.14-stable tree
To:     void0red@gmail.com, 1527030098@qq.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:52:48 +0100
Message-ID: <1672836768183249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1742e1c90c3d ("btrfs: fix extent map use-after-free when handling missing device in read_one_chunk")
ff37c89f94be ("btrfs: move missing device handling in a dedicate function")
562d7b1512f7 ("btrfs: handle device lookup with btrfs_dev_lookup_args")
1a9fd4172d5c ("btrfs: fix typos in comments")
e9306ad4ef5c ("btrfs: more graceful errors/warnings on 32bit systems when reaching limits")
bc03f39ec3c1 ("btrfs: use a bit to track the existence of tree mod log users")
406808ab2f0b ("btrfs: use booleans where appropriate for the tree mod log functions")
f3a84ccd28d0 ("btrfs: move the tree mod log code into its own file")
dbcc7d57bffc ("btrfs: fix race when cloning extent buffer during rewind of an old root")
cac06d843f25 ("btrfs: introduce the skeleton of btrfs_subpage structure")
2f96e40212d4 ("btrfs: fix possible free space tree corruption with online conversion")
1aaac38c83a2 ("btrfs: don't allow tree block to cross page boundary for subpage support")
948462294577 ("btrfs: keep sb cache_generation consistent with space_cache")
8b228324a8ce ("btrfs: clear free space tree on ro->rw remount")
8cd2908846d1 ("btrfs: clear oneshot options on mount and remount")
5011139a4718 ("btrfs: create free space tree on ro->rw remount")
8f1c21d7490f ("btrfs: start orphan cleanup on ro->rw remount")
44c0ca211a4d ("btrfs: lift read-write mount setup from mount and remount")
5297199a8bca ("btrfs: remove inode number cache feature")
ec7d6dfd73b2 ("btrfs: move btrfs_find_highest_objectid/btrfs_find_free_objectid to disk-io.c")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1742e1c90c3da344f3bb9b1f1309b3f47482756a Mon Sep 17 00:00:00 2001
From: void0red <void0red@gmail.com>
Date: Wed, 23 Nov 2022 22:39:45 +0800
Subject: [PATCH] btrfs: fix extent map use-after-free when handling missing
 device in read_one_chunk

Store the error code before freeing the extent_map. Though it's
reference counted structure, in that function it's the first and last
allocation so this would lead to a potential use-after-free.

The error can happen eg. when chunk is stored on a missing device and
the degraded mount option is missing.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216721
Reported-by: eriri <1527030098@qq.com>
Fixes: adfb69af7d8c ("btrfs: add_missing_dev() should return the actual error")
CC: stable@vger.kernel.org # 4.9+
Signed-off-by: void0red <void0red@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index acab20f2863d..aa25fa335d3e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6976,8 +6976,9 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			map->stripes[i].dev = handle_missing_device(fs_info,
 								    devid, uuid);
 			if (IS_ERR(map->stripes[i].dev)) {
+				ret = PTR_ERR(map->stripes[i].dev);
 				free_extent_map(em);
-				return PTR_ERR(map->stripes[i].dev);
+				return ret;
 			}
 		}
 

