Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583552B0CA8
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 19:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgKLScR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 13:32:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57266 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgKLScR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 13:32:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACIU2pR060467;
        Thu, 12 Nov 2020 18:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cVHqa7cYK8ZzuWSg4XDZr/ToewPKAuw4mG9HRNAE6RY=;
 b=rw/73x3Kx5OeS6XcHAYZFDRKO4ZDPzd7kL0umaipZ5XIyxBVCqB3uF7I24ILCYZLOqCm
 W3RoEmv0UNjduS1cHD2heyDW65F8AlyEBqJEySFEgqVot3E8gKVct44k8JHssu/9syZB
 hB27pGvBIMg8RjPR9IMc2TY7hxlS5hwGp8gXO2Of5/IcjKOrGtoy2RuHe7E9OOmxa1th
 gbzTmzBPz94A2Hk0Sib6QkJLHuTVwgrxTrK6o2EWaBUhqKW3HMRv9bRe+PheT6CkYWf9
 TCJTpgP3GomjxuS8BwNKvl/qr5tzrztgLDfgbp6OSSw8LFqGmrmN23IQuolsXHC25z3Z wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b765n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 18:32:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACIPCxN043230;
        Thu, 12 Nov 2020 18:30:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34rt56garw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 18:30:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACIU6fC022652;
        Thu, 12 Nov 2020 18:30:06 GMT
Received: from localhost (/10.159.255.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 10:30:05 -0800
Date:   Thu, 12 Nov 2020 10:30:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix signed calculation related to XFS_LITINO(mp)
Message-ID: <20201112183004.GU9695@magnolia>
References: <20201112063005.692054-1-hsiangkao@redhat.com>
 <3d04e9b3-f326-cbcd-e268-e4da40f35fa2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d04e9b3-f326-cbcd-e268-e4da40f35fa2@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120108
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 12, 2020 at 09:53:53AM -0600, Eric Sandeen wrote:
> On 11/12/20 12:30 AM, Gao Xiang wrote:
> > Currently, commit e9e2eae89ddb dropped a (int) decoration from
> > XFS_LITINO(mp), and since sizeof() expression is also involved,
> > the result of XFS_LITINO(mp) is simply as the size_t type
> > (commonly unsigned long).
> 
> Thanks for finding this!  Let me think through it a little.
>  
> > Considering the expression in xfs_attr_shortform_bytesfit():
> >   offset = (XFS_LITINO(mp) - bytes) >> 3;
> > let "bytes" be (int)340, and
> >     "XFS_LITINO(mp)" be (unsigned long)336.
> > 
> > on 64-bit platform, the expression is
> >   offset = ((unsigned long)336 - (int)340) >> 8 =
> 
> This should be >> 3, right.
> 
> >            (int)(0xfffffffffffffffcUL >> 3) = -1
> > 
> > but on 32-bit platform, the expression is
> >   offset = ((unsigned long)336 - (int)340) >> 8 =
> 
> and >> 3 here as well.
> 
> >            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> > instead.
> 
> Ok.  But wow, that magical cast to (int) in XFS_LITINO isn't at
> all clear to me.
> 
> XFS_LITINO() indicates a /size/ - fixing this problem by making it a
> signed value feels very strange, but I'm not sure what would be better,
> yet.

TBH I think this needs to be cleaned up -- what is "LITINO", anyway?

I'm pretty sure it's the size of the literal area, aka everything after
the inode core, where the forks live?

And, uh, can these things get turned into static inline helpers instead
of weird macros?  Separate patches, obviously.

> 
> > Therefore, one result is
> >   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> >   assertion failure in xfs_idata_realloc().
> > 
> > , which can be triggered with the following commands:
> >  touch a;
> >  setfattr -n user.0 -v "`seq 0 80`" a;
> >  setfattr -n user.1 -v "`seq 0 80`" a
> > on 32-bit platform.
> 
> Can you please write an xfstest for this? :)

Seconded.

If this is the fix for the corruption report that dgilmore reported on
IRC, this should credit him as the reporter and/or tester.  Especially
because I thought this was just a "oh I found this via code review"
until someone else pointed out that this was actually a fix for
something that a user hit in the field.

The difference is that we're headed towards -rc4 and I'm much more
willing to hold up posting the xfs-5.11-merge branch to get in fixes for
user-reported problems.

> > Fix it by restoring (int) decorator to XFS_LITINO(mp) since
> > int type for XFS_LITINO(mp) is safe and all pre-exist signed
> > calculations are correct.
> > 
> > Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> > Cc: <stable@vger.kernel.org> # 5.7+
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > I'm not sure this is the preferred way or just simply fix
> > xfs_attr_shortform_bytesfit() since I don't look into the
> > rest of XFS_LITINO(mp) users. Add (int) to XFS_LITINO(mp)
> > will avoid all potential regression at least.
> > 
> >  fs/xfs/libxfs/xfs_format.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index dd764da08f6f..f58f0a44c024 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1061,7 +1061,7 @@ enum xfs_dinode_fmt {
> >  		sizeof(struct xfs_dinode) : \
> >  		offsetof(struct xfs_dinode, di_crc))>  #define XFS_LITINO(mp) \
> > -	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
> > +	((int)((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb)))
> 
> If we do keep the (int) cast here we at least need a comment explaining why
> it cannot be removed, unless there is a better way to solve the problem.

It's still weird, because "size of literal inode area" isn't a signed
quantity because you can't have a negative size.

> I wonder if explicitly making XFS_LITINO() cast to a size_t would be
> best, and then in xfs_attr_shortform_bytesfit() we just quickly reject
> the query if the bytes are larger than the literal area:
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index bb128db..5588c2e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -535,6 +535,10 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
>         int                     maxforkoff;
>         int                     offset;
>  
> +       /* Is there no chance we can fit? */
> +       if (bytes > XFS_LITINO(mp))
> +               return 0;
> +
>         /* rounded down */
>         offset = (XFS_LITINO(mp) - bytes) >> 3;

So if LITINO is 336 and the caller asked for 350 bytes, offset will be
negative here.  However, offset is the proposed forkoff, right?  It
doesn't make any sense to have a negative forkoff, so I think Eric's
(bytes > LITINO) suggestion above is correct.

This patch was hard to review because the comment for
xfs_attr_shortform_bytesfit mentions "...the requested number of
additional bytes", but the bytes parameter represents the total number
of attr fork bytes we want, not a delta over what we have right now.
Can someone please fix that comment too?

--D

> 
> or, maybe simply:
> 
> -        offset = (XFS_LITINO(mp) - bytes) >> 3;
> +        offset = (int)(XFS_LITINO(mp) - bytes) >> 3;
> 
> to be sure that the arithmetic doesn't get promoted to unsigned before the shift?
> 
> or maybe others have better ideas.
> 
> -Eric
> 
>   
> >  /*
> >   * Inode data & attribute fork sizes, per inode.
> > 
