Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100F8422818
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhJENlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:41:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233975AbhJENlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 09:41:20 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195D2Xpd012275;
        Tue, 5 Oct 2021 09:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=tT6DUCI8Nn5l3TgZ/p1pja91tBWJOPbiEOheEvkbJfY=;
 b=qL/IcTLxivt/wDGRMZ2ugp9gkDfL71Tp0dJapWG2AihfWL1bUmAw7Aqm0IYE7inIKeW0
 97RBCLLanoW5zypn+lIiFRLSTclEiXxEYyQxnMe8iMzlaiM9i2ewQSlwzS3IJZJGyh5c
 iAO3XjIr/M0GbBJytVCkmjijJO/ZKlxH4ITGM+Ia8UDhFDBB911R5ClEeqb1wVFJvbcL
 P6eXjhmcGFY3GQMe5sX+bCytfaX61XP3TdXtpVwdiNJ6CfBqVvMa/PNy541Ou1RskgU6
 V/CgN7gCQS7gTWYDJUfPuG5jUKlEBICh2cRtVwabh6AheLFuDKadaXo2T3pmOrwv1CKD bw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgq4e198h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:39:23 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195DXCnr021508;
        Tue, 5 Oct 2021 13:39:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2a2y6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:39:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195DdHUX35914172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:39:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FD565205F;
        Tue,  5 Oct 2021 13:39:17 +0000 (GMT)
Received: from osiris (unknown [9.145.46.219])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 3A29C52052;
        Tue,  5 Oct 2021 13:39:17 +0000 (GMT)
Date:   Tue, 5 Oct 2021 15:39:15 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>, gor@linux.ibm.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] s390: Fix strrchr() implementation
Message-ID: <YVxVg7sgn8PJ5MTk@osiris>
References: <20211005120836.60630-1-roberto.sassu@huawei.com>
 <YVxP0OoUWQvhmqkq@osiris>
 <4eb4c1ea-d392-62fd-201f-472f24496f46@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eb4c1ea-d392-62fd-201f-472f24496f46@suse.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FNUwN5TBOetqs59iNf8wVvAsalMmD82p
X-Proofpoint-ORIG-GUID: FNUwN5TBOetqs59iNf8wVvAsalMmD82p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 suspectscore=0
 spamscore=0 mlxscore=0 clxscore=1015 mlxlogscore=850 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050080
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 03:24:33PM +0200, Juergen Gross wrote:
> On 05.10.21 15:14, Heiko Carstens wrote:
> > On Tue, Oct 05, 2021 at 02:08:36PM +0200, Roberto Sassu wrote:
> > > Fix two problems found in the strrchr() implementation for s390
> > > architectures: evaluate empty strings (return the string address instead of
> > > NULL, if '\0' is passed as second argument); evaluate the first character
> > > of non-empty strings (the current implementation stops at the second).
> > > 
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Heiko Carstens <hca@linux.ibm.com> (incorrect behavior with empty strings)
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > ---
> > >   arch/s390/lib/string.c | 15 +++++++--------
> > >   1 file changed, 7 insertions(+), 8 deletions(-)
> > 
> > Applied, thanks!
> > 
> 
> Really? I just wanted to write a response: len is unsigned (size_t)
> and compared to be >= 0, which sounds like always true.

Yeah.. I did some out-of-tree tests, but of course using int instead
of unsigned int. However sparse complains also. So this wouldn't have
hit upstream.
Many thanks for pointing this out anyway!
