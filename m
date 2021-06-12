Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487D83A4D38
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 09:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhFLHE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Jun 2021 03:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhFLHE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Jun 2021 03:04:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AFF961186;
        Sat, 12 Jun 2021 07:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623481366;
        bh=cyYgnn12E0TUjCf1JhTdpZWgTwBzpbkz1bQDyTJlhMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yJSnl7XvMM4cnz9idU0uiHyw0U8UmcOhjJUkAVkPeKLRojAjWo41UycxvpWwUJl4x
         VtiFZyJarVfZjTQmo5Lxd8mWDPWeNA9ZJo9rmuL4nJ90SwBel1si1DcECLZLjExCUm
         P22i9T5WMTFEHtlgPBvXAp7oENanh6JL9MJ9b+cs=
Date:   Sat, 12 Jun 2021 09:02:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Charles Haithcock <chaithco@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Helge Deller <deller@gmx.de>,
        YiFei Zhu <yifeifz2@illinois.edu>,
        Adrian Reber <areber@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v9] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <YMRcE8NXspQjSwQZ@kroah.com>
References: <AM8PR10MB4708AFBD838138A84CE89EF8E4359@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <20210610143642.e4535dbdc0db0b1bd3ee5367@linux-foundation.org>
 <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM8PR10MB470896FBC519ABCC20486958E4349@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 11, 2021 at 05:55:09PM +0200, Bernd Edlinger wrote:
> This introduces signal->unsafe_execve_in_progress,
> which is used to fix the case when at least one of the
> sibling threads is traced, and therefore the trace
> process may dead-lock in ptrace_attach, but de_thread
> will need to wait for the tracer to continue execution.
> 
> The solution is to detect this situation and allow
> ptrace_attach to continue, while de_thread() is still
> waiting for traced zombies to be eventually released.
> When the current thread changed the ptrace status from
> non-traced to traced, we can simply abort the whole
> execve and restart it by returning -ERESTARTSYS.
> This needs to be done before changing the thread leader,
> because the PTRACE_EVENT_EXEC needs to know the old
> thread pid.
> 
> Although it is technically after the point of no return,
> we just have to reset bprm->point_of_no_return here,
> since at this time only the other threads have received
> a fatal signal, not the current thread.
> 
> >From the user's point of view the whole execve was
> simply delayed until after the ptrace_attach.
> 
> Other threads die quickly since the cred_guard_mutex
> is released, but a deadly signal is already pending.
> In case the mutex_lock_killable misses the signal,
> ->unsafe_execve_in_progress makes sure they release
> the mutex immediately and return with -ERESTARTNOINTR.
> 
> This means there is no API change, unlike the previous
> version of this patch which was discussed here:
> 
> https://lore.kernel.org/lkml/b6537ae6-31b1-5c50-f32b-8b8332ace882@hotmail.de/
> 
> See tools/testing/selftests/ptrace/vmaccess.c
> for a test case that gets fixed by this change.
> 
> Note that since the test case was originally designed to
> test the ptrace_attach returning an error in this situation,
> the test expectation needed to be adjusted, to allow the
> API to succeed at the first attempt.
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  fs/exec.c                                 | 37 +++++++++++++++++++++++++++++--
>  fs/proc/base.c                            |  6 +++++
>  include/linux/sched/signal.h              | 13 +++++++++++
>  kernel/ptrace.c                           |  9 ++++++++
>  kernel/seccomp.c                          | 12 +++++++---
>  tools/testing/selftests/ptrace/vmaccess.c | 25 ++++++++++++++-------
>  6 files changed, 89 insertions(+), 13 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
