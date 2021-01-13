Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4571F2F4233
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 04:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbhAMDDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 22:03:25 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:58515 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726499AbhAMDDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 22:03:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0ULZk49v_1610506958;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0ULZk49v_1610506958)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Jan 2021 11:02:39 +0800
Subject: Re: [PATCH] X.509: Fix crash caused by NULL pointer
To:     David Howells <dhowells@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tobias Markus <tobias@markus-regensburg.de>,
        Tee Hao Wei <angelsl@in04.sg>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210107092855.76093-1-tianjia.zhang@linux.alibaba.com>
 <772253.1610017082@warthog.procyon.org.uk>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <8ff730e0-bf03-0fbf-41f6-8e06f8956929@linux.alibaba.com>
Date:   Wed, 13 Jan 2021 11:02:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <772253.1610017082@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/7/21 6:58 PM, David Howells wrote:
> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
> 
>> On the following call path, `sig->pkey_algo` is not assigned
>> in asymmetric_key_verify_signature(), which causes runtime
>> crash in public_key_verify_signature().
>>
>>    keyctl_pkey_verify
>>      asymmetric_key_verify_signature
>>        verify_signature
>>          public_key_verify_signature
>>
>> This patch simply check this situation and fixes the crash
>> caused by NULL pointer.
>>
>> Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
>> Cc: stable@vger.kernel.org # v5.10+
>> Reported-by: Tobias Markus <tobias@markus-regensburg.de>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> Looks reasonable:
> 
> Acked-by: David Howells <dhowells@redhat.com>
> 
> I wonder, though, if cert_sig_digest_update() should be obtained by some sort
> of function pointer.  It doesn't really seem to belong in this file.  But this
> is a separate issue.
> 
> David
> 

Yes, this is indeed the logic of the SM2 module. I have tried to 
dynamically load and obtain the pointer of this function through 
`request_module` before, but this method still does not seem very 
suitable. Here are some unfinished codes I tried before:

https://github.com/uudiin/linux/commit/55bca48c6282415d94c53a7692622d544da99342

It would be great if you have some good experience to share with me, I 
will continue to try to optimize this code.

Best regards,
Tianjia
