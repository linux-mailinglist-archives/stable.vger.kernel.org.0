Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F350196B29
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 06:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgC2EbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 00:31:21 -0400
Received: from mail-oln040092072097.outbound.protection.outlook.com ([40.92.72.97]:46857
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbgC2EbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Mar 2020 00:31:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyup1taQce7Czvt7r62RNYdbwR337OIPCOcCoEdRyTJRYDV8GLaNxAiL+bCCFyiWG9wCBa6VqWYqremWrUt/TqXQ5Zvcb0NEL8ZYrhItSyqGsTpb50rrsiivE/WA6p1PG0nsp9LXmwJeG2xxonJPV91T2J96ZoJfobB75ney0oeIuzcN+weNzkRWIOP05cs/1U+EnkxdP3GyDGhzVqxEEo18LI7TFGZC/vuWGr/XR8gebaZxOfPzkD/pNfJBSQ9ULBvxzB8jkz0ev4QEQLaAwL9vzEYkFA0m1H6jZGHbHlJ170I0hYcYnkwQSH7x5ZM4qKfILIkQiZpUp0OnHQVlJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BU6qOvtkmoxpqbOUiMCq2Q6Uh6Xqp4ZpfT/eykTnfl4=;
 b=ltV5XHTSw9REvhh8GTOAeC3mMtQvHO+X3Xn9KrB9aMLKZGgBpvjArcO87SLf2r4Sif03lMUfNWM5T8tr98vB6APpmaXtC4uBRO9gf/o2pKlNjqtHmOLlkiyk0IDhXSyBxb47t8asemeIYnpwQKLh8p3g4Qh8jFYCYo4HoaYkB5rWaxRMnFcH1vvIIHz8/us6KSV9p0hqNFF5y+ZFVBxNcDJFQCLS8iXbv4QFIKf8He9zkJDHlIjoDnmKe4r0K+qGl/XdSYgtRbTvSCEuFU9AnODrj2w8DqsY+T9wFrAhy1h6YgHTdj9Heqlg3LlB9eh2SqQZkj78kzrw2FB1xndJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from VE1EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e09::52) by
 VE1EUR03HT047.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e09::416)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.17; Sun, 29 Mar
 2020 04:31:14 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.18.51) by
 VE1EUR03FT048.mail.protection.outlook.com (10.152.19.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.17 via Frontend Transport; Sun, 29 Mar 2020 04:31:14 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:ED9EED656349D1FAC421A208C7F8CFD1A715EF757F9B8E5B54AB5D7201CA1406;UpperCasedChecksum:872083040AC657C2F86F36691608A054C21B532E3E0B156EAF4E00B017714D8F;SizeAsReceived:9568;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.025; Sun, 29 Mar 2020
 04:31:14 +0000
Subject: Re: [PATCH v6 15/16] exec: Fix dead-lock in de_thread with
 ptrace_attach
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        "jannh@google.com" <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "duyuyang@gmail.com" <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "christian@kellner.me" <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
 <b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de>
 <87a7448q7t.fsf@x220.int.ebiederm.org>
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Message-ID: <AM6PR03MB51700B30078BDCB6C6A4E0CAE4CA0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Sun, 29 Mar 2020 06:31:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <87a7448q7t.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::23) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <88361bfb-17d9-aae5-b7ef-08d4271c9bad@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by ZRAP278CA0013.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Sun, 29 Mar 2020 04:31:12 +0000
X-Microsoft-Original-Message-ID: <88361bfb-17d9-aae5-b7ef-08d4271c9bad@hotmail.de>
X-TMN:  [4KLlOOtqgqNbDk08WSbsS+zK6jdLXZV3]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 5e9d7664-0054-49af-6157-08d7d39a042d
X-MS-TrafficTypeDiagnostic: VE1EUR03HT047:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/6ABfWPMOvYmVF/EnnTcKRwiZPgLYPvr9qYP8jRl35a42BJw0NbBjO/e48BVSF42XmzPdJwjUbP9h3SJGDuz+7vz7LJ1bI6sn3wCVeVjFdf3Pi961YLETO0X7GX8ETHia8ANJfWrrWlmrJGYm2mWbk8A7T6SFy98uAid0TnK1B6AXwXYlncFMVa143CX/BL
X-MS-Exchange-AntiSpam-MessageData: HQ9anwJaCcDwGJH2DhJEt2I93KHYcht9rU00eGoDRXCyeI/s7Y+OTYslB3oEYTQfG8GxhJaDmu4PnyOf02kIWSi6k/O3/ue36tkcKJ3XVWLM0VZOaYkWjLwa1Ge1G5nfu3MnD6+FHKRkLsLGk79+WQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e9d7664-0054-49af-6157-08d7d39a042d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2020 04:31:14.7979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR03HT047
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/20 3:27 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> This removes the last users of cred_guard_mutex
>> and replaces it with a new mutex exec_guard_mutex,
>> and a boolean unsafe_execve_in_progress.
>>
>> This addresses the case when at least one of the
>> sibling threads is traced, and therefore the trace
>> process may dead-lock in ptrace_attach, but de_thread
>> will need to wait for the tracer to continue execution.
>>
>> The solution is to detect this situation and make
>> ptrace_attach and similar functions return -EAGAIN,
>> but only in a situation where a dead-lock is imminent.
>>
>> This means this is an API change, but only when the
>> process is traced while execve happens in a
>> multi-threaded application.
>>
>> See tools/testing/selftests/ptrace/vmaccess.c
>> for a test case that gets fixed by this change.
> 
> Hmm.  The logic with unsafe_execve_in_progress is interesting.
> I think I see what you are aiming for.
> 
> So far as you have hit what you are aiming for I think this is
> a safe change as the only cases that will change are the cases
> that would deadlock today.
> 
> At a minimum the code is subtle and I don't see big fat
> warning comments that subtle code needs to keep people
> from using it wrong.
> 

