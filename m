Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB575401869
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 10:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241139AbhIFI53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 04:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhIFI5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 04:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7272608FB;
        Mon,  6 Sep 2021 08:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630918576;
        bh=jrjn+jw7/mnR3MpUT0FQrZ/o2VRBStEospRq9n0RZew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K1zGDVrdu2E5h5e4aJkwLS3Xe5mw7X2xZxae1DE+LG/09uTT5BB08GfJH3U5dlJhm
         HOeduuvoCSXvbiZ1ZfzbLwGXac/2WXZYiyXcyDuKm3cxNKgqZNebZ1HxZH2LmeNNgU
         Hk+GopGfprnZuGTuIPiF4wqewrGEdis8b21qvuWY=
Date:   Mon, 6 Sep 2021 10:56:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Nikolaus Rath <Nikolaus@rath.org>,
        Vivek Goyal <vgoyal@redhat.com>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 5.10 2/2] fuse: fix illegal access to inode with reused
 nodeid
Message-ID: <YTXXres1sfX/MrOT@kroah.com>
References: <20210905070833.201102-1-amir73il@gmail.com>
 <20210905070833.201102-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905070833.201102-2-amir73il@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 05, 2021 at 10:08:33AM +0300, Amir Goldstein wrote:
> [ Upstream commit 15db16837a35d8007cb8563358787412213db25e ]
> 
> Server responds to LOOKUP and other ops (READDIRPLUS/CREATE/MKNOD/...)
> with ourarg containing nodeid and generation.
> 
> If a fuse inode is found in inode cache with the same nodeid but different
> generation, the existing fuse inode should be unhashed and marked "bad" and
> a new inode with the new generation should be hashed instead.
> 
> This can happen, for example, with passhrough fuse filesystem that returns
> the real filesystem ino/generation on lookup and where real inode numbers
> can get recycled due to real files being unlinked not via the fuse
> passthrough filesystem.
> 
> With current code, this situation will not be detected and an old fuse
> dentry that used to point to an older generation real inode, can be used to
> access a completely new inode, which should be accessed only via the new
> dentry.
> 
> Note that because the FORGET message carries the nodeid w/o generation, the
> server should wait to get FORGET counts for the nlookup counts of the old
> and reused inodes combined, before it can free the resources associated to
> that nodeid.
> 
> Stable backport notes:
> * This is not a regression. The bug has been in fuse forever, but only
>   a certain class of low level fuse filesystems can trigger this bug
> * Because there is no way to check if this fix is applied in runtime,
>   libfuse test_examples.py tests this fix with hardcoded check for
>   kernel version >= 5.14
> * After backport to stable kernel(s), the libfuse test can be updated
>   to also check minimal stable kernel version(s)
> * Depends on "fuse: fix bad inode" which is already applied to stable
>   kernels v5.4.y and v5.10.y
> * Required backporting helper inode_wrong_type()

All now queued up, thanks!

greg k-h
