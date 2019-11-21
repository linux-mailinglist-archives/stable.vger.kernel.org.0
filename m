Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF17105D72
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 00:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfKUXzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 18:55:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55304 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfKUXzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 18:55:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALNnTWv027681;
        Thu, 21 Nov 2019 23:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=QY8j3JMop/DxVJMadbxBdDgSIUv8maue2MbhnBUj7oY=;
 b=YJtDdfQTLEDQZkxgDah9Oh3oJf/Y7/LQYtpzWwR+JLcqKeDmtC69ZA9ZQIkovwWbz7Sd
 LEtJjuYjje7AVpB2UIciELSe28pUx51YwL0AjD5alz+aGgbGtqjpeOnz2gVsMpWS3neL
 NIetllZ/4ENPCXnKaxfg5VsidkLirx531ZBSBVPSsnDCl0fS3X6rr3x0B9HRIYDgxz/f
 2/lbG1twG71ME2qtKoPQpAHr8e+Ygs5gUa4LzfAdB+Xyx0khP63523LQzFChBozqma+m
 1HL5AAPRCK4T5sYPkirGxWDTxZpQm5QNdp7HfS8eTOBgd7y2+3Xmc32luQ8KdzeeOUEr pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rqyfru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 23:55:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALNnLRS134406;
        Thu, 21 Nov 2019 23:55:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wda06wxuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 23:55:32 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xALNtTrx011837;
        Thu, 21 Nov 2019 23:55:29 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 15:55:29 -0800
Date:   Thu, 21 Nov 2019 15:55:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: Fix pipe page leakage during splicing
Message-ID: <20191121235528.GO6211@magnolia>
References: <20191121161144.30802-1-jack@suse.cz>
 <20191121161538.18445-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121161538.18445-1-jack@suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210202
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 05:15:34PM +0100, Jan Kara wrote:
> When splicing using iomap_dio_rw() to a pipe, we may leak pipe pages
> because bio_iov_iter_get_pages() records that the pipe will have full
> extent worth of data however if file size is not block size aligned
> iomap_dio_rw() returns less than what bio_iov_iter_get_pages() set up
> and splice code gets confused leaking a pipe page with the file tail.
> 
> Handle the situation similarly to the old direct IO implementation and
> revert iter to actually returned read amount which makes iter consistent
> with value returned from iomap_dio_rw() and thus the splice code is
> happy.
> 
> Fixes: ff6a9292e6f6 ("iomap: implement direct I/O")
> CC: stable@vger.kernel.org
> Reported-by: syzbot+991400e8eba7e00a26e1@syzkaller.appspotmail.com
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/iomap/direct-io.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 1fc28c2da279..30189652c560 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -497,8 +497,15 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		}
>  		pos += ret;
>  
> -		if (iov_iter_rw(iter) == READ && pos >= dio->i_size)
> +		if (iov_iter_rw(iter) == READ && pos >= dio->i_size) {
> +			/*
> +			 * We will report we've read data only upto i_size.

Nit: "up to"; will fix that on the way in.

> +			 * Revert iter to a state corresponding to that as
> +			 * some callers (such as splice code) rely on it.
> +			 */
> +			iov_iter_revert(iter, pos - dio->i_size);

Just to make sure I'm getting this right, iov_iter_revert walks the
iterator variables backwards through pipe buffers/bvec/iovec, which has
the effect of undoing whatever iterator walking we've just done.

In contrast, iov_iter_reexpand undoes a previous subtraction to
iov->count which was (presumably) done via iov_iter_truncate.

Or to put it another way, _revert walks the iteration pointer backwards,
whereas _truncate/_reexpand modify where the iteration ends.  Right?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  			break;
> +		}
>  	} while ((count = iov_iter_count(iter)) > 0);
>  	blk_finish_plug(&plug);
>  
> -- 
> 2.16.4
> 
