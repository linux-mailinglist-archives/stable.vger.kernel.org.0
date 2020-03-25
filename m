Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45579192B22
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 15:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgCYOaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 10:30:08 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58982 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727538AbgCYOaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 10:30:08 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jH72b-0002ea-CW; Wed, 25 Mar 2020 08:29:57 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jH72Z-0002AT-33; Wed, 25 Mar 2020 08:29:56 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        "jannh\@google.com" <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "adobriyan\@gmail.com" <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "avagin\@gmail.com" <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        "duyuyang\@gmail.com" <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "christian\@kellner.me" <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
        <b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de>
Date:   Wed, 25 Mar 2020 09:27:18 -0500
In-Reply-To: <b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de> (Bernd
        Edlinger's message of "Sat, 21 Mar 2020 02:46:39 +0000")
Message-ID: <87a7448q7t.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jH72Z-0002AT-33;;;mid=<87a7448q7t.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1//grV9RcExZss0OZxt5aCJ/pLvokQjxgE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4772]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 556 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 12 (2.2%), b_tie_ro: 10 (1.8%), parse: 1.50
        (0.3%), extract_message_metadata: 14 (2.5%), get_uri_detail_list: 2.3
        (0.4%), tests_pri_-1000: 14 (2.6%), tests_pri_-950: 1.33 (0.2%),
        tests_pri_-900: 1.19 (0.2%), tests_pri_-90: 231 (41.5%), check_bayes:
        226 (40.7%), b_tokenize: 12 (2.1%), b_tok_get_all: 51 (9.3%),
        b_comp_prob: 2.7 (0.5%), b_tok_touch_all: 154 (27.8%), b_finish: 1.54
        (0.3%), tests_pri_0: 268 (48.3%), check_dkim_signature: 0.80 (0.1%),
        check_dkim_adsp: 2.7 (0.5%), poll_dns_idle: 0.74 (0.1%), tests_pri_10:
        2.3 (0.4%), tests_pri_500: 7 (1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v6 15/16] exec: Fix dead-lock in de_thread with ptrace_attach
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> This removes the last users of cred_guard_mutex
> and replaces it with a new mutex exec_guard_mutex,
> and a boolean unsafe_execve_in_progress.
>
> This addresses the case when at least one of the
> sibling threads is traced, and therefore the trace
> process may dead-lock in ptrace_attach, but de_thread
> will need to wait for the tracer to continue execution.
>
> The solution is to detect this situation and make
> ptrace_attach and similar functions return -EAGAIN,
> but only in a situation where a dead-lock is imminent.
>
> This means this is an API change, but only when the
> process is traced while execve happens in a
> multi-threaded application.
>
> See tools/testing/selftests/ptrace/vmaccess.c
> for a test case that gets fixed by this change.

Hmm.  The logic with unsafe_execve_in_progress is interesting.
I think I see what you are aiming for.

So far as you have hit what you are aiming for I think this is
a safe change as the only cases that will change are the cases
that would deadlock today.

At a minimum the code is subtle and I don't see big fat
warning comments that subtle code needs to keep people
from using it wrong.

Further while the change below to proc_pid_attr_write looks
like it is being treated the same as ptrace_attach.  When in
fact proc_pid_attr_write needs the no_new_privs and ptrace_attach
protection the same as exec.  As the updated cred won't be used in an
ongoing exec, exec does not need protection from proc_pid_attr_write,
other than deadlock protection.

Having the relevant lock be per task_struct lock would probably be a
better way to avoid deadlock with a concurrent proc_pid_attr_write.


So I am going to pass on these last two patches for now, and apply the
rest and get them into linux-next.

Eric


> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6b13fc4..a428536 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2680,14 +2680,17 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
>  	}
>  
>  	/* Guard against adverse ptrace interaction */
> -	rv = mutex_lock_interruptible(&current->signal->cred_guard_mutex);
> +	rv = mutex_lock_interruptible(&current->signal->exec_guard_mutex);
>  	if (rv < 0)
>  		goto out_free;
>  
> -	rv = security_setprocattr(PROC_I(inode)->op.lsm,
> -				  file->f_path.dentry->d_name.name, page,
> -				  count);
> -	mutex_unlock(&current->signal->cred_guard_mutex);
> +	if (unlikely(current->signal->unsafe_execve_in_progress))
> +		rv = -EAGAIN;
> +	else
> +		rv = security_setprocattr(PROC_I(inode)->op.lsm,
> +					  file->f_path.dentry->d_name.name,
> +					  page, count);
> +	mutex_unlock(&current->signal->exec_guard_mutex);
>  out_free:
>  	kfree(page);
>  out:
