Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6725A6EBF
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 22:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiH3Uyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 16:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiH3Uyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 16:54:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB59DC8;
        Tue, 30 Aug 2022 13:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90140B81D9E;
        Tue, 30 Aug 2022 20:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE95BC433D6;
        Tue, 30 Aug 2022 20:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661892883;
        bh=yIElMwQGWkojI/hIxW9i7E/xUCddTDsafw+x6dSqQPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RUWaqurIXbAN10nS43RqubzySwQZffXd9qrM4n8jvqKrTUMxlC+ytuGSmWtiFDvoG
         9gZPPK+zL+X2+eh4bqyVE02gMlYq69W0FseQazAAjy8m+xzOwMAURDwrIp5fXf5Egx
         tLoSDMROjIrxGpW4RC3VmWPdH/F/Zo3Z7tNRvI7Fc2nanjGrMbioqy7TT3N7fIEv+N
         UYs9aQphSnwr9QyD+URehQcdqemskzwtn5lwksNVN8L+FHEFZ36zaJrCfhdIK81Mjf
         8XZSxE9RJ85wwZKAd6nC8d0J07d1ZpBcB3Wo8rMXZhcWePdWF+tiWiruF5VuM9wJtX
         IyPxW73Zo/q6w==
Date:   Tue, 30 Aug 2022 13:54:41 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix missing mapping caused by the
 mount/umount race
Message-ID: <Yw55Ebk8zLIgBFfn@google.com>
References: <20220829215206.3082124-1-jaegeuk@kernel.org>
 <cbc4bfe5-14f9-a4e0-c9c5-6b6b06437d5d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbc4bfe5-14f9-a4e0-c9c5-6b6b06437d5d@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/30, Chao Yu wrote:
> On 2022/8/30 5:52, Jaegeuk Kim wrote:
> > Sometimes we can get a cached meta_inode which has no aops yet. Let's set it
> > all the time to fix the below panic.
> > 
> > Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> > Mem abort info:
> >    ESR = 0x0000000086000004
> >    EC = 0x21: IABT (current EL), IL = 32 bits
> >    SET = 0, FnV = 0
> >    EA = 0, S1PTW = 0
> >    FSC = 0x04: level 0 translation fault
> > user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109ee4000
> > [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
> > Internal error: Oops: 86000004 [#1] PREEMPT SMP
> > Modules linked in:
> > CPU: 1 PID: 3045 Comm: syz-executor330 Not tainted 6.0.0-rc2-syzkaller-16455-ga41a877bc12d #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
> > pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > pc : 0x0
> > lr : folio_mark_dirty+0xbc/0x208 mm/page-writeback.c:2748
> > sp : ffff800012783970
> > x29: ffff800012783970 x28: 0000000000000000 x27: ffff800012783b08
> > x26: 0000000000000001 x25: 0000000000000400 x24: 0000000000000001
> > x23: ffff0000c736e000 x22: 0000000000000045 x21: 05ffc00000000015
> > x20: ffff0000ca7403b8 x19: fffffc00032ec600 x18: 0000000000000181
> > x17: ffff80000c04d6bc x16: ffff80000dbb8658 x15: 0000000000000000
> > x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> > x11: ff808000083e9814 x10: 0000000000000000 x9 : ffff8000083e9814
> > x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
> > x5 : ffff0000cbb19000 x4 : ffff0000cb3d2000 x3 : ffff0000cbb18f80
> > x2 : fffffffffffffff0 x1 : fffffc00032ec600 x0 : ffff0000ca7403b8
> > Call trace:
> >   0x0
> >   set_page_dirty+0x38/0xbc mm/folio-compat.c:62
> >   f2fs_update_meta_page+0x80/0xa8 fs/f2fs/segment.c:2369
> >   do_checkpoint+0x794/0xea8 fs/f2fs/checkpoint.c:1522
> >   f2fs_write_checkpoint+0x3b8/0x568 fs/f2fs/checkpoint.c:1679
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: syzbot+775a3440817f74fddb8c@syzkaller.appspotmail.com
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >   fs/f2fs/inode.c | 13 ++++++++-----
> >   1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> > index 6d11c365d7b4..1feb0a8a699e 100644
> > --- a/fs/f2fs/inode.c
> > +++ b/fs/f2fs/inode.c
> > @@ -490,10 +490,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
> >   	if (!inode)
> >   		return ERR_PTR(-ENOMEM);
> > -	if (!(inode->i_state & I_NEW)) {
> > -		trace_f2fs_iget(inode);
> > -		return inode;
> > -	}
> > +	/* We can see an old cached inode. Let's set the aops all the time. */
> 
> Why an old cached inode (has no I_NEW flag) has NULL a_ops pointer? If it is a bad
> inode, it should be unhashed before unlock_new_inode().

I'm trying to dig further tho, it's not a bad inode, nor I_FREEING | I_CLEAR.
It's very werid that thie meta inode is found in newly created superblock by
the global hash table. I've checked that the same superblock pointer was used
in the previous tests, but inode was evictied all the time.

> 
> Thanks,
> 
> >   	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
> >   		goto make_now;
> > @@ -502,6 +499,11 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
> >   		goto make_now;
> >   #endif
> > +	if (!(inode->i_state & I_NEW)) {
> > +		trace_f2fs_iget(inode);
> > +		return inode;
> > +	}
> > +
> >   	ret = do_read_inode(inode);
> >   	if (ret)
> >   		goto bad_inode;
> > @@ -557,7 +559,8 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
> >   		file_dont_truncate(inode);
> >   	}
> > -	unlock_new_inode(inode);
> > +	if (inode->i_state & I_NEW)
> > +		unlock_new_inode(inode);
> >   	trace_f2fs_iget(inode);
> >   	return inode;
