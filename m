Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501F0175BF5
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 14:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgCBNmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 08:42:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727768AbgCBNmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 08:42:07 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022Da5Ug016346
        for <stable@vger.kernel.org>; Mon, 2 Mar 2020 08:42:06 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yfmg00e4v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 08:42:02 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 2 Mar 2020 13:41:53 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Mar 2020 13:41:49 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 022Dfm5K59572276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 13:41:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9644D11C04A;
        Mon,  2 Mar 2020 13:41:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87F6B11C050;
        Mon,  2 Mar 2020 13:41:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.229.179])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Mar 2020 13:41:47 +0000 (GMT)
Subject: Re: [PATCH v3 2/8] ima: Switch to ima_hash_algo for boot aggregate
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Mon, 02 Mar 2020 08:41:46 -0500
In-Reply-To: <6955307747034265bd282bf68c368f34@huawei.com>
References: <20200210100048.21448-1-roberto.sassu@huawei.com>
         <20200210100048.21448-3-roberto.sassu@huawei.com>
         <1581373420.5585.920.camel@linux.ibm.com>
         <6955307747034265bd282bf68c368f34@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030213-0016-0000-0000-000002EC466F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030213-0017-0000-0000-0000334F8904
Message-Id: <1583156506.8544.60.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_04:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 malwarescore=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020101
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-02-11 at 10:09 +0000, Roberto Sassu wrote:
> > -----Original Message-----

Please find/use a mailer that doesn't include this junk.

> > On Mon, 2020-02-10 at 11:00 +0100, Roberto Sassu wrote:
> > > boot_aggregate is the first entry of IMA measurement list. Its purpose is
> > > to link pre-boot measurements to IMA measurements. As IMA was
> > designed to
> > > work with a TPM 1.2, the SHA1 PCR bank was always selected.
> > >
> > > Currently, even if a TPM 2.0 is used, the SHA1 PCR bank is selected.
> > > However, the assumption that the SHA1 PCR bank is always available is not
> > > correct, as PCR banks can be selected with the PCR_Allocate() TPM
> > command.
> > >
> > > This patch tries to use ima_hash_algo as hash algorithm for
> > boot_aggregate.
> > > If no PCR bank uses that algorithm, the patch tries to find the SHA256 PCR
> > > bank (which is mandatory in the TCG PC Client specification).
> > 
> > Up to here, the patch description matches the code.
> > > If also this
> > > bank is not found, the patch selects the first one. If the TPM algorithm
> > > of that bank is not mapped to a crypto ID, boot_aggregate is set to zero.
> > 
> > This comment and the one inline are left over from previous version.
> 
> Hi Mimi
> 
> actually the code does what is described above. bank_idx is initially
> set to zero and remains as it is if there is no PCR bank for the default
> IMA algorithm or SHA256.

Sorry for the delay in continuing to review this patch set.  It took a
while to write ima-evm-utils regression tests for it.

Dmitry and you were the ones that initiated ima-evm-utils, saying
there should a single package for signing files and integrity testing.
 The features in ima-evm-utils should reflect what is actually
upstreamed in the kernel.  (Currently there are a few experimental
features which were never upstreamed.  I'd like to remove them, but am
a bit concerned that they are being used.)  I'd appreciate your help
in keeping ima-evm-utils up to date.  It will help simplify
upstreaming new kernel features.

My initial patch attempted to use any common TPM and kernel hash
algorithm to calculate the boot_aggregate.  The discussion with James
was pretty clear, which you even stated in the Changelog.  Either we
use the IMA default hash algorithm, SHA256 for TPM 2.0 or SHA1 for TPM
1.2 for the boot-aggregate.

thanks,

Mimi

