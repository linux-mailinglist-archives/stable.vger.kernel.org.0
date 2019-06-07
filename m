Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CD738D86
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 16:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfFGOkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 10:40:39 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:33001 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbfFGOkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 10:40:39 -0400
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 5288EE6A9E88F4C4862A;
        Fri,  7 Jun 2019 15:40:37 +0100 (IST)
Received: from [10.220.96.108] (10.220.96.108) by smtpsuk.huawei.com
 (10.201.108.35) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 7 Jun
 2019 15:40:29 +0100
Subject: Re: [PATCH v3 2/2] ima: add enforce-evm and log-evm modes to strictly
 check EVM status
To:     Mimi Zohar <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>
References: <20190606112620.26488-1-roberto.sassu@huawei.com>
 <20190606112620.26488-3-roberto.sassu@huawei.com>
 <1559917462.4278.253.camel@linux.ibm.com>
From:   Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <93459fe8-f9b6-fe45-1ca7-2efb8854dc8b@huawei.com>
Date:   Fri, 7 Jun 2019 16:40:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1559917462.4278.253.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.220.96.108]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/2019 4:24 PM, Mimi Zohar wrote:
> Hi Roberto,
> 
> Thank you for updating the patch description.

Hi Mimi

no problem.


> On Thu, 2019-06-06 at 13:26 +0200, Roberto Sassu wrote:
>> IMA and EVM have been designed as two independent subsystems: the first for
>> checking the integrity of file data; the second for checking file metadata.
>> Making them independent allows users to adopt them incrementally.
>>
>> The point of intersection is in IMA-Appraisal, which calls
>> evm_verifyxattr() to ensure that security.ima wasn't modified during an
>> offline attack. The design choice, to ensure incremental adoption, was to
>> continue appraisal verification if evm_verifyxattr() returns
>> INTEGRITY_UNKNOWN. This value is returned when EVM is not enabled in the
>> kernel configuration, or if the HMAC key has not been loaded yet.
>>
>> Although this choice appears legitimate, it might not be suitable for
>> hardened systems, where the administrator expects that access is denied if
>> there is any error. An attacker could intentionally delete the EVM keys
>> from the system and set the file digest in security.ima to the actual file
>> digest so that the final appraisal status is INTEGRITY_PASS.
> 
> Assuming that the EVM HMAC key is stored in the initramfs, not on some
> other file system, and the initramfs is signed, INTEGRITY_UNKNOWN
> would be limited to the rootfs filesystem.

There is another issue. The HMAC key, like the public keys, should be
loaded when appraisal is disabled. This means that we have to create a
trusted key at early boot and defer the unsealing.

Roberto

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
