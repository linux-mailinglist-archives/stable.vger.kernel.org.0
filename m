Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5A262158F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiKHONJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiKHOM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DF112A8A
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 624D4615C6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7544FC433C1;
        Tue,  8 Nov 2022 14:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916774;
        bh=fqPdWBbXadNh3lhUozUpva2BMcjiXmqoqPs0Fue6JfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjBWtanlbVpUYH3QrzEQ0JxMDPLwLy8z81533lr3sgtvK9xpXrdGodfwhHUwiPej+
         R3KzULOd6ZfYO+CYPR/VCkX39RVwF+//FMdsP+8CqU9hbxzcKNnpBBESLkhBc/93N2
         YXVbbz9K2DAV023jT/YzLjN+h0Z/e0NGM5Xtcls4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <oliver.sang@intel.com>,
        Viktor Kuzmin <kvaster@gmail.com>, Su Yue <glass@fydeos.io>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 130/197] btrfs: dont use btrfs_chunk::sub_stripes from disk
Date:   Tue,  8 Nov 2022 14:39:28 +0100
Message-Id: <20221108133400.884091198@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 76a66ba101329316a5d7f4275070be22eb85fdf2 upstream.

[BUG]
There are two reports (the earliest one from LKP, a more recent one from
kernel bugzilla) that we can have some chunks with 0 as sub_stripes.

This will cause divide-by-zero errors at btrfs_rmap_block, which is
introduced by a recent kernel patch ac0677348f3c ("btrfs: merge
calculations for simple striped profiles in btrfs_rmap_block"):

		if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
				 BTRFS_BLOCK_GROUP_RAID10)) {
			stripe_nr = stripe_nr * map->num_stripes + i;
			stripe_nr = div_u64(stripe_nr, map->sub_stripes); <<<
		}

[CAUSE]
>From the more recent report, it has been proven that we have some chunks
with 0 as sub_stripes, mostly caused by older mkfs.

It turns out that the mkfs.btrfs fix is only introduced in 6718ab4d33aa
("btrfs-progs: Initialize sub_stripes to 1 in btrfs_alloc_data_chunk")
which is included in v5.4 btrfs-progs release.

So there would be quite some old filesystems with such 0 sub_stripes.

[FIX]
Just don't trust the sub_stripes values from disk.

We have a trusted btrfs_raid_array[] to fetch the correct sub_stripes
numbers for each profile and that are fixed.

By this, we can keep the compatibility with older filesystems while
still avoid divide-by-zero bugs.

Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: Viktor Kuzmin <kvaster@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216559
Fixes: ac0677348f3c ("btrfs: merge calculations for simple striped profiles in btrfs_rmap_block")
CC: stable@vger.kernel.org # 6.0
Reviewed-by: Su Yue <glass@fydeos.io>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7029,6 +7029,7 @@ static int read_one_chunk(struct btrfs_k
 	u64 devid;
 	u64 type;
 	u8 uuid[BTRFS_UUID_SIZE];
+	int index;
 	int num_stripes;
 	int ret;
 	int i;
@@ -7036,6 +7037,7 @@ static int read_one_chunk(struct btrfs_k
 	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
 	type = btrfs_chunk_type(leaf, chunk);
+	index = btrfs_bg_flags_to_raid_index(type);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 
 #if BITS_PER_LONG == 32
@@ -7089,7 +7091,15 @@ static int read_one_chunk(struct btrfs_k
 	map->io_align = btrfs_chunk_io_align(leaf, chunk);
 	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	map->type = type;
-	map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
+	/*
+	 * We can't use the sub_stripes value, as for profiles other than
+	 * RAID10, they may have 0 as sub_stripes for filesystems created by
+	 * older mkfs (<v5.4).
+	 * In that case, it can cause divide-by-zero errors later.
+	 * Since currently sub_stripes is fixed for each profile, let's
+	 * use the trusted value instead.
+	 */
+	map->sub_stripes = btrfs_raid_array[index].sub_stripes;
 	map->verified_stripes = 0;
 	em->orig_block_len = btrfs_calc_stripe_length(em);
 	for (i = 0; i < num_stripes; i++) {


