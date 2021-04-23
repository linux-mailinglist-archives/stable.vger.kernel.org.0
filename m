Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2781369236
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 14:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhDWMfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 08:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhDWMfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 08:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FE0661459;
        Fri, 23 Apr 2021 12:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619181300;
        bh=w2d/19rqjOcEL2bFjXgcoHhpZBqK0MkDYLGo+da2pgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ywVwuACMI7MM1Hu5LEEkFEcvKxSOQ693QhlckzPKZn52UY7uTqLrYMfEwGiahnCjN
         pRI2YQRPZoOxxMOUTkEOpjCT56luij/D7PEf8mNMWb8hY/HcuTwRLpmKKw7TuzDL3a
         12npk1rARab2R0MKtruC4jBxpZ6+Ixx8s6oFGSho=
Date:   Fri, 23 Apr 2021 14:34:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     stable@vger.kernel.org, tytso@mit.edu, sashal@kernel.org
Subject: Re: [PATCH 4.4] ext4: correct error label in ext4_rename()
Message-ID: <YIK+8SHbx+LcBdJy@kroah.com>
References: <20210423123507.1936208-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423123507.1936208-1-yi.zhang@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 08:35:07PM +0800, Zhang Yi wrote:
> The backport of upstream patch 5dccdc5a1916 ("ext4: do not iput inode
> under running transaction in ext4_rename()") introduced a regression on
> the stable kernels 4.14 and older. One of the end_rename error label was
> forgetting to change to release_bh, which may trigger below bug.
> 
>  ------------[ cut here ]------------
>  kernel BUG at /home/zhangyi/hulk-4.4/fs/ext4/ext4_jbd2.c:30!
>  ...
>  Call Trace:
>   [<ffffffff8b4207b2>] ext4_rename+0x9e2/0x10c0
>   [<ffffffff8b331324>] ? unlazy_walk+0x124/0x2a0
>   [<ffffffff8b420eb5>] ext4_rename2+0x25/0x60
>   [<ffffffff8b335104>] vfs_rename+0x3a4/0xed0
>   [<ffffffff8b33a7ad>] SYSC_renameat2+0x57d/0x7f0
>   [<ffffffff8b33c119>] SyS_renameat+0x19/0x30
>   [<ffffffff8bc57bb8>] entry_SYSCALL_64_fastpath+0x18/0x78
>  ...
>  ---[ end trace 75346ce7c76b9f06 ]---
> 
> Fixes: 2fc8ce56985d ("ext4: do not iput inode under running transaction in ext4_rename()")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index f22fcb393684..8cd2a7e1eef1 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3561,7 +3561,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	    !ext4_is_child_context_consistent_with_parent(new.dir,
>  							  old.inode)) {
>  		retval = -EXDEV;
> -		goto end_rename;
> +		goto release_bh;
>  	}
>  
>  	new.bh = ext4_find_entry(new.dir, &new.dentry->d_name,
> -- 
> 2.25.4
> 

So should this also go to 4.14.y and 4.9.y?

thanks,

greg k-h
