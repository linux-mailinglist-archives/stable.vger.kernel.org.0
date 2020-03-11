Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B00182166
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgCKS7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:59:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45385 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730974AbgCKS7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 14:59:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id 2so1831939pfg.12
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 11:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZLCmQGD2nYRFngV6EM0JVcVHQdhqOzhhGYnboeZx+J8=;
        b=cEKMyEQqNjfrWLH7u32sjCQs4hChIhKsIZ0FmnXtkC4MfbJpY9o3rNlK4rYMDjh+45
         TETh5DQbErQLvzWXaM972+gECBSACcKku69Qsqowk2Q+HH8YsxB50x9QUNsub6EDIwnL
         4s6qwTsKVQ00/U+uZE5pymcXQkSM0FEMRbO4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZLCmQGD2nYRFngV6EM0JVcVHQdhqOzhhGYnboeZx+J8=;
        b=IzTXrN4cWF/1mAMohg36OKTOYAuo5asHISD8UMS4u6ZH1uoI3d9oS/P9dAXyOEGJCJ
         DrnrZiidrPCZy11AJmT73QRskZLBPBX+o/PgMN4Z+/vxtL6O85ry5Z967qPgfxUt2LLI
         /jvbT7MNIEoEmh7fSp65R6w6yI7U2bl/NXgpEO4D63Ea4d/17tntA82cbhA8XcrSCpPv
         4AeAoeP0mB8iyaolELV43afqBp01WUyfalN+WIVzPuIG1UIRtmBZXQxl81HLXcm6OLNs
         Ib2owA6l43uxVWN8oWsC++hzDqsKJpzh5U9lvcZICVwntMWXDisVGv529IeAWOX8xnLa
         lHcw==
X-Gm-Message-State: ANhLgQ2iuS3TO9FKgzcnLLCiyWrRzhhf9SBNtrDCEIEQVgMpLPT76+nh
        HmVnOrrSBX+PV9Cu0te8ZdFhmw==
X-Google-Smtp-Source: ADFU+vtJO9kiWA5K8fGpjclsKmfTQP+X/SjYQbVg72YZU8IhHMuYBgcwUyPQP2L+QH+kQwQAMxmaFA==
X-Received: by 2002:aa7:988f:: with SMTP id r15mr4221796pfl.252.1583953179891;
        Wed, 11 Mar 2020 11:59:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 11sm1155601pfv.43.2020.03.11.11.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 11:59:39 -0700 (PDT)
Date:   Wed, 11 Mar 2020 11:59:38 -0700
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
Subject: Re: [PATCH 2/4] proc: Use new infrastructure to fix deadlocks in
 execve
Message-ID: <202003111159.5D5B240F@keescook>
References: <87r1y12yc7.fsf@x220.int.ebiederm.org>
 <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfcxlwy.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705D211EC8E7EA270627B1E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB51705D211EC8E7EA270627B1E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 06:45:32PM +0100, Bernd Edlinger wrote:
> This changes lock_trace to use the new exec_update_mutex
> instead of cred_guard_mutex.
> 
> This fixes possible deadlocks when the trace is accessing
> /proc/$pid/stack for instance.
> 
> This should be safe, as the credentials are only used for reading,
> and task->mm is updated on execve under the new exec_update_mutex.
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  fs/proc/base.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index ebea950..4fdfe4f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -403,11 +403,11 @@ static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
>  
>  static int lock_trace(struct task_struct *task)
>  {
> -	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
> +	int err = mutex_lock_killable(&task->signal->exec_update_mutex);
>  	if (err)
>  		return err;
>  	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH_FSCREDS)) {
> -		mutex_unlock(&task->signal->cred_guard_mutex);
> +		mutex_unlock(&task->signal->exec_update_mutex);
>  		return -EPERM;
>  	}
>  	return 0;
> @@ -415,7 +415,7 @@ static int lock_trace(struct task_struct *task)
>  
>  static void unlock_trace(struct task_struct *task)
>  {
> -	mutex_unlock(&task->signal->cred_guard_mutex);
> +	mutex_unlock(&task->signal->exec_update_mutex);
>  }
>  
>  #ifdef CONFIG_STACKTRACE
> -- 
> 1.9.1

-- 
Kees Cook
