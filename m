Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB89D737
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 22:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfHZUIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 16:08:30 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:24215 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbfHZUI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 16:08:29 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 46HNNq2jq9z9v77Z;
        Mon, 26 Aug 2019 22:08:27 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=DR/TKeJF; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 8QQW6YTC9plx; Mon, 26 Aug 2019 22:08:27 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 46HNNq1Qr4z9v77Y;
        Mon, 26 Aug 2019 22:08:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1566850107; bh=pzWzILPxMyKOA9y6iRNb3YNvFsFY3QJWvZHmkH55InM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DR/TKeJFIZ2zFnQt0K+Kd5HRxKtCFXYE6wfuC661krDwU79ca9L7agaNiiT6Ee0rS
         AdNW5gGyiSFiHeb1cMVZ6HGp58DLprwlLV3S78xiyj3rGjj1oAJm87NyUxvz1yuwUw
         WZg6G9wrZOXqv0W825akEKDADsIYTYNbaUImFgl0=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4D4BB8B7F2;
        Mon, 26 Aug 2019 22:08:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id U09PT5UgfaFZ; Mon, 26 Aug 2019 22:08:27 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 981A88B7E1;
        Mon, 26 Aug 2019 22:08:26 +0200 (CEST)
Subject: Re: [PATCH v2] powerpc: Allow flush_(inval_)dcache_range to work
 across ranges >4GB
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alastair D'Silva <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, Allison Randal <allison@lohutok.net>
References: <20190821001929.4253-1-alastair@au1.ibm.com>
 <20190826165021.GB9305@kroah.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <bae6de93-f135-68c5-9118-a0732e6de301@c-s.fr>
Date:   Mon, 26 Aug 2019 22:08:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826165021.GB9305@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 26/08/2019 à 18:50, Greg Kroah-Hartman a écrit :
> On Wed, Aug 21, 2019 at 10:19:27AM +1000, Alastair D'Silva wrote:
>> From: Alastair D'Silva <alastair@d-silva.org>
>>
>> The upstream commit:
>> 22e9c88d486a ("powerpc/64: reuse PPC32 static inline flush_dcache_range()")
>> has a similar effect, but since it is a rewrite of the assembler to C, is
>> too invasive for stable. This patch is a minimal fix to address the issue in
>> assembler.
>>
>> This patch applies cleanly to v5.2, v4.19 & v4.14.
>>
>> When calling flush_(inval_)dcache_range with a size >4GB, we were masking
>> off the upper 32 bits, so we would incorrectly flush a range smaller
>> than intended.
>>
>> This patch replaces the 32 bit shifts with 64 bit ones, so that
>> the full size is accounted for.
>>
>> Changelog:
>> v2
>>    - Add related upstream commit
>>
>> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
>> ---
>>   arch/powerpc/kernel/misc_64.S | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
>> index 1ad4089dd110..d4d096f80f4b 100644
>> --- a/arch/powerpc/kernel/misc_64.S
>> +++ b/arch/powerpc/kernel/misc_64.S
>> @@ -130,7 +130,7 @@ _GLOBAL_TOC(flush_dcache_range)
>>   	subf	r8,r6,r4		/* compute length */
>>   	add	r8,r8,r5		/* ensure we get enough */
>>   	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of dcache block size */
>> -	srw.	r8,r8,r9		/* compute line count */
>> +	srd.	r8,r8,r9		/* compute line count */
>>   	beqlr				/* nothing to do? */
>>   	mtctr	r8
>>   0:	dcbst	0,r6
>> @@ -148,7 +148,7 @@ _GLOBAL(flush_inval_dcache_range)
>>   	subf	r8,r6,r4		/* compute length */
>>   	add	r8,r8,r5		/* ensure we get enough */
>>   	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)/* Get log-2 of dcache block size */
>> -	srw.	r8,r8,r9		/* compute line count */
>> +	srd.	r8,r8,r9		/* compute line count */
>>   	beqlr				/* nothing to do? */
>>   	sync
>>   	isync
> 
> I need an ack from the powerpc maintainer(s) before I can take this.

I think you already got an ack (on v1). See 
https://patchwork.ozlabs.org/patch/1147403/#2239663

Christophe
