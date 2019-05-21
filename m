Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C0B248FB
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 09:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfEUHc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 03:32:29 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32960 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbfEUHc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 03:32:28 -0400
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 5A34E89645266B1E4F09;
        Tue, 21 May 2019 08:32:27 +0100 (IST)
Received: from [10.220.96.108] (10.220.96.108) by smtpsuk.huawei.com
 (10.201.108.37) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 21 May
 2019 08:32:19 +0100
Subject: Re: [PATCH 4/4] ima: only audit failed appraisal verifications
To:     Mimi Zohar <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        <stable@vger.kernel.org>
References: <20190516161257.6640-1-roberto.sassu@huawei.com>
 <20190516161257.6640-4-roberto.sassu@huawei.com>
 <1558387225.4039.78.camel@linux.ibm.com>
From:   Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <4280cbe7-6596-1827-4358-fb45d7c13f25@huawei.com>
Date:   Tue, 21 May 2019 09:32:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1558387225.4039.78.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.220.96.108]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/20/2019 11:20 PM, Mimi Zohar wrote:
> On Thu, 2019-05-16 at 18:12 +0200, Roberto Sassu wrote:
>> This patch ensures that integrity_audit_msg() is called only when the
>> status is not INTEGRITY_PASS.
>>
>> Fixes: 8606404fa555c ("ima: digital signature verification support")
>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   security/integrity/ima/ima_appraise.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
>> index a32ed5d7afd1..f5f4506bcb8e 100644
>> --- a/security/integrity/ima/ima_appraise.c
>> +++ b/security/integrity/ima/ima_appraise.c
>> @@ -359,8 +359,9 @@ int ima_appraise_measurement(enum ima_hooks func,
>>   			status = INTEGRITY_PASS;
>>   		}
>>   
>> -		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
>> -				    op, cause, rc, 0);
>> +		if (status != INTEGRITY_PASS)
>> +			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
>> +					    filename, op, cause, rc, 0);
> 
> For some reason, the integrity verification has failed.  In some
> specific cases, we'll let it pass, but do we really want to remove any
> indication that it failed in all cases?

Ok. It is fine for me to discard the patch.

Roberto

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
