Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1781719BC8B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 09:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgDBHTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 03:19:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38907 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387431AbgDBHTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 03:19:39 -0400
Received: by mail-pl1-f196.google.com with SMTP id w3so1012897plz.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 00:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MNcbIL1+RcHP9n1/a7uW2cYhRUPkvEWLMMecHAgQsXw=;
        b=Mkdjc5J1SEZfYsVao6D+3svMUTOlPWR0GUglETGCp1BLe0DlCeO6EhQvWvFeICMv36
         FhEx79mg9w4G5l0oE52LrM6gGTrotrudHbeodjWMutpEZgdksa6OfQMqYRb+P06vpBHA
         5ziM8BNeNC/piG1MVXXvFtq9O6gGtn/zz65nI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MNcbIL1+RcHP9n1/a7uW2cYhRUPkvEWLMMecHAgQsXw=;
        b=C/G0PxbvddHH124GzmRgug65fjVyB4EbJ5oLyinVdt2CD3dHETaCOb600jxGEnt+KJ
         JDBxbA07wQPv+H0jlTrR3F4pdWXgES3OAZxjpQGLPh+CKUbu3EFIGVM80v4MNZFHVuAZ
         pA2SPjThGYOSRlSDBlPsR6Ycx7mjFfhLI/lUvX3VOwKuBmZNv88m0Z3/W4jrG0zaYC7y
         dUw9ZCkblS3PkoLc7Ih3aaeM/3drXxWblCrZ4TBkKugaPqq886lr8d4RLOBSnqoOsO3T
         7Y4i/7nS0XbAyCnRb4wms0fjTJpvzbkd/VCw+h4tBot6TwPjhcaTmiVIIDssj2EKFgqa
         7xWg==
X-Gm-Message-State: AGi0PuarmdJkvg1kcQh744fugk7HFAbLTdDKR7SeLS96hH08iZiI2bZY
        5V5bbFqBxisuP+TlH49j1Seljg==
X-Google-Smtp-Source: APiQypIgY9efFSF0nGqyq4XrnljhNDsb8eVxK3UTxH/mnTcO3+iTBEtSUKooI7eOyQJMhEFKWznCZA==
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr1717580pls.285.1585811976162;
        Thu, 02 Apr 2020 00:19:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x70sm2957375pfc.21.2020.04.02.00.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 00:19:35 -0700 (PDT)
Date:   Thu, 2 Apr 2020 00:19:34 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Adam Zabrocki <pi3@pi3.com.pl>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
Message-ID: <202004020019.1F1EEC3669@keescook>
References: <20200324215049.GA3710@pi3.com.pl>
 <202003291528.730A329@keescook>
 <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 03:47:44PM -0500, Eric W. Biederman wrote:
> 
> Replace the 32bit exec_id with a 64bit exec_id to make it impossible
> to wrap the exec_id counter.  With care an attacker can cause exec_id
> wrap and send arbitrary signals to a newly exec'd parent.  This
> bypasses the signal sending checks if the parent changes their
> credentials during exec.
> 
> The severity of this problem can been seen that in my limited testing
> of a 32bit exec_id it can take as little as 19s to exec 65536 times.
> Which means that it can take as little as 14 days to wrap a 32bit
> exec_id.  Adam Zabrocki has succeeded wrapping the self_exe_id in 7
> days.  Even my slower timing is in the uptime of a typical server.
> Which means self_exec_id is simply a speed bump today, and if exec
> gets noticably faster self_exec_id won't even be a speed bump.
> 
> Extending self_exec_id to 64bits introduces a problem on 32bit
> architectures where reading self_exec_id is no longer atomic and can
> take two read instructions.  Which means that is is possible to hit
> a window where the read value of exec_id does not match the written
> value.  So with very lucky timing after this change this still
> remains expoiltable.
> 
> I have updated the update of exec_id on exec to use WRITE_ONCE
> and the read of exec_id in do_notify_parent to use READ_ONCE
> to make it clear that there is no locking between these two
> locations.
> 
> Link: https://lore.kernel.org/kernel-hardening/20200324215049.GA3710@pi3.com.pl
> Fixes: 2.3.23pre2
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Thanks for chasing this down. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> 
> Linus would you prefer to take this patch directly or I could put it in
> a brach and send you a pull request.
>  
>  fs/exec.c             | 2 +-
>  include/linux/sched.h | 4 ++--
>  kernel/signal.c       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 0e46ec57fe0a..d55710a36056 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1413,7 +1413,7 @@ void setup_new_exec(struct linux_binprm * bprm)
>  
>  	/* An exec changes our domain. We are no longer part of the thread
>  	   group */
> -	current->self_exec_id++;
> +	WRITE_ONCE(current->self_exec_id, current->self_exec_id + 1);
>  	flush_signal_handlers(current, 0);
>  }
>  EXPORT_SYMBOL(setup_new_exec);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 04278493bf15..0323e4f0982a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -939,8 +939,8 @@ struct task_struct {
>  	struct seccomp			seccomp;
>  
>  	/* Thread group tracking: */
> -	u32				parent_exec_id;
> -	u32				self_exec_id;
> +	u64				parent_exec_id;
> +	u64				self_exec_id;
>  
>  	/* Protection against (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed, mempolicy: */
>  	spinlock_t			alloc_lock;
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 9ad8dea93dbb..5383b562df85 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1926,7 +1926,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
>  		 * This is only possible if parent == real_parent.
>  		 * Check if it has changed security domain.
>  		 */
> -		if (tsk->parent_exec_id != tsk->parent->self_exec_id)
> +		if (tsk->parent_exec_id != READ_ONCE(tsk->parent->self_exec_id))
>  			sig = SIGCHLD;
>  	}
>  
> -- 
> 2.20.1
> 

-- 
Kees Cook
