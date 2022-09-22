Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168CB5E66E6
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiIVPVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiIVPVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:21:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A44F1D48;
        Thu, 22 Sep 2022 08:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47B08B83840;
        Thu, 22 Sep 2022 15:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68C1C433D6;
        Thu, 22 Sep 2022 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663860090;
        bh=ntYvVBCQ6P4bG/5f9Tcc2zWBaGUCQPXTBLzTwbEgO2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SGSr8PEjm2DE2J7GmmeRagjGWkrQ3GQhWqyf9yTiD/PSFmw9OlrKb0GWMzrwxElwn
         28FiYHNSua0PlRLwfpzmGiuIFLskWWAbs/PVFE8Cm9IxV67ZuMfYsyliesPL5KLuKN
         8Tp36SRXQHE1UM5SsTZ1p+rSCXVO+hfjlAgCI3JWnmEYvbx9GIBnGImte98LCZ8ZKP
         qKHEX6D7Eh615TJ6M9KE4uLiTw5X3kcFwMeF6hHbD56QodIfmY8Dyl640pK+/WSFsl
         i0+U9oMm88vexkk19EHRq/bw3QUbDEwq8qClA1x7TJX9yxyGZEwDBc8LD0yYKXXdVG
         n68s/7BYyltRw==
Date:   Thu, 22 Sep 2022 08:21:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Varsha Teratipally <teratipally@google.com>,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 5.10] xfs: fix up non-directory creation in SGID
 directories
Message-ID: <Yyx9eaKyYC08vOvq@magnolia>
References: <20220922084956.74262-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922084956.74262-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 11:49:56AM +0300, Amir Goldstein wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.
> 
> XFS always inherits the SGID bit if it is set on the parent inode, while
> the generic inode_init_owner does not do this in a few cases where it can
> create a possible security problem, see commit 0fa3ecd87848
> ("Fix up non-directory creation in SGID directories") for details.
> 
> Switch XFS to use the generic helper for the normal path to fix this,
> just keeping the simple field inheritance open coded for the case of the
> non-sgid case with the bsdgrpid mount option.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Acked-off-by: Darrick J. Wong <djwong@kernel.org>

(H)acked-off-by?  I suppose we /are/ grafting bits of trees... :D

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Hi Greg,
> 
> This is an old debt of a patch that was dropped during review of my
> batch of 5.10.y xfs backports from v5.12 [1].
> 
> Recently, Varsha requested the inclusion of this fix in 5.10.y
> and Darrick has Acked it [2].
> 
> I have another series of SGID related fixes that also apply to 5.15.y
> which I am collaborating on testing with Leah, but as both Christian and
> Christoph commented in the original patch review [3], this fix from
> v5.12 is independent of the rest of the SGID fixes and is well worth
> backporting.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-xfs/20220606143255.685988-1-amir73il@gmail.com/
> [2] https://lore.kernel.org/linux-xfs/YyIDzPTn99XLTCFp@magnolia/
> [3] https://lore.kernel.org/linux-xfs/20220608082654.GA16753@lst.de/
> 
>  fs/xfs/xfs_inode.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 929ed3bc5619..19008838df76 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -802,6 +802,7 @@ xfs_ialloc(
>  	xfs_buf_t	**ialloc_context,
>  	xfs_inode_t	**ipp)
>  {
> +	struct inode	*dir = pip ? VFS_I(pip) : NULL;
>  	struct xfs_mount *mp = tp->t_mountp;
>  	xfs_ino_t	ino;
>  	xfs_inode_t	*ip;
> @@ -847,18 +848,17 @@ xfs_ialloc(
>  		return error;
>  	ASSERT(ip != NULL);
>  	inode = VFS_I(ip);
> -	inode->i_mode = mode;
>  	set_nlink(inode, nlink);
> -	inode->i_uid = current_fsuid();
>  	inode->i_rdev = rdev;
>  	ip->i_d.di_projid = prid;
>  
> -	if (pip && XFS_INHERIT_GID(pip)) {
> -		inode->i_gid = VFS_I(pip)->i_gid;
> -		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
> -			inode->i_mode |= S_ISGID;
> +	if (dir && !(dir->i_mode & S_ISGID) &&
> +	    (mp->m_flags & XFS_MOUNT_GRPID)) {
> +		inode->i_uid = current_fsuid();
> +		inode->i_gid = dir->i_gid;
> +		inode->i_mode = mode;
>  	} else {
> -		inode->i_gid = current_fsgid();
> +		inode_init_owner(inode, dir, mode);
>  	}
>  
>  	/*
> -- 
> 2.25.1
> 
