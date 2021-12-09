Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA7246EB69
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 16:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbhLIPj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 10:39:28 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41880 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239890AbhLIPj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 10:39:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 061A0CE267B;
        Thu,  9 Dec 2021 15:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88B3C341C7;
        Thu,  9 Dec 2021 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639064151;
        bh=m2ChWXdewRHPFFE7o78P74Le013n7Jn4c1fmlEjSVlw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QpwvVAao5+AmNh4bDjE7CCePHqWTfmguzsLv+U+MKQ8CJmOFaoyq4Ka9cDTBjWQPI
         f0V2aLmrtvWFwh8VM38swS8WeAYvszPlomLCSMlunDWMGQeBXTnV6x/qvq1ihrFssR
         GSPf85c1VDQ8a2OAV1uIHNaYJLwsHF+pasgvYVKU=
Date:   Thu, 9 Dec 2021 16:35:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc:     luca.stefani.ge1@gmail.com, akpm@linux-foundation.org,
        anton@tuxera.com, clang-built-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        michalechner92@googlemail.com, stable@vger.kernel.org,
        yj.chiang@mediatek.com
Subject: Re: [PATCH v2] ntfs: Fix ntfs_test_inode and ntfs_init_locked_inode
 function type
Message-ID: <YbIiVL404/Px0gXl@kroah.com>
References: <20200718112513.533800-1-luca.stefani.ge1@gmail.com>
 <20211209143839.31021-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209143839.31021-1-mark-pk.tsai@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 10:38:39PM +0800, Mark-PK Tsai wrote:
> > Clang's Control Flow Integrity (CFI) is a security mechanism that can
> > help prevent JOP chains, deployed extensively in downstream kernels
> > used in Android.
> > 
> > It's deployment is hindered by mismatches in function signatures.  For
> > this case, we make callbacks match their intended function signature,
> > and cast parameters within them rather than casting the callback when
> > passed as a parameter.
> > 
> > When running `mount -t ntfs ...` we observe the following trace:
> > 
> > Call trace:
> > __cfi_check_fail+0x1c/0x24
> > name_to_dev_t+0x0/0x404
> > iget5_locked+0x594/0x5e8
> > ntfs_fill_super+0xbfc/0x43ec
> > mount_bdev+0x30c/0x3cc
> > ntfs_mount+0x18/0x24
> > mount_fs+0x1b0/0x380
> > vfs_kern_mount+0x90/0x398
> > do_mount+0x5d8/0x1a10
> > SyS_mount+0x108/0x144
> > el0_svc_naked+0x34/0x38
> > 
> > Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
> > Tested-by: freak07 <michalechner92@googlemail.com>
> > Acked-by: Anton Altaparmakov <anton@tuxera.com>
> > ---
> >  fs/ntfs/dir.c   |  2 +-
> >  fs/ntfs/inode.c | 27 ++++++++++++++-------------
> >  fs/ntfs/inode.h |  4 +---
> >  fs/ntfs/mft.c   |  4 ++--
> >  4 files changed, 18 insertions(+), 19 deletions(-)
> > 
> 
> Hi,
> 
> I think stable tree should pick this change.
> 
> Below is the mainline commit.
> 
> (1146f7e2dc15 ntfs: fix ntfs_test_inode and ntfs_init_locked_inode function type)
> 
> 5.4 stable have the same issue when CFI is enabled.

Now queued up, thanks.

greg k-h
