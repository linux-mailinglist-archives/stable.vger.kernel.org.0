Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA2C5AA7DE
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 08:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiIBGO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 02:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiIBGO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 02:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822D113F31;
        Thu,  1 Sep 2022 23:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89CD7B829E3;
        Fri,  2 Sep 2022 06:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BB9C433C1;
        Fri,  2 Sep 2022 06:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662099292;
        bh=LOvLX/ZFQZ0Ns/M+t5tNoiDylATQ2kmr4xjAuQQnlvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NSPAvVpxAWAIJzkgYUGM+BldPQKFWvyfFlg15uj0TRv1tclTicaoT3Yq6CEUVDYyq
         t6lrqH9Q8cufzTcAurnoVWld5sHApZTV96jQ+3egeiXyXtAs9P1EpiyiuPIQXYP+sK
         96q9sjspvGHLC1kmEvli+9z77j0qc2OXo7dMcbbw=
Date:   Fri, 2 Sep 2022 08:14:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 5.15] btrfs: fix space cache corruption and potential
 double allocations
Message-ID: <YxGfT0sk7Jg96+ll@kroah.com>
References: <b07b2c2bcef831de5eaa6d2e61d46b92db4d41d5.1662055214.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b07b2c2bcef831de5eaa6d2e61d46b92db4d41d5.1662055214.git.osandov@fb.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 11:03:35AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> commit ced8ecf026fd8084cf175530ff85c76d6085d715 upstream.
> 
> When testing space_cache v2 on a large set of machines, we encountered a
> few symptoms:
> 
> 1. "unable to add free space :-17" (EEXIST) errors.
> 2. Missing free space info items, sometimes caught with a "missing free
>    space info for X" error.
> 3. Double-accounted space: ranges that were allocated in the extent tree
>    and also marked as free in the free space tree, ranges that were
>    marked as allocated twice in the extent tree, or ranges that were
>    marked as free twice in the free space tree. If the latter made it
>    onto disk, the next reboot would hit the BUG_ON() in
>    add_new_free_space().
> 4. On some hosts with no on-disk corruption or error messages, the
>    in-memory space cache (dumped with drgn) disagreed with the free
>    space tree.
> 
> All of these symptoms have the same underlying cause: a race between
> caching the free space for a block group and returning free space to the
> in-memory space cache for pinned extents causes us to double-add a free
> range to the space cache. This race exists when free space is cached
> from the free space tree (space_cache=v2) or the extent tree
> (nospace_cache, or space_cache=v1 if the cache needs to be regenerated).
> struct btrfs_block_group::last_byte_to_unpin and struct
> btrfs_block_group::progress are supposed to protect against this race,
> but commit d0c2f4fa555e ("btrfs: make concurrent fsyncs wait less when
> waiting for a transaction commit") subtly broke this by allowing
> multiple transactions to be unpinning extents at the same time.
> 
> Specifically, the race is as follows:
> 
> 1. An extent is deleted from an uncached block group in transaction A.
> 2. btrfs_commit_transaction() is called for transaction A.
> 3. btrfs_run_delayed_refs() -> __btrfs_free_extent() runs the delayed
>    ref for the deleted extent.
> 4. __btrfs_free_extent() -> do_free_extent_accounting() ->
>    add_to_free_space_tree() adds the deleted extent back to the free
>    space tree.
> 5. do_free_extent_accounting() -> btrfs_update_block_group() ->
>    btrfs_cache_block_group() queues up the block group to get cached.
>    block_group->progress is set to block_group->start.
> 6. btrfs_commit_transaction() for transaction A calls
>    switch_commit_roots(). It sets block_group->last_byte_to_unpin to
>    block_group->progress, which is block_group->start because the block
>    group hasn't been cached yet.
> 7. The caching thread gets to our block group. Since the commit roots
>    were already switched, load_free_space_tree() sees the deleted extent
>    as free and adds it to the space cache. It finishes caching and sets
>    block_group->progress to U64_MAX.
> 8. btrfs_commit_transaction() advances transaction A to
>    TRANS_STATE_SUPER_COMMITTED.
> 9. fsync calls btrfs_commit_transaction() for transaction B. Since
>    transaction A is already in TRANS_STATE_SUPER_COMMITTED and the
>    commit is for fsync, it advances.
> 10. btrfs_commit_transaction() for transaction B calls
>     switch_commit_roots(). This time, the block group has already been
>     cached, so it sets block_group->last_byte_to_unpin to U64_MAX.
> 11. btrfs_commit_transaction() for transaction A calls
>     btrfs_finish_extent_commit(), which calls unpin_extent_range() for
>     the deleted extent. It sees last_byte_to_unpin set to U64_MAX (by
>     transaction B!), so it adds the deleted extent to the space cache
>     again!
> 
> This explains all of our symptoms above:
> 
> * If the sequence of events is exactly as described above, when the free
>   space is re-added in step 11, it will fail with EEXIST.
> * If another thread reallocates the deleted extent in between steps 7
>   and 11, then step 11 will silently re-add that space to the space
>   cache as free even though it is actually allocated. Then, if that
>   space is allocated *again*, the free space tree will be corrupted
>   (namely, the wrong item will be deleted).
> * If we don't catch this free space tree corruption, it will continue
>   to get worse as extents are deleted and reallocated.
> 
> The v1 space_cache is synchronously loaded when an extent is deleted
> (btrfs_update_block_group() with alloc=0 calls btrfs_cache_block_group()
> with load_cache_only=1), so it is not normally affected by this bug.
> However, as noted above, if we fail to load the space cache, we will
> fall back to caching from the extent tree and may hit this bug.
> 
> The easiest fix for this race is to also make caching from the free
> space tree or extent tree synchronous. Josef tested this and found no
> performance regressions.
> 
> A few extra changes fall out of this change. Namely, this fix does the
> following, with step 2 being the crucial fix:
> 
> 1. Factor btrfs_caching_ctl_wait_done() out of
>    btrfs_wait_block_group_cache_done() to allow waiting on a caching_ctl
>    that we already hold a reference to.
> 2. Change the call in btrfs_cache_block_group() of
>    btrfs_wait_space_cache_v1_finished() to
>    btrfs_caching_ctl_wait_done(), which makes us wait regardless of the
>    space_cache option.
> 3. Delete the now unused btrfs_wait_space_cache_v1_finished() and
>    space_cache_v1_done().
> 4. Change btrfs_cache_block_group()'s `int load_cache_only` parameter to
>    `bool wait` to more accurately describe its new meaning.
> 5. Change a few callers which had a separate call to
>    btrfs_wait_block_group_cache_done() to use wait = true instead.
> 6. Make btrfs_wait_block_group_cache_done() static now that it's not
>    used outside of block-group.c anymore.
> 
> Fixes: d0c2f4fa555e ("btrfs: make concurrent fsyncs wait less when waiting for a transaction commit")
> CC: stable@vger.kernel.org # 5.12+
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> Hi,
> 
> This is the backport of commit ced8ecf026fd8084cf175530ff85c76d6085d715
> to the 5.15 stable branch. Please consider it for the next 5.15 stable
> release.

Now queued up, thanks.

greg k-h
