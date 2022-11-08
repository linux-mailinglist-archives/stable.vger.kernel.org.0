Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D356214D6
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiKHOFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiKHOFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:33 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09483686AD;
        Tue,  8 Nov 2022 06:05:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9F3DB2249B;
        Tue,  8 Nov 2022 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667916329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zL3w8DJvA8eE/6QG4kSb7l6IPM6rB1dgJlbtR0vCZxo=;
        b=M4fCdcd70ixEsfGK5UNng/t3q5YVm1vp3zcJWF/DoYR9vIBCnNKjBlQEIgmLo49DIKhtiz
        c/NQw+nSKOnB3Kz9FtvuCEx06qrSpIr7I6yJ73F9LwXG4MyjjeZutwogQ97JL/z8p5nGCv
        q8VJRrgFOSKNk7a6vY17TeJt1FzEymw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667916329;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zL3w8DJvA8eE/6QG4kSb7l6IPM6rB1dgJlbtR0vCZxo=;
        b=4DgR+kSdAUt58CFnC0r6qSOc79JOm4N0GoJuNwGsHnmF2nt6In1I5W9mvPRHa/d2XqUhuy
        wiU9d0vm9h/44JAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 48A00139F1;
        Tue,  8 Nov 2022 14:05:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Yx4lDyliamNiHgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 08 Nov 2022 14:05:29 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id ffde96ab;
        Tue, 8 Nov 2022 14:06:29 +0000 (UTC)
Date:   Tue, 8 Nov 2022 14:06:29 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix a NULL pointer when validating an inode
 bitmap
Message-ID: <Y2piZT22QwSjNso9@suse.de>
References: <20221010142035.2051-1-lhenriques@suse.de>
 <20221011155623.14840-1-lhenriques@suse.de>
 <Y2cAiLNIIJhm4goP@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y2cAiLNIIJhm4goP@mit.edu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 05, 2022 at 08:32:08PM -0400, Theodore Ts'o wrote:
> First of all, you replied to this patch a completely different patch,
> "ext4: fix BUG_ON() when directory entry has invalid rec_len".  This
> very much confuses b4, so please don't do that.  If you send a patch
> series, where the message-id are related, e.g.:
> 
>     20221011155623.14840-1-lhenriques@suse.de
>     20221011155623.14840-2-lhenriques@suse.de
> 
> etc., b4 will figure out what is going on.  But when the message id's
> are unrelated, e.g:
> 
>     20221011155623.14840-1-lhenriques@suse.de
> vs    
>     20221012131330.32456-1-lhenriques@suse.de
> 
> ... b4 will assume that 20221012131330.32456-1-lhenriques@suse.de is a
> newer version of 20221011155623.14840-1-lhenriques@suse.de and there
> is apparently no way to tell it to not try to use the "newer" version
> of the patch.

Yeah, I'm really sorry for this.  As I mentioned in a reply to that email,
I messed it up by running my scripts from shell history, without cleaning
the extra parameters.  Lesson learned -- *never* use shell history for
sending patches! :-(

> On Tue, Oct 11, 2022 at 04:56:24PM +0100, Luís Henriques wrote:
> > It's possible to hit a NULL pointer exception while accessing the
> > sb->s_group_info in ext4_validate_inode_bitmap(), when calling
> > ext4_get_group_info().
> 
>   ...
> 
> > This issue can be fixed by returning NULL in ext4_get_group_info() when
> > ->s_group_info is NULL.  This also requires checking the return code from
> > ext4_get_group_info() when appropriate.
> 
> I don't believe this is a correct diagnosis of what is going on.  Did
> you actually confirm the line numbers associated with the call stack?

Here's the line numbers:

$ ./scripts/faddr2line fs/ext4/ialloc.o ext4_read_inode_bitmap+0x21b/0x5a0
ext4_read_inode_bitmap+0x21b/0x5a0:
ext4_get_group_info at /home/miguel/kernel/linux/fs/ext4/ext4.h:3332
(inlined by) ext4_validate_inode_bitmap at /home/miguel/kernel/linux/fs/ext4/ialloc.c:90
(inlined by) ext4_read_inode_bitmap at /home/miguel/kernel/linux/fs/ext4/ialloc.c:210

This is on a 6.1.0-rc4 kernel, where I got:

  RIP: 0010:ext4_read_inode_bitmap+0x21b/0x5a0

So, the issue is happening in ext4_read_inode_bitmap(), when
jumping to the 'verify' label from here:

    184         if (buffer_uptodate(bh)) {
    185                 /*
    186                  * if not uninit if bh is uptodate,
    187                  * bitmap is also uptodate
    188                  */
    189                 set_bitmap_uptodate(bh);
    190                 unlock_buffer(bh);
    191                 goto verify;
    192         }
    ...
    209 verify:
==> 210         err = ext4_validate_inode_bitmap(sb, desc, block_group, bh);
    211         if (err)
    212                 goto out;
    213         return bh;
    214 out:
    215         put_bh(bh);
    216         return ERR_PTR(err);
    217 }

