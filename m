Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1BC155A59
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 16:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgBGPHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 10:07:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgBGPHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 10:07:30 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9724D21741;
        Fri,  7 Feb 2020 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581088049;
        bh=M569W9421dzjoxt2SWlmqyIzn4fe5+qb1hQ4GP8XL0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xBFuJ1nrt1kT+WmX0tiqnfITU6oYPXIQdLkgSKD/Q1WawemNhtyh8vXG1ZD72RVHK
         8g9/JT5zkSAjALsxg4nAGNzPeNnEeotIjpzGE72idCP+60GwHneO++pA6DPXoak7Rs
         FYYV+IqXeGAcQOy5LcPu5RoWBlR1kLlOP34MlAiM=
Date:   Fri, 7 Feb 2020 10:07:28 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     gregkh@linuxfoundation.org, joel@joelfernandes.org,
        paulmck@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ftrace: Protect ftrace_graph_hash with
 ftrace_sync" failed to apply to 5.5-stable tree
Message-ID: <20200207150728.GW31482@sasha-vm>
References: <15810705761598@kroah.com>
 <20200207082842.1ce4bf32@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200207082842.1ce4bf32@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 07, 2020 at 08:28:42AM -0500, Steven Rostedt wrote:
>
>Hi Greg,
>
>On Fri, 07 Feb 2020 11:16:16 +0100
><gregkh@linuxfoundation.org> wrote:
>
>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>> index 8c52f5de9384..3c75d29bd861 100644
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -979,6 +979,7 @@ static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
>>  	 * Have to open code "rcu_dereference_sched()" because the
>>  	 * function graph tracer can be called when RCU is not
>>  	 * "watching".
>> +	 * Protected with schedule_on_each_cpu(ftrace_sync)
>>  	 */
>>  	hash = rcu_dereference_protected(ftrace_graph_hash, !preemptible());
>>
>> @@ -1031,6 +1032,7 @@ static inline int ftrace_graph_notrace_addr(unsigned long addr)
>>  	 * Have to open code "rcu_dereference_sched()" because the
>>  	 * function graph tracer can be called when RCU is not
>>  	 * "watching".
>> +	 * Protected with schedule_on_each_cpu(ftrace_sync)
>>  	 */
>>  	notrace_hash = rcu_dereference_protected(ftrace_graph_notrace_hash,
>>  						 !preemptible());
>
>Ah, I updated that patch to insert these comments, which makes it
>dependent on 16052dd5bdfa ("ftrace: Add comment to why
>rcu_dereference_sched() is open coded"). This is just adding comments
>and should have a very lower risk of breaking anything. If you add that
>patch first, then this patch should apply cleanly. Would it be OK to
>add that comment patch? It should fix most the conflicts.

I've ended up taking these additional commits, and queued everything for
5.5-4.14:

16052dd5bdfa ("ftrace: Add comment to why rcu_dereference_sched() is open coded")
24a9729f8314 ("tracing: Annotate ftrace_graph_hash pointer with __rcu")
fd0e6852c407 ("tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu")

-- 
Thanks,
Sasha
