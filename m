Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F3A4CF8F2
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbiCGKDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240747AbiCGKBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693366AA5E;
        Mon,  7 Mar 2022 01:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAF7B60AEC;
        Mon,  7 Mar 2022 09:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B05C340F3;
        Mon,  7 Mar 2022 09:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646645;
        bh=cCvGd8yQ8lD4nHtyqMot3EfWFxRQlXARj6mKIkcVBjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9sPXUJ/ooi2GQJDBFCzxmCtvqF390SCFTMaERcPKAbb867XiQcs4PVB06A+3smxq
         nE+pJriXaMWfm7smk+xB7Gch4/1LaxgcqEjs94SAoXFOy0cZDae0DrhRL1iPLsGXlN
         gUjMHUmkVDi0faMryrVfTdGVAdHM8vBN5t38EaGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 047/186] btrfs: defrag: dont use merged extent map for their generation check
Date:   Mon,  7 Mar 2022 10:18:05 +0100
Message-Id: <20220307091655.411079917@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 199257a78bb01341c3ba6e85bdcf3a2e6e452c6d upstream.

For extent maps, if they are not compressed extents and are adjacent by
logical addresses and file offsets, they can be merged into one larger
extent map.

Such merged extent map will have the higher generation of all the
original ones.

But this brings a problem for autodefrag, as it relies on accurate
extent_map::generation to determine if one extent should be defragged.

For merged extent maps, their higher generation can mark some older
extents to be defragged while the original extent map doesn't meet the
minimal generation threshold.

Thus this will cause extra IO.

So solve the problem, here we introduce a new flag, EXTENT_FLAG_MERGED,
to indicate if the extent map is merged from one or more ems.

And for autodefrag, if we find a merged extent map, and its generation
meets the generation requirement, we just don't use this one, and go
back to defrag_get_extent() to read extent maps from subvolume trees.

This could cause more read IO, but should result less defrag data write,
so in the long run it should be a win for autodefrag.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_map.c |    2 ++
 fs/btrfs/extent_map.h |    8 ++++++++
 fs/btrfs/ioctl.c      |   14 ++++++++++++++
 3 files changed, 24 insertions(+)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -261,6 +261,7 @@ static void try_merge_map(struct extent_
 			em->mod_len = (em->mod_len + em->mod_start) - merge->mod_start;
 			em->mod_start = merge->mod_start;
 			em->generation = max(em->generation, merge->generation);
+			set_bit(EXTENT_FLAG_MERGED, &em->flags);
 
 			rb_erase_cached(&merge->rb_node, &tree->map);
 			RB_CLEAR_NODE(&merge->rb_node);
@@ -278,6 +279,7 @@ static void try_merge_map(struct extent_
 		RB_CLEAR_NODE(&merge->rb_node);
 		em->mod_len = (merge->mod_start + merge->mod_len) - em->mod_start;
 		em->generation = max(em->generation, merge->generation);
+		set_bit(EXTENT_FLAG_MERGED, &em->flags);
 		free_extent_map(merge);
 	}
 }
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -25,6 +25,8 @@ enum {
 	EXTENT_FLAG_FILLING,
 	/* filesystem extent mapping type */
 	EXTENT_FLAG_FS_MAPPING,
+	/* This em is merged from two or more physically adjacent ems */
+	EXTENT_FLAG_MERGED,
 };
 
 struct extent_map {
@@ -40,6 +42,12 @@ struct extent_map {
 	u64 ram_bytes;
 	u64 block_start;
 	u64 block_len;
+
+	/*
+	 * Generation of the extent map, for merged em it's the highest
+	 * generation of all merged ems.
+	 * For non-merged extents, it's from btrfs_file_extent_item::generation.
+	 */
 	u64 generation;
 	unsigned long flags;
 	/* Used for chunk mappings, flag EXTENT_FLAG_FS_MAPPING must be set */
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1149,6 +1149,20 @@ static struct extent_map *defrag_lookup_
 	em = lookup_extent_mapping(em_tree, start, sectorsize);
 	read_unlock(&em_tree->lock);
 
+	/*
+	 * We can get a merged extent, in that case, we need to re-search
+	 * tree to get the original em for defrag.
+	 *
+	 * If @newer_than is 0 or em::generation < newer_than, we can trust
+	 * this em, as either we don't care about the generation, or the
+	 * merged extent map will be rejected anyway.
+	 */
+	if (em && test_bit(EXTENT_FLAG_MERGED, &em->flags) &&
+	    newer_than && em->generation >= newer_than) {
+		free_extent_map(em);
+		em = NULL;
+	}
+
 	if (!em) {
 		struct extent_state *cached = NULL;
 		u64 end = start + sectorsize - 1;


