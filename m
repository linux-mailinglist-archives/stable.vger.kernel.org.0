Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5B83B9842
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 23:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbhGAVn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 17:43:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58272 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhGAVn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 17:43:58 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lz4R2-00CqTz-JP; Thu, 01 Jul 2021 15:41:24 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:51614 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lz4R1-00CJeQ-F2; Thu, 01 Jul 2021 15:41:24 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Marco Elver <elver@google.com>
Cc:     peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-perf-users@vger.kernel.org,
        omosnace@redhat.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
References: <20210701083842.580466-1-elver@google.com>
Date:   Thu, 01 Jul 2021 16:41:15 -0500
In-Reply-To: <20210701083842.580466-1-elver@google.com> (Marco Elver's message
        of "Thu, 1 Jul 2021 10:38:43 +0200")
Message-ID: <87h7hdn24k.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lz4R1-00CJeQ-F2;;;mid=<87h7hdn24k.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+7+SbuL4vTLyI6IaqmY8TWPh1qYr3dYsI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4941]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Marco Elver <elver@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 503 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 11 (2.3%), b_tie_ro: 10 (1.9%), parse: 1.23
        (0.2%), extract_message_metadata: 4.7 (0.9%), get_uri_detail_list: 2.0
        (0.4%), tests_pri_-1000: 4.4 (0.9%), tests_pri_-950: 1.34 (0.3%),
        tests_pri_-900: 1.09 (0.2%), tests_pri_-90: 129 (25.7%), check_bayes:
        128 (25.4%), b_tokenize: 9 (1.8%), b_tok_get_all: 9 (1.8%),
        b_comp_prob: 2.8 (0.5%), b_tok_touch_all: 104 (20.7%), b_finish: 0.82
        (0.2%), tests_pri_0: 327 (65.0%), check_dkim_signature: 0.92 (0.2%),
        check_dkim_adsp: 2.7 (0.5%), poll_dns_idle: 0.74 (0.1%), tests_pri_10:
        2.2 (0.4%), tests_pri_500: 12 (2.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2] perf: Require CAP_KILL if sigtrap is requested
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Marco Elver <elver@google.com> writes:

> If perf_event_open() is called with another task as target and
> perf_event_attr::sigtrap is set, and the target task's user does not
> match the calling user, also require the CAP_KILL capability.
>
> Otherwise, with the CAP_PERFMON capability alone it would be possible
> for a user to send SIGTRAP signals via perf events to another user's
> tasks. This could potentially result in those tasks being terminated if
> they cannot handle SIGTRAP signals.
>
> Note: The check complements the existing capability check, but is not
> supposed to supersede the ptrace_may_access() check. At a high level we
> now have:
>
> 	capable of CAP_PERFMON and (CAP_KILL if sigtrap)
> 		OR
> 	ptrace_may_access() // also checks for same thread-group and uid

Is there anyway we could have a comment that makes the required
capability checks clear?

Basically I see an inlined version of kill_ok_by_cred being implemented
without the comments on why the various pieces make sense.

Certainly ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS) should not
be a check to allow writing/changing a task.  It needs to be
PTRACE_MODE_ATTACH_REALCREDS, like /proc/self/mem uses.

Now in practice I think your patch probably has the proper checks in
place for sending a signal but it is far from clear.

Eric


> Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
> Cc: <stable@vger.kernel.org> # 5.13+
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Marco Elver <elver@google.com>
> ---
> v2:
> * Drop kill_capable() and just check CAP_KILL (reported by Ondrej Mosnacek).
> * Use ns_capable(__task_cred(task)->user_ns, CAP_KILL) to check for
>   capability in target task's ns (reported by Ondrej Mosnacek).
> ---
>  kernel/events/core.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index fe88d6eea3c2..43c99695dc3f 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -12152,10 +12152,23 @@ SYSCALL_DEFINE5(perf_event_open,
>  	}
>  
>  	if (task) {
> +		bool is_capable;
> +
>  		err = down_read_interruptible(&task->signal->exec_update_lock);
>  		if (err)
>  			goto err_file;
>  
> +		is_capable = perfmon_capable();
> +		if (attr.sigtrap) {
> +			/*
> +			 * perf_event_attr::sigtrap sends signals to the other
> +			 * task. Require the current task to have CAP_KILL.
> +			 */
> +			rcu_read_lock();
> +			is_capable &= ns_capable(__task_cred(task)->user_ns, CAP_KILL);
> +			rcu_read_unlock();
> +		}
> +
>  		/*
>  		 * Preserve ptrace permission check for backwards compatibility.
>  		 *
> @@ -12165,7 +12178,7 @@ SYSCALL_DEFINE5(perf_event_open,
>  		 * perf_event_exit_task() that could imply).
>  		 */
>  		err = -EACCES;
> -		if (!perfmon_capable() && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
> +		if (!is_capable && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
>  			goto err_cred;
>  	}
