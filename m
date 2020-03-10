Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5519E180A93
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJVg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:36:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34455 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJVg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:36:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id 23so93216pfj.1
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 14:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NWf0TdeJvck0pCGGb01hva0XMggef5ubqIU9iaLUhUA=;
        b=NXdmMClgabWQioF4yjl5Jwd3G2+POPv9SbUzVwujJhh2o2BxjxxPsjmZx+RtR3ZTkT
         fid8mFGefGZRDOe9uPgT1YkjFUTL2YObjeqf7oy5iWafQQpc/Nr/eBX6Dqq2cvpJd3wt
         zEwIhTLVA6qRzzVmFGqNT3JOmI0cC8+6pR2cc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NWf0TdeJvck0pCGGb01hva0XMggef5ubqIU9iaLUhUA=;
        b=dGdA9Efv3SJx7SIa/NnThm03Q6cVmMSFKYB0dT4bS8yUrscrhm8r8L8/1cCa+l64ge
         Ypt/4Ok1JQoJNrqK+7GXwvc1JNeUvxw9zEW5G4ZHgwYSoxYotudFKZbZ/f1DMGhl0mlQ
         eaLid9u3ID5soYF2RlKp80nzb2DPWljuk+OYyAi6ErTvM5lx7UtqyZcKXlX63IJ874pb
         p+apxhJP9if9k3zJGut7Clf2RA75uOriNNSVjBB/yMAI0Wc6mU+2fWMluWCdoR2wyi42
         QS20okgGJZ7pgFPHzXLMzCsiP6FbWAXd/69IFUvQeOkq2TlqovS+oTaGGsifrw6Z9qn5
         tB+w==
X-Gm-Message-State: ANhLgQ1Ted99Taijg9RJz6vRYuW4FrDvyKa2pKV0cIzOMaoxRFpjJph6
        YtlsuHswPR/wJn++ckCBAOjfLQ==
X-Google-Smtp-Source: ADFU+vs/Uypr3q8a3tw+hkF+0Zw9ymbsnPXTwDAQkVznHvEHqBvv2ESuGLkB9ZYHjVG64HW7T+09ig==
X-Received: by 2002:a65:44cd:: with SMTP id g13mr23586615pgs.365.1583876182960;
        Tue, 10 Mar 2020 14:36:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g11sm20159100pfo.184.2020.03.10.14.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 14:36:21 -0700 (PDT)
Date:   Tue, 10 Mar 2020 14:36:20 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH 2/4] selftests/ptrace: add test cases for dead-locks
Message-ID: <202003101401.9A4FD3F@keescook>
References: <878sk94eay.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org>
 <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51703199741A2C27A78980FFE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB51703199741A2C27A78980FFE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 02:44:01PM +0100, Bernd Edlinger wrote:
> This adds test cases for ptrace deadlocks.
> 
> Additionally fixes a compile problem in get_syscall_info.c,
> observed with gcc-4.8.4:
> 
> get_syscall_info.c: In function 'get_syscall_info':
> get_syscall_info.c:93:3: error: 'for' loop initial declarations are only
>                                  allowed in C99 mode
>    for (unsigned int i = 0; i < ARRAY_SIZE(args); ++i) {
>    ^
> get_syscall_info.c:93:3: note: use option -std=c99 or -std=gnu99 to compile
>                                your code

*discomfort noises* (see below)

> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  tools/testing/selftests/ptrace/Makefile   |  4 +-
>  tools/testing/selftests/ptrace/vmaccess.c | 86 +++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/ptrace/vmaccess.c
> 
> diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
> index c0b7f89..2f1f532 100644
> --- a/tools/testing/selftests/ptrace/Makefile
> +++ b/tools/testing/selftests/ptrace/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -CFLAGS += -iquote../../../../include/uapi -Wall
> +CFLAGS += -std=c99 -pthread -iquote../../../../include/uapi -Wall

This isn't the common solution in the kernel (the variable declaration
would just be lifted out of the loop), but as it's selftest code, which
does lots of special things ... I *guess* this is okay.

