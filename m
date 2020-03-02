Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79C5176118
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 18:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgCBRdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 12:33:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726997AbgCBRdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 12:33:11 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022HLN0p091335
        for <stable@vger.kernel.org>; Mon, 2 Mar 2020 12:33:09 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yh0du6yv8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 02 Mar 2020 12:33:09 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Mon, 2 Mar 2020 17:33:07 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Mar 2020 17:33:04 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 022HX3jL64749652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 17:33:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1111B52050;
        Mon,  2 Mar 2020 17:33:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.229.179])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 015595204E;
        Mon,  2 Mar 2020 17:33:01 +0000 (GMT)
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
Date:   Mon, 02 Mar 2020 12:33:01 -0500
In-Reply-To: <a5e0cdc4839e478d926b90bd5ba0857c@huawei.com>
References: <20200210100048.21448-1-roberto.sassu@huawei.com>
         <20200210100048.21448-3-roberto.sassu@huawei.com>
         <1581373420.5585.920.camel@linux.ibm.com>
         <6955307747034265bd282bf68c368f34@huawei.com>
         <1583156506.8544.60.camel@linux.ibm.com>
         <8a6fb34e18b147fa811e82c78fb30d66@huawei.com>
         <1583160394.8544.89.camel@linux.ibm.com>
         <a5e0cdc4839e478d926b90bd5ba0857c@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030217-0028-0000-0000-000003E013D9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030217-0029-0000-0000-000024A53D9C
Message-Id: <1583170381.8544.113.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_06:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=847 lowpriorityscore=0 mlxscore=0
 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0 impostorscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003020116
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-03-02 at 15:11 +0000, Roberto Sassu wrote:


> > Yes, preference is given to the IMA default algorithm, but it should
> > fall back to using SHA256 or SHA1, based on the TPM.
> 
> Ok. The patch already does it even if the TPM version is not checked.
> For TPM 1.2, if the default algorithm is not SHA1 the patch will select
> the first PCR bank (SHA1).
> 
> Should I send a new patch which explicitly checks the TPM version?

Checking the TPM version shouldn't be necessary.  The code currently
sets bank_idx to the HASH_ALGO_SHA256.  If instead of initializing
bank_idx to 0, initialize it to the nr_allocated_banks or -1.  As long
as the bank_idx value is the same as the initialized value, set the
bank_idx to HASH_ALGO_SHA1.

The subsequent bank_idx would then be limited to testing for the
initialized value.

Mimi

