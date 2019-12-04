Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2651130DB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfLDRdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:33:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfLDRdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:33:37 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 013CE207DD;
        Wed,  4 Dec 2019 17:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575480816;
        bh=4/DMwvfrnYivcFIK52Tj1sOTHgxyGimoHU2m8nOpOA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o2QJgZcALDuROeJxPSZwFYlx3LFmRnPlAv6/u5wK9YqBZSEsmXfsjv81vYW2JCEHW
         bt/M72/BbTt/AW99+J60TP+n6LSuyUoMLt+DazKqjXBy5yE+7yLJQLtNsiAGOJkJ2j
         dwHcaucLbGh+6/9fdRYyOipkV25KOngKSYDnkilc=
Date:   Wed, 4 Dec 2019 18:33:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yu kuai <yukuai3@huawei.com>
Cc:     stable@vger.kernel.org, hughd@google.com, viro@zeniv.linux.org.uk,
        yi.zhang@huawei.com, zhengbin13@huawei.com, houtao1@huawei.com
Subject: Re: [4.19.y PATCH] tmpfs: fix unable to remount nr_inodes from
 limited to unlimited
Message-ID: <20191204173334.GB3630950@kroah.com>
References: <20191204131137.10388-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204131137.10388-1-yukuai3@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 09:11:37PM +0800, yu kuai wrote:
> tmpfs support 'size', 'nr_blocks' and 'nr_inodes' mount options. mount or
> remount them to zero means unlimited. 'size' and 'br_blocks' can remount
> from limited to unlimited, while 'nr_inodes' can't.
> 
> The problem is fixed since upstream commit 0b5071dd323d ("
> shmem_parse_options(): use a separate structure to keep the results"). But
> in order to backport it, the amount of related patches need to backport is
> huge. 
> 
> So, I made some local changes to fix the problem.
> 
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>  mm/shmem.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3c8742655756..966fc69ee8fb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3444,7 +3444,7 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
>  	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
>  	if (percpu_counter_compare(&sbinfo->used_blocks, config.max_blocks) > 0)
>  		goto out;
> -	if (config.max_inodes < inodes)
> +	if (config.max_inodes && config.max_inodes < inodes)
>  		goto out;
>  	/*
>  	 * Those tests disallow limited->unlimited while any are in use;
> @@ -3460,7 +3460,10 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
>  	sbinfo->huge = config.huge;
>  	sbinfo->max_blocks  = config.max_blocks;
>  	sbinfo->max_inodes  = config.max_inodes;
> -	sbinfo->free_inodes = config.max_inodes - inodes;
> +	if (!config.max_inodes)
> +		sbinfo->free_inodes = 0;
> +	else
> +		sbinfo->free_inodes = config.max_inodes - inodes;
>  
>  	/*
>  	 * Preserve previous mempolicy unless mpol remount option was specified.
> -- 
> 2.17.2
> 

Hm, sorry about my bot, this looked like an odd one-off patch.

What about 5.3.y, should this patch also go there as well?

But is it really an issue as this is a new "feature" that 5.4 now has,
can't you just use 5.4.y if you need this type of thing?  It's never
worked in the past, right?

thanks,

greg k-h
