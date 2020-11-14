Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C1A2B2CB7
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 11:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgKNKcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 05:32:53 -0500
Received: from verein.lst.de ([213.95.11.211]:50055 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgKNKcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Nov 2020 05:32:53 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4C68D68AFE; Sat, 14 Nov 2020 11:32:50 +0100 (CET)
Date:   Sat, 14 Nov 2020 11:32:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dennis Gilmore <dgilmore@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix forkoff miscalculation related to
 XFS_LITINO(mp)
Message-ID: <20201114103249.GA19866@lst.de>
References: <20201112063005.692054-1-hsiangkao@redhat.com> <20201113015044.844213-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113015044.844213-1-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 13, 2020 at 09:50:44AM +0800, Gao Xiang wrote:
> Currently, commit e9e2eae89ddb dropped a (int) decoration from
> XFS_LITINO(mp), and since sizeof() expression is also involved,
> the result of XFS_LITINO(mp) is simply as the size_t type
> (commonly unsigned long).
> 
> Considering the expression in xfs_attr_shortform_bytesfit():
>   offset = (XFS_LITINO(mp) - bytes) >> 3;
> let "bytes" be (int)340, and
>     "XFS_LITINO(mp)" be (unsigned long)336.
> 
> on 64-bit platform, the expression is
>   offset = ((unsigned long)336 - (int)340) >> 3 =
>            (int)(0xfffffffffffffffcUL >> 3) = -1
> 
> but on 32-bit platform, the expression is
>   offset = ((unsigned long)336 - (int)340) >> 3 =
>            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> instead.
> 
> so offset becomes a large positive number on 32-bit platform, and
> cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.
> 
> Therefore, one result is
>   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> 
> assertion failure in xfs_idata_realloc(), which was also the root
> cause of the original bugreport from Dennis, see:
>    https://bugzilla.redhat.com/show_bug.cgi?id=1894177
> 
> And it can also be manually triggered with the following commands:
>   $ touch a;
>   $ setfattr -n user.0 -v "`seq 0 80`" a;
>   $ setfattr -n user.1 -v "`seq 0 80`" a
> 
> on 32-bit platform.
> 
> Fix the case in xfs_attr_shortform_bytesfit() by bailing out
> "XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
> comment together with this bugfix suggested by Darrick. It seems the
> other users of XFS_LITINO(mp) are not impacted.
> 
> Reported-by: Dennis Gilmore <dgilmore@redhat.com>
> Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> Cc: <stable@vger.kernel.org> # 5.7+
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> changes since v1:
>  - fix 2 typos ">> 8" to ">> 3" mentioned by Eric;
>  - directly bail out "XFS_LITINO(mp) < bytes" suggested
>    by Eric and Darrick;
>  - fix a misleading comment together suggested by Darrick;
>  - since (int) decorator doesn't need to be added, so update
>    the patch subject as well.
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index bb128db220ac..c8d91034850b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -515,7 +515,7 @@ xfs_attr_copy_value(
>   *========================================================================*/
>  
>  /*
> - * Query whether the requested number of additional bytes of extended
> + * Query whether the total requested number of attr fork bytes of extended
>   * attribute space will be able to fit inline.
>   *
>   * Returns zero if not, else the di_forkoff fork offset to be used in the
> @@ -535,6 +535,10 @@ xfs_attr_shortform_bytesfit(
>  	int			maxforkoff;
>  	int			offset;
>  
> +	/* there is no chance we can fit */

Maybe:

	/* 
	 * Check if the new size could fit at all first:
	 */

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
