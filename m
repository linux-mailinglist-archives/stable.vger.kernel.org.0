Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD8C38CE5
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfFGOYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 10:24:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728669AbfFGOYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 10:24:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x57EMF3O001175
        for <stable@vger.kernel.org>; Fri, 7 Jun 2019 10:24:40 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2syqwswn41-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 10:24:40 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Fri, 7 Jun 2019 15:24:38 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Jun 2019 15:24:35 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x57EOYvB58261520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jun 2019 14:24:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5674A11C05C;
        Fri,  7 Jun 2019 14:24:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E46E11C052;
        Fri,  7 Jun 2019 14:24:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.81.48])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jun 2019 14:24:32 +0000 (GMT)
Subject: Re: [PATCH v3 2/2] ima: add enforce-evm and log-evm modes to
 strictly check EVM status
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com
Date:   Fri, 07 Jun 2019 10:24:22 -0400
In-Reply-To: <20190606112620.26488-3-roberto.sassu@huawei.com>
References: <20190606112620.26488-1-roberto.sassu@huawei.com>
         <20190606112620.26488-3-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19060714-4275-0000-0000-000003404A76
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060714-4276-0000-0000-0000385052FF
Message-Id: <1559917462.4278.253.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070102
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Roberto,

Thank you for updating the patch description.

On Thu, 2019-06-06 at 13:26 +0200, Roberto Sassu wrote:
> IMA and EVM have been designed as two independent subsystems: the first for
> checking the integrity of file data; the second for checking file metadata.
> Making them independent allows users to adopt them incrementally.
> 
> The point of intersection is in IMA-Appraisal, which calls
> evm_verifyxattr() to ensure that security.ima wasn't modified during an
> offline attack. The design choice, to ensure incremental adoption, was to
> continue appraisal verification if evm_verifyxattr() returns
> INTEGRITY_UNKNOWN. This value is returned when EVM is not enabled in the
> kernel configuration, or if the HMAC key has not been loaded yet.
> 
> Although this choice appears legitimate, it might not be suitable for
> hardened systems, where the administrator expects that access is denied if
> there is any error. An attacker could intentionally delete the EVM keys
> from the system and set the file digest in security.ima to the actual file
> digest so that the final appraisal status is INTEGRITY_PASS.

Assuming that the EVM HMAC key is stored in the initramfs, not on some
other file system, and the initramfs is signed, INTEGRITY_UNKNOWN
would be limited to the rootfs filesystem.

> 
> This patch allows such hardened systems to strictly enforce an access
> control policy based on the validity of signatures/HMACs, by introducing
> two new values for the ima_appraise= kernel option: enforce-evm and
> log-evm.
> 

This patch defines a global policy requiring EVM on all filesystems.
I've previously suggested extending the IMA policy to support
enforcing or maybe exempting EVM on a per IMA policy rule basis.  As
seen by the need for an additional patch, included in this patch set,
which defines a temporary random number HMAC key to address
INTEGRITY_UNKNOWN on the rootfs filesystem, exempting certain
filesystems on a per policy rule basis might be simpler and achieve
similar results.

I'd like to hear other people's thoughts on defining a temporary,
random number HMAC key.

thanks,

Mimi

