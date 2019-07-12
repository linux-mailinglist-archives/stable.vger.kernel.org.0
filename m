Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C7674B1
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 19:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfGLRuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 13:50:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53222 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfGLRuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 13:50:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CHj40F087152;
        Fri, 12 Jul 2019 17:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=x7UvLQTSUB1LsR4hNhBIrs6gKfi4eqgBS41bGNCZxkE=;
 b=WmIBn4TzVxJx7tITkiSdrxbMpLlvOyowIFmWIQLvD8rTXOemFcj/0peG8zV3LJOZopYV
 5hKdk0m359lkfQ7nMT4n2GhVSOCH4wp95EOwzR6Ohrzx9y5528wIXvddyfPrfkytsJDI
 SNvy/mobFyaDD+GB0eg8nzsY+gbUx03fqPfGr0UgLAx4VLkrQkety9jgD4AAHLwrZpa6
 HYfIZYhjoI1JkxBBH4sfGEdHz/pHZJjw/NmTv1sSRBHGcdIShUvN18StFkQ7qAZJKrpq
 5qdQ9L3z/Q/UdLLt6fdxQ9dJx6oa3hNyB6f6Us/sRV1+OoU5AKQpKtclrhQZES7W/CVA wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tjk2u71re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 17:50:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CHlfJb072667;
        Fri, 12 Jul 2019 17:50:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tn1j296kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 17:50:43 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6CHofoJ017303;
        Fri, 12 Jul 2019 17:50:41 GMT
Received: from localhost (/10.159.245.178)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 10:50:41 -0700
Date:   Fri, 12 Jul 2019 10:50:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: Handle MADV_WILLNEED through vfs_fadvise()
Message-ID: <20190712175040.GY1404256@magnolia>
References: <20190711140012.1671-1-jack@suse.cz>
 <20190711140012.1671-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711140012.1671-2-jack@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9316 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9316 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 04:00:10PM +0200, Jan Kara wrote:
> Currently handling of MADV_WILLNEED hint calls directly into readahead
> code. Handle it by calling vfs_fadvise() instead so that filesystem can
> use its ->fadvise() callback to acquire necessary locks or otherwise
> prepare for the request.
> 
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> CC: stable@vger.kernel.org # Needed by "xfs: Fix stale data exposure
> 					when readahead races with hole punch"
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks reasonable to me, though is this race between readahead and
truncate severe enough to try to push it as a fix for 5.3 or are you
targetting 5.4?

--D

> ---
>  mm/madvise.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 628022e674a7..ae56d0ef337d 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -14,6 +14,7 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/hugetlb.h>
>  #include <linux/falloc.h>
> +#include <linux/fadvise.h>
>  #include <linux/sched.h>
>  #include <linux/ksm.h>
>  #include <linux/fs.h>
> @@ -275,6 +276,7 @@ static long madvise_willneed(struct vm_area_struct *vma,
>  			     unsigned long start, unsigned long end)
>  {
>  	struct file *file = vma->vm_file;
> +	loff_t offset;
>  
>  	*prev = vma;
>  #ifdef CONFIG_SWAP
> @@ -298,12 +300,20 @@ static long madvise_willneed(struct vm_area_struct *vma,
>  		return 0;
>  	}
>  
> -	start = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> -	if (end > vma->vm_end)
> -		end = vma->vm_end;
> -	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> -
> -	force_page_cache_readahead(file->f_mapping, file, start, end - start);
> +	/*
> +	 * Filesystem's fadvise may need to take various locks.  We need to
> +	 * explicitly grab a reference because the vma (and hence the
> +	 * vma's reference to the file) can go away as soon as we drop
> +	 * mmap_sem.
> +	 */
> +	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
> +	get_file(file);
> +	up_read(&current->mm->mmap_sem);
> +	offset = (loff_t)(start - vma->vm_start)
> +			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
> +	vfs_fadvise(file, offset, end - start, POSIX_FADV_WILLNEED);
> +	fput(file);
> +	down_read(&current->mm->mmap_sem);
>  	return 0;
>  }
>  
> -- 
> 2.16.4
> 
