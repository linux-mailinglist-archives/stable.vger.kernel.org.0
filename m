Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DB11D59C0
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 21:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgEOTOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 15:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgEOTOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 15:14:17 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D9A420727;
        Fri, 15 May 2020 19:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589570057;
        bh=U7+OMuFXR/wq18HNvqccFPF/InNFiHHmpdGzaBnusqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ifb4fJo3Dl+eLlVApJmTNfbDilmqheqSqzn2qUyYk0f8iP4mAG4OZcfV9GHMQy5RJ
         L+mLGksUiX1OMEzS8/grcZFB2qAiZa4SWCzkuXpjibyXjBzPfCG7iLVSYe01k0RDYB
         dWfRVeZylqOt9OUuuluTbnndrgZDAWAzx1fjPfuI=
Date:   Fri, 15 May 2020 12:14:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix race between ext4_sync_parent() and rename()
Message-ID: <20200515191415.GC1009@sol.localdomain>
References: <20200506183140.541194-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506183140.541194-1-ebiggers@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 06, 2020 at 11:31:40AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> 'igrab(d_inode(dentry->d_parent))' without holding dentry->d_lock is
> broken because without d_lock, d_parent can be concurrently changed due
> to a rename().  Then if the old directory is immediately deleted, old
> d_parent->inode can be NULL.  That causes a NULL dereference in igrab().
> 
> To fix this, use dget_parent() to safely grab a reference to the parent
> dentry, which pins the inode.  This also eliminates the need to use
> d_find_any_alias() other than for the initial inode, as we no longer
> throw away the dentry at each step.
> 
> This is an extremely hard race to hit, but it is possible.  Adding a
> udelay() in between the reads of ->d_parent and its ->d_inode makes it
> reproducible on a no-journal filesystem using the following program:
> 
>     #include <fcntl.h>
>     #include <unistd.h>
> 
>     int main()
>     {
>         if (fork()) {
>             for (;;) {
>                 mkdir("dir1", 0700);
>                 int fd = open("dir1/file", O_RDWR|O_CREAT|O_SYNC);
>                 write(fd, "X", 1);
>                 close(fd);
>             }
>         } else {
>             mkdir("dir2", 0700);
>             for (;;) {
>                 rename("dir1/file", "dir2/file");
>                 rmdir("dir1");
>             }
>         }
>     }
> 
> Fixes: d59729f4e794 ("ext4: fix races in ext4_sync_parent()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>


Any comments on this patch?

- Eric
