Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0995965D319
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjADMw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjADMwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:52:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EDA1CFD4
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 662D3B81640
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AE6C433F0;
        Wed,  4 Jan 2023 12:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836740;
        bh=M+kKn9N0hToQBgD4EuqcWCPBuMma8ZZQMxSGXvUfMlU=;
        h=Subject:To:Cc:From:Date:From;
        b=cxIaPDseYsuXa3FHip0ExqnxoiUcY6pblW+MoJKitn7lYp+opPBh9SsrzUDWTvn8a
         PKgdEQrZ5pmdmGjgmxfWfYQk1pKMOiKRM8QAE/rw5klWD3e/tTlA5jWuk9upq7tAwL
         noZX7VBibVXOhhQCsbyBma2TWGStxwGYhnam6+X8=
Subject: FAILED: patch "[PATCH] btrfs: fix uninitialized parent in insert_state" failed to apply to 6.0-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:52:12 +0100
Message-ID: <16728367328920@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d7c9e1be2876 ("btrfs: fix uninitialized parent in insert_state")
04eba8932392 ("btrfs: temporarily export and then move extent state helpers")
91af24e48474 ("btrfs: temporarily export and move core extent_io_tree tree functions")
6962541e964f ("btrfs: move btrfs_debug_check_extent_io_range into extent-io-tree.c")
a66318872c41 ("btrfs: move simple extent bit helpers out of extent_io.c")
ad795329574c ("btrfs: convert BUG_ON(EXTENT_BIT_LOCKED) checks to ASSERT's")
83cf709a89fb ("btrfs: move extent state init and alloc functions to their own file")
c45379a20fbc ("btrfs: temporarily export alloc_extent_state helpers")
a40246e8afc0 ("btrfs: separate out the eb and extent state leak helpers")
a62a3bd9546b ("btrfs: separate out the extent state and extent buffer init code")
87c11705cc94 ("btrfs: convert the io_failure_tree to a plain rb_tree")
a2061748052c ("btrfs: unexport internal failrec functions")
0d0a762c419a ("btrfs: rename clean_io_failure and remove extraneous args")
917f32a23501 ("btrfs: give struct btrfs_bio a real end_io handler")
f1c2937976be ("btrfs: properly abstract the parity raid bio handling")
c3a62baf21ad ("btrfs: use chained bios when cloning")
2bbc72f14f19 ("btrfs: don't take a bio_counter reference for cloned bios")
6b42f5e3439d ("btrfs: pass the operation to btrfs_bio_alloc")
d45cfb883b10 ("btrfs: move btrfs_bio allocation to volumes.c")
1e408af31b4a ("btrfs: don't create integrity bioset for btrfs_bioset")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d7c9e1be2876f63fb2178a24e0c1d5733ff98d47 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 18 Nov 2022 15:06:09 -0500
Subject: [PATCH] btrfs: fix uninitialized parent in insert_state

I don't know how this isn't caught when we build this in the kernel, but
while syncing extent-io-tree.c into btrfs-progs I got an error because
parent could potentially be uninitialized when we link in a new node,
specifically when the extent_io_tree is empty.  This means we could have
garbage in the parent color.  I don't know what the ramifications are of
that, but it's probably not great, so fix this by initializing parent to
NULL.  I spot checked all of our other usages in btrfs and we appear to
be doing the correct thing everywhere else.

Fixes: c7e118cf98c7 ("btrfs: open code rbtree search in insert_state")
CC: stable@vger.kernel.org # 6.0+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 21fa15123af8..82ca6a11e11a 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -395,7 +395,7 @@ static int insert_state(struct extent_io_tree *tree,
 			u32 bits, struct extent_changeset *changeset)
 {
 	struct rb_node **node;
-	struct rb_node *parent;
+	struct rb_node *parent = NULL;
 	const u64 end = state->end;
 
 	set_state_bits(tree, state, bits, changeset);

