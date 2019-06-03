Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF732CC9
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfFCJZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:25:16 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32977 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726684AbfFCJZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:25:16 -0400
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id DAD2985DF29930B44972;
        Mon,  3 Jun 2019 10:25:13 +0100 (IST)
Received: from [10.220.96.108] (10.220.96.108) by smtpsuk.huawei.com
 (10.201.108.35) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 3 Jun
 2019 10:25:06 +0100
Subject: Re: [PATCH v2 2/3] ima: don't ignore INTEGRITY_UNKNOWN EVM status
To:     Mimi Zohar <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>, <stable@vger.kernel.org>
References: <20190529133035.28724-1-roberto.sassu@huawei.com>
 <20190529133035.28724-3-roberto.sassu@huawei.com>
 <1559217621.4008.7.camel@linux.ibm.com>
From:   Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <e6b31aa9-0319-1805-bdfc-3ddde5884494@huawei.com>
Date:   Mon, 3 Jun 2019 11:25:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1559217621.4008.7.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.220.96.108]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/30/2019 2:00 PM, Mimi Zohar wrote:
> On Wed, 2019-05-29 at 15:30 +0200, Roberto Sassu wrote:
>> Currently, ima_appraise_measurement() ignores the EVM status when
>> evm_verifyxattr() returns INTEGRITY_UNKNOWN. If a file has a valid
>> security.ima xattr with type IMA_XATTR_DIGEST or IMA_XATTR_DIGEST_NG,
>> ima_appraise_measurement() returns INTEGRITY_PASS regardless of the EVM
>> status. The problem is that the EVM status is overwritten with the
>>> appraisal statu
> 
> Roberto, your framing of this problem is harsh and misleading.  IMA
> and EVM are intentionally independent of each other and can be
> configured independently of each other.  The intersection of the two
> is the call to evm_verifyxattr().  INTEGRITY_UNKNOWN is returned for a
> number of reasons - when EVM is not configured, the EVM hmac key has
> not yet been loaded, the protected security attribute is unknown, or
> the file is not in policy.
> 
> This patch does not differentiate between any of the above cases,
> requiring mutable files to always be protected by EVM, when specified
> as an "ima_appraise=" option on the boot command line.
> 
> IMA could be extended to require EVM on a per IMA policy rule basis.
> Instead of framing allowing IMA file hashes without EVM as a bug that
> has existed from the very beginning, now that IMA/EVM have matured and
> is being used, you could frame it as extending IMA or hardening.

I'm seeing it from the perspective of an administrator that manages an
already hardened system, and expects that the system only grants access
to files with a valid signature/HMAC. That system would not enforce this
behavior if EVM keys are removed and the digest in security.ima is set
to the actual file digest.

Framing it as a bug rather than an extension would in my opinion help to
convince people about the necessity to switch to the safe mode, if their
system is already hardened.


>> This patch mitigates the issue by selecting signature verification as the
>> only method allowed for appraisal when EVM is not initialized. Since the
>> new behavior might break user space, it must be turned on by adding the
>> '-evm' suffix to the value of the ima_appraise= kernel option.
>>
>> Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   Documentation/admin-guide/kernel-parameters.txt | 3 ++-
>>   security/integrity/ima/ima_appraise.c           | 8 ++++++++
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index 138f6664b2e2..d84a2e612b93 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -1585,7 +1585,8 @@
>>   			Set number of hash buckets for inode cache.
>>   
>>   	ima_appraise=	[IMA] appraise integrity measurements
>> -			Format: { "off" | "enforce" | "fix" | "log" }
>> +			Format: { "off" | "enforce" | "fix" | "log" |
>> +				  "enforce-evm" | "log-evm" }
> 
> Is it necessary to define both "enforce-evm" and "log-evm"?  Perhaps
> defining "require-evm" is sufficient.

ima_appraise= accepts as values modes of operation. I consider the -evm
suffix as a modifier of already defined modes.

Roberto

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
