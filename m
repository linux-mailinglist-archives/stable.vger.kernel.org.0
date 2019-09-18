Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549E7B67BA
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 18:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbfIRQHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 12:07:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfIRQHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 12:07:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IFxtmx154960;
        Wed, 18 Sep 2019 16:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=rdHGkEXVnsLqXXMuOn321K1NAe6rVR7Cugi8O0TDiAQ=;
 b=RvTMIJ0Wh6JBKNQIEMUS8XyEt8widyel6SVg0Rd6vGlf50mhCXj20uqTXlG7uVIjgO79
 TohdWwkUn+yjUKKKtEF87oeChpe+2wRhQIge+iHcgoHqobZCv2FZdJEGvXnpTNXeXI9Z
 PN7maeTCNrRubFs7pHlRQ6jgw+n2IUs/CpPP13rKMijtvQnVxYN7tghBc7oQBHKE17DK
 pVd6alL8n4z0un1Ofv/6onjUD7Lc3uFS2cz4wNuGKGS34pV2sMCtaadY+nujU9gn8cd1
 neR5xkMtXF2RmoMFyCfrgaxzDqcguTGHaa9c5q5ZzXfmJZRg58PyHwIgjbSpVBKLQYLK dQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v385e4y5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:07:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IFwfQu058733;
        Wed, 18 Sep 2019 16:07:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v37m9v52c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 16:07:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IG7E9Z010968;
        Wed, 18 Sep 2019 16:07:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 09:07:14 -0700
Date:   Wed, 18 Sep 2019 09:07:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
Message-ID: <20190918160712.GV2229799@magnolia>
References: <20190829131034.10563-1-jack@suse.cz>
 <20190829131034.10563-4-jack@suse.cz>
 <20190829155204.GD5354@magnolia>
 <20190830152449.GA25069@quack2.suse.cz>
 <20190918123123.GC31891@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918123123.GC31891@quack2.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180154
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 02:31:24PM +0200, Jan Kara wrote:
> On Fri 30-08-19 17:24:49, Jan Kara wrote:
> > On Thu 29-08-19 08:52:04, Darrick J. Wong wrote:
> > > On Thu, Aug 29, 2019 at 03:10:34PM +0200, Jan Kara wrote:
> > > > Hole puching currently evicts pages from page cache and then goes on to
> > > > remove blocks from the inode. This happens under both XFS_IOLOCK_EXCL
> > > > and XFS_MMAPLOCK_EXCL which provides appropriate serialization with
> > > > racing reads or page faults. However there is currently nothing that
> > > > prevents readahead triggered by fadvise() or madvise() from racing with
> > > > the hole punch and instantiating page cache page after hole punching has
> > > > evicted page cache in xfs_flush_unmap_range() but before it has removed
> > > > blocks from the inode. This page cache page will be mapping soon to be
> > > > freed block and that can lead to returning stale data to userspace or
> > > > even filesystem corruption.
> > > > 
> > > > Fix the problem by protecting handling of readahead requests by
> > > > XFS_IOLOCK_SHARED similarly as we protect reads.
> > > > 
> > > > CC: stable@vger.kernel.org
> > > > Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com/
> > > > Reported-by: Amir Goldstein <amir73il@gmail.com>
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > 
> > > Is there a test on xfstests to demonstrate this race?
> > 
> > No, but I can try to create one.
> 
> I was experimenting with this but I could not reproduce the issue in my
> test VM without inserting artificial delay at appropriate place... So I
> don't think there's much point in the fstest for this.

<shrug> We've added debugging knobs to XFS that inject delays to
demonstrate race conditions that are hard to reproduce, but OTOH it's
more fun to have a generic/ test that you can use to convince the other
fs maintainers to take your patches. :)

--D

> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
