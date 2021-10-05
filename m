Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681EA42280F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhJENip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:38:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234694AbhJENim (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 09:38:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195DXtm5019131;
        Tue, 5 Oct 2021 09:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=ektqZ/mfyb7dAOJNyP0mSMY39E6jfqwsUuut/kZQ/C4=;
 b=rtaPLdNiOoA7CYBFJXvMHcYiL5pV09stDD7fjYmjaXbwvvG/IW9khIAf16M2r66e1WEr
 C5RBbNVUrq+Xg6mGcGAl2XTAEMnnSQimDDniNZVYt5EKMji3gKPgn13xZLFlP/TtvdMB
 bev2vli7tCvr35ZUlVbiIX7A9kHJLlKO56aN8e+hqiKAJTJlvibDj/y7A0nCP0i0Khd/
 pwJDJvSD8t0uTDDKvoLqrr9xY3af9pJCl6C+WgEO6KVyrONRr2CsysxDA3Cgp7Hk0vnD
 Uv+Gq9kzd9tTcPUum+pvoAc59h/aM+a9titm47a7yAmMXVxW+MH8da40jPetsZQg+jBw Qg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgnm9bef6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:36:45 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195DWj7W022778;
        Tue, 5 Oct 2021 13:36:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3bef29gsxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:36:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195DadM83867170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:36:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 216CE52069;
        Tue,  5 Oct 2021 13:36:39 +0000 (GMT)
Received: from osiris (unknown [9.145.46.219])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id CEF5A5207E;
        Tue,  5 Oct 2021 13:36:38 +0000 (GMT)
Date:   Tue, 5 Oct 2021 15:36:37 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Juergen Gross <jgross@suse.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] s390: Fix strrchr() implementation
Message-ID: <YVxU5fNTpFt/P0wk@osiris>
References: <20211005120836.60630-1-roberto.sassu@huawei.com>
 <YVxP0OoUWQvhmqkq@osiris>
 <4eb4c1ea-d392-62fd-201f-472f24496f46@suse.com>
 <923ea0761d4d45158acbd1347d9bb6b5@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <923ea0761d4d45158acbd1347d9bb6b5@huawei.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 67M2sR0VWEH4Q98q3R6yU8XdcCyxG-A-
X-Proofpoint-ORIG-GUID: 67M2sR0VWEH4Q98q3R6yU8XdcCyxG-A-
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 impostorscore=0 mlxlogscore=936 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050080
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 01:30:45PM +0000, Roberto Sassu wrote:
> > From: Juergen Gross [mailto:jgross@suse.com]
> > Sent: Tuesday, October 5, 2021 3:25 PM
> > On 05.10.21 15:14, Heiko Carstens wrote:
> > > On Tue, Oct 05, 2021 at 02:08:36PM +0200, Roberto Sassu wrote:
> > >> Fix two problems found in the strrchr() implementation for s390
> > >> architectures: evaluate empty strings (return the string address instead of
> > >> NULL, if '\0' is passed as second argument); evaluate the first character
> > >> of non-empty strings (the current implementation stops at the second).
> > >>
> > >> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > >> Cc: stable@vger.kernel.org
> > >> Reported-by: Heiko Carstens <hca@linux.ibm.com> (incorrect behavior with
> > empty strings)
> > >> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > >> ---
> > >>   arch/s390/lib/string.c | 15 +++++++--------
> > >>   1 file changed, 7 insertions(+), 8 deletions(-)
> > >
> > > Applied, thanks!
> > >
> > 
> > Really? I just wanted to write a response: len is unsigned (size_t)
> > and compared to be >= 0, which sounds like always true.
> 
> Thanks for catching this. Will fix it.

I'll fix it. No need to resend.
