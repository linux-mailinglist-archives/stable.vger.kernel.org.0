Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D526B2B98
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 16:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388534AbfINOVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 10:21:32 -0400
Received: from mail.efficios.com ([167.114.142.138]:55114 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387786AbfINOVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 10:21:32 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 5ADDB2B9B77;
        Sat, 14 Sep 2019 10:21:30 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id cVHedDvBx6U9; Sat, 14 Sep 2019 10:21:29 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id A942C2B9B73;
        Sat, 14 Sep 2019 10:21:29 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com A942C2B9B73
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568470889;
        bh=M10BlrTXAj0G5y7uqqZ+tCLOJeUIc+aRdoN/am4d8Qs=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=OrM9XPiIjv9+zo4an4UrG/+X9Ag8E8VsyGp9CSouhtbLgQHQW1q7RLxo2SzHPtUsB
         soLryC4pEL0QcFbWbUOekyDq1723FMIAjRpx3mHjDtlCYAo0BAlR7uNPHtaxST/BXc
         MbqYnsqaNRG0VOWwuAFAudaN6ntE/sNMq7rjrDe98AsXNaSwyiq/U24TRTww60ik2s
         vzdUrsQCuYuzvoF2S4LRxtgphBO34e1Vz3tW7L6tp8axudzkOnLZLDDRVWe/Bnw603
         RxEbD/XB4OWilZUjwXNJ0mCQ443ugi0gnon4+XT/qiSTYIOVj4VDpd06+nxHDqAvVk
         1ElusDH4V3glg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 4BJ5TKhxbPjp; Sat, 14 Sep 2019 10:21:29 -0400 (EDT)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 8FD772B9B69;
        Sat, 14 Sep 2019 10:21:29 -0400 (EDT)
Date:   Sat, 14 Sep 2019 10:21:29 -0400 (EDT)
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
Message-ID: <819646407.3304.1568470889470.JavaMail.zimbra@efficios.com>
In-Reply-To: <20190913151220.3105-2-mathieu.desnoyers@efficios.com>
References: <20190913151220.3105-1-mathieu.desnoyers@efficios.com> <20190913151220.3105-2-mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.3 2/3] rseq: Fix: Unregister rseq for CLONE_SETTLS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3847 (ZimbraWebClient - FF69 (Linux)/8.8.15_GA_3847)
Thread-Topic: rseq: Fix: Unregister rseq for CLONE_SETTLS
Thread-Index: o9eZqvAOKmXphmxsJKc8X5whD/BREg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is an ongoing discussion on the choice of flag we want to care
about here. Therefore, please don't pull this patch until we reach an
agreement.

Thanks,

Mathieu

----- On Sep 13, 2019, at 11:12 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> It has been reported by Google that rseq is not behaving properly
> with respect to clone when CLONE_VM is used without CLONE_THREAD.
> It keeps the prior thread's rseq TLS registered when the TLS of the
> thread has moved, so the kernel deals with the wrong TLS.
> 
> The approach of clearing the per task-struct rseq registration
> on clone with CLONE_THREAD flag is incomplete. It does not cover
> the use-case of clone with CLONE_VM set, but without CLONE_THREAD.
> 
> Looking more closely at each of the clone flags:
> 
> - CLONE_THREAD,
> - CLONE_VM,
> - CLONE_SETTLS.
> 
> It appears that the flag we really want to track is CLONE_SETTLS, which
> moves the location of the TLS for the child, making the rseq
> registration point to the wrong TLS.
> 
> Suggested-by: "H . Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: linux-api@vger.kernel.org
> Cc: <stable@vger.kernel.org>
> ---
> include/linux/sched.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 9f51932bd543..76bf55b5cccf 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1919,11 +1919,11 @@ static inline void rseq_migrate(struct task_struct *t)
> 
> /*
>  * If parent process has a registered restartable sequences area, the
> - * child inherits. Only applies when forking a process, not a thread.
> + * child inherits. Unregister rseq for a clone with CLONE_SETTLS set.
>  */
> static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
> {
> -	if (clone_flags & CLONE_THREAD) {
> +	if (clone_flags & CLONE_SETTLS) {
> 		t->rseq = NULL;
> 		t->rseq_sig = 0;
> 		t->rseq_event_mask = 0;
> --
> 2.17.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
