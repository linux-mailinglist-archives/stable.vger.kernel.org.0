Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC91E4388B1
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhJXLwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28B6A6101D;
        Sun, 24 Oct 2021 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635076214;
        bh=8NlTWoFqHgpCEgtVjpBL+Fw1T6s3kpWZciV5FsjGH3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AbWmGEtvP4usumpbkjAK466ph7vPvAtEwjiNprcGb7Ml878iMDvC0Xw+83IqW5U5r
         +6fVf2urvNTwkLUf5HCgE7QNRMZeYnj9s4pxkxVsPGLJmKLm08IkYluzSa0NWNkzPF
         ckXzt36mxWCkgVrxStmmj30lISeyDmUtJocTSr2I=
Date:   Sun, 24 Oct 2021 13:50:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Masami Ichikawa(CIP)" <masami256@gmail.com>
Cc:     mszeredi@redhat.com, stable@vger.kernel.org,
        zhengliang6@huawei.com,
        Masami Ichikawa <masami.ichikawa@cybertrust.co.jp>
Subject: Re: [PATCH] ovl: fix missing negative dentry check in ovl_rename()
Message-ID: <YXVIcqyzNCvwDO5/@kroah.com>
References: <163378772914820@kroah.com>
 <20211022001605.22814-1-masami.ichikawa@cybertrust.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022001605.22814-1-masami.ichikawa@cybertrust.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 22, 2021 at 09:16:05AM +0900, Masami Ichikawa(CIP) wrote:
> From: Zheng Liang <zhengliang6@huawei.com>
> 
> From: Zheng Liang <zhengliang6@huawei.com>
> 
> commit a295aef603e109a47af355477326bd41151765b6 upstream.
> 
> The following reproducer
> 
>   mkdir lower upper work merge
>   touch lower/old
>   touch lower/new
>   mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merge
>   rm merge/new
>   mv merge/old merge/new & unlink upper/new
> 
> may result in this race:
> 
> PROCESS A:
>   rename("merge/old", "merge/new");
>   overwrite=true,ovl_lower_positive(old)=true,
>   ovl_dentry_is_whiteout(new)=true -> flags |= RENAME_EXCHANGE
> 
> PROCESS B:
>   unlink("upper/new");
> 
> PROCESS A:
>   lookup newdentry in new_upperdir
>   call vfs_rename() with negative newdentry and RENAME_EXCHANGE
> 
> Fix by adding the missing check for negative newdentry.
> 
> Signed-off-by: Zheng Liang <zhengliang6@huawei.com>
> Fixes: e9be9d5e76e3 ("overlay filesystem")
> Cc: <stable@vger.kernel.org> # v3.18
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Reference: CVE-2021-20321
> Signed-off-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>
> ---
>  fs/overlayfs/dir.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index eedacae889b9..80bf0ab52e81 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -824,9 +824,13 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
>  		}
>  	} else {
>  		new_create = true;
> -		if (!d_is_negative(newdentry) &&
> -		    (!new_opaque || !ovl_is_whiteout(newdentry)))
> -			goto out_dput;
> +		if (!d_is_negative(newdentry)) {
> +			if (!new_opaque || !ovl_is_whiteout(newdentry))
> +				goto out_dput;
> +		} else {
> +			if (flags & RENAME_EXCHANGE)
> +				goto out_dput;
> +		}
>  	}
>  
>  	if (olddentry == trap)
> -- 
> 2.33.0
> 

Now queued up for 4.4.y, thanks!

greg k-h
