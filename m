Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03225551C5
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 18:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376705AbiFVQyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 12:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377386AbiFVQxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 12:53:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F92441632;
        Wed, 22 Jun 2022 09:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B38E619F6;
        Wed, 22 Jun 2022 16:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D816FC3411B;
        Wed, 22 Jun 2022 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655916732;
        bh=TxxIurnsqu6z7EwvzQ9NyM0v3aNR0Q6zyP6sKqQYt2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IFPUygRJjK9fHi3P4sbPdhML+nttk5tdx0iZ4TgHvcCodTZ1AjDuCBwvQ1aqc+5zc
         AbM9QyzyXp8hIuCly3loO4Whe4nsQ7tA/gPU/uFJyZYusAGfnFLzD/LxFPCPWTxfBR
         aQ3bX+fk1H2Qqgb8I6tCigSbPjiwuSL9qUppa3Vez4CzrAeRc5thaI99Lqq55JnkTy
         medNV4AnTspN0EEWNbgowOsg4Nj6XfPc3VGFo2p+/UJuoiAZ1ElS724v4NU30aiCWV
         a154YaJD9E4Zbm+g1dvg4Bv10j5RL4EQ6TJSIJKgDcViCpvt8Og02MmPJJDI0I7iSt
         gJJnbcVB04NUg==
Date:   Wed, 22 Jun 2022 09:52:10 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: attach inline_data after setting
 compression
Message-ID: <YrNIuqmMg/KSfoHA@google.com>
References: <20220617223106.3517374-1-jaegeuk@kernel.org>
 <ae324c70-8671-8878-5854-c0910c744379@kernel.org>
 <4c090b50-bfd1-ae90-ac72-ebae3963f578@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c090b50-bfd1-ae90-ac72-ebae3963f578@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/22, Chao Yu wrote:
> On 2022/6/19 8:35, Chao Yu wrote:
> > On 2022/6/18 6:31, Jaegeuk Kim wrote:
> > > This fixes the below corruption.
> > > 
> > > [345393.335389] F2FS-fs (vdb): sanity_check_inode: inode (ino=6d0, mode=33206) should not have inline_data, run fsck to fix
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Fixes: 677a82b44ebf ("f2fs: fix to do sanity check for inline inode")
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >    fs/f2fs/namei.c | 16 ++++++++++------
> > >    1 file changed, 10 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> > > index c549acb52ac4..a841abe6a071 100644
> > > --- a/fs/f2fs/namei.c
> > > +++ b/fs/f2fs/namei.c
> > > @@ -89,8 +89,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
> > >    	if (test_opt(sbi, INLINE_XATTR))
> > >    		set_inode_flag(inode, FI_INLINE_XATTR);
> > > -	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
> > > -		set_inode_flag(inode, FI_INLINE_DATA);
> > >    	if (f2fs_may_inline_dentry(inode))
> > >    		set_inode_flag(inode, FI_INLINE_DENTRY);
> > > @@ -107,10 +105,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
> > >    	f2fs_init_extent_tree(inode, NULL);
> > > -	stat_inc_inline_xattr(inode);
> > > -	stat_inc_inline_inode(inode);
> > > -	stat_inc_inline_dir(inode);
> > > -
> > >    	F2FS_I(inode)->i_flags =
> > >    		f2fs_mask_flags(mode, F2FS_I(dir)->i_flags & F2FS_FL_INHERITED);
> > > @@ -127,6 +121,14 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
> > >    			set_compress_context(inode);
> > >    	}
> > > +	/* Should enable inline_data after compression set */
> > > +	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
> > > +		set_inode_flag(inode, FI_INLINE_DATA);
> > > +
> > > +	stat_inc_inline_xattr(inode);
> > > +	stat_inc_inline_inode(inode);
> > > +	stat_inc_inline_dir(inode);
> > > +
> > >    	f2fs_set_inode_flags(inode);
> > >    	trace_f2fs_new_inode(inode, 0);
> > > @@ -325,6 +327,8 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
> > >    		if (!is_extension_exist(name, ext[i], false))
> > >    			continue;
> > > +		/* Do not use inline_data with compression */
> > > +		clear_inode_flag(inode, FI_INLINE_DATA);
> > 
> > if (is_inode_set_flag()) {
> > 	clear_inode_flag();
> > 	stat_dec_inline_inode();
> > }
> 
> Missed to send new version to mailing list?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git/commit/?h=dev&id=4cde00d50707c2ef6647b9b96b2cb40b6eb24397

I'm testing the new version.

> 
> Thanks,
> 
> > 
> > Thanks,
> > 
> > >    		set_compress_context(inode);
> > >    		return;
> > >    	}
> > 
> > 
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
