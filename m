Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67AB1CDD99
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 16:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgEKOpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 10:45:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:51632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729688AbgEKOpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 10:45:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EF18DAD72;
        Mon, 11 May 2020 14:45:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 76262DA823; Mon, 11 May 2020 16:44:46 +0200 (CEST)
Date:   Mon, 11 May 2020 16:44:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com,
        fdmanana@suse.com, Marcos Paulo de Souza <mpdesouza@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: send: Emit file capabilities after chown
Message-ID: <20200511144445.GT18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Marcos Paulo de Souza <marcos@mpdesouza.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, wqu@suse.com, fdmanana@suse.com,
        Marcos Paulo de Souza <mpdesouza@suse.com>, stable@vger.kernel.org
References: <20200511021507.26942-1-marcos@mpdesouza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511021507.26942-1-marcos@mpdesouza.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 10, 2020 at 11:15:07PM -0300, Marcos Paulo de Souza wrote:
> From: Marcos Paulo de Souza <mpdesouza@suse.com>
> 
> [PROBLEM]
> Whenever a chown is executed, all capabilities of the file being touched are
> lost.  When doing incremental send with a file with capabilities, there is a
> situation where the capability can be lost in the receiving side. The
> sequence of actions bellow shows the problem:
> 
> $ mount /dev/sda fs1
> $ mount /dev/sdb fs2
> 
> $ touch fs1/foo.bar
> $ setcap cap_sys_nice+ep fs1/foo.bar
> $ btrfs subvol snap -r fs1 fs1/snap_init
> $ btrfs send fs1/snap_init | btrfs receive fs2
> 
> $ chgrp adm fs1/foo.bar
> $ setcap cap_sys_nice+ep fs1/foo.bar
> 
> $ btrfs subvol snap -r fs1 fs1/snap_complete
> $ btrfs subvol snap -r fs1 fs1/snap_incremental
> 
> $ btrfs send fs1/snap_complete | btrfs receive fs2
> $ btrfs send -p fs1/snap_init fs1/snap_incremental | btrfs receive fs2
> 
> At this point, only a chown was emitted by "btrfs send" since only the group
> was changed. This makes the cap_sys_nice capability to be dropped from
> fs2/snap_incremental/foo.bar
> 
> [FIX]
> Only emit capabilities after chown is emitted. The current code
> first checks for xattrs that are new/changed, emits them, and later emit
> the chown. Now, __process_new_xattr skips capabilities, letting only
> finish_inode_if_needed to emit them, if they exist, for the inode being
> processed.
> 
> This behavior was being worked around in "btrfs receive"
> side by caching the capability and only applying it after chown. Now,
> xattrs are only emmited _after_ chown, making that hack not needed
> anymore.
> 
> Link: https://github.com/kdave/btrfs-progs/issues/202
> CC: stable@vger.kernel.org
> Suggested-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  Changes from v2:
>  * Tag Stable correctly
>  * Forgot to add v2 in the latest patch. Now set to v3 to avoid confusion
> 
>  Changes from v1:
>  * Constify name var in send_capabilities function (suggested by Filipe)
>  * Changed btrfs_alloc_path -> alloc_path_for_send() in send_capabilities
>   (suggested by Filipe)
>  * Removed a redundant sentence in the commit message (suggested by Filipe)
>  * Added the Reviewed-By tag from Filipe
> 
>  Changes from RFC:
>  * Explained about chown + drop capabilities problem in the commit message (suggested
>    by Filipe and David)
>  * Changed the commit message to show describe the fix (suggested by Filipe)
>  * Skip the xattr in __process_new_xattr if it's a capability, since it'll be
>    handled in finish_inode_if_needed now (suggested by Filipe).
>  * Created function send_capabilities to query if the inode has caps, and if
>    yes, emit them.
>  * Call send_capabilities in finish_inode_if_needed _after_ the needs_chown
>    check. (suggested by Filipe)
> 
>  fs/btrfs/send.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 6b86841315be..2b378e32e7dc 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -23,6 +23,7 @@
>  #include "btrfs_inode.h"
>  #include "transaction.h"
>  #include "compression.h"
> +#include "xattr.h"
>  
>  /*
>   * Maximum number of references an extent can have in order for us to attempt to
> @@ -4545,6 +4546,10 @@ static int __process_new_xattr(int num, struct btrfs_key *di_key,
>  	struct fs_path *p;
>  	struct posix_acl_xattr_header dummy_acl;
>  
> +	/* capabilities are emitted by finish_inode_if_needed */

Comments should start with an uppercase

> +	if (!strncmp(name, XATTR_NAME_CAPS, name_len))
> +		return 0;
> +
>  	p = fs_path_alloc();
>  	if (!p)
>  		return -ENOMEM;
> @@ -5107,6 +5112,66 @@ static int send_extent_data(struct send_ctx *sctx,
>  	return 0;
>  }
>  
> +/*
> + * Search for a capability xattr related to sctx->cur_ino. If the capability if
> + * found, call send_set_xattr function to emit it.
> + *
> + * Return %0 if there isn't a capability, or when the capability was emitted
> + * successfully, or < %0 if an error occurred.
> + */
> +static int send_capabilities(struct send_ctx *sctx)
> +{
> +	struct fs_path *fspath = NULL;
> +	struct btrfs_path *path;
> +	struct btrfs_dir_item *di;
> +	struct extent_buffer *leaf;
> +	unsigned long data_ptr;
> +	const char *name = XATTR_NAME_CAPS;
> +	char *buf = NULL;
> +	int buf_len;
> +	int ret = 0;
> +
> +	path = alloc_path_for_send();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	di = btrfs_lookup_xattr(NULL, sctx->send_root, path, sctx->cur_ino,
> +				name, strlen(name), 0);

As Filipe pointed out in previous iteration, this could be directly
XATTR_NAME_CAPS instead of the temporary variable. I'd prefer it that
way too, XATTR_NAME_CAPS is a plain string and strings get merged at
link time. Also compiler replaces strlen("string") with the number.

> +	if (!di) {
> +		/* there is no xattr for this inode */
> +		goto out;
> +	} else if (IS_ERR(di)) {
> +		ret = PTR_ERR(di);
> +		goto out;
> +	}
> +
> +	leaf = path->nodes[0];
> +	buf_len = btrfs_dir_data_len(leaf, di);
> +
> +	fspath = fs_path_alloc();
> +	buf = kmalloc(buf_len, GFP_KERNEL);
> +	if (!fspath || !buf) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, fspath);
> +	if (ret < 0)
> +		goto out;
> +
> +	data_ptr = (unsigned long)((char *)(di + 1) +
> +				   btrfs_dir_name_len(leaf, di));

This is probably copy&pasted, but the char* typecast is not necessary
and the whole expression could be

	data_ptr = (unsigned long)(di + 1) + btrfs_dir_name_len(leaf, di);

> +	read_extent_buffer(leaf, buf, data_ptr,
> +			   btrfs_dir_data_len(leaf, di));

btrfs_dir_data_len(leaf, di) is cached as buf_len from before so it
should be used as well.
