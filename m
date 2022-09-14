Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E585B8B8D
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 17:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiINPPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 11:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiINPP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 11:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15A87C763;
        Wed, 14 Sep 2022 08:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 911AC61DFA;
        Wed, 14 Sep 2022 15:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA521C433D7;
        Wed, 14 Sep 2022 15:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663168527;
        bh=pIwq9umY/OwwBicZlUiI0jtC5FowcLFuNrBfxhn7xPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qMVpJd7PmGu4+8+YKTMitE/3YQBtCGeNT2uKl+NhMvJj1758rlUoVOXaH26G8V9MG
         myLGID4U8Lub9FrzeqSMJaLlHq7foNm2oe0EVS0uU8abelFm3lmdopz0ZlYOy2DXMN
         sEMvq0c4JKC1+MvgtweVwZCgl0N9rc+VQjMeP+JNJs85f3+UMOoIJ+w3bN/k2VJBKc
         H8vuUF5KWcOU0qas9S2MI3knJxoi6qwR8yygCl+XL2Syt4CM8Hxa+otllx0J2F7Jve
         fmDFLVOK1fUeUVZRvYRhfm41W9LmkFJblBWH6t26gZqcvFWdfbwrbZmyCXXnJjAfTd
         DuFEMuqELEnHQ==
Date:   Wed, 14 Sep 2022 08:15:25 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix missing mapping caused by the
 mount/umount race
Message-ID: <YyHwDVk96qvKn9eQ@google.com>
References: <20220829215206.3082124-1-jaegeuk@kernel.org>
 <cbc4bfe5-14f9-a4e0-c9c5-6b6b06437d5d@kernel.org>
 <Yw55Ebk8zLIgBFfn@google.com>
 <Yw7P6BkNZmqxji3B@google.com>
 <2b669973-caf0-75e8-f421-7647dddf03ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b669973-caf0-75e8-f421-7647dddf03ce@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/14, Chao Yu wrote:
