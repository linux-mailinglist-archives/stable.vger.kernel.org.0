Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A30D1809CA
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCJVAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:00:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46995 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJVAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:00:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id c19so19556pfo.13
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 14:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8rwWaGaAnCRv7abCrLVGP/12v6tm69sSb/N4biM+MpU=;
        b=E4fHeovRMCTEHPf2Y5E/1XX89oUv6PPRO7U0xbU19Ojqt9o6vTvNVOrSjmjVlksK0u
         WT3MVOTY1M10Pq6ui6+/FqibefM1Uq0luC+0aYMB0nLC3CZ3xdern/rFtpoTc70jV0mw
         55hRTwk9a28dM92Eddl4f7pViHS37XCoNZMBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8rwWaGaAnCRv7abCrLVGP/12v6tm69sSb/N4biM+MpU=;
        b=lFcu9ffHhlw5dUo5Bn4TRPY+L4vebH3MFemWha36Yp/j+Py20IBGNPUZ4Il82rW9Lj
         jdpQIrIKZSJWYIbf061gRzZXTzrjzLcr5MtRfn/5MsRvq+0dKx3y80N8J27toPDxM30G
         oEmf5vTPop+kBLkJ6xjgOJBTykX+keJPhQOmj3sjzw22JjDaBAf24x8VSnLKEDwG3aG5
         MfyiqR79UZXcL7V06yN1pC9fsv/JupGfnjmh4kkUkGUtXRy1e0zI+GUbQifW7FaNiBmy
         584bMCeqXjHxk11jX8k4UrtUPmC3ydApYLYZCv6TbgU6qbzTX3wn+FBxBxKfVakYt3yU
         gptg==
X-Gm-Message-State: ANhLgQ2A8wxGBViqSRfprnccuaQ7jp5VIrMB5XgCcbV5Y44mLO3Tl0dj
        JcOL+h02cyOrULInJrEzRy5BNw==
X-Google-Smtp-Source: ADFU+vvzzBsNUhcLuygLAbVhS+hIcIHULf8laQU65uTwnTJV1Vz6m0g3VGILMP5riK69aqdvEmItOA==
X-Received: by 2002:a63:2542:: with SMTP id l63mr22436554pgl.312.1583874043288;
        Tue, 10 Mar 2020 14:00:43 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c201sm3106135pfc.73.2020.03.10.14.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 14:00:41 -0700 (PDT)
Date:   Tue, 10 Mar 2020 14:00:40 -0700
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
Subject: Re: [PATCH 1/4] exec: Fix a deadlock in ptrace
Message-ID: <202003101359.8BEE26F322@keescook>
References: <878sk94eay.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org>
 <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517033EAD25BED15CC84E17DE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB517033EAD25BED15CC84E17DE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 02:43:41PM +0100, Bernd Edlinger wrote:
> This fixes a deadlock in the tracer when tracing a multi-threaded
> application that calls execve while more than one thread are running.
> 
> I observed that when running strace on the gcc test suite, it always
> blocks after a while, when expect calls execve, because other threads
> have to be terminated.  They send ptrace events, but the strace is no
> longer able to respond, since it is blocked in vm_access.
> 
> The deadlock is always happening when strace needs to access the
> tracees process mmap, while another thread in the tracee starts to
> execve a child process, but that cannot continue until the
> PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:
> 
> strace          D    0 30614  30584 0x00000000
> Call Trace:
> __schedule+0x3ce/0x6e0
> schedule+0x5c/0xd0
> schedule_preempt_disabled+0x15/0x20
> __mutex_lock.isra.13+0x1ec/0x520
> __mutex_lock_killable_slowpath+0x13/0x20
> mutex_lock_killable+0x28/0x30
> mm_access+0x27/0xa0
> process_vm_rw_core.isra.3+0xff/0x550
> process_vm_rw+0xdd/0xf0
> __x64_sys_process_vm_readv+0x31/0x40
> do_syscall_64+0x64/0x220
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> expect          D    0 31933  30876 0x80004003
> Call Trace:
> __schedule+0x3ce/0x6e0
> schedule+0x5c/0xd0
> flush_old_exec+0xc4/0x770
> load_elf_binary+0x35a/0x16c0
> search_binary_handler+0x97/0x1d0
> __do_execve_file.isra.40+0x5d4/0x8a0
> __x64_sys_execve+0x49/0x60
> do_syscall_64+0x64/0x220
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> This changes mm_access to use the new exec_update_mutex
> instead of cred_guard_mutex.
> 
> This patch is based on the following patch by Eric W. Biederman:
> "[PATCH 0/5] Infrastructure to allow fixing exec deadlocks"
> Link: https://lore.kernel.org/lkml/87v9ne5y4y.fsf_-_@x220.int.ebiederm.org/
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>

Cool, yes, on top of the new infrastructure this looks correct to me --
the new mutex wraps mm changes and mm_access() is looking at *drum roll*
the mm! :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  kernel/fork.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index c12595a..5720ff3 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1224,7 +1224,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  	struct mm_struct *mm;
>  	int err;
>  
> -	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
> +	err =  mutex_lock_killable(&task->signal->exec_update_mutex);
>  	if (err)
>  		return ERR_PTR(err);
>  
> @@ -1234,7 +1234,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  		mmput(mm);
>  		mm = ERR_PTR(-EACCES);
>  	}
> -	mutex_unlock(&task->signal->cred_guard_mutex);
> +	mutex_unlock(&task->signal->exec_update_mutex);
>  
>  	return mm;
>  }
> -- 
> 1.9.1

-- 
Kees Cook
