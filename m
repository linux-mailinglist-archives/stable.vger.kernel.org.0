Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE63A32922B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbhCAUkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238841AbhCAUdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E4F600CD;
        Mon,  1 Mar 2021 18:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614623903;
        bh=Usbgf4w4CPwBJdAjaGObAuklNlbhEtgzWAuSXxvNqgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=obsfa9+0yM6DvT1kTXIRM5rKh8CcWoX43yimFP0IlRq+LyKkYiL9M2JNgTaLjLEVZ
         18y0rhqlPVg/1DtvJyf7EeKE9rE/saw4DKvNu80w4Cj/waJDGWApp/dWutCttmlgKs
         cdSZzZ/YGQ4EdXE/wz/d8CdZXMaULJOENUaaJop5DpThBiP2W8FZdSXOgzPM6QOlHR
         O5ICtni2GaGBT+1awZKJhx2MNMR1fFkS0fh07vcTPykC8B3pTjqnqiwZqzHNHKxTCm
         j5IUx+9Q6IgQhoEnPghrM2w1fAjKlNpN5uTXUoYWvMW0YfwaiiMsTcGTwkLyQJIXFX
         bf4J9BEDlBTGQ==
Date:   Mon, 1 Mar 2021 10:38:21 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Yunlei He <heyunlei@hihonor.com>
Cc:     chao@kernel.org, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, bintian.wang@hihonor.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] f2fs: fsverity: Truncate cache pages if set verity
 failed
Message-ID: <YD00nfInJqE/UlxM@gmail.com>
References: <20210301141506.6410-1-heyunlei@hihonor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301141506.6410-1-heyunlei@hihonor.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 10:15:06PM +0800, Yunlei He wrote:
> If file enable verity failed, should truncate anything wrote
> past i_size, including cache pages.

The commit message and title need to be updated to properly describe the change.
They were okay for v1, but v2 makes additional changes.

> 
> Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Yunlei He <heyunlei@hihonor.com>
> ---
>  fs/f2fs/verity.c | 47 +++++++++++++++++++++++++----------------------
>  1 file changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> index 054ec852b5ea..3aa851affc46 100644
> --- a/fs/f2fs/verity.c
> +++ b/fs/f2fs/verity.c
> @@ -158,33 +158,36 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
>  		.size = cpu_to_le32(desc_size),
>  		.pos = cpu_to_le64(desc_pos),
>  	};
> -	int err = 0;
> +	int err;
>  
> -	if (desc != NULL) {
> -		/* Succeeded; write the verity descriptor. */
> -		err = pagecache_write(inode, desc, desc_size, desc_pos);
> +	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
> +	if (!desc)
> +		return 0;

This isn't correct.  If desc == NULL (indicating that enabling verity failed),
it's still necessary to truncate the stuff past i_size.

>  
> -		/* Write all pages before clearing FI_VERITY_IN_PROGRESS. */
> -		if (!err)
> -			err = filemap_write_and_wait(inode->i_mapping);

As the comment above (which you deleted) says, all pages need to be written
before clearing FI_VERITY_IN_PROGRESS.

- Eric
