Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE32E67B
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 22:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfE2Uuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 16:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfE2Uuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 16:50:32 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD9E9241A4;
        Wed, 29 May 2019 20:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559163031;
        bh=cnGL/rCeGGyY5cst0qXNsS563p1Dypp4JsR/g/4Wrzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Db9aczmf1UvSPUz9Upb3k4j+mhEvIsGGkDg07Wq8/9DAClfMBjQv1bMIr/xdSudKG
         IvcTmvrLbMEvVZ72AgkBeOl/clBiSag+WEj5vi57eBoVFEGG7CxQEOYOBeJ4AVzpi4
         wUOlQTEztnyhNDa5lPQn1kLj3v6qza8wdPOKlzUo=
Date:   Wed, 29 May 2019 13:50:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hongjie Fang <hongjiefang@asrmicro.com>
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V3] fscrypt: don't set policy for a dead directory
Message-ID: <20190529205028.GC141639@gmail.com>
References: <1558490573-21562-1-git-send-email-hongjiefang@asrmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558490573-21562-1-git-send-email-hongjiefang@asrmicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 10:02:53AM +0800, Hongjie Fang wrote:
> the directory maybe has been removed when enter fscrypt_ioctl_set_policy().
> if so, the empty_dir() check will return error for ext4 file system.
> 
> ext4_rmdir() sets i_size = 0, then ext4_empty_dir() reports an error
> because 'inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)'.
> if the fs is mounted with errors=panic, it will trigger a panic issue.
> 
> add the check IS_DEADDIR() to fix this problem.
> 
> Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> Cc: <stable@vger.kernel.org> # v4.1+
> Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
> ---
>  fs/crypto/policy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index d536889..4941fe8 100644
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

Applied to fscrypt.git for v5.3.

- Eric
