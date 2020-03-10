Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F8C1809D5
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgCJVFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:05:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52914 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJVFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:05:09 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBm3o-0007Ja-5Z; Tue, 10 Mar 2020 15:05:08 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBm3n-0008Ca-EI; Tue, 10 Mar 2020 15:05:08 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kees Cook <keescook@chromium.org>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
        <87d09l2x5n.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <871rq12vxu.fsf@x220.int.ebiederm.org>
        <202003101352.28BE3BEB4@keescook>
Date:   Tue, 10 Mar 2020 16:02:48 -0500
In-Reply-To: <202003101352.28BE3BEB4@keescook> (Kees Cook's message of "Tue,
        10 Mar 2020 13:55:54 -0700")
Message-ID: <87a74nsz2f.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBm3n-0008Ca-EI;;;mid=<87a74nsz2f.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18PTvqUqvFHzaS8aRXcjAAB8aMmbAjVv+4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4984]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 341 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 2.6 (0.8%), b_tie_ro: 1.70 (0.5%), parse: 1.61
        (0.5%), extract_message_metadata: 18 (5.2%), get_uri_detail_list: 1.88
        (0.6%), tests_pri_-1000: 28 (8.4%), tests_pri_-950: 1.89 (0.6%),
        tests_pri_-900: 1.78 (0.5%), tests_pri_-90: 41 (12.1%), check_bayes:
        39 (11.5%), b_tokenize: 20 (5.9%), b_tok_get_all: 10 (2.9%),
        b_comp_prob: 2.8 (0.8%), b_tok_touch_all: 3.8 (1.1%), b_finish: 0.71
        (0.2%), tests_pri_0: 230 (67.6%), check_dkim_signature: 0.62 (0.2%),
        check_dkim_adsp: 2.2 (0.7%), poll_dns_idle: 0.72 (0.2%), tests_pri_10:
        2.1 (0.6%), tests_pri_500: 8 (2.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Mon, Mar 09, 2020 at 02:02:37PM -0500, Eric W. Biederman wrote:
>>     exec: Add exec_update_mutex to replace cred_guard_mutex
>>     
>>     The cred_guard_mutex is problematic as it is held over possibly
>>     indefinite waits for userspace.  The possilbe indefinite waits for
>>     userspace that I have identified are: The cred_guard_mutex is held in
>>     PTRACE_EVENT_EXIT waiting for the tracer.  The cred_guard_mutex is
>>     held over "put_user(0, tsk->clear_child_tid)" in exit_mm().  The
>>     cred_guard_mutex is held over "get_user(futex_offset, ...")  in
>>     exit_robust_list.  The cred_guard_mutex held over copy_strings.
>
> I suspect you're not trying to make a comprehensive list here, but do
> you want to mention seccomp too (since it's yet another weird case).

I was calling out all of the places I have found so far where
cred_guard_mutex is held over waiting for userspace to maybe do
something.  Those places are what cause our deadlocks.

>> [...]
>>     Holding a mutex over any of those possibly indefinite waits for
>>     userspace does not appear necessary.  Add exec_update_mutex that will
>>     just cover updating the process during exec where the permissions and
>>     the objects pointed to by the task struct may be out of sync.
>
> Should the specific resources be pointed out here? creds, mm, ... ?
>
> But otherwise, yup, looks sane:

Probably not.  The design is if exec changes it we will hold the
cred_guard_mutex over it, so things are semi-atomic.

> Reviewed-by: Kees Cook <keescook@chromium.org>

Eric
