Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA90A674C6
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 19:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfGLR4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 13:56:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfGLR4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 13:56:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CHsRrU105742;
        Fri, 12 Jul 2019 17:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=PFVmlVQEMCCclkWvCJY9Wejc6o6dKfzcVtLPB+0UMb4=;
 b=OXL38PEgYIEwQYsJjNApbLl+0t2sHeSMQvqUPxX/417fBcno3jB9YEdB5dpSzYd1WriO
 vZIWR1w+nSpYskMMSmqlga9y7mobZYEUWCIX8rITvKqJJyhCmKTAR1kfAO4RtwM15MyA
 CTnPoPupmbj3RvCDoxC5iqHkL/vW9mzdxk9luV2B9krAl4Qge+M2DIuJjHc9LsIPgGSb
 uO+rIoKGax+7Dnepzps3T0bqTnk6Bs8orCM79XMOUhGHozPuI1z1sNgSAAN3QVX0O6n0
 BmkhkUUWz4h2DbsWUOQzAXm1o9tGwj2+LkTcrH/nP9RC9MO0eaoTQ+XKTD7l7njMQH+W Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tjm9r6ym8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 17:56:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CHqRB7133355;
        Fri, 12 Jul 2019 17:56:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tpefd7ke3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 17:56:46 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6CHuj7l010001;
        Fri, 12 Jul 2019 17:56:45 GMT
Received: from localhost (/10.159.245.178)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 10:56:45 -0700
Date:   Fri, 12 Jul 2019 10:56:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Boaz Harrosh <boaz@plexistor.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
Message-ID: <20190712175644.GQ1654093@magnolia>
References: <20190711140012.1671-1-jack@suse.cz>
 <20190711140012.1671-4-jack@suse.cz>
 <CAOQ4uxh-xpwgF-wQf1ozaZ3yg8nWuBvSyLr_ZFQpkA=coW1dxA@mail.gmail.com>
 <20190711154917.GW1404256@magnolia>
 <20190712120004.GB24009@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712120004.GB24009@quack2.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9316 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9316 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120182
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:00:04PM +0200, Jan Kara wrote:
> On Thu 11-07-19 08:49:17, Darrick J. Wong wrote:
> > On Thu, Jul 11, 2019 at 06:28:54PM +0300, Amir Goldstein wrote:
> > > > +{
> > > > +       struct xfs_inode *ip = XFS_I(file_inode(file));
> > > > +       int ret;
> > > > +
> > > > +       /* Readahead needs protection from hole punching and similar ops */
> > > > +       if (advice == POSIX_FADV_WILLNEED)
> > > > +               xfs_ilock(ip, XFS_IOLOCK_SHARED);
> > 
> > It's good to fix this race, but at the same time I wonder what's the
> > impact to processes writing to one part of a file waiting on IOLOCK_EXCL
> > while readahead holds IOLOCK_SHARED?
> > 
> > (bluh bluh range locks ftw bluh bluh)
> 
> Yeah, with range locks this would have less impact. Also note that we hold
> the lock only during page setup and IO submission. IO itself will already
> happen without IOLOCK, only under page lock. But that's enough to stop the
> race.

> > Do we need a lock for DONTNEED?  I think the answer is that you have to
> > lock the page to drop it and that will protect us from <myriad punch and
> > truncate spaghetti> ... ?
> 
> Yeah, DONTNEED is just page writeback + invalidate. So page lock is enough
> to protect from anything bad. Essentially we need IOLOCK only to protect
> the places that creates new pages in page cache.
> 
> > > > +       ret = generic_fadvise(file, start, end, advice);
> > > > +       if (advice == POSIX_FADV_WILLNEED)
> > > > +               xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> > 
> > Maybe it'd be better to do:
> > 
> > 	int	lockflags = 0;
> > 
> > 	if (advice == POSIX_FADV_WILLNEED) {
> > 		lockflags = XFS_IOLOCK_SHARED;
> > 		xfs_ilock(ip, lockflags);
> > 	}
> > 
> > 	ret = generic_fadvise(file, start, end, advice);
> > 
> > 	if (lockflags)
> > 		xfs_iunlock(ip, lockflags);
> > 
> > Just in case we some day want more or different types of inode locks?
> 
> OK, will do. Just I'll get to testing this only after I return from
> vacation.

<nod>

--D
> 
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
