Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9F242BB5E
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 11:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbhJMJVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 05:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230150AbhJMJVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 05:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D791160F4A;
        Wed, 13 Oct 2021 09:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634116787;
        bh=l66dDBdToCsFG+DSqfRDAIdvASVaqUh/dsuUSy/Iq4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r9LEegT24h7LPrzrWEzr7sLVamqro8PNR8moO0aj1iWJ1g47yrj9HuJuxTJkeWye5
         VC2AKqA9sJBb8AloXVx5RAc3VBDYTMkF92MuyRFAEB/rmCdsw6ZA70ebElwQtDVsHu
         3Yil+Pj1hLeoWsXDfdLmP3amLgBU7aCseF583vsY=
Date:   Wed, 13 Oct 2021 11:19:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ChenXiaoSong <chenxiaosong2@huawei.com>
Cc:     viro@zeniv.linux.org.uk, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, yukuai3@huawei.com, yi.zhang@huawei.com,
        zhangxiaoxu5@huawei.com
Subject: Re: [PATCH 4.19] VFS: Fix fuseblk memory leak caused by mount
 concurrency
Message-ID: <YWaksarpG4/PtMN9@kroah.com>
References: <20211013092117.639147-1-chenxiaosong2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013092117.639147-1-chenxiaosong2@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 05:21:17PM +0800, ChenXiaoSong wrote:
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
>  fs/namespace.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Is this a v2 patch?  If so, you need to list below the --- line what
changed.

thanks,

greg k-h
