Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731C522C279
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 11:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgGXJmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 05:42:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:54798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgGXJmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 05:42:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DDF4FAD46;
        Fri, 24 Jul 2020 09:42:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9D4FADA791; Fri, 24 Jul 2020 11:41:45 +0200 (CEST)
Date:   Fri, 24 Jul 2020 11:41:45 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs: reloc: clear DEAD_RELOC_TREE bit for orphan roots
 -- for 5.7 to prevent runaway balance
Message-ID: <20200724094145.GG3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>
References: <20200724014640.20784-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724014640.20784-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Qu,

you need to make the target version visible in the subject. The manual
submissions to stable are processed by humans, while the CC: tag is for
semi-automatic collection of patches that get merged to master.

If you send 3 patches with same subjects it could be ignored as resends
or it's required to read all the changelogs.

On Fri, Jul 24, 2020 at 09:46:40AM +0800, Qu Wenruo wrote:
> commit 1dae7e0e58b484eaa43d530f211098fdeeb0f404 upstream.
> 
> [BUG]
> There are several reported runaway balance, that balance is flooding the
> log with "found X extents" where the X never changes.
> 
> [CAUSE]
> Commit d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after
> merge_reloc_roots") introduced BTRFS_ROOT_DEAD_RELOC_TREE bit to
> indicate that one subvolume has finished its tree blocks swap with its
> reloc tree.
> 
> However if balance is canceled or hits ENOSPC halfway, we didn't clear
> the BTRFS_ROOT_DEAD_RELOC_TREE bit, leaving that bit hanging forever
> until unmount.
> 
> Any subvolume root with that bit, would cause backref cache to skip this
> tree block, as it has finished its tree block swap.  This would cause
> all tree blocks of that root be ignored by balance, leading to runaway
> balance.
> 
> [FIX]
> Fix the problem by also clearing the BTRFS_ROOT_DEAD_RELOC_TREE bit for
> the original subvolume of orphan reloc root.
> 
> Add an umount check for the stale bit still set.
> 
> Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
> Cc: <stable@vger.kernel.org> # 5.7.x
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c    | 1 +
>  fs/btrfs/relocation.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f71e4dbe1d8a..f00e64fee5dd 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1998,6 +1998,7 @@ void btrfs_put_root(struct btrfs_root *root)
>  
>  	if (refcount_dec_and_test(&root->refs)) {
>  		WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
> +		WARN_ON(test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state));
>  		if (root->anon_dev)
>  			free_anon_bdev(root->anon_dev);
>  		btrfs_drew_lock_destroy(&root->snapshot_lock);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 157452a5e110..f67d736c27a1 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -2642,6 +2642,8 @@ void merge_reloc_roots(struct reloc_control *rc)
>  					root->reloc_root = NULL;
>  					btrfs_put_root(reloc_root);
>  				}
> +				clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
> +					  &root->state);
>  				btrfs_put_root(root);
>  			}
>  
> -- 
> 2.27.0
