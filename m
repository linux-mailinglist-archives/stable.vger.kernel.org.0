Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00A5175D80
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 15:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgCBOqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 09:46:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727121AbgCBOqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 09:46:44 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022EkCUn128915
        for <stable@vger.kernel.org>; Mon, 2 Mar 2020 09:46:43 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yfmyqs00k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 09:46:42 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 2 Mar 2020 14:46:40 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Mar 2020 14:46:37 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 022EkarV55705680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 14:46:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 248075204F;
        Mon,  2 Mar 2020 14:46:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.229.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 105105204E;
        Mon,  2 Mar 2020 14:46:34 +0000 (GMT)
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
Date:   Mon, 02 Mar 2020 09:46:34 -0500
In-Reply-To: <8a6fb34e18b147fa811e82c78fb30d66@huawei.com>
References: <20200210100048.21448-1-roberto.sassu@huawei.com>
         <20200210100048.21448-3-roberto.sassu@huawei.com>
         <1581373420.5585.920.camel@linux.ibm.com>
         <6955307747034265bd282bf68c368f34@huawei.com>
         <1583156506.8544.60.camel@linux.ibm.com>
         <8a6fb34e18b147fa811e82c78fb30d66@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030214-0016-0000-0000-000002EC4EF2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030214-0017-0000-0000-0000334F91DB
Message-Id: <1583160394.8544.89.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_05:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 malwarescore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020108
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> > > > On Mon, 2020-02-10 at 11:00 +0100, Roberto Sassu wrote: 
> > My initial patch attempted to use any common TPM and kernel hash
> > algorithm to calculate the boot_aggregate.  The discussion with James
> > was pretty clear, which you even stated in the Changelog.  Either we
> > use the IMA default hash algorithm, SHA256 for TPM 2.0 or SHA1 for TPM
> > 1.2 for the boot-aggregate.
> 
> Ok, I didn't understand fully. I thought we should use the default IMA
> algorithm and select SHA256 as fallback choice for TPM 2.0 if there is no
> PCR bank for default algorithm.

Yes, preference is given to the IMA default algorithm, but it should
fall back to using SHA256 or SHA1, based on the TPM.

> I additionally implemented the logic to
> select the first PCR bank if the SHA256 PCR bank is not available but I can
> remove it.
> 
> SHA256 should be the minimum requirement for boot aggregate. The
> advantage of using the default IMA algorithm is that it will be possible to
> select stronger algorithms when they are supported by the TPM. We might
> introduce a new option to specify only the algorithm for boot aggregate,
> like James suggested to support embedded systems. Let me know which
> option you prefer.

I don't remember James saying that, but if the community really wants
that support, then it should be upstreamed independently, as a
separate patch.  Let's first get the basics working.

thanks,

Mimi

