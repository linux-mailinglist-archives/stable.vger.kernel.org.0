Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4482C176E33
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 05:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCCEyl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 2 Mar 2020 23:54:41 -0500
Received: from mail-oln040092070095.outbound.protection.outlook.com ([40.92.70.95]:36853
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726859AbgCCEyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 23:54:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUIqA4VvWG4FLLAl4z2/BB+HHnfhfBcZgTj9JvgrJNdefzCGp1ggBeIxHyb1U+6l3KW9tgyXgrkzCRlVQZLJCL0vlw1Jf1T8GgRSnYk4P5zw8ZVg0DEl0MD70Z0gTzZQcB23puugjO1P641Cq9HYZ4MOjYiyM/BuiqaKYlq+ynMQAwmm9uzbAquOGsr2exi3cP+zX0zAelVmgyD/4TkZ/t4Tc+4SX5FlhfwYNElBsjMmfVHjxRTaSk9H+SsyU007H7v9AO1L8HOuZo/yHL9t/tGk3UAYVez8wG8y0HVv9R2FkdBfuqMpNUT8PK5se+4QdObgLQRu9QEkwEojYBl5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLKBicD0doo9BpuM8aW/ry59OGrYpUwBYuQjZ0cy1ts=;
 b=Pe6/sEhu76EWdb2OCC1TI8LpCZY4DsPlIp7SDOgWPXt8MYZypdWV+0/qQ1bZjAKVrduGZ/oD86j5LUj3464dF1TZBfAjI4pmH741MJ2Z4irWjcYaTfGR31uBfhuKxiw2vDlpS2QnCTLG67tPciFOTgvMkrAfDVq6Tw3U5TgRcdXb41TiQhKYvlvBcITIYCJuPCycCoLHbqspX1iR1Wkz7i1VQnz2R+py6q6ZrYh6h101oxG67dI7jA7mO8wM0qiVzKdvgijocKl5+KPlMxsh42PPHxwXQKxOUY7xOyi5BrDVPXUf2Es/27K32wmWVLb+s6OvfzJkaf8LDE9OoOYrjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from AM5EUR03FT045.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e08::36) by
 AM5EUR03HT035.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e08::356)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 04:54:35 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.16.56) by
 AM5EUR03FT045.mail.protection.outlook.com (10.152.17.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14 via Frontend Transport; Tue, 3 Mar 2020 04:54:35 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 04:54:35 +0000
Received: from [192.168.1.101] (92.77.140.102) by FRYP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 04:54:33 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Kees Cook <keescook@chromium.org>
CC:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCHv4] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv4] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8OBzc5kV6gCKfE+vkD4wYYEirqg2JJ+AgAApSAA=
Date:   Tue, 3 Mar 2020 04:54:34 +0000
Message-ID: <AM6PR03MB5170B5C1B95CB1D065EE3AFAE4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
In-Reply-To: <202003021531.C77EF10@keescook>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FRYP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::18)
 To AM6PR03MB5170.eurprd03.prod.outlook.com (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:D0AF81EBF57FF4E0FA39A02EF2E55711D9D9F378C1DBD8C5F2F55777D1A502FE;UpperCasedChecksum:A46C2A023D1186536431E9B2F54DA0623E0A2BC6F2AD1477215FBC4A3AEEB3E2;SizeAsReceived:9469;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [NdRjtnlpnqZCTBMFIqM7nCf2GpWI9J2o]
x-microsoft-original-message-id: <7ddd696b-7af5-1a52-d460-7881892cf0d7@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 6cea68ee-c06a-4212-8d1f-08d7bf2ef7e5
x-ms-traffictypediagnostic: AM5EUR03HT035:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jm/x99l+PneAy6z+Ztgs58DaLXr7PMcHQmh9slLsY2WgSyDkW2ogLH/wWdjDfSzRHSmUIX2jq5CpPsiounQiVg+28wSQDvfxYUI0ZvM+bgGXkneV0LG1/Gn6NtL/oQxECpqEQtNgMGOpseFaqUEv2PWA+C7aT7gzQWmVi1TDVAUFbzeQKWk7lHZGKa5DNgDw
x-ms-exchange-antispam-messagedata: JlVNasgbcpteY+b98q9b70if6wOCB2eZxIccmobvhxgT85eCX/hFhooDsrA3g0ZpHor97nhdqY18u51oGKor6xas/6fWcZvcY+eHmGnx3Ti9CXm/NqlQ0fKEP4n/bXjdz0gbquWi/0F0VPq9kuUVXw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <69DFAB71AE99E14B97C1F29DBB5FC5E7@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cea68ee-c06a-4212-8d1f-08d7bf2ef7e5
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 04:54:34.9238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR03HT035
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/20 3:26 AM, Kees Cook wrote:
> On Mon, Mar 02, 2020 at 10:18:07PM +0000, Bernd Edlinger wrote:
>> This fixes a deadlock in the tracer when tracing a multi-threaded
>> application that calls execve while more than one thread are running.
>>
>> I observed that when running strace on the gcc test suite, it always
>> blocks after a while, when expect calls execve, because other threads
>> have to be terminated.  They send ptrace events, but the strace is no
>> longer able to respond, since it is blocked in vm_access.
>>
>> The deadlock is always happening when strace needs to access the
>> tracees process mmap, while another thread in the tracee starts to
>> execve a child process, but that cannot continue until the
>> PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:
>>
>> strace          D    0 30614  30584 0x00000000
>> Call Trace:
>> __schedule+0x3ce/0x6e0
>> schedule+0x5c/0xd0
>> schedule_preempt_disabled+0x15/0x20
>> __mutex_lock.isra.13+0x1ec/0x520
>> __mutex_lock_killable_slowpath+0x13/0x20
>> mutex_lock_killable+0x28/0x30
>> mm_access+0x27/0xa0
>> process_vm_rw_core.isra.3+0xff/0x550
>> process_vm_rw+0xdd/0xf0
>> __x64_sys_process_vm_readv+0x31/0x40
>> do_syscall_64+0x64/0x220
>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> expect          D    0 31933  30876 0x80004003
>> Call Trace:
>> __schedule+0x3ce/0x6e0
>> schedule+0x5c/0xd0
>> flush_old_exec+0xc4/0x770
>> load_elf_binary+0x35a/0x16c0
>> search_binary_handler+0x97/0x1d0
>> __do_execve_file.isra.40+0x5d4/0x8a0
>> __x64_sys_execve+0x49/0x60
>> do_syscall_64+0x64/0x220
>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> The proposed solution is to take the cred_guard_mutex only
>> in a critical section at the beginning, and at the end of the
>> execve function, and let PTRACE_ATTACH fail with EAGAIN while
>> execve is not complete, but other functions like vm_access are
>> allowed to complete normally.
> 
> Sorry to be bummer, but I don't think this will work. A few more things
> during the exec process depend on cred_guard_mutex being held.
> 
> If I'm reading this patch correctly, this changes the lifetime of the
> cred_guard_mutex lock to be:
> 	- during prepare_bprm_creds()
> 	- from flush_old_exec() through install_exec_creds()
> Before, cred_guard_mutex was held from prepare_bprm_creds() through
> install_exec_creds().
> 
> That means, for example, that check_unsafe_exec()'s documented invariant
> is violated:
>     /*
>      * determine how safe it is to execute the proposed program
>      * - the caller must hold ->cred_guard_mutex to protect against
>      *   PTRACE_ATTACH or seccomp thread-sync
>      */

Oh, right, I haven't understood that hint...

>     static void check_unsafe_exec(struct linux_binprm *bprm) ...
> which is looking at no_new_privs as well as other details, and making
> decisions about the bprm state from the current state.
> 
> I think it also means that the potentially multiple invocations
> of bprm_fill_uid() (via prepare_binprm() via binfmt_script.c and
> binfmt_misc.c) would be changing bprm->cred details (uid, gid) without
> a lock (another place where current's no_new_privs is evaluated).

So no_new_privs can change from 0->1, but should not
when execve is running.

As long as the calling thread is in execve it won't do this,
and the only other place, where it may set for other threads
is in seccomp_sync_threads, but that can easily be avoided see below.

> 
> Related, it also means that cred_guard_mutex is unheld for every
> invocation of search_binary_handler() (which can loop via the previously
> mentioned binfmt_script.c and binfmt_misc.c), if any of them have hidden
> dependencies on cred_guard_mutex. (Thought I only see bprm_fill_uid()
> currently.)
> 
> For seccomp, the expectations about existing thread states risks races
> too. There are two locks held for TSYNC:
> - current->sighand->siglock is held to keep new threads from
>   appearing/disappearing, which would destroy filter refcounting and
>   lead to memory corruption.

I don't understand what you mean here.
How can this lead to memory corruption?

> - cred_guard_mutex is held to keep no_new_privs in sync with filters to
>   avoid no_new_privs and filter confusion during exec, which could
>   lead to exploitable setuid conditions (see below).
> 
> Just racing a malicious thread during TSYNC is not a very strong
> example (a malicious thread could do lots of fun things to "current"
> before it ever got near calling TSYNC), but I think there is the risk
> of mismatched/confused states that we don't want to allow. One is a
> particularly bad state that could lead to privilege escalations (in the
> form of the old "sendmail doesn't check setuid" flaw; if a setuid process
> has a filter attached that silently fails a priv-dropping setuid call
> and continues execution with elevated privs, it can be tricked into
> doing bad things on behalf of the unprivileged parent, which was the
> primary goal of the original use of cred_guard_mutex with TSYNC[1]):
> 
> thread A clones thread B
> thread B starts setuid exec
> thread A sets no_new_privs
> thread A calls seccomp with TSYNC
> thread A in seccomp_sync_threads() sets seccomp filter on self and thread B
> thread B passes check_unsafe_exec() with no_new_privs unset
> thread B reaches bprm_fill_uid() with no_new_privs unset and gains privs
> thread A still in seccomp_sync_threads() sets no_new_privs on thread B
> thread B finishes exec, now running with elevated privs, a filter chosen
>          by thread A, _and_ nnp set (which doesn't matter)
> 
> With the original locking, thread B will fail check_unsafe_exec()
> because filter and nnp state are changed together, with "atomicity"
> protected by the cred_guard_mutex.
> 

Ah, good point, thanks!

This can be fixed by checking current->signal->cred_locked_for_ptrace
while the cred_guard_mutex is locked, like this for instance:

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b6ea3dc..377abf0 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -342,6 +342,9 @@ static inline pid_t seccomp_can_sync_threads(void)
        BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
        assert_spin_locked(&current->sighand->siglock);
 
+       if (current->signal->cred_locked_for_ptrace)
+               return -EAGAIN;
+
        /* Validate all threads being eligible for synchronization. */
        caller = current;
        for_each_thread(caller, thread) {


> And this is just the bad state I _can_ see. I'm worried there are more...
> 
> All this said, I do see a small similarity here to the work I did to
> stabilize stack rlimits (there was an ongoing problem with making multiple
> decisions for the bprm based on current's state -- but current's state
> was mutable during exec). For this, I saved rlim_stack to bprm and ignored
> current's copy until exec ended and then stored bprm's copy into current.
> If the only problem anyone can see here is the handling of no_new_privs,
> we might be able to solve that similarly, at least disentangling tsync/nnp
> from cred_guard_mutex.
> 

I still think that is solvable with using cred_locked_for_ptrace and
simply make the tsync fail if it would otherwise be blocked.


Thanks
Bernd.
