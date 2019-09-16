Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C66B41C1
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 22:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733222AbfIPU03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 16:26:29 -0400
Received: from mail.efficios.com ([167.114.142.138]:38586 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733177AbfIPU02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 16:26:28 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 349762D2E16;
        Mon, 16 Sep 2019 16:26:27 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id cqKT6pE8k2Yk; Mon, 16 Sep 2019 16:26:26 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id AF3532D2E03;
        Mon, 16 Sep 2019 16:26:26 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com AF3532D2E03
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568665586;
        bh=Edl2EwdVavNOhnVKCHzg8QRXPTO+dPykDxXdhG5Kbbc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=m0tE5l9LMLlF2Sua8CV4PLOLb53pG7G5dTI9jDdRvc9J4asazqFuUjOKoWVeZcx4N
         SQVNrGBYb7zHwImO+a0H81bMfF9OEMH4CliHb+3UdYKlXhARJRyUGC2aMFpGfhz2Nr
         HGFzvfbJsoFJkOVaBdo8Lj8uSpir7Tl/kr7xGH5fC10XnzY+miDlfQnziDj8+vMwvK
         y4vp2MO0WnuJxwEqPqv68vu4kQLkU9dVnN58+EgJYcGzbiOLv4fysBvnh9I3DkGO1H
         8fMwnskjjDpd1eiA3PZt3dcv7yzsu1BLBMJCVK10yS5IkWAbrv/PriOb5jWfDt0w34
         d6k/qOzah4XPg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id vzadUWW5ct8D; Mon, 16 Sep 2019 16:26:26 -0400 (EDT)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 970982D2DF9;
        Mon, 16 Sep 2019 16:26:26 -0400 (EDT)
Date:   Mon, 16 Sep 2019 16:26:26 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Neel Natu <neelnatu@google.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1809268320.7843.1568665586487.JavaMail.zimbra@efficios.com>
In-Reply-To: <819646407.3304.1568470889470.JavaMail.zimbra@efficios.com>
References: <20190913151220.3105-1-mathieu.desnoyers@efficios.com> <20190913151220.3105-2-mathieu.desnoyers@efficios.com> <819646407.3304.1568470889470.JavaMail.zimbra@efficios.com>
Subject: Re: [PATCH for 5.3 2/3] rseq: Fix: Unregister rseq for CLONE_SETTLS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3847 (ZimbraWebClient - FF69 (Linux)/8.8.15_GA_3847)
Thread-Topic: rseq: Fix: Unregister rseq for CLONE_SETTLS
Thread-Index: o9eZqvAOKmXphmxsJKc8X5whD/BREsteql3R
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Sep 14, 2019, at 10:21 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> There is an ongoing discussion on the choice of flag we want to care
> about here. Therefore, please don't pull this patch until we reach an
> agreement.

Following discussion with Neel Natu (Google) and Paul Turner (Google),
I plan to modify this patch, and unregister RSEQ on clone CLONE_VM for the
following reasons:

1) CLONE_THREAD requires CLONE_SIGHAND, which requires CLONE_VM to be
   set. Therefore, just checking for CLONE_VM covers all CLONE_THREAD uses,

2) There is the possibility of an unlikely scenario where CLONE_SETTLS is used
   without CLONE_VM. In order to be an issue, it would require that the rseq
   TLS is in a shared memory area.

   I do not plan on adding CLONE_SETTLS to the set of clone flags which
   unregister RSEQ, because it would require that we also unregister RSEQ
   on set_thread_area(2) and arch_prctl(2) ARCH_SET_FS for completeness.
   So rather than doing a partial solution, it appears better to let user-space
   explicitly perform rseq unregistration across clone if needed in scenarios
   where CLONE_VM is not set.

Thoughts ?

Thanks,

Mathieu


> 
> Thanks,
> 
> Mathieu
> 
> ----- On Sep 13, 2019, at 11:12 AM, Mathieu Desnoyers
> mathieu.desnoyers@efficios.com wrote:
> 
>> It has been reported by Google that rseq is not behaving properly
>> with respect to clone when CLONE_VM is used without CLONE_THREAD.
>> It keeps the prior thread's rseq TLS registered when the TLS of the
>> thread has moved, so the kernel deals with the wrong TLS.
>> 
>> The approach of clearing the per task-struct rseq registration
>> on clone with CLONE_THREAD flag is incomplete. It does not cover
>> the use-case of clone with CLONE_VM set, but without CLONE_THREAD.
>> 
>> Looking more closely at each of the clone flags:
>> 
>> - CLONE_THREAD,
>> - CLONE_VM,
>> - CLONE_SETTLS.
>> 
>> It appears that the flag we really want to track is CLONE_SETTLS, which
>> moves the location of the TLS for the child, making the rseq
>> registration point to the wrong TLS.
>> 
>> Suggested-by: "H . Peter Anvin" <hpa@zytor.com>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
>> Cc: Boqun Feng <boqun.feng@gmail.com>
>> Cc: "H . Peter Anvin" <hpa@zytor.com>
>> Cc: Paul Turner <pjt@google.com>
>> Cc: Dmitry Vyukov <dvyukov@google.com>
>> Cc: linux-api@vger.kernel.org
>> Cc: <stable@vger.kernel.org>
>> ---
>> include/linux/sched.h | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 9f51932bd543..76bf55b5cccf 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1919,11 +1919,11 @@ static inline void rseq_migrate(struct task_struct *t)
>> 
>> /*
>>  * If parent process has a registered restartable sequences area, the
>> - * child inherits. Only applies when forking a process, not a thread.
>> + * child inherits. Unregister rseq for a clone with CLONE_SETTLS set.
>>  */
>> static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
>> {
>> -	if (clone_flags & CLONE_THREAD) {
>> +	if (clone_flags & CLONE_SETTLS) {
>> 		t->rseq = NULL;
>> 		t->rseq_sig = 0;
>> 		t->rseq_event_mask = 0;
>> --
>> 2.17.1
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
