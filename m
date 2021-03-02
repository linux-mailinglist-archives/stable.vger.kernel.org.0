Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34832B2C3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344021AbhCCAx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345706AbhCBUKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 15:10:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 998C564F25;
        Tue,  2 Mar 2021 20:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614715799;
        bh=IMcrxgy4pmTw3Hovh6U4Hmr08wWkOgVJt217xAmKh8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gZ3pOYDJL32Wn2tUnLNVfnH+JBmp05+FEraOT4R/knoCxY7elpBpThss27KJjnz4q
         1PtzKuB60Jq/FV+e4AW3ywg3xKYz3vcBAHN6rUV7NEoL1QNPBaewE/0OP4Paytruoc
         zXRNJqNfu/L2px7Cq2dtD2hCGkehFWqU/znNmBAaYBC0y1bIpC6BrvAfccpMvQga4y
         wSHafouruIh7z7ByTm3+V8waH/8XM2ETRY8UcGCUynmmj8JDQ7H7xPdwq/lL0iLVpw
         eMr4KzOSMtrsSZHm2YaHzY4ECNAB2VlBtYiajuX6l0KkBruHchghGGzZaSVa1EyFzX
         CfssgntjIWONw==
Date:   Tue, 2 Mar 2021 12:09:58 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Yunlei He <heyunlei@hihonor.com>
Cc:     chao@kernel.org, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, bintian.wang@hihonor.com,
        stable@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH] f2fs: fsverity: modify truncation for verity
 enable failed
Message-ID: <YD6bltna2vBFVlgV@sol.localdomain>
References: <20210302113850.17011-1-heyunlei@hihonor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302113850.17011-1-heyunlei@hihonor.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Yunlei,

On Tue, Mar 02, 2021 at 07:38:50PM +0800, Yunlei He wrote:
> If file enable verity failed, should truncate anything wrote
> past i_size, including cache pages. Move the truncation to
> the end of function, in case of f2fs set xattr failed.
> 
> Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Yunlei He <heyunlei@hihonor.com>
> ---
>  fs/f2fs/verity.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> index 054ec852b5ea..610f2a9b4928 100644
> --- a/fs/f2fs/verity.c
> +++ b/fs/f2fs/verity.c
> @@ -169,10 +169,6 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
>  			err = filemap_write_and_wait(inode->i_mapping);
>  	}
>  
> -	/* If we failed, truncate anything we wrote past i_size. */
> -	if (desc == NULL || err)
> -		f2fs_truncate(inode);
> -
>  	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
>  
>  	if (desc != NULL && !err) {
> @@ -185,6 +181,13 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
>  			f2fs_mark_inode_dirty_sync(inode, true);
>  		}
>  	}
> +
> +	/* If we failed, truncate anything we wrote past i_size. */
> +	if (desc == NULL || err) {
> +		truncate_inode_pages(inode->i_mapping, inode->i_size);
> +		f2fs_truncate(inode);
> +	}
> +
>  	return err;

This is better, but we really should properly separate the success path from the
error paths in this function; otherwise it's too hard to understand.  Also, the
same bugs need to be fixed in ext4 too, and the commit message could be better.
I went ahead and sent out a new patchset which addresses all this
(https://lkml.kernel.org/linux-f2fs-devel/20210302200420.137977-1-ebiggers@kernel.org/T/#u);
can you take a look at that instead?  Thanks!

- Eric
