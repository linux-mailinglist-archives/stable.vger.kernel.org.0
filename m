Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCF0434B27
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 14:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJTMcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 08:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230077AbhJTMcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 08:32:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CF9161355;
        Wed, 20 Oct 2021 12:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634733039;
        bh=LiE/hWTQ5V9XEhRPLyQB9qsB24jCZaZMytc4IqnfsIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VJhmUgvdf+nNfJtaQ+tmvYAjNLeMkWcdVOxSKh5qHfBm/3xFLe3Uy8u9rFnO6OGFU
         3Kldf8yXiJejx01qVBeV3oBR6bWGG+1vvMlpnXkVFRWod9iX2+D+oY6d0TqGTD5XT4
         zFgkBshnc8Rn2Xaq37sfD77eMRxzl8cf3ye92eZs=
Date:   Wed, 20 Oct 2021 14:30:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "chenxiaosong (A)" <chenxiaosong2@huawei.com>
Cc:     viro@zeniv.linux.org.uk, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, yukuai3@huawei.com, yi.zhang@huawei.com,
        zhangxiaoxu5@huawei.com
Subject: Re: [PATCH 4.19,v2] VFS: Fix fuseblk memory leak caused by mount
 concurrency
Message-ID: <YXAL7K88XGWXckWe@kroah.com>
References: <20211013095101.641329-1-chenxiaosong2@huawei.com>
 <YWawy0J9JfStEku0@kroah.com>
 <429d87b0-3a53-052a-a304-0afa8d51900d@huawei.com>
 <860c36c4-3668-1388-66d1-a07d463c2ad9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <860c36c4-3668-1388-66d1-a07d463c2ad9@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 06:49:06PM +0800, chenxiaosong (A) wrote:
> 在 2021/10/13 18:38, chenxiaosong (A) 写道:
> > 在 2021/10/13 18:11, Greg KH 写道:
> > > On Wed, Oct 13, 2021 at 05:51:01PM +0800, ChenXiaoSong wrote:
> > > > If two processes mount same superblock, memory leak occurs:
> > > > 
> > > > CPU0               |  CPU1
> > > > do_new_mount       |  do_new_mount
> > > >    fs_set_subtype   |    fs_set_subtype
> > > >      kstrdup        |
> > > >                     |      kstrdup
> > > >      memrory leak   |
> > > > 
> > > > Fix this by adding a write lock while calling fs_set_subtype.
> > > > 
> > > > Linus's tree already have refactoring patchset [1], one of them
> > > > can fix this bug:
> > > >          c30da2e981a7 (fuse: convert to use the new mount API)
> > > > 
> > > > Since we did not merge the refactoring patchset in this branch,
> > > > I create this patch.
> > > > 
> > > > [1] https://patchwork.kernel.org/project/linux-fsdevel/patch/20190903113640.7984-3-mszeredi@redhat.com/
> > > > 
> > > > 
> > > > Fixes: 79c0b2df79eb (add filesystem subtype support)
> > > > Cc: David Howells <dhowells@redhat.com>
> > > > Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
> > > > ---
> > > > v1: Can not mount sshfs ([PATCH linux-4.19.y] VFS: Fix fuseblk
> > > > memory leak caused by mount concurrency)
> > > > v2: Use write lock while writing superblock
> > > > 
> > > >   fs/namespace.c | 9 ++++++---
> > > >   1 file changed, 6 insertions(+), 3 deletions(-)
> > > 
> > > As you are referring to a fuse-only patch above, why are you trying to
> > > resolve this issue in the core namespace code instead?
> > > 
> > > How does fuse have anything to do with this?
> > > 
> > > confused,
> > > 
> > > greg k-h
> > > .
> > > 
> > 
> > Now, only `fuse_fs_type` and `fuseblk_fs_type` has `FS_HAS_SUBTYPE` flag
> > in kernel code, but maybe there is a filesystem module(`struct
> > file_system_type` has `FS_HAS_SUBTYPE` flag). And only mounting fuseblk
> > filesystem(e.g. ntfs) will occur memory leak now.
> 
> How about updating the subject as: VFS: Fix memory leak caused by mounting
> fs with subtype concurrency?

That would be a better idea, but still, this is not obvious that this is
the correct fix at all...
