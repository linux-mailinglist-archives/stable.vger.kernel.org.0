Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F8110D2C
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 21:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfEAT2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 15:28:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59458 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfEAT2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 15:28:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41JJiwf014200;
        Wed, 1 May 2019 19:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=axQU61zNPf2pA7LWLjeMxuK4W1F18U79UO1y3Yex6/U=;
 b=LGik3DwWRRn92qo7GPgjVrPBjoBHtY6KiV/5NAXbThbiiTgD0FwoVjsivhtCFqm16dQR
 FV3yFx3HaID6jJBkED3EO1WhginLsHCZmAIqz/NGpMs9B7tfObvHa98sa/0LFyKgV4Vv
 TC8RlRpC+muUh22bVUijgRNLwxFRVtoZdvbXXxh34xZSa7afgN7YOhY/o+oRixn2j3mS
 KHdyL9mTIUxU4DEtrnAmBGEHPp93o0Y+AWUNqP4vPbHJbi02p0PRkhbG2a38aZiDQHot
 m8MIdI6bGrBq3vo71uiflO2anr5TdC5I9Un4GdW9lzzyxji353dpU5OUHQ5jSF5LVRtA UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2s6xhymktn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 19:28:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41JRg86037907;
        Wed, 1 May 2019 19:28:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2s6xhhe5j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 19:28:26 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x41JSNYt026378;
        Wed, 1 May 2019 19:28:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 May 2019 12:28:23 -0700
Date:   Wed, 1 May 2019 12:28:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andre Noll <maan@tuebingen.mpg.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190501192822.GM5207@magnolia>
References: <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190501175129.GH2780@tuebingen.mpg.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905010121
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905010120
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 01, 2019 at 07:51:29PM +0200, Andre Noll wrote:
> On Wed, May 01, 19:15, Greg Kroah-Hartman wrote
> > On Wed, May 01, 2019 at 06:59:33PM +0200, Andre Noll wrote:
> > > On Wed, May 01, 08:36, Darrick J. Wong wrote
> > > > > > You could send this patch to the stable list, but my guess is that
> > > > > > they'd prefer a straight backport of all three commits...
> > > > > 
> > > > > Hm, cherry-picking the first commit onto 4.9,171 already gives
> > > > > four conflicting files. The conflicts are trivial to resolve (git
> > > > > cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
> > > > > compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
> > > > > (xfs: create a function to query all records in a btree) is needed as
> > > > > well. But then, applying 86210fbebae (xfs: move various type verifiers
> > > > > to common file) on top of that gives non-trivial conflicts.
> > > > 
> > > > Ah, I suspected that might happen.  Backports are hard. :(
> > > > 
> > > > I suppose one saving grace of the patch you sent is that it'll likely
> > > > break the build if anyone ever /does/ attempt a backport of those first
> > > > two commits.  Perhaps that is the most practical way forward.
> > > > 
> > > > > So, for automatic backporting we would need to cherry-pick even more,
> > > > > and each backported commit should be tested of course. Given this, do
> > > > > you still think Greg prefers a rather large set of straight backports
> > > > > over the simple commit that just pulls in the missing function?
> > > > 
> > > > I think you'd have to ask him that, if you decide not to send
> > > > yesterday's patch.
> > > 
> > > Let's try. I've added a sentence to the commit message which explains
> > > why a straight backport is not practical, and how to proceed if anyone
> > > wants to backport the earlier commits.
> > > 
> > > Greg: Under the given circumstances, would you be willing to accept
> > > the patch below for 4.9?
> > 
> > If the xfs maintainers say this is ok, it is fine with me.
> 
> Darrick said, he's in favor of the patch, so I guess I can add his
> Acked-by. Would you also like to see the ack from Dave (the author
> of the original commit)?

FWIW it seems fine to me, though Dave [cc'd] might have stronger opinions...

Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Anything else that needs to be changed?
> 
> Thanks
> Andre
> -- 
> Max Planck Institute for Developmental Biology
> Max-Planck-Ring 5, 72076 Tübingen, Germany. Phone: (+49) 7071 601 829
> http://people.tuebingen.mpg.de/maan/


