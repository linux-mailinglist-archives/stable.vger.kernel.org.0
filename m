Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78B9276440
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 00:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIWW67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 18:58:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37498 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWW66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 18:58:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NMuhDb047784;
        Wed, 23 Sep 2020 22:58:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=de/CRfCpEfLcXmk13jmhnbVHV0BFNqAnIyk5IZFQbLo=;
 b=xc5x0TcoLL2jC97e2xy8bgvoig6ZFPQ6iS7++gZO+4dqYdg9M9+N0mhD+AGMhzegOPcw
 WwkSnzGPCOqDQ/gIqKU2QVCC6lj2FyKAu5OskOZEXIp7MxrSyaqQYlRgbjw4HmmhsfZS
 lv2Woy5y/tRTsQ9J8JLhxVFImxRomf//MGAiXnv5OE70h7X5E8VEtOyEtjY3lNP9LOJE
 1/Wo3wUbub3X4bt+oX8fO5sW0Ot1jhBuw3x3h1fAsauWUXRCbhRi/rwgjos7VyEnAt/Y
 PArvpPoi2CYzLHsSoznZb4y2H+PIV5NDxAvBOwKgmjcKNVDIR8L0z5pkN6qwXOlIsxrm 9A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33qcpu25af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 22:58:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NMu6ZF118281;
        Wed, 23 Sep 2020 22:58:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33r28w85aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 22:58:50 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NMwnP0028404;
        Wed, 23 Sep 2020 22:58:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 15:58:49 -0700
Date:   Wed, 23 Sep 2020 15:58:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH STABLE] xfs: trim IO to found COW exent limit
Message-ID: <20200923225848.GX7955@magnolia>
References: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230174
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 05:35:44PM -0500, Eric Sandeen wrote:
> A bug existed in the XFS reflink code between v5.1 and v5.5 in which
> the mapping for a COW IO was not trimmed to the mapping of the COW
> extent that was found.  This resulted in a too-short copy, and
> corruption of other files which shared the original extent.
> 
> (This happened only when extent size hints were set, which bypasses
> delalloc and led to this code path.)
> 
> This was (inadvertently) fixed upstream with
> 
> 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
> 
> and related patches which moved lots of this functionality to
> the iomap subsystem.
> 
> Hence, this is a -stable only patch, targeted to fix this
> corruption vector without other major code changes.
> 
> Fixes: 78f0cc9d55cb ("xfs: don't use delalloc extents for COW on files with extsize hints")
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Note: Someone please fix the typo "exent" in the subject line.)

--D

> ---
> 
> I've tested this with a targeted reproducer (in next email) as well as
> with xfstests.
> 
> Stable folk, not sure how to send a "stable only" patch, or if that's even
> valid.  Assuming you're willing to accept it, I would still like to have
> some formal Reviewed-by's from the xfs developer community before it gets
> merged.
> 
> Big thanks to Darrick & Dave for letting me whine about this bug and
> offering suggestions for testing and ultimately, a patch to test.
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 06b9e0aacf54..3289d0f4bb03 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1002,9 +1002,15 @@ xfs_file_iomap_begin(
>  		 * I/O, which must be block aligned, we need to report the
>  		 * newly allocated address.  If the data fork has a hole, copy
>  		 * the COW fork mapping to avoid allocating to the data fork.
> +		 *
> +		 * Otherwise, ensure that the imap range does not extend past
> +		 * the range allocated/found in cmap.
>  		 */
>  		if (directio || imap.br_startblock == HOLESTARTBLOCK)
>  			imap = cmap;
> +		else
> +			xfs_trim_extent(&imap, cmap.br_startoff,
> +					cmap.br_blockcount);
>  
>  		end_fsb = imap.br_startoff + imap.br_blockcount;
>  		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
> 