>  
> -TEST_GEN_PROGS := get_syscall_info peeksiginfo
> +TEST_GEN_PROGS := get_syscall_info peeksiginfo vmaccess

I love having this deadlock test added to the selftests.

I think I need to make an improvement to the test harness, though, as
the failure mode right now just blows up after the 30 second timeout
and leaves this deadlocked:

$ ./vmaccess
[==========] Running 2 tests from 1 test cases.
[ RUN      ] global.vmaccess
Alarm clock
$ ps
  PID TTY          TIME CMD
 2605 pts/0    00:00:00 bash
23360 pts/0    00:00:00 vmaccess
23361 pts/0    00:00:00 vmaccess
23363 pts/0    00:00:00 ps

But that's mostly unrelated to this code.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

>  
>  include ../lib.mk
> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
> new file mode 100644
> index 0000000..4db327b
> --- /dev/null
> +++ b/tools/testing/selftests/ptrace/vmaccess.c
> @@ -0,0 +1,86 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
> + * All rights reserved.
> + *
> + * Check whether /proc/$pid/mem can be accessed without causing deadlocks
> + * when de_thread is blocked with ->cred_guard_mutex held.
> + */
> +
> +#include "../kselftest_harness.h"
> +#include <stdio.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <signal.h>
> +#include <unistd.h>
> +#include <sys/ptrace.h>
> +
> +static void *thread(void *arg)
> +{
> +	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
> +	return NULL;
> +}
> +
> +TEST(vmaccess)
> +{
> +	int f, pid = fork();
> +	char mm[64];
> +
> +	if (!pid) {
> +		pthread_t pt;
> +
> +		pthread_create(&pt, NULL, thread, NULL);
> +		pthread_join(pt, NULL);
> +		execlp("true", "true", NULL);
> +	}
> +
> +	sleep(1);
> +	sprintf(mm, "/proc/%d/mem", pid);
> +	f = open(mm, O_RDONLY);
> +	ASSERT_GE(f, 0);
> +	close(f);
> +	f = kill(pid, SIGCONT);
> +	ASSERT_EQ(f, 0);
> +}
> +
> +TEST(attach)
> +{
> +	int s, k, pid = fork();
> +
> +	if (!pid) {
> +		pthread_t pt;
> +
> +		pthread_create(&pt, NULL, thread, NULL);
> +		pthread_join(pt, NULL);
> +		execlp("sleep", "sleep", "2", NULL);
> +	}
> +
> +	sleep(1);
> +	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
> +	ASSERT_EQ(errno, EAGAIN);
> +	ASSERT_EQ(k, -1);
> +	k = waitpid(-1, &s, WNOHANG);
> +	ASSERT_NE(k, -1);
> +	ASSERT_NE(k, 0);
> +	ASSERT_NE(k, pid);
> +	ASSERT_EQ(WIFEXITED(s), 1);
> +	ASSERT_EQ(WEXITSTATUS(s), 0);
> +	sleep(1);
> +	k = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
> +	ASSERT_EQ(k, 0);
> +	k = waitpid(-1, &s, 0);
> +	ASSERT_EQ(k, pid);
> +	ASSERT_EQ(WIFSTOPPED(s), 1);
> +	ASSERT_EQ(WSTOPSIG(s), SIGSTOP);
> +	k = ptrace(PTRACE_DETACH, pid, 0L, 0L);
> +	ASSERT_EQ(k, 0);
> +	k = waitpid(-1, &s, 0);
> +	ASSERT_EQ(k, pid);
> +	ASSERT_EQ(WIFEXITED(s), 1);
> +	ASSERT_EQ(WEXITSTATUS(s), 0);
> +	k = waitpid(-1, NULL, 0);
> +	ASSERT_EQ(k, -1);
> +	ASSERT_EQ(errno, ECHILD);
> +}
> +
> +TEST_HARNESS_MAIN
> -- 
> 1.9.1

-- 
Kees Cook
