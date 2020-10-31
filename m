Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DD12A1A66
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 21:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgJaUE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 16:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:32898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgJaUE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 16:04:56 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53DE9206F7;
        Sat, 31 Oct 2020 20:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604174696;
        bh=FyVEfoAcUcTxrvhSxANkxkD7tnNZuVOiijmKvVEGQns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhLQnNsKwQLpyTPHhEfFMobk2XL2bL2fndIljpa1SRIaBCxCdQAXciCHfvV6UZXE5
         fkZMAFvCWFcO0eh9/gUr/AybzB+ZHYKNSsQYSBjDwpB9pXfI3zlpTpQSWEJNJ1kfKb
         3uHf52vN0oJqxvQfgdOzmRLEhs8Ofb3kFWRihkDM=
Date:   Sat, 31 Oct 2020 13:04:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 010/149] f2fs: check memory boundary by insane namelen
Message-ID: <20201031200454.GB936@sol.localdomain>
References: <20200820092125.688850368@linuxfoundation.org>
 <20200820092126.196020416@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820092126.196020416@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:21:27AM +0200, Greg Kroah-Hartman wrote:
> From: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> [ Upstream commit 4e240d1bab1ead280ddf5eb05058dba6bbd57d10 ]
> 
> If namelen is corrupted to have very long value, fill_dentries can copy
> wrong memory area.
> 
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/f2fs/dir.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 92a240616f520..5411d6667781f 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -805,6 +805,16 @@ bool f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
>  		de_name.name = d->filename[bit_pos];
>  		de_name.len = le16_to_cpu(de->name_len);
>  
> +		/* check memory boundary before moving forward */
> +		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
> +		if (unlikely(bit_pos > d->max)) {
> +			f2fs_msg(F2FS_I_SB(d->inode)->sb, KERN_WARNING,
> +				"%s: corrupted namelen=%d, run fsck to fix.",
> +				__func__, le16_to_cpu(de->name_len));
> +			set_sbi_flag(F2FS_I_SB(d->inode)->sb->s_fs_info, SBI_NEED_FSCK);
> +			return -EINVAL;
> +		}
> +
>  		if (f2fs_encrypted_inode(d->inode)) {
>  			int save_len = fstr->len;
>  			int ret;
> @@ -829,7 +839,6 @@ bool f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
>  					le32_to_cpu(de->ino), d_type))
>  			return true;
>  
> -		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
>  		ctx->pos = start_pos + bit_pos;

This buggy backport broke f2fs encryption in 4.4-stable, due to a missing
prerequisite commit
(https://lkml.kernel.org/stable/20201031195809.377983-1-ebiggers@kernel.org/).
Why didn't this backport get Cc'ed to the subsystem mailing list?  It wasn't
even a clean cherry pick.

- Eric
