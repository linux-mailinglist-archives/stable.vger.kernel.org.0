Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85E952030E
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 18:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbiEIRB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 13:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbiEIRB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 13:01:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F811E05AE;
        Mon,  9 May 2022 09:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19EA1B81810;
        Mon,  9 May 2022 16:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B52C385B2;
        Mon,  9 May 2022 16:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652115449;
        bh=OaXybH4jCWXEKkCxz9xjsRa7BIfvoYHVfNPxqyV5/94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RJuMf1panOt4mw/iicfCpg3O5q1+LpvR5dgUX36eHh6ymw2J8oEJm/XBJWo4zWYMg
         65WG208cr1xfLdqpe9wBhyt42K8i5l2tm8+i8sLFmIZDrhO+tbV7X5lfCrlX7ircJl
         +R00oiq9K+1s7SjB0TKqXkgDjsnSFrt0F+fbP+256Wfk5EUjJjytQDMVWKKNcuxuzX
         mYmCJXdAn9zeS7QTGq6BPC3UyEqJWO/0Md+QNIdj1yqpQ2eqLiHkfnmCbMb372dmzD
         +bsJ9ZmNjacbiPN8njZICA9SOhg18ljW0Pk4jBLraIazA+9VXCDxdX1unB/mAPLYQa
         qD9N9Tl9+FzQA==
Date:   Mon, 9 May 2022 09:57:27 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     Ming Yan <yanming@tju.edu.cn>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix to do sanity check for inline inode
Message-ID: <YnlH929igOSi+Iv3@google.com>
References: <20220428024940.12102-1-chao@kernel.org>
 <YnLwDx1smguDQ6qC@google.com>
 <173c51c2-eff3-8d76-7041-e9c58024a97e@kernel.org>
 <YnNFCEdSpyVSaTZq@google.com>
 <142acf95-c940-8d4a-7f00-08f1bb816c49@kernel.org>
 <c717cdc3-bb6f-d437-f039-d05418c9dd88@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c717cdc3-bb6f-d437-f039-d05418c9dd88@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/08, Chao Yu wrote:
> Ping,

This is in my TODO list, but will take some time. Sorry.

