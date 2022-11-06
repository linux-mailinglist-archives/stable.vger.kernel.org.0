Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D361DFD1
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 01:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKFAcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 20:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKFAcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Nov 2022 20:32:19 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ACEB85C;
        Sat,  5 Nov 2022 17:32:17 -0700 (PDT)
Received: from letrec.thunk.org (guestnat-104-133-8-97.corp.google.com [104.133.8.97] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2A60W9Vu026511
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 5 Nov 2022 20:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1667694732; bh=azX4G6X16XY4YlZZR91Wa/ucrvUu3oVweywncwRmWZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=BYuDOdgYrMa2SvrDKJ8/BOIcHD3FN1jNmiNwcwiUGnFjRnnvyDGQGVR+rZtDzbQ0e
         staf7jJCrgCDn1mwxek80hAS6/aJRj/z3n534JE9OkornLh6ZT/zrFjwAs67u9X9w5
         VdLQgkJIz8lctifYLFeJEZhjQUSAU0UqKVgbjF7DkS/m/A7CzoOkV1TZW6WBMInT6S
         dnfCxsKDvIVXyNXM638fWcvYtPxt/WS2h4elNWXnF+ruQ6JL4Kzdo+WY6srDoPDr6A
         ANZIyJi3ic4ShX7kt3/nIYKPtOopQjUtyHs/FTVCL+WpNmI3t5wSnbFoO2n8jvLnib
         UwIAaigFW1X2w==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id F2D3E8C00A0; Sat,  5 Nov 2022 20:32:08 -0400 (EDT)
Date:   Sat, 5 Nov 2022 20:32:08 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix a NULL pointer when validating an inode
 bitmap
Message-ID: <Y2cAiLNIIJhm4goP@mit.edu>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221011155623.14840-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221011155623.14840-1-lhenriques@suse.de>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

First of all, you replied to this patch a completely different patch,
"ext4: fix BUG_ON() when directory entry has invalid rec_len".  This
very much confuses b4, so please don't do that.  If you send a patch
series, where the message-id are related, e.g.:

    20221011155623.14840-1-lhenriques@suse.de
    20221011155623.14840-2-lhenriques@suse.de

etc., b4 will figure out what is going on.  But when the message id's
are unrelated, e.g:

    20221011155623.14840-1-lhenriques@suse.de
vs    
    20221012131330.32456-1-lhenriques@suse.de

... b4 will assume that 20221012131330.32456-1-lhenriques@suse.de is a
newer version of 20221011155623.14840-1-lhenriques@suse.de and there
is apparently no way to tell it to not try to use the "newer" version
of the patch.

On Tue, Oct 11, 2022 at 04:56:24PM +0100, Luís Henriques wrote:
> It's possible to hit a NULL pointer exception while accessing the
> sb->s_group_info in ext4_validate_inode_bitmap(), when calling
> ext4_get_group_info().

  ...

> This issue can be fixed by returning NULL in ext4_get_group_info() when
> ->s_group_info is NULL.  This also requires checking the return code from
> ext4_get_group_info() when appropriate.

I don't believe this is a correct diagnosis of what is going on.  Did
you actually confirm the line numbers associated with the call stack?
What makes you believe that?  Look at how s_group_info is initialized
in ext4_mb_alloc_groupinfo() in fs/ext4/mballoc.c.  It's pretty
careful to make sure this is not the case.

>  EXT4-fs (loop0): warning: mounting unchecked fs, running e2fsck is recommended
>  EXT4-fs error (device loop0): ext4_clear_blocks:866: inode #32: comm mount: attempt to clear invalid blocks 16777450 len 1
>  EXT4-fs error (device loop0): ext4_free_branches:1012: inode #32: comm mount: invalid indirect mapped block 1258291200 (level 1)
>  EXT4-fs error (device loop0): ext4_free_branches:1012: inode #32: comm mount: invalid indirect mapped block 7379847 (level 2)
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  ...
>  RIP: 0010:ext4_read_inode_bitmap+0x21b/0x5a0
>  ...
>  Call Trace:
>   <TASK>
>   ext4_free_inode+0x172/0x5c0
>   ext4_evict_inode+0x4a5/0x730
>   evict+0xc1/0x1c0
>   ext4_setup_system_zone+0x2ea/0x380
>   ext4_fill_super+0x249f/0x3910
>   ? ext4_reconfigure+0x880/0x880
>   ? snprintf+0x49/0x60
>   ? ext4_reconfigure+0x880/0x880
>   get_tree_bdev+0x169/0x260
>   vfs_get_tree+0x16/0x70
>   path_mount+0x77d/0xa30
>   __x64_sys_mount+0x101/0x140
>   do_syscall_64+0x3c/0x80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0

So we're evicting an inode while in the middle of calling
ext4_setup_system_zone() in fs/ext4/block_validity.c.  That can only
happen if we are calling iput() on an an inode, and the only place
that we do that in block_validity.c is in the function
ext4_protect_reserved_inode() --- which we call on the journal inode.

Given the error messages, I suspect this was a fuzzed file system
where the journal inode was not in the standard reserved ino, but
rather in a the normal inode number, in s_journal_inum (which is a
leftover relic from the very early ext3 days), and that inode number
was then explicitly/maliciously placed on the orphan list, and then
hilarity ensued from there.

We need to add some better error checking to protect against this case
in ext4_orphan_get().

Do you have the file system image which triggered this failure?  Was
it the same syzkaller report, or perhaps was it some other syzkaller
report?


> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 860fc5119009..e5ac5c2363df 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -148,6 +148,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
>  	struct super_block *sb = inode->i_sb;
>  	Indirect *p = chain;
>  	struct buffer_head *bh;
> +	unsigned int key;
>  	int ret = -EIO;
>  
>  	*err = 0;
> @@ -156,9 +157,18 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
>  	if (!p->key)
>  		goto no_block;
>  	while (--depth) {
> -		bh = sb_getblk(sb, le32_to_cpu(p->key));
> +		key = le32_to_cpu(p->key);
> +		bh = sb_getblk(sb, key);
>  		if (unlikely(!bh)) {
> -			ret = -ENOMEM;
> +			/*
> +			 * sb_getblk() masks different errors by always
> +			 * returning NULL.  Let's distinguish at least the case
> +			 * where the block is out of range.
> +			 */
> +			if (key > ext4_blocks_count(EXT4_SB(sb)->s_es))
> +				ret = -EFSCORRUPTED;
> +			else
> +				ret = -ENOMEM;
>  			goto failure;
>  		}
>

And this is fixing a completely different problem and should go in a
different patch.  It's also not the best way of fixing it.  What we
should do is check whether key is out of bounds *before* calling
sb_getblkf(), and then call ext4_error() to mark the file system is
corrupted, and then return -EFSCORRUPTED.

Cheers,

						- Ted