> On 2022/8/31 11:05, Jaegeuk Kim wrote:
> > On 08/30, Jaegeuk Kim wrote:
> > > On 08/30, Chao Yu wrote:
> > > > On 2022/8/30 5:52, Jaegeuk Kim wrote:
> > > > > Sometimes we can get a cached meta_inode which has no aops yet. Let's set it
> > > > > all the time to fix the below panic.
> > > > > 
> > > > > Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> > > > > Mem abort info:
> > > > >     ESR = 0x0000000086000004
> > > > >     EC = 0x21: IABT (current EL), IL = 32 bits
> > > > >     SET = 0, FnV = 0
> > > > >     EA = 0, S1PTW = 0
> > > > >     FSC = 0x04: level 0 translation fault
> > > > > user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109ee4000
> > > > > [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
> > > > > Internal error: Oops: 86000004 [#1] PREEMPT SMP
> > > > > Modules linked in:
> > > > > CPU: 1 PID: 3045 Comm: syz-executor330 Not tainted 6.0.0-rc2-syzkaller-16455-ga41a877bc12d #0
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
> > > > > pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > > > > pc : 0x0
> > > > > lr : folio_mark_dirty+0xbc/0x208 mm/page-writeback.c:2748
> > > > > sp : ffff800012783970
> > > > > x29: ffff800012783970 x28: 0000000000000000 x27: ffff800012783b08
> > > > > x26: 0000000000000001 x25: 0000000000000400 x24: 0000000000000001
> > > > > x23: ffff0000c736e000 x22: 0000000000000045 x21: 05ffc00000000015
> > > > > x20: ffff0000ca7403b8 x19: fffffc00032ec600 x18: 0000000000000181
> > > > > x17: ffff80000c04d6bc x16: ffff80000dbb8658 x15: 0000000000000000
> > > > > x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> > > > > x11: ff808000083e9814 x10: 0000000000000000 x9 : ffff8000083e9814
> > > > > x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
> > > > > x5 : ffff0000cbb19000 x4 : ffff0000cb3d2000 x3 : ffff0000cbb18f80
> > > > > x2 : fffffffffffffff0 x1 : fffffc00032ec600 x0 : ffff0000ca7403b8
> > > > > Call trace:
> > > > >    0x0
> > > > >    set_page_dirty+0x38/0xbc mm/folio-compat.c:62
> > > > >    f2fs_update_meta_page+0x80/0xa8 fs/f2fs/segment.c:2369
> > > > >    do_checkpoint+0x794/0xea8 fs/f2fs/checkpoint.c:1522
> > > > >    f2fs_write_checkpoint+0x3b8/0x568 fs/f2fs/checkpoint.c:1679
> > > > > 
> > > > > Cc: stable@vger.kernel.org
> > > > > Reported-by: syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com
> > > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > > ---
> > > > >    fs/f2fs/inode.c | 13 ++++++++-----
> > > > >    1 file changed, 8 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> > > > > index 6d11c365d7b4..1feb0a8a699e 100644
> > > > > --- a/fs/f2fs/inode.c
> > > > > +++ b/fs/f2fs/inode.c
> > > > > @@ -490,10 +490,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
> > > > >    	if (!inode)
> > > > >    		return ERR_PTR(-ENOMEM);
> > > > > -	if (!(inode->i_state & I_NEW)) {
> > > > > -		trace_f2fs_iget(inode);
> > > > > -		return inode;
> > > > > -	}
> > > > > +	/* We can see an old cached inode. Let's set the aops all the time. */
> > > > 
> > > > Why an old cached inode (has no I_NEW flag) has NULL a_ops pointer? If it is a bad
> > > > inode, it should be unhashed before unlock_new_inode().
> > > 
> > > I'm trying to dig further tho, it's not a bad inode, nor I_FREEING | I_CLEAR.
> > > It's very werid that thie meta inode is found in newly created superblock by
> > > the global hash table. I've checked that the same superblock pointer was used
> > > in the previous tests, but inode was evictied all the time.
> > 
> > I'll drop this patch, since it turned out there is a bug in reiserfs which
> > doesn't free the root inode (ino=2). That leads f2fs to find an ino=2 with
> > the previous superblock point used by reiserfs. That stale inode has no valid
> 
> One more question, why stale inode could be remained in inode hash table,
> shouldn't the stale inode be evicted/unhashed in below path during reiserfs
> umount:
> 
> - reiserfs_kill_sb
>  - kill_block_super
>   - generic_shutdown_super
>    - evict_inodes
>     - dispose_list
>      - evict
>       - remove_inode_hash

Yes, that's why I didn't dive into further, as it's odd.

> 
> Thanks,
> 
> > inode that f2fs can use. I tried to find where the root cause is in reiserfs,
> > but it seems quite hard to catch one.
> > 
> > - reiserfs_fill_super
> >   - reiserfs_xattr_init
> >    - create_privroot
> >     - xattr_mkdir
> >      - reiserfs_new_inode
> >       - reiserfs_get_unused_objectid returned 0 due to map crash
> > 
> > It seems the error path doesn't handle the root inode properly.
> > 
> > > 
> > > > 
> > > > Thanks,
> > > > 
> > > > >    	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
> > > > >    		goto make_now;
> > > > > @@ -502,6 +499,11 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
> > > > >    		goto make_now;
> > > > >    #endif
> > > > > +	if (!(inode->i_state & I_NEW)) {
> > > > > +		trace_f2fs_iget(inode);
> > > > > +		return inode;
> > > > > +	}
> > > > > +
> > > > >    	ret = do_read_inode(inode);
> > > > >    	if (ret)
> > > > >    		goto bad_inode;
> > > > > @@ -557,7 +559,8 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
> > > > >    		file_dont_truncate(inode);
> > > > >    	}
> > > > > -	unlock_new_inode(inode);
> > > > > +	if (inode->i_state & I_NEW)
> > > > > +		unlock_new_inode(inode);
> > > > >    	trace_f2fs_iget(inode);
> > > > >    	return inode;
> > > 
> > > 
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
