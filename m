Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045752A8C71
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 03:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgKFCJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 21:09:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55100 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730414AbgKFCJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 21:09:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A6251Ew195642;
        Fri, 6 Nov 2020 02:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kTQxOUHa0VI2vWmISQ2XSlXt+0jwP0BOIDm2cqhREEI=;
 b=V7RAM3FeoPUDmHrnov2L2ftD12viYOrtTi1WMQyb/M4SfrTOX7XOKDpykTNSC653Sjp6
 77mYSgcW1+iWbpxs0Q+Gb6rjgafrVBTQvv/Qs45qN0N/xsYujJUR8c93leqI5D08RlFD
 IPJA1osUjFT3+mUG4F7wNERhR17C2ImfRsh2qCDdywd6L7WkGUdMuMaYsHchzBMhetY6
 dVu4Ts0nHq4BibTe/rbUFqKuvZ0si+eL/zguFJvguJG3gHDgXkTaO2dlaj9IrICQMhg9
 vDqGzTiLjT2J7RMEw+yJg6cNWQ1sC5JOkr0NPha9YuwduVCXHIV7D30ru1Wd1PUsoO2j 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34hhb2exp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 06 Nov 2020 02:09:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A620oAg075769;
        Fri, 6 Nov 2020 02:07:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34hw0jd6x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Nov 2020 02:07:07 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A6276wY007444;
        Fri, 6 Nov 2020 02:07:06 GMT
Received: from localhost (/10.159.136.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Nov 2020 18:07:06 -0800
Date:   Thu, 5 Nov 2020 18:07:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andy Strohman <astroh@amazon.com>
Cc:     stable@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 5.4] xfs: flush for older, xfs specific ioctls
Message-ID: <20201106020705.GC7118@magnolia>
References: <20201105202850.20216-1-astroh@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105202850.20216-1-astroh@amazon.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9796 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9796 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=1
 clxscore=1011 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011060012
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 08:28:50PM +0000, Andy Strohman wrote:
> 837a6e7f5cdb ("fs: add generic UNRESVSP and ZERO_RANGE ioctl handlers") changed
> ioctls XFS_IOC_UNRESVSP XFS_IOC_UNRESVSP64 and XFS_IOC_ZERO_RANGE to be generic
> instead of xfs specific.
> 
> Because of this change, 36f11775da75 ("xfs: properly serialise fallocate against
> AIO+DIO") needed adaptation, as 5.4 still uses the xfs specific ioctls.
> 
> Without this, xfstests xfs/242 and xfs/290 fail. Both of these tests test
> XFS_IOC_ZERO_RANGE.
> 
> Fixes: 36f11775da75 ("xfs: properly serialise fallocate against AIO+DIO")
>
> Tested-by: Andy Strohman <astroh@amazon.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yeah, looks good to me,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index bf0435dbec43..b3021d9b34a5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -622,7 +622,6 @@ xfs_ioc_space(
>  	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
>  	if (error)
>  		goto out_unlock;
> -	inode_dio_wait(inode);
>  
>  	switch (bf->l_whence) {
>  	case 0: /*SEEK_SET*/
> @@ -668,6 +667,31 @@ xfs_ioc_space(
>  		goto out_unlock;
>  	}
>  
> +	/*
> +	 * Must wait for all AIO to complete before we continue as AIO can
> +	 * change the file size on completion without holding any locks we
> +	 * currently hold. We must do this first because AIO can update both
> +	 * the on disk and in memory inode sizes, and the operations that follow
> +	 * require the in-memory size to be fully up-to-date.
> +	 */
> +	inode_dio_wait(inode);
> +
> +	/*
> +	 * Now that AIO and DIO has drained we can flush and (if necessary)
> +	 * invalidate the cached range over the first operation we are about to
> +	 * run. We include zero range here because it starts with a hole punch
> +	 * over the target range.
> +	 */
> +	switch (cmd) {
> +	case XFS_IOC_ZERO_RANGE:
> +	case XFS_IOC_UNRESVSP:
> +	case XFS_IOC_UNRESVSP64:
> +		error = xfs_flush_unmap_range(ip, bf->l_start, bf->l_len);
> +		if (error)
> +			goto out_unlock;
> +		break;
> +	}
> +
>  	switch (cmd) {
>  	case XFS_IOC_ZERO_RANGE:
>  		flags |= XFS_PREALLOC_SET;
> -- 
> 2.16.6
> 
