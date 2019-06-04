Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDE635486
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFDXvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:51:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48712 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFDXvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 19:51:53 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hYJDZ-0007Eb-FK; Tue, 04 Jun 2019 17:51:49 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hYJDY-0007E1-J9; Tue, 04 Jun 2019 17:51:49 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Laight <David.Laight@aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
        <20190529161157.GA27659@redhat.com>
        <20190604134117.GA29963@redhat.com>
        <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
Date:   Tue, 04 Jun 2019 18:51:39 -0500
In-Reply-To: <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
        (Linus Torvalds's message of "Tue, 4 Jun 2019 14:26:42 -0700")
Message-ID: <878sugewok.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hYJDY-0007E1-J9;;;mid=<878sugewok.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18JWsEY56EAlEOUXsS4oiORhVM/2epMWVE=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,FVGT_m_MULTI_ODD,T_TM2_M_HEADER_IN_MSG,
        T_TooManySym_01,T_TooManySym_02,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 487 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 3.8 (0.8%), b_tie_ro: 2.6 (0.5%), parse: 1.62
        (0.3%), extract_message_metadata: 20 (4.2%), get_uri_detail_list: 3.9
        (0.8%), tests_pri_-1000: 20 (4.0%), tests_pri_-950: 1.82 (0.4%),
        tests_pri_-900: 1.45 (0.3%), tests_pri_-90: 34 (7.0%), check_bayes: 32
        (6.6%), b_tokenize: 13 (2.6%), b_tok_get_all: 10 (2.0%), b_comp_prob:
        3.6 (0.7%), b_tok_touch_all: 3.2 (0.7%), b_finish: 0.74 (0.2%),
        tests_pri_0: 383 (78.8%), check_dkim_signature: 0.62 (0.1%),
        check_dkim_adsp: 3.1 (0.6%), poll_dns_idle: 0.03 (0.0%), tests_pri_10:
        4.6 (0.9%), tests_pri_500: 11 (2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in restore_user_sigmask()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Jun 4, 2019 at 6:41 AM Oleg Nesterov <oleg@redhat.com> wrote:
>>
>> This is the minimal fix for stable, I'll send cleanups later.
>
> Ugh. I htink this is correct, but I wish we had a better and more
> intuitive interface.
>
> In particular, since restore_user_sigmask() basically wants to check
> for "signal_pending()" anyway (to decide if the mask should be
> restored by signal handling or by that function), I really get the
> feeling that a lot of these patterns like

Linus that checking for signal_pending() in restore_user_sigmask is the
bug that caused the regression.

>> -       restore_user_sigmask(ksig.sigmask, &sigsaved);
>> -       if (signal_pending(current) && !ret)
>> +
>> +       interrupted = signal_pending(current);
>> +       restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
>> +       if (interrupted && !ret)
>>                 ret = -ERESTARTNOHAND;
>
> are wrong to begin with, and we really should aim for an interface
> which says "tell me whether you completed the system call, and I'll
> give you an error return if not".

The pattern you are pointing out is specific to io_pgetevents and it's
variations.  It does look buggy to me but not for the reason you point
out, but instead because it does not appear to let a pending signal
cause io_pgetevents to return early.

I suspect we should fix that and have do_io_getevents return
-EINTR or -ERESTARTNOHAND like everyone else.

The concept of interrupted (aka return -EINTR to userspace) is truly
fundamental to the current semantics.  We effectively put a normally
blocked signal that was triggered back if we won't be returning -EINTR
to userspace.

> How about we make restore_user_sigmask() take two return codes: the
> 'ret' we already have, and the return we would get if there is a
> signal pending and w're currently returning zero.
>
> IOW, I think the above could become
>
>         ret = restore_user_sigmask(ksig.sigmask, &sigsaved, ret, -ERESTARTHAND);
>
> instead if we just made the right interface decision.
>
> Hmm?

At best I think that is a cleanup that will complicate creating a simple
straight forward regression fix.

Unless I am misreading things that is optimizing the interface for
dealing with broken code.

So can we please get this fix in and then look at cleaning up and
simplifying this code.

Eric

p.s. A rather compelling cleanup is to:

- Leave the signal mask alone.
- Register with signalfd_wqh for wake ups.
- Have a helper

   int signal_pending_sigmask(sigset_t *blocked)
   {
   	struct task_struct *tsk = current;
   	int ret = 0;
   	spin_lock_irq(&tsk->sighand->siglock);
        if (next_signal(&tsk->pending, blocked) ||
            next_signal(&tsk->signal->pending, blocked)) {
        	ret = -ERESTARTHAND;
                if (!sigequalsets(&tsk->blocked, blocked)) {
                	tsk->saved_sigmask = tsk->blocked;
                	__set_task_blocked(tsk, blocked);
                        set_restore_sigmask();
		}
        }
        spin_unlock_irq(&tsk->sighand->siglock);
        return ret;
   }
  
- Use that helper instead of signal_pending() in the various
  sleep functions.
- Possibly get the signal mask from tsk instead of passing it into
  all of the helpers.

Eric
