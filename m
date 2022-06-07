Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C63453FBC6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241501AbiFGKpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241469AbiFGKpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3202983D;
        Tue,  7 Jun 2022 03:45:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD9EAB81EF7;
        Tue,  7 Jun 2022 10:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8B6C34115;
        Tue,  7 Jun 2022 10:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654598736;
        bh=7Ndve4VjzmTJE46labaQh6inliAlI07aRZpwhzGDVRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=llk0tQaHwsN1S6xaXU8jn7xGYaznEnITcq9DR+jbeCtgRTWGGmBBGgzPOSkKlVr0u
         XVMUQSB3xOaVLk27LKNXO0NoEEDIKnZdCqjgU1QAHHKheAOH4oNiBnWMThHsdTXkHR
         BoJIIK3xvHKnLTozzLPf+kTrypzqRhRqC3YW2wBhhBVmBqUV2gROwUuin9lv6u4R9y
         mJddeqY4t5dq9FmBhoHBl4Qu49c+vFd3XHHRJ2WFLBE0Xdn/JKW/agAXDMuM5rwRzq
         ZEgB/BqNGIX2nbV3dOyiF74FjTkR3KqTkbX2e8cL5EeFNrLWLaW13mX5AzyHIQIZjR
         /Uhn+UolrcL7g==
Date:   Tue, 7 Jun 2022 11:45:33 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: correctly populate
 btrfs_super_block::log_root_transid
Message-ID: <20220607104533.GA3559971@falcondesktop>
References: <f7ae86f509d11d941ceac2a153b38a4f3bc5d342.1654578537.git.wqu@suse.com>
 <20220607094055.GB3554947@falcondesktop>
 <532d5fd2-e93b-2fec-72d3-d0b0f099e541@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532d5fd2-e93b-2fec-72d3-d0b0f099e541@gmx.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 06:30:03PM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/6/7 17:40, Filipe Manana wrote:
> > On Tue, Jun 07, 2022 at 01:09:13PM +0800, Qu Wenruo wrote:
> > > [BUG]
> > > After creating a dirty log tree, although
> > > btrfs_super_block::log_root and log_root_level is correctly populated,
> > > its generation is still left 0:
> > > 
> > >   log_root                30474240
> > >   log_root_transid        0 <<<
> > >   log_root_level          0
> > > 
> > > [CAUSE]
> > > We just forgot to update btrfs_super_block::log_root_transid completely.
> > > 
> > > Thus it's always the original value (0) from the initial super block.
> > > 
> > > Thankfully this old behavior won't break log replay, as in
> > > btrfs_read_tree(), parent generation 0 means we just skip the generation
> > 
> > btrfs_read_tree() does not exists, it's btrfs_read_tree_root().
> > 
> > This is actually irrelevant, because we don't read the root log tree with
> > btrfs_read_tree_root(). We use read_tree_block() for that (at btrfs_replay_log()),
> 
> Oh, right, I forgot to check that code, and just assumed every root read
> from superblock would has its generation checked, but it's not the case
> for log tree root.
> 
> > and we use a generation matching the committed transaction + 1 (as it can never
> > be anything else).
> > 
> > For every other log tree, we use btrfs_read_tree_root(), but the generation is
> > stored in the root's root item stored in the root log tree.
> > 
> > The log_root_transid field was added to the super block by:
> > 
> > commit c3027eb5523d6983f12628f3fe13d8a7576db701
> > Author: Chris Mason <chris.mason@oracle.com>
> > Date:   Mon Dec 8 16:40:21 2008 -0500
> > 
> >      Btrfs: Add inode sequence number for NFS and reserved space in a few structs
> > 
> > But it was never used.
> > 
> > So this change is not needed.
> 
> Then, considering we have never really set log_root_transid anywhere,
> and in theory we're always using btrfs_super_block::generation + 1, why

It's not in theory only, it's in practice too.
We use committed generation + 1 since the first day the log tree was added:

commit e02119d5a7b4396c5a872582fddc8bd6d305a70a
Author: Chris Mason <chris.mason@oracle.com>
Date:   Fri Sep 5 16:13:11 2008 -0400

    Btrfs: Add a write ahead tree log to optimize synchronous operations

(back then we read the root log tree directly at open_ctree()).

> not just deprecate that member?
> 
> In fact, every time (thankfully not that many times for me) I checked
> log_root_transid, I can not help but to wonder why it's always 0.

You'd have to ask Chris why he added the field if it was never used and,
as far as I can see, was always useless since the life of a log tree
has never spanned more than 1 transaction, its generation must necessarily
be "committed transaction generation + 1".

Maybe just add a comment on top of the field saying it's unused and should
always be 0.

It's technically part of the disk format, so it's probably better not being
renamed to '__le64 unused;'.

Thanks.

> 
> Thanks,
> Qu
> 
> > 
> > Thanks.
> > 
> > 
> > > check.
> > > 
> > > And per-root log tree is still done properly using the root generation,
> > > so here we really only missed the generation check for log tree root,
> > > and even we fixed it, it should not cause any compatible problem.
> > > 
> > > [FIX]
> > > Just update btrfs_super_block::log_root_transid properly.
> > 
> > We don't need this.
> > 
> > The log_root_transid field was added to the super block by:
> > 
> > commit c3027eb5523d6983f12628f3fe13d8a7576db701
> > Author: Chris Mason <chris.mason@oracle.com>
> > Date:   Mon Dec 8 16:40:21 2008 -0500
> > 
> >      Btrfs: Add inode sequence number for NFS and reserved space in a few structs
> > 
> > But it was never used.
> > For btrfs_read_tree_root(), what we use is the
> > 
> > 
> > 
> > > 
> > > Cc: stable@vger.kernel.org #4.9+
> > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > ---
> > >   fs/btrfs/tree-log.c | 5 ++++-
> > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> > > index 370388fadf96..27a76d6fef8c 100644
> > > --- a/fs/btrfs/tree-log.c
> > > +++ b/fs/btrfs/tree-log.c
> > > @@ -3083,7 +3083,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
> > >   	struct btrfs_log_ctx root_log_ctx;
> > >   	struct blk_plug plug;
> > >   	u64 log_root_start;
> > > -	u64 log_root_level;
> > > +	u64 log_root_transid;
> > > +	u8 log_root_level;
> > > 
> > >   	mutex_lock(&root->log_mutex);
> > >   	log_transid = ctx->log_transid;
> > > @@ -3297,6 +3298,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
> > > 
> > >   	log_root_start = log_root_tree->node->start;
> > >   	log_root_level = btrfs_header_level(log_root_tree->node);
> > > +	log_root_transid = btrfs_header_generation(log_root_tree->node);
> > >   	log_root_tree->log_transid++;
> > >   	mutex_unlock(&log_root_tree->log_mutex);
> > > 
> > > @@ -3334,6 +3336,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
> > > 
> > >   	btrfs_set_super_log_root(fs_info->super_for_commit, log_root_start);
> > >   	btrfs_set_super_log_root_level(fs_info->super_for_commit, log_root_level);
> > > +	btrfs_set_super_log_root_transid(fs_info->super_for_commit, log_root_transid);
> > >   	ret = write_all_supers(fs_info, 1);
> > >   	mutex_unlock(&fs_info->tree_log_mutex);
> > >   	if (ret) {
> > > --
> > > 2.36.1
> > > 