> 
> On 2022/5/5 22:33, Chao Yu wrote:
> > On 2022/5/5 11:31, Jaegeuk Kim wrote:
> > > On 05/05, Chao Yu wrote:
> > > > On 2022/5/5 5:28, Jaegeuk Kim wrote:
> > > > > On 04/28, Chao Yu wrote:
> > > > > > As Yanming reported in bugzilla:
> > > > > > 
> > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=215895
> > > > > > 
> > > > > > I have encountered a bug in F2FS file system in kernel v5.17.
> > > > > > 
> > > > > > The kernel message is shown below:
> > > > > > 
> > > > > > kernel BUG at fs/inode.c:611!
> > > > > > Call Trace:
> > > > > >     evict+0x282/0x4e0
> > > > > >     __dentry_kill+0x2b2/0x4d0
> > > > > >     dput+0x2dd/0x720
> > > > > >     do_renameat2+0x596/0x970
> > > > > >     __x64_sys_rename+0x78/0x90
> > > > > >     do_syscall_64+0x3b/0x90
> > > > > > 
> > > > > > The root cause is: fuzzed inode has both inline_data flag and encrypted
> > > > > > flag, so after it was deleted by rename(), during f2fs_evict_inode(),
> > > > > > it will cause inline data conversion due to flags confilction, then
> > > > > > page cache will be polluted and trigger panic in clear_inode().
> > > > > > 
> > > > > > This patch tries to fix the issue by do more sanity checks for inline
> > > > > > data inode in sanity_check_inode().
> > > > > > 
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Reported-by: Ming Yan <yanming@tju.edu.cn>
> > > > > > Signed-off-by: Chao Yu <chao.yu@oppo.com>
> > > > > > ---
> > > > > >     fs/f2fs/f2fs.h  | 7 +++++++
> > > > > >     fs/f2fs/inode.c | 3 +--
> > > > > >     2 files changed, 8 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > > > > > index 27aa93caec06..64c511b498cc 100644
> > > > > > --- a/fs/f2fs/f2fs.h
> > > > > > +++ b/fs/f2fs/f2fs.h
> > > > > > @@ -4173,6 +4173,13 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
> > > > > >      */
> > > > > >     static inline bool f2fs_post_read_required(struct inode *inode)
> > > > > >     {
> > > > > > +	/*
> > > > > > +	 * used by sanity_check_inode(), when disk layout fields has not
> > > > > > +	 * been synchronized to inmem fields.
> > > > > > +	 */
> > > > > > +	if (file_is_encrypt(inode) || file_is_verity(inode) ||
> > > > > > +			F2FS_I(inode)->i_flags & F2FS_COMPR_FL)
> > > > > > +		return true;
> > > > > >     	return f2fs_encrypted_file(inode) || fsverity_active(inode) ||
> > > > > >     		f2fs_compressed_file(inode);
> > > > > >     }
> > > > > > diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> > > > > > index 83639238a1fe..234b8ed02644 100644
> > > > > > --- a/fs/f2fs/inode.c
> > > > > > +++ b/fs/f2fs/inode.c
> > > > > > @@ -276,8 +276,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
> > > > > >     		}
> > > > > >     	}
> > > > > > -	if (f2fs_has_inline_data(inode) &&
> > > > > > -			(!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))) {
> > > > > > +	if (f2fs_has_inline_data(inode) && !f2fs_may_inline_data(inode)) {
> > > > > 
> > > > > It seems f2fs_may_inline_data() is breaking the atomic write case. Please fix.
> > > > 
> > > > sanity_check_inode() change only affect f2fs_iget(), during inode initialization,
> > > > file should not be set as atomic one, right?
> > > > 
> > > > I didn't see any failure during 'f2fs_io write atomic_write' testcase... could you
> > > > please provide me detail of the testcase?
> > > 
> > > I just applied this into my device and was getting lots of the below error
> > > messages resulting in open failures of database files.
> > 
> > Could you please help to apply below patch and dump the log?
> > 
> > From: Chao Yu <chao@kernel.org>
> > Subject: [PATCH] f2fs: fix to do sanity check for inline inode
> > 
> > Signed-off-by: Chao Yu <chao.yu@oppo.com>
> > ---
> >    fs/f2fs/f2fs.h  |  7 +++++++
> >    fs/f2fs/inode.c | 11 +++++++----
> >    2 files changed, 14 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 0f8c426aed50..13a9212d6cb6 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -4159,6 +4159,13 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
> >     */
> >    static inline bool f2fs_post_read_required(struct inode *inode)
> >    {
> > +	/*
> > +	 * used by sanity_check_inode(), when disk layout fields has not
> > +	 * been synchronized to inmem fields.
> > +	 */
> > +	if (file_is_encrypt(inode) || file_is_verity(inode) ||
> > +			F2FS_I(inode)->i_flags & F2FS_COMPR_FL)
> > +		return true;
> >    	return f2fs_encrypted_file(inode) || fsverity_active(inode) ||
> >    		f2fs_compressed_file(inode);
> >    }
> > diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> > index 02630c17da93..a98614a24ad0 100644
> > --- a/fs/f2fs/inode.c
> > +++ b/fs/f2fs/inode.c
> > @@ -276,11 +276,14 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
> >    		}
> >    	}
> > 
> > -	if (f2fs_has_inline_data(inode) &&
> > -			(!S_ISREG(inode->i_mode) && !S_ISLNK(inode->i_mode))) {
> > +	if (f2fs_has_inline_data(inode) && !f2fs_may_inline_data(inode)) {
> >    		set_sbi_flag(sbi, SBI_NEED_FSCK);
> > -		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
> > -			  __func__, inode->i_ino, inode->i_mode);
> > +		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) reason(%d, %llu, %ld, %d, %d, %lu) should not have inline_data, run fsck to fix",
> > +			  __func__, inode->i_ino, inode->i_mode,
> > +			  f2fs_is_atomic_file(inode),
> > +			  i_size_read(inode), MAX_INLINE_DATA(inode),
> > +			  file_is_encrypt(inode), file_is_verity(inode),
> > +			  F2FS_I(inode)->i_flags & F2FS_COMPR_FL);
> >    		return false;
> >    	}
> > 
