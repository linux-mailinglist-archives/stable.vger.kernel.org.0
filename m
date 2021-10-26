Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036DC43ABD5
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 07:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhJZFsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 01:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhJZFsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 01:48:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD1060E05;
        Tue, 26 Oct 2021 05:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635227154;
        bh=TIjVkFEWJB7q7GF6lS61TRk3nmEo51a0DU9X6QcW9hY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KhbpyYsNXErwr2o99+8NA/bqELaVNukCD+dHr4vMMMnSZ9mSAgrON3mR5Vwt4UOJx
         V+hL5MeobyUOoRdjGF9LCqyFjkrRhXsatzF6HUrmKMEEIQnY8ZZFi2oJduqYOothtA
         LFAw0L4KGWtt9o3cuk0IpVlpj0OR4rNqQVc/bEQc=
Date:   Tue, 26 Oct 2021 07:45:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "chenxiaosong (A)" <chenxiaosong2@huawei.com>
Cc:     viro@zeniv.linux.org.uk, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, yukuai3@huawei.com, yi.zhang@huawei.com,
        zhangxiaoxu5@huawei.com
Subject: Re: [PATCH 4.19,v2] VFS: Fix fuseblk memory leak caused by mount
 concurrency
Message-ID: <YXeWDSLo4+MuOg4+@kroah.com>
References: <20211013095101.641329-1-chenxiaosong2@huawei.com>
 <YWawy0J9JfStEku0@kroah.com>
 <429d87b0-3a53-052a-a304-0afa8d51900d@huawei.com>
 <860c36c4-3668-1388-66d1-a07d463c2ad9@huawei.com>
 <YXAL7K88XGWXckWe@kroah.com>
 <209361bb-9e15-ebaf-2ff8-5846d5bfbbc2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <209361bb-9e15-ebaf-2ff8-5846d5bfbbc2@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 10:18:11AM +0800, chenxiaosong (A) wrote:
> 
> 
> 在 2021/10/20 20:30, Greg KH 写道:
> > On Wed, Oct 13, 2021 at 06:49:06PM +0800, chenxiaosong (A) wrote:
> > > 在 2021/10/13 18:38, chenxiaosong (A) 写道:
> > > > 在 2021/10/13 18:11, Greg KH 写道:
> > > > > On Wed, Oct 13, 2021 at 05:51:01PM +0800, ChenXiaoSong wrote:
> > > > > > If two processes mount same superblock, memory leak occurs:
> > > > > > 
> > > > > > CPU0               |  CPU1
> > > > > > do_new_mount       |  do_new_mount
> > > > > >     fs_set_subtype   |    fs_set_subtype
> > > > > >       kstrdup        |
> > > > > >                      |      kstrdup
> > > > > >       memrory leak   |
> > > > > > 
> > > > > > Fix this by adding a write lock while calling fs_set_subtype.
> > > > > > 
> > > > > > Linus's tree already have refactoring patchset [1], one of them
> > > > > > can fix this bug:
> > > > > >           c30da2e981a7 (fuse: convert to use the new mount API)
> > > > > > 
> > > > > > Since we did not merge the refactoring patchset in this branch,
> > > > > > I create this patch.
> > > > > > 
> > > > > > [1] https://patchwork.kernel.org/project/linux-fsdevel/patch/20190903113640.7984-3-mszeredi@redhat.com/
> > > > > > 
> > > > > > 
> > > > > > Fixes: 79c0b2df79eb (add filesystem subtype support)
> > > > > > Cc: David Howells <dhowells@redhat.com>
> > > > > > Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
> > > > > > ---
> > > > > > v1: Can not mount sshfs ([PATCH linux-4.19.y] VFS: Fix fuseblk
> > > > > > memory leak caused by mount concurrency)
> > > > > > v2: Use write lock while writing superblock
> > > > > > 
> > > > > >    fs/namespace.c | 9 ++++++---
> > > > > >    1 file changed, 6 insertions(+), 3 deletions(-)
> > > > > 
> > > > > As you are referring to a fuse-only patch above, why are you trying to
> > > > > resolve this issue in the core namespace code instead?
> > > > > 
> > > > > How does fuse have anything to do with this?
> > > > > 
> > > > > confused,
> > > > > 
> > > > > greg k-h
> > > > > .
> > > > > 
> > > > 
> > > > Now, only `fuse_fs_type` and `fuseblk_fs_type` has `FS_HAS_SUBTYPE` flag
> > > > in kernel code, but maybe there is a filesystem module(`struct
> > > > file_system_type` has `FS_HAS_SUBTYPE` flag). And only mounting fuseblk
> > > > filesystem(e.g. ntfs) will occur memory leak now.
> > > 
> > > How about updating the subject as: VFS: Fix memory leak caused by mounting
> > > fs with subtype concurrency?
> > 
> > That would be a better idea, but still, this is not obvious that this is
> > the correct fix at all...
> > .
> > 
> Why is this patch not correct? Can you tell me more about it? Thanks.

You need to prove that it is correct, and you need to get maintainers to
approve it.

thanks,

greg k-h
