Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDFD1192EF
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfEITbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfEITbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 15:31:38 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7840421479;
        Thu,  9 May 2019 19:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557430297;
        bh=ZynyW32bDUdUrDIoqDCTYDwsCjwFtbayESpBp+uqyhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tsEQE61vdmJ/3zjUtI54cnuT/4smE+9IuMCstP9kRMVEZMdqjmU/nthvTSvPPtzhh
         gYf7mrsjGMZSZJZ/ewnF6najz+0VgS6RNa2DFRoTiF2I2nzSJ3WzCu2F21p4vHdLoW
         6hT0eOdjq0dHI8xQcqmWnDCj3zIenH/waA2BwuKM=
Date:   Thu, 9 May 2019 12:31:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     hongjiefang <hongjiefang@asrmicro.com>
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] fscrypt: don't set policy for a dead directory
Message-ID: <20190509193135.GB42815@gmail.com>
References: <1557307654-673-1-git-send-email-hongjiefang@asrmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557307654-673-1-git-send-email-hongjiefang@asrmicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 05:27:34PM +0800, hongjiefang wrote:
> the directory maybe has been removed when enter fscrypt_ioctl_set_policy().
> it this case, the empty_dir() check will return error for ext4 file system.
> 
> ext4_rmdir() sets i_size = 0, then ext4_empty_dir() reports an error
> because 'inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)'.
> if the fs is mounted with errors=panic, it will trigger a panic issue.
> 
> add the check IS_DEADDIR() to fix this problem.
> 
> Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> Cc: <stable@vger.kernel.org> # v4.1+
> Signed-off-by: hongjiefang <hongjiefang@asrmicro.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>

FYI, the part of the Author and Signed-off-by lines outside the email address
should be your name properly formatted, not the email address again.  I see the
following in another kernel commit from you; is it correct?

	Hongjie Fang <hongjiefang@asrmicro.com>

If so, please set user.name accordingly in your .gitconfig.  Thanks!

- Eric

> ---
>  fs/crypto/policy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index bd7eaf9..a4eca6e 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -81,6 +81,8 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
>  	if (ret == -ENODATA) {
>  		if (!S_ISDIR(inode->i_mode))
>  			ret = -ENOTDIR;
> +		else if (IS_DEADDIR(inode))
> +			ret = -ENOENT;
>  		else if (!inode->i_sb->s_cop->empty_dir(inode))
>  			ret = -ENOTEMPTY;
>  		else
> -- 
> 1.9.1
> 
