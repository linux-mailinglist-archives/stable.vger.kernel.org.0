Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5189F1543E4
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 13:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgBFMRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 07:17:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727728AbgBFMRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 07:17:18 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 016CDdjs031760
        for <stable@vger.kernel.org>; Thu, 6 Feb 2020 07:17:17 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xyhq00f8a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 06 Feb 2020 07:17:16 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 6 Feb 2020 12:17:12 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 12:17:08 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 016CH7Ms58720370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 12:17:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 869F552051;
        Thu,  6 Feb 2020 12:17:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.140.59])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 99E505204F;
        Thu,  6 Feb 2020 12:17:06 +0000 (GMT)
Subject: Re: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot aggregate
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Thu, 06 Feb 2020 07:17:06 -0500
In-Reply-To: <b1507c1121b64b3abc00e154fcfeef65@huawei.com>
References: <20200205103317.29356-1-roberto.sassu@huawei.com>
         <20200205103317.29356-3-roberto.sassu@huawei.com>
         <1580936432.5585.309.camel@linux.ibm.com>
         <b1507c1121b64b3abc00e154fcfeef65@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020612-0012-0000-0000-0000038443A0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020612-0013-0000-0000-000021C0B155
Message-Id: <1580991426.5585.334.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_01:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002060093
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-02-06 at 09:36 +0000, Roberto Sassu wrote:
> > Hi Roberto,
> > 
> > On Wed, 2020-02-05 at 11:33 +0100, Roberto Sassu wrote:
> > 
> > <snip>
> > 
> > > Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > > Suggested-by: James Bottomley
> > <James.Bottomley@HansenPartnership.com>
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > Cc: stable@vger.kernel.org
> > 
> > Cc'ing stable resulted in Sasha's automated message.  If you're going
> > to Cc stable, then please include the stable kernel release (e.g. Cc:
> > stable@vger.kernel.org # v5.3).  Also please include a "Fixes" tag.
> >  Normally only bug fixes are backported.
> 
> Ok, will add the kernel version. I also thought which commit I should
> mention in the Fixes tag. IMA always read the SHA1 bank from the
> beginning. I could mention the patch that introduces the new API
> to read other banks, but I'm not sure. What do you think?

This patch is dependent on nr_allocated_banks.  Please try applying
this patch to the earliest stable kernel with the commit that
introduces nr_allocated_banks and test to make sure it works properly.

thanks,

Mimi

