Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0960F56BD36
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 18:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbiGHP4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 11:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbiGHP4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 11:56:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788F070E56;
        Fri,  8 Jul 2022 08:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140C761709;
        Fri,  8 Jul 2022 15:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3E2C341C0;
        Fri,  8 Jul 2022 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657295810;
        bh=4HZbIthseZRLHViKy0j4K4UGYUeoRLsqPSpxVKmk1ME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qxb+hSl5FdoHPAKvqrcscf9/LdIX+DBqZBZbPMHLAcQ40LM7bwwpCRPdfjm7EIB+U
         EHi4PyFejNYzHklZyHiCAhtHhlFkcYumFb/nbCQSok0cmS+YSNv6L5SDytkPx+clpO
         wV9/1u88z9cwFMk28bw8LqgMcszV9OY9dioKKCYw4165mxNZDkSG/bhfXmeOyYp7FX
         XzJygugg4tbkDIJdptahckaEFXFte2cMU5xpvgyitGywd9Q6ntvpM5WI0KfZVHOb4Y
         MG17PZTGcoPlxeF4mrsFGZqoI5Tj2Go6/Ckz5zjViRrRJseRPmlPGNtVrZJYxv+tRC
         KPu4k8JFzrmCw==
Date:   Fri, 8 Jul 2022 08:56:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ke Xu <kkexu@amazon.com>, Ayushman Dutta <ayudutta@amazon.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH stable 4.9, 4.14, 4.19, 5.4, 5.10] xfs: remove incorrect
 ASSERT in xfs_rename
Message-ID: <YshTwayP+hM5IVHd@magnolia>
References: <20220707230753.32743-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707230753.32743-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 07, 2022 at 04:07:53PM -0700, Kuniyuki Iwashima wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> commit e445976537ad139162980bee015b7364e5b64fff upstream.
> 
> Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
> the original commit misses a Fixes tag and was not backported to the stable
> tree.  The fix is merged in 5.16, but it conflicts in 4.9 - 5.10 because
> of the idmapped mount changes:
> 
>   ++<<<<<<< HEAD
>    +      ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
>    +      error = xfs_rename_alloc_whiteout(target_dp, &wip);
>   ++=======
>   +       error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
>   ++>>>>>>> e445976537ad (xfs: remove incorrect ASSERT in xfs_rename)
> 
> We can resolve this by removing mnt_userns from the argument.
> 
> This ASSERT in xfs_rename is a) incorrect, because
> (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> b) unnecessary, because actual invalid flag combinations are already
> handled at the vfs level in do_renameat2() before we get called.
> So, remove it.
> 
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> I confirmed this can be applied cleanly on the latest 4.9 - 5.10 stable
> branch, but if there is any problem, please let me know.

LGTM
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e958b1c74561..03497741aef7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3170,7 +3170,6 @@ xfs_rename(
>  	 * appropriately.
>  	 */
>  	if (flags & RENAME_WHITEOUT) {
> -		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
>  		error = xfs_rename_alloc_whiteout(target_dp, &wip);
>  		if (error)
>  			return error;
> -- 
> 2.30.2
> 