Okay, I can add big fat warning comments, yeah.

> Further while the change below to proc_pid_attr_write looks
> like it is being treated the same as ptrace_attach.  When in
> fact proc_pid_attr_write needs the no_new_privs and ptrace_attach
> protection the same as exec.  As the updated cred won't be used in an
> ongoing exec, exec does not need protection from proc_pid_attr_write,
> other than deadlock protection.
> 

Not sure I understand this comment correct.
You refer to this block here:

> @@ -2680,14 +2680,17 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
>         }
> 
>         /* Guard against adverse ptrace interaction */
> -       rv = mutex_lock_interruptible(&current->signal->cred_guard_mutex);
> +       rv = mutex_lock_interruptible(&current->signal->exec_guard_mutex);
>         if (rv < 0)
>                 goto out_free;
> 
> -       rv = security_setprocattr(PROC_I(inode)->op.lsm,
> -                                 file->f_path.dentry->d_name.name, page,
> -                                 count);
> -       mutex_unlock(&current->signal->cred_guard_mutex);
> +       if (unlikely(current->signal->unsafe_execve_in_progress))
> +               rv = -EAGAIN;
> +       else
> +               rv = security_setprocattr(PROC_I(inode)->op.lsm,
> +                                         file->f_path.dentry->d_name.name,
> +                                         page, count);
> +       mutex_unlock(&current->signal->exec_guard_mutex);
>  out_free:
>         kfree(page);

I think the logic is correct, but instead if an if-then-else,
I need the big-fat-warning-comment followed by if-unsafe-goto-mutex-unlock
kind of thing, so it looks more like the other places, right?


> Having the relevant lock be per task_struct lock would probably be a
> better way to avoid deadlock with a concurrent proc_pid_attr_write.
> 

Please elaborate your idea a bit.

> 
> So I am going to pass on these last two patches for now, and apply the
> rest and get them into linux-next.
> 

No problem, I can update this patch and if you like take it to your tree,
otherwise it is of course not the most important issue in the world ;-)


Thanks
Bernd.
