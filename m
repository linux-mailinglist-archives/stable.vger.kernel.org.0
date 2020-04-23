Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176D11B6156
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 18:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgDWQxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 12:53:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729715AbgDWQxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 12:53:09 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03NGXSUt136183
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 12:53:09 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30k09wu9j0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 12:53:08 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 23 Apr 2020 17:52:29 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Apr 2020 17:52:26 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03NGptFe53805508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 16:51:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 754D2A4065;
        Thu, 23 Apr 2020 16:53:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2AA4A405B;
        Thu, 23 Apr 2020 16:53:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.178.107])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Apr 2020 16:53:01 +0000 (GMT)
Subject: Re: [PATCH 3/5] ima: Fix ima digest hash table key calculation
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Thu, 23 Apr 2020 12:53:01 -0400
In-Reply-To: <11984a05a5624f64aed1ec6b0d0b75ff@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
         <20200325161116.7082-3-roberto.sassu@huawei.com>
         <1587588987.5165.20.camel@linux.ibm.com>
         <11984a05a5624f64aed1ec6b0d0b75ff@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042316-0008-0000-0000-000003762A0D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042316-0009-0000-0000-00004A97F7F0
Message-Id: <1587660781.5610.15.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_12:2020-04-23,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230128
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-04-23 at 10:21 +0000, Roberto Sassu wrote:
> > Hi Roberto, Krsysztof,
> > 
> > On Wed, 2020-03-25 at 17:11 +0100, Roberto Sassu wrote:
> > > From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
> > >
> > > Function hash_long() accepts unsigned long, while currently only one byte
> > > is passed from ima_hash_key(), which calculates a key for ima_htable.
> > Use
> > > more bytes to avoid frequent collisions.
> > >
> > > Length of the buffer is not explicitly passed as a function parameter,
> > > because this function expects a digest whose length is greater than the
> > > size of unsigned long.
> > 
> > Somehow I missed the original report of this problem https://lore.kern
> > el.org/patchwork/patch/674684/.  This patch is definitely better, but
> > how many unique keys are actually being used?  Is it anywhere near
> > IMA_MEASURE_HTABLE_SIZE(512)?
> 
> I did a small test (with 1043 measurements):
> 
> slots: 250, max depth: 9 (without the patch)
> slots: 448, max depth: 7 (with the patch)

448 out of 512 slots are used.

> 
> Then, I increased the number of bits to 10:
> 
> slots: 251, max depth: 9 (without the patch)
> slots: 660, max depth: 4 (with the patch)

660 out of 1024 slots are used.

I wonder if there is any benefit to hashing a digest, instead of just
using the first bits. 

> 
> > Do we need a new securityfs entry to display the number used?
> 
> Probably it is useful only if the administrator can decide the number of slots.

The securityfs suggestion was just a means for triggering the above
debugging info you provided.  Could you provide another patch with the
debugging info?

thanks,

Mimi

