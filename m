Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074FD42BC82
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 12:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbhJMKN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 06:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhJMKN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 06:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EED061077;
        Wed, 13 Oct 2021 10:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634119885;
        bh=nfULThVsL8PZi2EK7lNA9LOGPPun9HsOuXuidX4x624=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VwNLqnVTAmlp9DN94XpAzhi3BZMEhLGfk4Z8roBXXp9tHX16hSy9epXZqNLfJqnpp
         GoR7gRXnFnGk4JdCYGtKm/X2JfGxRRgTo1gasAkdf9w+b+466f62YSoziYSgk5oQq6
         wGx4HjrA0CpcuPMzOHD9IloW4d2DqSGrEoUukBkc=
Date:   Wed, 13 Oct 2021 12:11:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ChenXiaoSong <chenxiaosong2@huawei.com>
Cc:     viro@zeniv.linux.org.uk, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, yukuai3@huawei.com, yi.zhang@huawei.com,
        zhangxiaoxu5@huawei.com
Subject: Re: [PATCH 4.19,v2] VFS: Fix fuseblk memory leak caused by mount
 concurrency
Message-ID: <YWawy0J9JfStEku0@kroah.com>
References: <20211013095101.641329-1-chenxiaosong2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013095101.641329-1-chenxiaosong2@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 05:51:01PM +0800, ChenXiaoSong wrote:
> If two processes mount same superblock, memory leak occurs:
> 
> CPU0               |  CPU1
> do_new_mount       |  do_new_mount
>   fs_set_subtype   |    fs_set_subtype
>     kstrdup        |
>                    |      kstrdup
>     memrory leak   |
> 
> Fix this by adding a write lock while calling fs_set_subtype.
> 
> Linus's tree already have refactoring patchset [1], one of them can fix this bug:
>         c30da2e981a7 (fuse: convert to use the new mount API)
> 
> Since we did not merge the refactoring patchset in this branch, I create this patch.
> 
> [1] https://patchwork.kernel.org/project/linux-fsdevel/patch/20190903113640.7984-3-mszeredi@redhat.com/
> 
> Fixes: 79c0b2df79eb (add filesystem subtype support)
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
> ---
> v1: Can not mount sshfs ([PATCH linux-4.19.y] VFS: Fix fuseblk memory leak caused by mount concurrency)
> v2: Use write lock while writing superblock
> 
>  fs/namespace.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

As you are referring to a fuse-only patch above, why are you trying to
resolve this issue in the core namespace code instead?

How does fuse have anything to do with this?

confused,

greg k-h
