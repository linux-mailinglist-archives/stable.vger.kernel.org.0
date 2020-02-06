Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB604154412
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 13:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgBFMbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 07:31:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727825AbgBFMbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 07:31:24 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 016CQhbL147441
        for <stable@vger.kernel.org>; Thu, 6 Feb 2020 07:31:21 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xyhmch3xx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 06 Feb 2020 07:31:21 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 6 Feb 2020 12:31:19 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 12:31:15 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 016CVEm047906816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 12:31:14 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 547D911C04C;
        Thu,  6 Feb 2020 12:31:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 663DA11C05B;
        Thu,  6 Feb 2020 12:31:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.140.59])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Feb 2020 12:31:13 +0000 (GMT)
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
Date:   Thu, 06 Feb 2020 07:31:12 -0500
In-Reply-To: <17bfd3e2b7fa4f31a46a6688e4a6e34f@huawei.com>
References: <20200205103317.29356-1-roberto.sassu@huawei.com>
         <20200205103317.29356-3-roberto.sassu@huawei.com>
         <1580936432.5585.309.camel@linux.ibm.com>
         <b1507c1121b64b3abc00e154fcfeef65@huawei.com>
         <1580991426.5585.334.camel@linux.ibm.com>
         <17bfd3e2b7fa4f31a46a6688e4a6e34f@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20020612-0008-0000-0000-000003504B1D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020612-0009-0000-0000-00004A70DEEB
Message-Id: <1580992272.5585.337.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_01:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002060094
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-02-06 at 12:28 +0000, Roberto Sassu wrote:
> > -----Original Message-----
> > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > Sent: Thursday, February 6, 2020 1:17 PM
> > To: Roberto Sassu <roberto.sassu@huawei.com>;
> > James.Bottomley@HansenPartnership.com;
> > jarkko.sakkinen@linux.intel.com
> > Cc: linux-integrity@vger.kernel.org; linux-security-module@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Silviu Vlasceanu
> > <Silviu.Vlasceanu@huawei.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot
> > aggregate
> > 
> > On Thu, 2020-02-06 at 09:36 +0000, Roberto Sassu wrote:
> > > > Hi Roberto,
> > > >
> > > > On Wed, 2020-02-05 at 11:33 +0100, Roberto Sassu wrote:
> > > >
> > > > <snip>
> > > >
> > > > > Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > > > > Suggested-by: James Bottomley
> > > > <James.Bottomley@HansenPartnership.com>
> > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > Cc: stable@vger.kernel.org
> > > >
> > > > Cc'ing stable resulted in Sasha's automated message.  If you're going
> > > > to Cc stable, then please include the stable kernel release (e.g. Cc:
> > > > stable@vger.kernel.org # v5.3).  Also please include a "Fixes" tag.
> > > >  Normally only bug fixes are backported.
> > >
> > > Ok, will add the kernel version. I also thought which commit I should
> > > mention in the Fixes tag. IMA always read the SHA1 bank from the
> > > beginning. I could mention the patch that introduces the new API
> > > to read other banks, but I'm not sure. What do you think?
> > 
> > This patch is dependent on nr_allocated_banks.  Please try applying
> > this patch to the earliest stable kernel with the commit that
> > introduces nr_allocated_banks and test to make sure it works properly.
> 
> It also depends on 879b589210a9 ("tpm: retrieve digest size of unknown"
> algorithms with PCR read") which exported the mapping between TPM
> algorithm ID and crypto ID, and changed the definition of tpm_pcr_read()
> to read non-SHA1 PCR banks. It requires many patches, so backporting it
> is not a trivial task. I think the earliest kernel this patch can be backported to
> is 5.1.

Agreed.  Thank you for checking.

Mimi

