Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2F664E718
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 06:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiLPFrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 00:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiLPFrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 00:47:42 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6492F643
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 21:47:41 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BG5lH2C023104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 00:47:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671169641; bh=rbJVZ8DsMM6S8Bsd5BYiY8W/KAivyA6ztnbNyvSqbik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Uk6AdQcMDlLn+bYErQu2TQ1PYRkljk0Kv202BLpcxk9E+k2R13fHH1FqCV1zMmOEE
         PPgTW3EnLf7HWgpVaTuWRYCTEGyfnAoCNEbV0gMO4nBBF8eDBKISvsFeMSroXrcnAq
         QK4tPgmdh8RGsjgcOD4sYLvKFkasb/0gQ1aWR+lvGnQdVrQ3+x/D9ji6+qmDNdOZdk
         bD+69bE2ZlQv04A+52fEedBc/si0o9RhaW3fvksiVp5/RIUg+3vO0W64/z2CIjTDjV
         6P5ktV1diokPDqZvpVMyoeYVbyZ+IcX35LAnk+F8GUXaqri2tpo4JQVDrthHsndxP2
         /+a+CCRQC8HYA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id E788A15C40A2; Fri, 16 Dec 2022 00:47:16 -0500 (EST)
Date:   Fri, 16 Dec 2022 00:47:16 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jun Nie <jun.nie@linaro.org>
Cc:     stable@vger.kernel.org, djwong@kernel.org, jack@suse.cz,
        jlayton@kernel.org, lczerner@redhat.com,
        linux-ext4@vger.kernel.org, xuyang2018.jy@fujitsu.com
Subject: Re: [PATCH v1] ext4: Remove deprecated noacl/nouser_xattr options
Message-ID: <Y5wGZG05uicAPscI@mit.edu>
References: <166431556706.3511882.843791619431401636.b4-ty@mit.edu>
 <20221216034116.869864-1-jun.nie@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216034116.869864-1-jun.nie@linaro.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 11:41:16AM +0800, Jun Nie wrote:
> This patch[1] is needed on linux-5.15.y because the panic[2] is also found on
> linux-5.15.y when debugging bug[3]. Back ported patch[4] is confirmed to fix
> the bug on linux-5.15.y in the latest test of page[3]. Maybe back port on more
> branches is needed per patch comments.

This is not a proper fix for the syzkaller report being reported here:

https://syzkaller.appspot.com/bug?id=3613786cb88c93aa1c6a279b1df6a7b201347d08

It's true that the reproducer will no longer trigger, but that's just
because the reproducer is just exiting early because it is passing in
a mount option which is no longer being accepted.  In fact, that mount
option is completely unneeded and it's a failing of syzkaller that it
doesn't adequately minimize the reproducer by trying to remove various
random mount options that are not actually needed.  For example,
running the reproducer will trigger warnings like this:

	EXT4-fs: Ignoring removed nobh option

If we modify the kernel to simply ignore nouser_xattr, then the
reproducer will still trigger.  So this is not the right patch to
backport.

It's important that people who are trying to fix syzkaller bugs
understand what is fundamentally going on, instead of using blunt
force patches that simple paper over the issue.  Please remember that
syzkaller is supposed to help us improve the kernel, and it's not just
about trying to reduce the count of open syzkaller reports for its own
sake.  (This is really much more of a quality of implementation issue,
since this is not something that would really ever trigger in real
life, nor is it really a security issue --- despite some people
thinking that all syzkaller reports are actually security issues, and
we must run around like chickens with their heads cut off and until
they are all fixed.)


The real root cause of the problem is that the file system is getting
mounted with these mount options:

nouser_xattr,acl,debug_want_extra_isize=0x0000000000000080,lazytime,nobh,quota

Of which nouser_attr, acl, nobh, and quota are completely pointless.
It's also **super** unfortunate that the reproducer isn't written in
C, but this horrible psuedo-assimply language:

  memcpy(
      (void*)0x20000000,
      "\x6e\x6f\x75\x73\x65\x72\x5f\x78\x61\x74\x74\x72\x2c\x61\x63\x6c\x2c\x64"
      "\x65\x62\x75\x67\x5f\x77\x61\x6e\x74\x5f\x65\x78\x74\x72\x61\x5f\x69\x73"
      "\x69\x7a\x65\x3d\x30\x78\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30"
      "\x30\x30\x38\x30\x2c\x6c\x61\x7a\x79\x74\x69\x6d\x65\x2c\x6e\x6f\x62\x68"
      "\x2c\x71\x75\x6f\x74\x61\x2c\x00\x3d\x93\x09\x61\x36\x5d\x73\x58\x9c",
      89);

      ...
  syz_mount_image(0x20000440, 0x20000480, 0x1e, 0x20000000, 2, 0x427,
  			      		  	^^^^^^^^^^
                  0x200004c0);

(And again, this is stuff that I've complained to the syzkaller team
for years and years and years as being fundamentally developer hostile
and disrespects the time of upstream maintainers.  ARGH!!!!)

