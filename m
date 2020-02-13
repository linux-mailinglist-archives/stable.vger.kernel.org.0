Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9A2915CCA3
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 21:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgBMUzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 15:55:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:40474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbgBMUzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 15:55:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 78273ADE4;
        Thu, 13 Feb 2020 20:55:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 43650DA703; Thu, 13 Feb 2020 21:55:33 +0100 (CET)
Date:   Thu, 13 Feb 2020 21:55:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 083/116] btrfs: free block groups after freeing fs
 trees
Message-ID: <20200213205533.GR2902@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
References: <20200213151842.259660170@linuxfoundation.org>
 <20200213151915.106400155@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151915.106400155@linuxfoundation.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:20:27AM -0800, Greg Kroah-Hartman wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> [ Upstream commit 4e19443da1941050b346f8fc4c368aa68413bc88 ]
> 
> Sometimes when running generic/475 we would trip the
> WARN_ON(cache->reserved) check when free'ing the block groups on umount.
> This is because sometimes we don't commit the transaction because of IO
> errors and thus do not cleanup the tree logs until at umount time.
> 
> These blocks are still reserved until they are cleaned up, but they
> aren't cleaned up until _after_ we do the free block groups work.  Fix
> this by moving the free after free'ing the fs roots, that way all of the
> tree logs are cleaned up and we have a properly cleaned fs.  A bunch of
> loops of generic/475 confirmed this fixes the problem.
> 
> CC: stable@vger.kernel.org # 4.9+
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/btrfs/disk-io.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index eab5a9065f093..439b5f5dc3274 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3864,6 +3864,15 @@ void close_ctree(struct btrfs_root *root)
>  	clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
>  	free_root_pointers(fs_info, true);
>  
> +	/*
> +	 * We must free the block groups after dropping the fs_roots as we could
> +	 * have had an IO error and have left over tree log blocks that aren't
> +	 * cleaned up until the fs roots are freed.  This makes the block group
> +	 * accounting appear to be wrong because there's pending reserved bytes,
> +	 * so make sure we do the block group cleanup afterwards.
> +	 */
> +	btrfs_free_block_groups(fs_info);

Something's wrong here.  The patch 4e19443da1 moves the
btrfs_free_block_groups() call and the stable backport lacks the "-"
line. However the patch applies cleanly on 4.9.213.

3855         btrfs_free_block_groups(fs_info);
^^^^

3856
3857         /*
3858          * we must make sure there is not any read request to
3859          * submit after we stopping all workers.
3860          */
3861         invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
3862         btrfs_stop_all_workers(fs_info);
3863
3864         clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
3865         free_root_pointers(fs_info, 1);
3866
3867         /*
3868          * We must free the block groups after dropping the fs_roots as we could
3869          * have had an IO error and have left over tree log blocks that aren't
3870          * cleaned up until the fs roots are freed.  This makes the block group
3871          * accounting appear to be wrong because there's pending reserved bytes,
3872          * so make sure we do the block group cleanup afterwards.
3873          */
3874         btrfs_free_block_groups(fs_info);

The first one should not be there.
