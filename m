Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83793E1AD9
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 19:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbhHER5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 13:57:47 -0400
Received: from mail.efficios.com ([167.114.26.124]:44558 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhHER5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 13:57:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id B88F2372267;
        Thu,  5 Aug 2021 13:57:31 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id lTQtT4Y58h44; Thu,  5 Aug 2021 13:57:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 23EE73722DA;
        Thu,  5 Aug 2021 13:57:31 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 23EE73722DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1628186251;
        bh=mEXkdFbyh3eR6ZopNCr0bSrg2k1xcnu9OW3yHQ5YARY=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=m3IugQ89KM+KDnt73n3a7hYseiqwjm7rYK6SmDxPGYnJfH8RY8GEGQNWqDHF/+eCH
         5d65gUWmUeP4sMNKtlSIza2cFraxswOcHhSxEr7Hv2Lq2cm5MA3OE6c29kyZHXZ9JE
         UITZr9DpaRafrbMhYC34P+8eDcPTsCcw/qj5qvQ0vNn9AcPq1giKTG+qc6CAfY6joq
         WLr1P0AYq/In5nJA1cCjMqYXAHEIPpeJhD2OGR5c9ZbkzWOhjF3Og6g+sjeWggHvix
         nfiZK0F2Qd5UYvEMGOOEfR6c89b/XgjoNK3s2r74e2wDxjSxV6W2+/Jhmevqku7UrA
         +8eRmOo3cP2cg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 81MMzbFP1LU6; Thu,  5 Aug 2021 13:57:31 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 15C393722D9;
        Thu,  5 Aug 2021 13:57:31 -0400 (EDT)
Date:   Thu, 5 Aug 2021 13:57:30 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        paulmck <paulmck@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        stable <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1270289445.7118.1628186250992.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210805130700.0bc7e52a@oasis.local.home>
References: <20210805132717.23813-1-mathieu.desnoyers@efficios.com> <20210805132717.23813-2-mathieu.desnoyers@efficios.com> <20210805130700.0bc7e52a@oasis.local.home>
Subject: Re: [PATCH 1/3] Fix: tracepoint: static call: compare data on
 transition from 2->1 callees
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4101 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4059)
Thread-Topic: tracepoint: static call: compare data on transition from 2->1 callees
Thread-Index: Yc0DXoffTwTZJbm+apjtc06R9rYRqA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Aug 5, 2021, at 1:07 PM, rostedt rostedt@goodmis.org wrote:

> On Thu,  5 Aug 2021 09:27:15 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> On transition from 2->1 callees, we should be comparing .data rather
>> than .func, because the same callback can be registered twice with
>> different data, and what we care about here is that the data of array
>> element 0 is unchanged to skip rcu sync.
>> 
>> Link:
>> https://lore.kernel.org/io-uring/4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org/
> 
> FYI, You only need to show one Fixes.
> 
>> Fixes: d25e37d89dd2 ("tracepoint: Optimize using static_call()")
> 
> The above is fixed by the one below. Which means all the stable kernels
> that have the above, will also have the below, and thus the above is
> just redundant.
> 
>> Fixes: 547305a64632 ("tracepoint: Fix out of sync data passing by static
>> caller")
> 
> The above is what the patch actually fixes.
> 
>> Fixes: 352384d5c84e ("tracepoints: Update static_call before tp_funcs when
>> adding a tracepoint")
> 
> How does this patch fix the above? Perhaps the above did not go enough
> to fix the issue, but it's unrelated.

OK

> 
> I'll remove the first and last Fixes tag.

OK

> 
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: "Paul E. McKenney" <paulmck@kernel.org>
>> Cc: Stefan Metzmacher <metze@samba.org>
>> Cc: <stable@vger.kernel.org> # 5.10+
> 
> The "# 5.10+" is now obsolete, and not needed. The Fixes tag is used to
> determine where this gets backported to.
> 
> Other than that. This patch looks good.

Great, thanks!

Mathieu

> 
> -- Steve
> 
>> ---
>>  kernel/tracepoint.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
>> index fc32821f8240..133b6454b287 100644
>> --- a/kernel/tracepoint.c
>> +++ b/kernel/tracepoint.c
>> @@ -338,7 +338,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>>  	} else {
>>  		rcu_assign_pointer(tp->funcs, tp_funcs);
>>  		tracepoint_update_call(tp, tp_funcs,
>> -				       tp_funcs[0].func != old[0].func);
>> +				       tp_funcs[0].data != old[0].data);
>>  	}
>>  	release_probes(old);
> >  	return 0;

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
