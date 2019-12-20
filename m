Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1E5128348
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 21:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLTUcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 15:32:08 -0500
Received: from mail.efficios.com ([167.114.142.138]:55580 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfLTUcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 15:32:08 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id C2B2E68F247;
        Fri, 20 Dec 2019 15:32:06 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id KBJo3erltmQA; Fri, 20 Dec 2019 15:32:06 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 4E6A868F241;
        Fri, 20 Dec 2019 15:32:06 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 4E6A868F241
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576873926;
        bh=O0Xgi55hU+GeNXOpB6Fs1osave4TEg0Pab/JqA6fyos=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=W/o7O03KqinpAL9L6BofgbdUAK/3gjJ40LSFc4bsuvH3AVd5nUgsOdIj6142KLpY3
         APpitBATR2j9xKMPaOGQVEyHovOVIfUmwwq2xW5KHNL2qlLPQILpCcuuWaF7y3EPpV
         YW43rXmRBZoaitmVUbT2qyqN/KYv0H5SGShObV6SWL/PDNidwnl5vc4/HNDBudwDrN
         45epAw/lZcDL0vBWZPyE7q65DR6KZzXGeGVVLe/5p7RimktTNFPoke1cc13vN5e47R
         /XwmtBgpRluprzBSXataLRkevTlIj6iUFkym5dSRBg0w5fowDnfFQeCCR2cha3U69f
         l1DLkNlSLEZfg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id iPOVCdJFCO0r; Fri, 20 Dec 2019 15:32:06 -0500 (EST)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 3419068F232;
        Fri, 20 Dec 2019 15:32:06 -0500 (EST)
Date:   Fri, 20 Dec 2019 15:32:06 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Dmitry Vyukov <dvyukov@google.com>
Message-ID: <190540378.14355.1576873926104.JavaMail.zimbra@efficios.com>
In-Reply-To: <2ad7d561-2cbc-09c2-2806-97c3be3727e2@linuxfoundation.org>
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com> <20191220201207.17389-2-mathieu.desnoyers@efficios.com> <2ad7d561-2cbc-09c2-2806-97c3be3727e2@linuxfoundation.org>
Subject: Re: [PATCH for 5.5 2/2] rseq/selftests: Clarify
 rseq_prepare_unload() helper requirements
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3888 (ZimbraWebClient - FF71 (Linux)/8.8.15_GA_3890)
Thread-Topic: rseq/selftests: Clarify rseq_prepare_unload() helper requirements
Thread-Index: IiprUiRn6EeFcp2vmx/kx/xCRnSd5w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 20, 2019, at 3:27 PM, Shuah Khan skhan@linuxfoundation.org wrote:

> Hi Mathieu,
> 
> On 12/20/19 1:12 PM, Mathieu Desnoyers wrote:
>> The rseq.h UAPI now documents that the rseq_cs field must be cleared
>> before reclaiming memory that contains the targeted struct rseq_cs, but
>> also that the rseq_cs field must be cleared before reclaiming memory of
>> the code pointed to by the rseq_cs start_ip and post_commit_offset
>> fields.
>> 
>> While we can expect that use of dlclose(3) will typically unmap
>> both struct rseq_cs and its associated code at once, nothing would
>> theoretically prevent a JIT from reclaiming the code without
>> reclaiming the struct rseq_cs, which would erroneously allow the
>> kernel to consider new code which is not a rseq critical section
>> as a rseq critical section following a code reclaim.
>> 
>> Suggested-by: Florian Weimer <fw@deneb.enyo.de>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Shuah Khan <skhan@linuxfoundation.org>
>> Cc: Florian Weimer <fw@deneb.enyo.de>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
>> Cc: Boqun Feng <boqun.feng@gmail.com>
>> Cc: "H . Peter Anvin" <hpa@zytor.com>
>> Cc: Paul Turner <pjt@google.com>
>> Cc: Dmitry Vyukov <dvyukov@google.com>
>> ---
>>   tools/testing/selftests/rseq/rseq.h | 12 +++++++-----
>>   1 file changed, 7 insertions(+), 5 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/rseq/rseq.h
>> b/tools/testing/selftests/rseq/rseq.h
>> index d40d60e7499e..15cbd51d0818 100644
>> --- a/tools/testing/selftests/rseq/rseq.h
>> +++ b/tools/testing/selftests/rseq/rseq.h
>> @@ -149,11 +149,13 @@ static inline void rseq_clear_rseq_cs(void)
>>   /*
>>    * rseq_prepare_unload() should be invoked by each thread executing a rseq
>>    * critical section at least once between their last critical section and
>> - * library unload of the library defining the rseq critical section
>> - * (struct rseq_cs). This also applies to use of rseq in code generated by
>> - * JIT: rseq_prepare_unload() should be invoked at least once by each
>> - * thread executing a rseq critical section before reclaim of the memory
>> - * holding the struct rseq_cs.
>> + * library unload of the library defining the rseq critical section (struct
>> + * rseq_cs) or the code refered to by the struct rseq_cs start_ip and
> 
> Nit: referred instead of refered

Good catch. I've done the same error in patch 1/2. I'll update both and
resend.

Thanks!

Mathieu

> 
>> + * post_commit_offset fields. This also applies to use of rseq in code
>> + * generated by JIT: rseq_prepare_unload() should be invoked at least once by
>> + * each thread executing a rseq critical section before reclaim of the memory
>> + * holding the struct rseq_cs or reclaim of the code pointed to by struct
>> + * rseq_cs start_ip and post_commit_offset fields.
>>    */
>>   static inline void rseq_prepare_unload(void)
>>   {
>> 
> 
> thanks,
> -- Shuah

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
