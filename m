Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCCF281748
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 17:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgJBP6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 11:58:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBP6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 11:58:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092FjE6k065785;
        Fri, 2 Oct 2020 15:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=BWDjDe4zoMLNH+jhuLzMN3K/jKAbI/nl40X0SJF4P+8=;
 b=Zk3kZcHgLksZSz9wI1aA9TNlecIzfm6KZHOwTJ95EXLzmGtV5tDjvOIgQ4h6GcLuffCW
 rwZbgJ6IFpy96u7wBlKMW2vyh8s8SuxbKuQFMKyvzKblan+cRfttZmaUEwbAWg+WibcV
 aF6C5HnM53US4/HcS2VhcZH9qvC/MWrmYq9p/ocPLAPW/tImKzSQ8O20dIBN+cPqLBAB
 2LdyClBV1eCN1/irUmesHfARTi8hQ2tU5VP/Sb7XsPK4qy/UReqrVXPHR/Z2U7c2agda
 Fwh6eL/2eP6LFDVaUpk4CwoGuzUUfd6JbDuQWSLbR/Ir3Z3CtC+XLkI7Nv4gZy+hs6LK 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9nkm46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 15:58:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092FetZx100638;
        Fri, 2 Oct 2020 15:58:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdxrnf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 15:58:43 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092FwgVG027616;
        Fri, 2 Oct 2020 15:58:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 08:58:41 -0700
Date:   Fri, 2 Oct 2020 08:58:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Sasha Levin <sashal@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH STABLE V2] xfs: trim IO to found COW extent limit
Message-ID: <20201002155841.GW49547@magnolia>
References: <5d2f4fc1-e498-c45e-3d57-9c2d7ac275e6@sandeen.net>
 <20201002130740.GF2415204@sasha-vm>
 <300427ae-6135-29cd-6cbe-8fa2c4efb8d5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <300427ae-6135-29cd-6cbe-8fa2c4efb8d5@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020121
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 02, 2020 at 08:19:43AM -0500, Eric Sandeen wrote:
> On 10/2/20 8:07 AM, Sasha Levin wrote:
> > On Thu, Oct 01, 2020 at 08:34:48AM -0500, Eric Sandeen wrote:
> >> A bug existed in the XFS reflink code between v5.1 and v5.5 in which
> >> the mapping for a COW IO was not trimmed to the mapping of the COW
> >> extent that was found.  This resulted in a too-short copy, and
> >> corruption of other files which shared the original extent.
> >>
> >> (This happened only when extent size hints were set, which bypasses
> >> delalloc and led to this code path.)
> >>
> >> This was (inadvertently) fixed upstream with
> >>
> >> 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
> >>
> >> and related patches which moved lots of this functionality to
> >> the iomap subsystem.
> >>
> >> Hence, this is a -stable only patch, targeted to fix this
> >> corruption vector without other major code changes.
> >>
> >> Fixes: 78f0cc9d55cb ("xfs: don't use delalloc extents for COW on files with extsize hints")
> >> Cc: <stable@vger.kernel.org> # 5.4.x
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >> ---
> >>
> >> V2: Fix typo in subject, add reviewers
> >>
> >> I've tested this with a targeted reproducer (in next email) as well as
> >> with xfstests.
> >>
> >> There is also now a testcase for xfstests submitted upstream
> >>
> >> Stable folk, not sure how to send a "stable only" patch, or if that's even
> >> valid.  Assuming you're willing to accept it, I would still like to have
> >> some formal Reviewed-by's from the xfs developer community before it gets
> >> merged.
> > 
> > This is perfect stable-process-wise :) Will wait for reviews/acks before
> > merging.
> 
> Thansk Sasha - the reviews/acks were given for V1 (hch & darrick), V2
> adds them to the commit log (see above) and fixes a typo in the
> subject.

Still looks ok ;)

Still-Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Thanks,
> -Eric
> 
