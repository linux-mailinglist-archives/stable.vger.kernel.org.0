Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164DA3A3362
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 20:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFJSl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 14:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhFJSlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 14:41:55 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B1CC061574;
        Thu, 10 Jun 2021 11:39:59 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4G1CSs23vWzQk3G;
        Thu, 10 Jun 2021 20:39:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-language:content-type
        :content-type:in-reply-to:mime-version:date:date:message-id:from
        :from:references:subject:subject:received; s=mail20150812; t=
        1623350392; bh=u9JoI09PtB0guYEvyFd4WuI90Hqe2oL0ZbIxw6V5xjc=; b=A
        MfVUiR+JCD0i6+wNdXm/D7Qe1epkFNPIS37reFUKh60C15D+3msLJndQVD5VSl1v
        onuQjiBmC8xD6MmtgSyJddRcez9ZgoV+VWj7ImfquYyy1z4689MFYpjWz3mHNsuo
        qZClVVhaXf9tRLOLzMe9o+jJuci8jCV7MEgNjeRt0m651GQ3M2ebdzp2nCq6/NVh
        JIzM9+50vHj5E/LP3NVbpY7AMUivNGnL6dBrQkc7KFKIJUJDDGDBJtMXmh2O6e63
        HF2jmZf7fqP0kwEp6o0S1KcMwyLHiA4vd/ctE7pTgwBKlI2CNOxnZEgUN+50iJQh
        /7ExKmvqd+F/571WK2vaA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1623350395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ED7r0qztVT/NoVf7338Yzez73nCHxmA7+JBorIZ9hHE=;
        b=QUXTaqxW173iR2ZT3XYqlgE0G+cVP/pSokFeNY9IxYUQA0qGINEXvGt+/H1iFPWvdASuWl
        07ZNs93qt9zm0c7UnTCAJz9xVjN4mdu/5/gNCxnKnCo6rd7lJ9CnXi1mh8xFk//sG5uFws
        qXVv9igRrauGfklTCrWCj/lJsMJyslyvaF1Bi3kUhKiRQlmFCESShzQrc1JRIEVQKbnVHc
        2jFK2KmoVwzzkxcdv+n6mEIVeTClqyX3QHj6+dWs05TN9cvBL9XHvjNWYSfxI5SIBv2O6l
        L4osTixzRKuEqC+Z/j1m9l8LCctc9IEwPmiJxGD4mc8HdJTjAozbVc1jRpy21w==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id 4hP10dEOVgtl; Thu, 10 Jun 2021 20:39:52 +0200 (CEST)
Subject: Re: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD <
 13.0.0
To:     Nathan Chancellor <nathan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <214134496.67043.1623317284090@office.mailbox.org>
 <ea01f4cb-3e65-0b79-ae93-ba0957e076fc@kernel.org>
From:   Tor Vic <torvic9@mailbox.org>
Message-ID: <ba06e4f5-709a-08cc-0f62-e50c64fc301f@mailbox.org>
Date:   Thu, 10 Jun 2021 18:39:45 +0000
MIME-Version: 1.0
In-Reply-To: <ea01f4cb-3e65-0b79-ae93-ba0957e076fc@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -6.90 / 15.00 / 15.00
X-Rspamd-Queue-Id: E17F71860
X-Rspamd-UID: 7b8300
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nathan,

On 10.06.21 16:42, Nathan Chancellor wrote:
> Hi Tor,
> 
> On 6/10/2021 2:28 AM, torvic9@mailbox.org wrote:
>> Since LLVM commit 3787ee4, the '-stack-alignment' flag has been
>> dropped [1],
>> leading to the following error message when building a LTO kernel with
>> Clang-13 and LLD-13:
>>
>>      ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument
>>      '-stack-alignment=8'.  Try 'ld.lld --help'
>>      ld.lld: Did you mean '--stackrealign=8'?
>>
>> It also appears that the '-code-model' flag is not necessary anymore
>> starting
>> with LLVM-9 [2].
>>
>> Drop '-code-model' and make '-stack-alignment' conditional on LLD <
>> 13.0.0.
>>
>> This is for linux-stable 5.12.
>> Another patch will be submitted for 5.13 shortly (unless there are
>> objections).
> 
> This patch needs to be accepted into mainline first before it can go to
> stable so this line needs to be removed. The rest of the description
> looks good to me, good job on being descriptive!
> 

Thank you for explaining this.
I wasn't exactly sure how the procedure for stable was.
Does this mean that the patch should be based on 5.13?
I usually use Linus' tree mirrored at GitHub.

>> Discussion: https://github.com/ClangBuiltLinux/linux/issues/1377
>> [1]: https://reviews.llvm.org/D103048
>> [2]: https://reviews.llvm.org/D52322
> 
> As Greg's auto-response points out, there needs to be an actual
> 
> Cc: stable@vger.kernel.org
> 
> here in the patch, rather than just cc'ing stable@vger.kernel.org
> through email.
> 

Yes I misinterpreted this in the sense of "put stable mail in CC".
So if I get this right, I should NOT put stable email in CC, but only
add the "Cc: stable@vger.kernel.org" tag above the "Signed-off-by"?

>> Signed-off-by: Tor Vic <torvic9@mailbox.org>
> 
> The actual patch itself looks good and I have verified that it fixes the
> build error. On the resend with the above fixed, please feel free to add:
> 
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> 
>> ---
>>   arch/x86/Makefile | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>> index 1f2e5bf..2855a1a 100644
>> --- a/arch/x86/Makefile
>> +++ b/arch/x86/Makefile
>> @@ -192,8 +192,9 @@ endif
>>   KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
>>     ifdef CONFIG_LTO_CLANG
>> -KBUILD_LDFLAGS    += -plugin-opt=-code-model=kernel \
>> -           -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
>> +ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 130000; echo $$?),0)
>> +KBUILD_LDFLAGS    += -plugin-opt=-stack-alignment=$(if
>> $(CONFIG_X86_32),4,8)
>> +endif
>>   endif
>>     ifdef CONFIG_X86_NEED_RELOCS
>>
> 
> Cheers,
> Nathan

Thanks for your help!
Tor

