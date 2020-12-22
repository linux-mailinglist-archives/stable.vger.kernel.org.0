Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BAC2E0745
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 09:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLVIhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 03:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgLVIhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 03:37:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 384A52311D;
        Tue, 22 Dec 2020 08:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608626199;
        bh=48rJQnmzqEftD1VjzzcfOsmUsVzxjgaTphPkyo+ScK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UCt/ESzr00Qj3/ivG8OTZmyqduOFyjavQMtaBNVP0PbrerWkBoYiEdmENUj8z3Ca7
         nPy251WplpYANInMY6PVt+rUsp9ZTttrI1D3GP04qXcNj/V3DfELeTjnnO4X1KDhio
         7q4LUba3FxgEPUHIBQadwXAgFm/S6xvK4Mxrn5NU=
Date:   Tue, 22 Dec 2020 09:36:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        chao@kernel.org, jaegeuk@kernel.org,
        kitestramuort <kitestramuort@autistici.org>
Subject: Re: [PATCH 5.10.y] f2fs: fix to seek incorrect data offset in inline
 data file
Message-ID: <X+GwEz8NTepCKEFX@kroah.com>
References: <20201222011634.124180-1-yuchao0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222011634.124180-1-yuchao0@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 09:16:34AM +0800, Chao Yu wrote:
> As kitestramuort reported:
> 
> F2FS-fs (nvme0n1p4): access invalid blkaddr:1598541474
> [   25.725898] ------------[ cut here ]------------
> [   25.725903] WARNING: CPU: 6 PID: 2018 at f2fs_is_valid_blkaddr+0x23a/0x250
> [   25.725923] Call Trace:
> [   25.725927]  ? f2fs_llseek+0x204/0x620
> [   25.725929]  ? ovl_copy_up_data+0x14f/0x200
> [   25.725931]  ? ovl_copy_up_inode+0x174/0x1e0
> [   25.725933]  ? ovl_copy_up_one+0xa22/0xdf0
> [   25.725936]  ? ovl_copy_up_flags+0xa6/0xf0
> [   25.725938]  ? ovl_aio_cleanup_handler+0xd0/0xd0
> [   25.725939]  ? ovl_maybe_copy_up+0x86/0xa0
> [   25.725941]  ? ovl_open+0x22/0x80
> [   25.725943]  ? do_dentry_open+0x136/0x350
> [   25.725945]  ? path_openat+0xb7e/0xf40
> [   25.725947]  ? __check_sticky+0x40/0x40
> [   25.725948]  ? do_filp_open+0x70/0x100
> [   25.725950]  ? __check_sticky+0x40/0x40
> [   25.725951]  ? __check_sticky+0x40/0x40
> [   25.725953]  ? __x64_sys_openat+0x1db/0x2c0
> [   25.725955]  ? do_syscall_64+0x2d/0x40
> [   25.725957]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> llseek() reports invalid block address access, the root cause is if
> file has inline data, f2fs_seek_block() will access inline data regard
> as block address index in inode block, which should be wrong, fix it.
> 
> Fixes: 788e96d1d3994 ("f2fs: code cleanup by removing unnecessary check")
> Fixes: 267378d4de69 ("f2fs: introduce f2fs_seek_block to support SEEK_{DATA, HOLE} in llseek")
> Cc: stable <stable@vger.kernel.org> # 3.16+
> Reported-by: kitestramuort <kitestramuort@autistici.org>
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
> 
> This will cause boot failure in f2fs image, which was reported in gentoo
> community, I'd like to fix them in stable kernel 5.10 first as request in
> bugzilla:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=210825

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
