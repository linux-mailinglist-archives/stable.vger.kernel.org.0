Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9DCA3B95
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 18:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfH3QJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 12:09:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47886 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfH3QJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Aug 2019 12:09:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UG8VnF193537;
        Fri, 30 Aug 2019 16:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fDZkm7TGgVyRUW7Itan/V6vOBM2/o4OXxKZDDHyHkQk=;
 b=ar2PzY1a2BDwQZuxJjLGrWiNZgzTbflDX4rYndb/+yTiGDGB0PCqJ598NEmnsESROX+s
 2mnjHIK7Y1ZuH+aHhUd2htUGnoz8V9kNYfeURPKdwCHwBG66HtAgJU2QZnolqZmTYStd
 gEbYNVrWPukV2Ycq1vsu0j7JWlZCPtDBYbbx8HLB61PG/aCX2taeLiUPzHbbihUnDcZN
 HpTliNZQV9kD2zJDXDzoOsmZvUEwapLR+WJz28sXk+wpXhe9Uh2777MYP0I1b3vMGKZv
 ZwqCemdEp0Yd6kFi6IsdU9HSw6Y0etUy27ox7HLqH8q4JzBLy/MBbyEpoEXBxg565hE4 fQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uq6yn81ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 16:09:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UFvkZB041739;
        Fri, 30 Aug 2019 16:02:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2upxabfpfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 16:02:16 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7UG2FYT000919;
        Fri, 30 Aug 2019 16:02:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 09:02:15 -0700
Date:   Fri, 30 Aug 2019 09:02:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
Message-ID: <20190830160213.GF5360@magnolia>
References: <20190829131034.10563-1-jack@suse.cz>
 <20190829131034.10563-4-jack@suse.cz>
 <20190829155204.GD5354@magnolia>
 <20190830152449.GA25069@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830152449.GA25069@quack2.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300161
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 30, 2019 at 05:24:49PM +0200, Jan Kara wrote:
> On Thu 29-08-19 08:52:04, Darrick J. Wong wrote:
> > On Thu, Aug 29, 2019 at 03:10:34PM +0200, Jan Kara wrote:
> > > Hole puching currently evicts pages from page cache and then goes on to
> > > remove blocks from the inode. This happens under both XFS_IOLOCK_EXCL
> > > and XFS_MMAPLOCK_EXCL which provides appropriate serialization with
> > > racing reads or page faults. However there is currently nothing that
> > > prevents readahead triggered by fadvise() or madvise() from racing with
> > > the hole punch and instantiating page cache page after hole punching has
> > > evicted page cache in xfs_flush_unmap_range() but before it has removed
> > > blocks from the inode. This page cache page will be mapping soon to be
> > > freed block and that can lead to returning stale data to userspace or
> > > even filesystem corruption.
> > > 
> > > Fix the problem by protecting handling of readahead requests by
> > > XFS_IOLOCK_SHARED similarly as we protect reads.
> > > 
> > > CC: stable@vger.kernel.org
> > > Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com/
> > > Reported-by: Amir Goldstein <amir73il@gmail.com>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > Is there a test on xfstests to demonstrate this race?
> 
> No, but I can try to create one.

<nod> I imgaine this race was hard to spot in the first place...

> > Will test it out though...
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks. BTW, will you pick up these patches please?

Yeah, they looked fine.

--D

> 								Honza
> 
> > 
> > --D
> > 
> > > ---
> > >  fs/xfs/xfs_file.c | 26 ++++++++++++++++++++++++++
> > >  1 file changed, 26 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 28101bbc0b78..d952d5962e93 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -28,6 +28,7 @@
> > >  #include <linux/falloc.h>
> > >  #include <linux/backing-dev.h>
> > >  #include <linux/mman.h>
> > > +#include <linux/fadvise.h>
> > >  
> > >  static const struct vm_operations_struct xfs_file_vm_ops;
> > >  
> > > @@ -933,6 +934,30 @@ xfs_file_fallocate(
> > >  	return error;
> > >  }
> > >  
> > > +STATIC int
> > > +xfs_file_fadvise(
> > > +	struct file	*file,
> > > +	loff_t		start,
> > > +	loff_t		end,
> > > +	int		advice)
> > > +{
> > > +	struct xfs_inode *ip = XFS_I(file_inode(file));
> > > +	int ret;

> > > +	int lockflags = 0;
> > > +
> > > +	/*
> > > +	 * Operations creating pages in page cache need protection from hole
> > > +	 * punching and similar ops
> > > +	 */
> > > +	if (advice == POSIX_FADV_WILLNEED) {
> > > +		lockflags = XFS_IOLOCK_SHARED;
> > > +		xfs_ilock(ip, lockflags);
> > > +	}
> > > +	ret = generic_fadvise(file, start, end, advice);
> > > +	if (lockflags)
> > > +		xfs_iunlock(ip, lockflags);
> > > +	return ret;
> > > +}
> > >  
> > >  STATIC loff_t
> > >  xfs_file_remap_range(
> > > @@ -1232,6 +1257,7 @@ const struct file_operations xfs_file_operations = {
> > >  	.fsync		= xfs_file_fsync,
> > >  	.get_unmapped_area = thp_get_unmapped_area,
> > >  	.fallocate	= xfs_file_fallocate,
> > > +	.fadvise	= xfs_file_fadvise,
> > >  	.remap_file_range = xfs_file_remap_range,
> > >  };
> > >  
> > > -- 
> > > 2.16.4
> > > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
