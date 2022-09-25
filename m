Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFE25E92C4
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 13:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiIYLjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 07:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiIYLjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 07:39:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0010425C74;
        Sun, 25 Sep 2022 04:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7560B80DC7;
        Sun, 25 Sep 2022 11:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4622C433D6;
        Sun, 25 Sep 2022 11:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664105944;
        bh=a7iE2sFy/hDekqqTfT8c66wXwJbENHupWu/JBCBcGvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=btomTuEnhnGpOrsrl1mFErbVo2LBZAiJ5Ltu9d5ZaGvXs+0Ev5XpbRNOrwKQe93KF
         zNEaeyHjzvATHy9vpwG6fxCUjlrUOWi3cf6S0hwkCE77dOxMB9ZXamTvU5dl4zTuXA
         Pbd12jtg7+3sFRhEgNcKVHJS0xxPlpyrJX5yqepY=
Date:   Sun, 25 Sep 2022 13:39:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5.10 1/2] xfs: reorder iunlink remove operation in
 xfs_ifree
Message-ID: <YzA91RSiwKkkwbG1@kroah.com>
References: <20220922154728.97402-1-amir73il@gmail.com>
 <20220922154728.97402-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922154728.97402-2-amir73il@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 06:47:27PM +0300, Amir Goldstein wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> 
> [backport for 5.10.y]
> 
> The O_TMPFILE creation implementation creates a specific order of
> operations for inode allocation/freeing and unlinked list
> modification. Currently both are serialised by the AGI, so the order
> doesn't strictly matter as long as the are both in the same
> transaction.
> 
> However, if we want to move the unlinked list insertions largely out
> from under the AGI lock, then we have to be concerned about the
> order in which we do unlinked list modification operations.
> O_TMPFILE creation tells us this order is inode allocation/free,
> then unlinked list modification.
> 
> Change xfs_ifree() to use this same ordering on unlinked list
> removal. This way we always guarantee that when we enter the
> iunlinked list removal code from this path, we already have the AGI
> locked and we don't have to worry about lock nesting AGI reads
> inside unlink list locks because it's already locked and attached to
> the transaction.
> 
> We can do this safely as the inode freeing and unlinked list removal
> are done in the same transaction and hence are atomic operations
> with respect to log recovery.
> 
> Reported-by: Frank Hofmann <fhofmann@cloudflare.com>
> Fixes: 298f7bec503f ("xfs: pin inode backing buffer to the inode log item")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Acked-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1f61e085676b..929ed3bc5619 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2669,14 +2669,13 @@ xfs_ifree_cluster(
>  }
>  
>  /*
> - * This is called to return an inode to the inode free list.
> - * The inode should already be truncated to 0 length and have
> - * no pages associated with it.  This routine also assumes that
> - * the inode is already a part of the transaction.
> + * This is called to return an inode to the inode free list.  The inode should
> + * already be truncated to 0 length and have no pages associated with it.  This
> + * routine also assumes that the inode is already a part of the transaction.
>   *
> - * The on-disk copy of the inode will have been added to the list
> - * of unlinked inodes in the AGI. We need to remove the inode from
> - * that list atomically with respect to freeing it here.
> + * The on-disk copy of the inode will have been added to the list of unlinked
> + * inodes in the AGI. We need to remove the inode from that list atomically with
> + * respect to freeing it here.
>   */
>  int
>  xfs_ifree(
> @@ -2694,13 +2693,16 @@ xfs_ifree(
>  	ASSERT(ip->i_d.di_nblocks == 0);
>  
>  	/*
> -	 * Pull the on-disk inode from the AGI unlinked list.
> +	 * Free the inode first so that we guarantee that the AGI lock is going
> +	 * to be taken before we remove the inode from the unlinked list. This
> +	 * makes the AGI lock -> unlinked list modification order the same as
> +	 * used in O_TMPFILE creation.
>  	 */
> -	error = xfs_iunlink_remove(tp, ip);
> +	error = xfs_difree(tp, ip->i_ino, &xic);
>  	if (error)
>  		return error;
>  
> -	error = xfs_difree(tp, ip->i_ino, &xic);
> +	error = xfs_iunlink_remove(tp, ip);
>  	if (error)
>  		return error;
>  
> -- 
> 2.25.1
> 

Any specific reason you do not want 6f5097e3367a ("xfs: fix xfs_ifree()
error handling to not leak perag ref") also applied?  That commit fixes
this one (or so it says.)

That is part of the 5.15 queue right now, but not 5.10, is that a
problem?

thanks,

greg k-h
