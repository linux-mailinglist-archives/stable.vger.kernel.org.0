Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD83B1B7880
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 16:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgDXOqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 10:46:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgDXOqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 10:46:00 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OEXs8s090025;
        Fri, 24 Apr 2020 10:45:51 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jtk3xcwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 10:45:51 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03OEjc79018177;
        Fri, 24 Apr 2020 14:45:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 30fs65h4yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 14:45:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OEjl9u58589366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 14:45:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 012A6A4051;
        Fri, 24 Apr 2020 14:45:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7903A4040;
        Fri, 24 Apr 2020 14:45:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.204.171])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 14:45:45 +0000 (GMT)
Message-ID: <1587739544.5190.14.camel@linux.ibm.com>
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
Date:   Fri, 24 Apr 2020 10:45:44 -0400
In-Reply-To: <59a280b928db4c478f660d14c33cdd87@huawei.com>
References: <20200325161116.7082-1-roberto.sassu@huawei.com>
         <20200325161116.7082-3-roberto.sassu@huawei.com>
         <1587588987.5165.20.camel@linux.ibm.com>
         <11984a05a5624f64aed1ec6b0d0b75ff@huawei.com>
         <1587660781.5610.15.camel@linux.ibm.com>
         <59a280b928db4c478f660d14c33cdd87@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_07:2020-04-24,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240117
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-04-24 at 12:18 +0000, Roberto Sassu wrote:

> > On Thu, 2020-04-23 at 10:21 +0000, Roberto Sassu wrote:
> > > > Hi Roberto, Krsysztof,
> > > >
> > > > On Wed, 2020-03-25 at 17:11 +0100, Roberto Sassu wrote:
> > > > > From: Krzysztof Struczynski <krzysztof.struczynski@huawei.com>
> > > > >
> > > > > Function hash_long() accepts unsigned long, while currently only one
> > byte
> > > > > is passed from ima_hash_key(), which calculates a key for ima_htable.
> > > > Use
> > > > > more bytes to avoid frequent collisions.
> > > > >
> > > > > Length of the buffer is not explicitly passed as a function parameter,
> > > > > because this function expects a digest whose length is greater than
> > the
> > > > > size of unsigned long.
> > > >
> > > > Somehow I missed the original report of this problem https://lore.kern
> > > > el.org/patchwork/patch/674684/.  This patch is definitely better, but
> > > > how many unique keys are actually being used?  Is it anywhere near
> > > > IMA_MEASURE_HTABLE_SIZE(512)?
> > >
> > > I did a small test (with 1043 measurements):
> > >
> > > slots: 250, max depth: 9 (without the patch)
> > > slots: 448, max depth: 7 (with the patch)
> > 
> > 448 out of 512 slots are used.
> > 
> > >
> > > Then, I increased the number of bits to 10:
> > >
> > > slots: 251, max depth: 9 (without the patch)
> > > slots: 660, max depth: 4 (with the patch)
> > 
> > 660 out of 1024 slots are used.
> > 
> > I wonder if there is any benefit to hashing a digest, instead of just
> > using the first bits.
> 
> Before I calculated max depth until there is a match, not the full depth.
> 
> #1
> return hash_long(*((unsigned long *)digest), IMA_HASH_BITS);
> #define IMA_HASH_BITS 9
> 
> Runtime measurements: 1488
> Violations: 0
> Slots (used/available): 484/512
> Max depth hash table: 10
> 
> #2
> return *(unsigned long *)digest % IMA_MEASURE_HTABLE_SIZE;
> #define IMA_HASH_BITS 9
> 
> Runtime measurements: 1491
> Violations: 2
> Slots (used/available): 489/512
> Max depth hash table: 10
> 
> #3
> return hash_long(*((unsigned long *)digest), IMA_HASH_BITS);
> #define IMA_HASH_BITS 10
> 
> Runtime measurements: 1489
> Violations: 0
> Slots (used/available): 780/1024
> Max depth hash table: 6
> 
> #4
> return *(unsigned long *)digest % IMA_MEASURE_HTABLE_SIZE;
> #define IMA_HASH_BITS 10
> 
> Runtime measurements: 1489
> Violations: 0
> Slots (used/available): 793/1024
> Max depth hash table: 6

At least for this measurement list sample, there doesn't seem to be
any benefit to hashing the digest.  In terms of increasing the number
of slots, the additional memory is minimal and shouldn't negatively
affect small embedded devices.  Please make sure checkpatch doesn't
flag it.

thanks,

Mimi