Anyway.....  So now let's look at the stack trace:

 ext4_xattr_block_set+0x8f8/0x3820 fs/ext4/xattr.c:1971
 ext4_xattr_move_to_block fs/ext4/xattr.c:2603 [inline]
 ext4_xattr_make_inode_space fs/ext4/xattr.c:2672 [inline]
 ext4_expand_extra_isize_ea+0x1591/0x1f30 fs/ext4/xattr.c:2764
 __ext4_expand_extra_isize+0x29e/0x3d0 fs/ext4/inode.c:5826
 ext4_try_to_expand_extra_isize fs/ext4/inode.c:5869 [inline]
 __ext4_mark_inode_dirty+0x4bf/0x7a0 fs/ext4/inode.c:5947
 ext4_dirty_inode+0xbc/0x100 fs/ext4/inode.c:5979
 __mark_inode_dirty+0x1f9/0x9d0 fs/fs-writeback.c:2431
 mark_inode_dirty_sync include/linux/fs.h:2429 [inline]
 iput+0x155/0x7d0 fs/inode.c:1686
 dentry_unlink_inode+0x349/0x430 fs/dcache.c:376
 __dentry_kill+0x3e2/0x5d0 fs/dcache.c:582
 shrink_dentry_list+0x379/0x4d0 fs/dcache.c:1176
 shrink_dcache_parent+0xcd/0x350
 do_one_tree fs/dcache.c:1657 [inline]
 shrink_dcache_for_umount+0x7c/0x1a0 fs/dcache.c:1674
 generic_shutdown_super+0x69/0x2d0 fs/super.c:447
 kill_block_super+0x80/0xe0 fs/super.c:1395

Because lazytime is enabled, after running the reproducer under
strace, what happens is that inode #12 gets touched so its access time
is modified, but because lazytime is enabled, we don't actually update
the on-disk until we actually unmount the superblock.  That's why
generic_shutdown_super() is in the stack trace.

At that point, when we shrink the dentry cache, when we eject the
inode from memory, iput() needs to update the on-disk inode with the
updated atime.  So far, so good.  But then we call ext4_dirty_inode(),
and then that interacts with the "debug_want_extra_isize-=128" mount
option.  So at this point, we try to expand inode's extra isize space,
and in order to do that we have to move some extended attributes.

Unfortunately, how ext4 currently does this is a bit stupid, and it
reads the contents of the ea_inode into memory, deletes the ea_inode
and then creates a new ea_inode.  That works, but it's horribly
inefficient, and **that's*** what we should actually fix.

Unfortunately, because we try to create a new ea_inode, when
ext4_xattr_block_set() calls the static function (which gets inlined)
ext4_xattr_inode_create(), and at that point, the call to
ext4_new_inode trips over the fact that the file system is being
unmoutned, and sb->s_root has already been set to NULL.

So this is what actually goes *boom*:

	ea_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
					  ^^^^^^^^^^^^^^^^^^^ NULL ptr, oops!
				  S_IFREG | 0600, NULL, inode->i_ino + 1, owner,
				  EXT4_EA_INODE_FL);


We can prove this is the issue by using the following debugging patch,
which prevents the reproducer from triggering after prining the "fs
being unmouinted" message:

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2697,6 +2697,13 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	int s_min_extra_isize = le16_to_cpu(sbi->s_es->s_min_extra_isize);
 	int isize_diff;	/* How much do we need to grow i_extra_isize */
 
+	pr_err("ext4_expand_extra_isize_ea ino %lu new_extra_isize %d curr %d\n",
+	       inode->i_ino, new_extra_isize, EXT4_I(inode)->i_extra_isize);
+	if (inode->i_sb->s_root == NULL) {
+		pr_err("ext4_expand_extra_isize_ea: fs being unmounted\n");
+		return -EINVAL;
+	}
+
 retry:
 	isize_diff = new_extra_isize - EXT4_I(inode)->i_extra_isize;
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)

Fixing this the clean and proper way, which is by making
ext4_xattr_move_to_block() more intelligent/efficient, is left as an
exercise to the reader.

Cheers,

						- Ted

P.S.  Note that this fix is actually needed for the current upstream
kernel; the reproducer will trigger in 6.1, although we need to either
modify the reproducer to drop the completely pointless nouser_xattr
mount option (which is a bit painful since the !@?! mount options is
obfuscated by virtue of being in hex for no particular good reason) or
by hacking the kernel to ignore that mount options, via a patch like
this:

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1658,6 +1658,7 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
 	fsparam_flag	("oldalloc",		Opt_removed),
 	fsparam_flag	("orlov",		Opt_removed),
 	fsparam_flag	("user_xattr",		Opt_user_xattr),
+	fsparam_flag	("nouser_xattr",	Opt_removed),
 	fsparam_flag	("acl",			Opt_acl),
 	fsparam_flag	("norecovery",		Opt_noload),
 	fsparam_flag	("noload",		Opt_noload),

