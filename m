Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E787515CE6B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 00:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBMXAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 18:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgBMW77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 17:59:59 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE13020873;
        Thu, 13 Feb 2020 22:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581634799;
        bh=FSnRT2XaeyQWdBjJCyfOus16Mgn1L6DS6vfFSoQ/Of0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=g1xqNIMZD9cn8bv+W8kFRZ8SlE/3zSUVlsI4DOv9PYpHTAzjGYwkL+KJ43YZlE7Gd
         BRl0i2/OgopP6I7IUUoHsBnl6EIacqyeBtP83plURKAeDwYTkLsxiZ+ErXxk2/gzkU
         k3oylD+/1FC9mA7rWiap9Jf44vW73/WaAKLdj34g=
Date:   Thu, 13 Feb 2020 14:59:58 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 083/116] btrfs: free block groups after freeing fs
 trees
Message-ID: <20200213225958.GB3878275@kroah.com>
References: <20200213151842.259660170@linuxfoundation.org>
 <20200213151915.106400155@linuxfoundation.org>
 <20200213205533.GR2902@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213205533.GR2902@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 09:55:33PM +0100, David Sterba wrote:
> On Thu, Feb 13, 2020 at 07:20:27AM -0800, Greg Kroah-Hartman wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> > 
> > [ Upstream commit 4e19443da1941050b346f8fc4c368aa68413bc88 ]
> > 
> > Sometimes when running generic/475 we would trip the
> > WARN_ON(cache->reserved) check when free'ing the block groups on umount.
> > This is because sometimes we don't commit the transaction because of IO
> > errors and thus do not cleanup the tree logs until at umount time.
> > 
> > These blocks are still reserved until they are cleaned up, but they
> > aren't cleaned up until _after_ we do the free block groups work.  Fix
> > this by moving the free after free'ing the fs roots, that way all of the
> > tree logs are cleaned up and we have a properly cleaned fs.  A bunch of
> > loops of generic/475 confirmed this fixes the problem.
> > 
> > CC: stable@vger.kernel.org # 4.9+
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/btrfs/disk-io.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index eab5a9065f093..439b5f5dc3274 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3864,6 +3864,15 @@ void close_ctree(struct btrfs_root *root)
> >  	clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
> >  	free_root_pointers(fs_info, true);
> >  
> > +	/*
> > +	 * We must free the block groups after dropping the fs_roots as we could
> > +	 * have had an IO error and have left over tree log blocks that aren't
> > +	 * cleaned up until the fs roots are freed.  This makes the block group
> > +	 * accounting appear to be wrong because there's pending reserved bytes,
> > +	 * so make sure we do the block group cleanup afterwards.
> > +	 */
> > +	btrfs_free_block_groups(fs_info);
> 
> Something's wrong here.  The patch 4e19443da1 moves the
> btrfs_free_block_groups() call and the stable backport lacks the "-"
> line. However the patch applies cleanly on 4.9.213.
> 
> 3855         btrfs_free_block_groups(fs_info);
> ^^^^
> 
> 3856
> 3857         /*
> 3858          * we must make sure there is not any read request to
> 3859          * submit after we stopping all workers.
> 3860          */
> 3861         invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> 3862         btrfs_stop_all_workers(fs_info);
> 3863
> 3864         clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
> 3865         free_root_pointers(fs_info, 1);
> 3866
> 3867         /*
> 3868          * We must free the block groups after dropping the fs_roots as we could
> 3869          * have had an IO error and have left over tree log blocks that aren't
> 3870          * cleaned up until the fs roots are freed.  This makes the block group
> 3871          * accounting appear to be wrong because there's pending reserved bytes,
> 3872          * so make sure we do the block group cleanup afterwards.
> 3873          */
> 3874         btrfs_free_block_groups(fs_info);
> 
> The first one should not be there.

Now fixed up by just dropping this patch entirely :)

Sasha, can you fix it up and add it back for the next round?

thanks,

greg k-h
