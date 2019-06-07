Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E82438E72
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbfFGPIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:08:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41638 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728446AbfFGPIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 11:08:52 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x57F7ZVG076352
        for <stable@vger.kernel.org>; Fri, 7 Jun 2019 11:08:51 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2syt9wg24q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 11:08:51 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <zohar@linux.ibm.com>;
        Fri, 7 Jun 2019 16:08:49 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Jun 2019 16:08:45 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x57F8ibE52101270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jun 2019 15:08:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 168FD52052;
        Fri,  7 Jun 2019 15:08:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.81.48])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0704652054;
        Fri,  7 Jun 2019 15:08:42 +0000 (GMT)
Subject: Re: [PATCH v3 2/2] ima: add enforce-evm and log-evm modes to
 strictly check EVM status
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        dmitry.kasatkin@huawei.com, mjg59@google.com
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com
Date:   Fri, 07 Jun 2019 11:08:32 -0400
In-Reply-To: <93459fe8-f9b6-fe45-1ca7-2efb8854dc8b@huawei.com>
References: <20190606112620.26488-1-roberto.sassu@huawei.com>
         <20190606112620.26488-3-roberto.sassu@huawei.com>
         <1559917462.4278.253.camel@linux.ibm.com>
         <93459fe8-f9b6-fe45-1ca7-2efb8854dc8b@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19060715-0012-0000-0000-00000326484D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060715-0013-0000-0000-0000215F347A
Message-Id: <1559920112.4278.264.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070106
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-06-07 at 16:40 +0200, Roberto Sassu wrote:
> > On Thu, 2019-06-06 at 13:26 +0200, Roberto Sassu wrote:

> >> Although this choice appears legitimate, it might not be suitable for
> >> hardened systems, where the administrator expects that access is denied if
> >> there is any error. An attacker could intentionally delete the EVM keys
> >> from the system and set the file digest in security.ima to the actual file
> >> digest so that the final appraisal status is INTEGRITY_PASS.
> > 
> > Assuming that the EVM HMAC key is stored in the initramfs, not on some
> > other file system, and the initramfs is signed, INTEGRITY_UNKNOWN
> > would be limited to the rootfs filesystem.
> 
> There is another issue. The HMAC key, like the public keys, should be
> loaded when appraisal is disabled. This means that we have to create a
> trusted key at early boot and defer the unsealing.

There is no need for IMA to appraise the public key file signature,
since the certificate is signed by a key on the builtin/secondary
trusted keyring.  With CONFIG_IMA_LOAD_X509 enabled, the public key
can be loaded onto the IMA keyring with IMA-appraisal enabled, but
without verifying the file signature.

Mimi