> What makes you believe that?  Look at how s_group_info is initialized
> in ext4_mb_alloc_groupinfo() in fs/ext4/mballoc.c.  It's pretty
> careful to make sure this is not the case.

Right.  I may be missing something, but I don't think we get that far.
__ext4_fill_super() will first call ext4_setup_system_zone() (which is
where this bug occurs) and only after that ext4_mb_init() will be invoked
(which is where ext4_mb_alloc_groupinfo() will eventually be called).

> >  EXT4-fs (loop0): warning: mounting unchecked fs, running e2fsck is recommended
> >  EXT4-fs error (device loop0): ext4_clear_blocks:866: inode #32: comm mount: attempt to clear invalid blocks 16777450 len 1
> >  EXT4-fs error (device loop0): ext4_free_branches:1012: inode #32: comm mount: invalid indirect mapped block 1258291200 (level 1)
> >  EXT4-fs error (device loop0): ext4_free_branches:1012: inode #32: comm mount: invalid indirect mapped block 7379847 (level 2)
> >  BUG: kernel NULL pointer dereference, address: 0000000000000000
> >  ...
> >  RIP: 0010:ext4_read_inode_bitmap+0x21b/0x5a0
> >  ...
> >  Call Trace:
> >   <TASK>
> >   ext4_free_inode+0x172/0x5c0
> >   ext4_evict_inode+0x4a5/0x730
> >   evict+0xc1/0x1c0
> >   ext4_setup_system_zone+0x2ea/0x380
> >   ext4_fill_super+0x249f/0x3910
> >   ? ext4_reconfigure+0x880/0x880
> >   ? snprintf+0x49/0x60
> >   ? ext4_reconfigure+0x880/0x880
> >   get_tree_bdev+0x169/0x260
> >   vfs_get_tree+0x16/0x70
> >   path_mount+0x77d/0xa30
> >   __x64_sys_mount+0x101/0x140
> >   do_syscall_64+0x3c/0x80
> >   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> So we're evicting an inode while in the middle of calling
> ext4_setup_system_zone() in fs/ext4/block_validity.c.  That can only
> happen if we are calling iput() on an an inode, and the only place
> that we do that in block_validity.c is in the function
> ext4_protect_reserved_inode() --- which we call on the journal inode.
> 
> Given the error messages, I suspect this was a fuzzed file system
> where the journal inode was not in the standard reserved ino, but
> rather in a the normal inode number, in s_journal_inum (which is a
> leftover relic from the very early ext3 days), and that inode number
> was then explicitly/maliciously placed on the orphan list, and then
> hilarity ensued from there.

Correct, the images do indeed have the wrong inode number (32) in
s_journal_inum.

> We need to add some better error checking to protect against this case
> in ext4_orphan_get().

Unfortunately, after some debug, I don't see ext4_orphan_get() ever being
invoked anywhere.

> 
> Do you have the file system image which triggered this failure?  Was
> it the same syzkaller report, or perhaps was it some other syzkaller
> report?

Yes, these were generated with a fuzzer, and the 2 images I've used as
reproducers were picked from the bugzillas in the commit 'Link' tags:

  Link: https://bugzilla.kernel.org/show_bug.cgi?id=216541
  Link: https://bugzilla.kernel.org/show_bug.cgi?id=216539

To reproduce the issue you simply need to mount those images.

> 
> 
> > diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> > index 860fc5119009..e5ac5c2363df 100644
> > --- a/fs/ext4/indirect.c
> > +++ b/fs/ext4/indirect.c
> > @@ -148,6 +148,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
> >  	struct super_block *sb = inode->i_sb;
> >  	Indirect *p = chain;
> >  	struct buffer_head *bh;
> > +	unsigned int key;
> >  	int ret = -EIO;
> >  
> >  	*err = 0;
> > @@ -156,9 +157,18 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
> >  	if (!p->key)
> >  		goto no_block;
> >  	while (--depth) {
> > -		bh = sb_getblk(sb, le32_to_cpu(p->key));
> > +		key = le32_to_cpu(p->key);
> > +		bh = sb_getblk(sb, key);
> >  		if (unlikely(!bh)) {
> > -			ret = -ENOMEM;
> > +			/*
> > +			 * sb_getblk() masks different errors by always
> > +			 * returning NULL.  Let's distinguish at least the case
> > +			 * where the block is out of range.
> > +			 */
> > +			if (key > ext4_blocks_count(EXT4_SB(sb)->s_es))
> > +				ret = -EFSCORRUPTED;
> > +			else
> > +				ret = -ENOMEM;
> >  			goto failure;
> >  		}
> >
> 
> And this is fixing a completely different problem and should go in a
> different patch.  It's also not the best way of fixing it.  What we
> should do is check whether key is out of bounds *before* calling
> sb_getblkf(), and then call ext4_error() to mark the file system is
> corrupted, and then return -EFSCORRUPTED.

OK, makes sense.  I'll send out a separate patch for this.  Thanks a lot
for your review, Ted.

Cheers,
--
Luís
