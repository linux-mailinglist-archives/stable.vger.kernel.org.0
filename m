Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A42E2B08FF
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 16:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgKLPx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 10:53:56 -0500
Received: from sandeen.net ([63.231.237.45]:49204 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728263AbgKLPxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 10:53:55 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7BC1014A36;
        Thu, 12 Nov 2020 09:53:37 -0600 (CST)
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
References: <20201112063005.692054-1-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: fix signed calculation related to XFS_LITINO(mp)
Message-ID: <3d04e9b3-f326-cbcd-e268-e4da40f35fa2@sandeen.net>
Date:   Thu, 12 Nov 2020 09:53:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201112063005.692054-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/12/20 12:30 AM, Gao Xiang wrote:
> Currently, commit e9e2eae89ddb dropped a (int) decoration from
> XFS_LITINO(mp), and since sizeof() expression is also involved,
> the result of XFS_LITINO(mp) is simply as the size_t type
> (commonly unsigned long).

Thanks for finding this!  Let me think through it a little.
 
> Considering the expression in xfs_attr_shortform_bytesfit():
>   offset = (XFS_LITINO(mp) - bytes) >> 3;
> let "bytes" be (int)340, and
>     "XFS_LITINO(mp)" be (unsigned long)336.
> 
> on 64-bit platform, the expression is
>   offset = ((unsigned long)336 - (int)340) >> 8 =

This should be >> 3, right.

>            (int)(0xfffffffffffffffcUL >> 3) = -1
> 
> but on 32-bit platform, the expression is
>   offset = ((unsigned long)336 - (int)340) >> 8 =

and >> 3 here as well.

>            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> instead.

Ok.  But wow, that magical cast to (int) in XFS_LITINO isn't at
all clear to me.

XFS_LITINO() indicates a /size/ - fixing this problem by making it a
signed value feels very strange, but I'm not sure what would be better,
yet.

> Therefore, one result is
>   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
>   assertion failure in xfs_idata_realloc().
> 
> , which can be triggered with the following commands:
>  touch a;
>  setfattr -n user.0 -v "`seq 0 80`" a;
>  setfattr -n user.1 -v "`seq 0 80`" a
> on 32-bit platform.

Can you please write an xfstest for this? :)

> Fix it by restoring (int) decorator to XFS_LITINO(mp) since
> int type for XFS_LITINO(mp) is safe and all pre-exist signed
> calculations are correct.
> 
> Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> Cc: <stable@vger.kernel.org> # 5.7+
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> I'm not sure this is the preferred way or just simply fix
> xfs_attr_shortform_bytesfit() since I don't look into the
> rest of XFS_LITINO(mp) users. Add (int) to XFS_LITINO(mp)
> will avoid all potential regression at least.
> 
>  fs/xfs/libxfs/xfs_format.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dd764da08f6f..f58f0a44c024 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1061,7 +1061,7 @@ enum xfs_dinode_fmt {
>  		sizeof(struct xfs_dinode) : \
>  		offsetof(struct xfs_dinode, di_crc))>  #define XFS_LITINO(mp) \
> -	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
> +	((int)((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb)))

If we do keep the (int) cast here we at least need a comment explaining why
it cannot be removed, unless there is a better way to solve the problem.

I wonder if explicitly making XFS_LITINO() cast to a size_t would be
best, and then in xfs_attr_shortform_bytesfit() we just quickly reject
the query if the bytes are larger than the literal area:

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bb128db..5588c2e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -535,6 +535,10 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
        int                     maxforkoff;
        int                     offset;
 
+       /* Is there no chance we can fit? */
+       if (bytes > XFS_LITINO(mp))
+               return 0;
+
        /* rounded down */
        offset = (XFS_LITINO(mp) - bytes) >> 3;

or, maybe simply:

-        offset = (XFS_LITINO(mp) - bytes) >> 3;
+        offset = (int)(XFS_LITINO(mp) - bytes) >> 3;

to be sure that the arithmetic doesn't get promoted to unsigned before the shift?

or maybe others have better ideas.

-Eric

  
>  /*
>   * Inode data & attribute fork sizes, per inode.
> 
