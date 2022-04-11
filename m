Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC66F4FB560
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240647AbiDKH4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiDKH4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:56:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3741C27CDA
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC67CB810A9
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334B1C385AC;
        Mon, 11 Apr 2022 07:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649663633;
        bh=KipijSTzm2C8CpX7PXuUxnflnLMgj5R43L/+aMTIpUA=;
        h=Subject:To:Cc:From:Date:From;
        b=XqT+dIJHQibV8XeKF+MN2BNwtNk8Ggqrq74/50vKSTjk92bAiixTJUhK/1lBp8btR
         abWOYKo4E0Y5gfOS2fE1gIP5/LjggJWuXTQkyd3lgyQTPwY4A0XyWc7ldjoZ4CUZyI
         FHRDgzzgZ8y2fLtG6fdhX1JwvZzMHjf0KLz39fPg=
Subject: FAILED: patch "[PATCH] btrfs: zoned: remove left over ASSERT checking for single" failed to apply to 5.17-stable tree
To:     johannes.thumshirn@wdc.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 09:53:50 +0200
Message-ID: <164966363022185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 62ed0bf7315b524973bb5fb9174b60e353289835 Mon Sep 17 00:00:00 2001
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Mon, 7 Mar 2022 02:47:18 -0800
Subject: [PATCH] btrfs: zoned: remove left over ASSERT checking for single
 profile

With commit dcf5652291f6 ("btrfs: zoned: allow DUP on meta-data block
groups") we started allowing DUP on metadata block groups, so the
ASSERT()s in btrfs_can_activate_zone() and btrfs_zoned_get_device() are
no longer valid and in fact even harmful.

Fixes: dcf5652291f6 ("btrfs: zoned: allow DUP on meta-data block groups")
CC: stable@vger.kernel.org # 5.17
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 61125aec8723..1b1b310c3c51 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1801,7 +1801,6 @@ struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 
 	map = em->map_lookup;
 	/* We only support single profile for now */
-	ASSERT(map->num_stripes == 1);
 	device = map->stripes[0].dev;
 
 	free_extent_map(em);
@@ -1983,9 +1982,6 @@ bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 	if (!btrfs_is_zoned(fs_info))
 		return true;
 
-	/* Non-single profiles are not supported yet */
-	ASSERT((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0);
-
 	/* Check if there is a device with active zones left */
 	mutex_lock(&fs_info->chunk_mutex);
 	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {

