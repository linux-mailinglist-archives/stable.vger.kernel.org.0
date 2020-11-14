Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C019E2B2FF9
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 20:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgKNTIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 14:08:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34922 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgKNTIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 14:08:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJ5El7027376;
        Sat, 14 Nov 2020 19:08:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7MJmZXu2LZdRPERbG+JEb89HvsP+6UG4t0ZCdNvZWZ8=;
 b=j366OgC5hH+xmNCwLoZPOYTY9xtmWKhtJ1IZITPwX85z4QZ/rxg+jh8QNInnl0CF3yA8
 jJLup9wS483NpXYG3+XY1LWQ7/gpY3WkH5kcYdMAUojdKARO0FgpZYwuFcw0aS4E1sq/
 mlVG59MaE7rxCWCIcIPPcMe5WW6Hu3HTPBR/sjRZpBlvuEZd0XQxzGOSxtJs+bNlpoB6
 TOiVyvbBIq+6zG8L/ov7eHCSfe2LPys1/883pEAm8ReKl8GAugaxKKnVKaKlqcHBZeny
 pIcRG4syy7DsoJk91VsZ+auaOLTz8PKE9EwkPXh65kOsxMM2M9aVkBL2aAA2V8NaDFYH /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rahapu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 19:08:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJ6Mv2117115;
        Sat, 14 Nov 2020 19:06:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34t4bt2sd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 19:06:45 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AEJ6hrx005294;
        Sat, 14 Nov 2020 19:06:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Nov 2020 11:06:43 -0800
Date:   Sat, 14 Nov 2020 11:06:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dennis Gilmore <dgilmore@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] xfs: fix forkoff miscalculation related to
 XFS_LITINO(mp)
Message-ID: <20201114190642.GQ9695@magnolia>
References: <20201113015044.844213-1-hsiangkao@redhat.com>
 <20201114140234.1154690-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114140234.1154690-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140127
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 14, 2020 at 10:02:34PM +0800, Gao Xiang wrote:
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
> Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> Cc: <stable@vger.kernel.org> # 5.7+
> Reported-and-tested-by: Dennis Gilmore <dgilmore@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> changes since v2:
>  - collect more tags from the replies of v2;
>  - refine a comment suggested by Christoph.
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index bb128db220ac..d6ef69ab1c67 100644
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
> @@ -535,6 +535,12 @@ xfs_attr_shortform_bytesfit(
>  	int			maxforkoff;
>  	int			offset;
>  
> +	/*
> +	 * Check if the new size could fit at all first:
> +	 */
> +	if (bytes > XFS_LITINO(mp))
> +		return 0;
> +
>  	/* rounded down */
>  	offset = (XFS_LITINO(mp) - bytes) >> 3;
>  
> -- 
> 2.18.4
> 
