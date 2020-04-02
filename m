Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFEB19CDAB
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 01:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390306AbgDBXxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 19:53:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390253AbgDBXxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 19:53:47 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 032NXtwt083145
        for <stable@vger.kernel.org>; Thu, 2 Apr 2020 19:53:46 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304hjbu623-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 19:53:46 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Fri, 3 Apr 2020 00:53:31 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 Apr 2020 00:53:27 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 032Nrd4454591736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 23:53:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 634154C046;
        Thu,  2 Apr 2020 23:53:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 720924C040;
        Thu,  2 Apr 2020 23:53:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.192.10])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 23:53:38 +0000 (GMT)
Subject: Re: [PATCH v4 1/7] ima: Switch to ima_hash_algo for boot aggregate
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        James.Bottomley@HansenPartnership.com,
        Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Date:   Thu, 02 Apr 2020 19:53:37 -0400
In-Reply-To: <20200325104712.25694-2-roberto.sassu@huawei.com>
References: <20200325104712.25694-1-roberto.sassu@huawei.com>
         <20200325104712.25694-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20040223-0008-0000-0000-0000036956FE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040223-0009-0000-0000-00004A8AE4C0
Message-Id: <1585871617.7311.5.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_13:2020-04-02,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020169
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

On Wed, 2020-03-25 at 11:47 +0100, Roberto Sassu wrote:
> boot_aggregate is the first entry of IMA measurement list. Its purpose is
> to link pre-boot measurements to IMA measurements. As IMA was designed to
> work with a TPM 1.2, the SHA1 PCR bank was always selected even if a
> TPM 2.0 with support for stronger hash algorithms is available.
> 
> This patch first tries to find a PCR bank with the IMA default hash
> algorithm. If it does not find it, it selects the SHA256 PCR bank for
> TPM 2.0 and SHA1 for TPM 1.2. Ultimately, it selects SHA1 also for TPM 2.0
> if the SHA256 PCR bank is not found.
> 
> If none of the PCR banks above can be found, boot_aggregate file digest is
> filled with zeros, as for TPM bypass, making it impossible to perform a
> remote attestation of the system.
> 
> Cc: stable@vger.kernel.org # 5.1.x
> Fixes: 879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Thank you!  This patch set is now queued in next-integrity-testing
during the open window.  Jerry, I assume this works for you.  Could we
get your tag?

thanks!

Mimi

