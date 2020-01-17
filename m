Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E775B1401EB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 03:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388922AbgAQC33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 21:29:29 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54885 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388787AbgAQC33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 21:29:29 -0500
Received: by mail-pj1-f67.google.com with SMTP id kx11so2472389pjb.4
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 18:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cNKQGmohsm0js0t9Yfi7QDCnZ5QjDcwPOto1MGozAGI=;
        b=YHweXW1BHdK06HpJk/shgab9ReA5DF5on1rXQ1e2W+Sco9cIlFH5PKIUTl5sDpLBMq
         TaavXktOSETHe+/Ukz/H2nHDXF5dXhF75rY9m3e6t6lfNDfPdTUVHmWhYsPRL9QecTy0
         IjeMxvMlBLdD9VFD2wxs0hllqTQ7HlINgMwsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cNKQGmohsm0js0t9Yfi7QDCnZ5QjDcwPOto1MGozAGI=;
        b=NooMG37606+3LFJ6WrTzZuR4ml/TBml3QJAQaiU7rbORCl6HQsEqHJnnG9peUx7pIn
         cfrm//ecCJOvZU8k+0UdzHpNO2LMXv0hykhE76aO5pByYvuLr/z4sxToPaJm8kHPyeLt
         YiSZktUkQEPSvx0oXL7AENJ0tYH2HbjNQ0dErqvVjYvz3oF5IChxUWI4WJEBa+RFM7Xa
         BQL7TCq+ED929yvCtbr5d4+FWJgo09eMzg1P1KNU5i01L2yHk64QMMzG+BCjozUnPNSs
         ucpksCjfeSFQs37Z7e5A/OUxDOb7CJp8uykRl4E4USBm6u8c847DWgt164UcQrA0TqbE
         EJQA==
X-Gm-Message-State: APjAAAWIRR9MapuRicUkOq81nqjgkx32zSjnDbSVfRLucEO6wMLfrYsg
        tyNEfNAllGXzGo1+Ub2oXfSwFg==
X-Google-Smtp-Source: APXvYqzGzUog91b8IJC3uKUgYr3d9LGy71/IitxdK1jKocFLrP5CDR1QmNL8kExxVCvq9P5cvo2vng==
X-Received: by 2002:a17:902:d205:: with SMTP id t5mr24614917ply.138.1579228168736;
        Thu, 16 Jan 2020 18:29:28 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q8sm26292399pgg.92.2020.01.16.18.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 18:29:27 -0800 (PST)
Date:   Thu, 16 Jan 2020 18:29:26 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [REVIEW PATCH v2] ptrace: reintroduce usage of subjective
 credentials in ptrace_has_cap()
Message-ID: <202001161753.27427AD@keescook>
References: <20200116224518.30598-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116224518.30598-1-christian.brauner@ubuntu.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 11:45:18PM +0100, Christian Brauner wrote:
> Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> introduced the ability to opt out of audit messages for accesses to
> various proc files since they are not violations of policy.
> While doing so it somehow switched the check from ns_capable() to
> has_ns_capability{_noaudit}(). That means it switched from checking the
> subjective credentials of the task to using the objective credentials. I
> couldn't find the original lkml thread and so I don't know why this switch
> was done. But it seems wrong since ptrace_has_cap() is currently only used
> in ptrace_may_access(). And it's used to check whether the calling task
> (subject) has the CAP_SYS_PTRACE capability in the provided user namespace
> to operate on the target task (object). According to the cred.h comments
> this would mean the subjective credentials of the calling task need to be
> used.

I don't follow this description. As far as I can see, both the current
code and your patch end up using current's cred, yes? I'm not following
the subjective/objective change mentioned here.

Before:
bool has_ns_capability(struct task_struct *t,
                       struct user_namespace *ns, int cap)
{
        int ret;

        rcu_read_lock();
        ret = security_capable(__task_cred(t), ns, cap, CAP_OPT_NONE);
        rcu_read_unlock();

        return (ret == 0);
}
...
		return has_ns_capability(current, ns, CAP_SYS_PTRACE)

After:
	const struct cred *cred = current_cred(), ...
...
		return security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NOAUDIT);

The cred passed to security_capable() is the subject before and after.

> This switches it to use security_capable() because we only call
> ptrace_has_cap() in ptrace_may_access() and in there we already have a
> stable reference to the calling tasks creds under cred_guard_mutex so
> there's no need to go through another series of dereferences and rcu
> locking done in ns_capable{_noaudit}().

This makes sense to me -- now there's no possible race on the cred
changing between the two ptrace_has_cap() checks, yes?

However, I'm still trying to see where cred_guard_mutex() comes into
play for callers of ptrace_may_access(). I see it for the object
("task" arg in ptrace_may_access()), but if this is dealing with the cred
on current, it's just the RCU read lock protecting it (which I think is
fine here), but seems confusing in the commit log.

> As one example where this might be particularly problematic, Jann pointed
> out that in combination with the upcoming IORING_OP_OPENAT feature, this
> bug might allow unprivileged users to bypass the capability checks while
> asynchronously opening files like /proc/*/mem, because the capability
> checks for this would be performed against kernel credentials.

As in, winning a race between the two ptrace_has_cap() calls across a
cred transition?

> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Serge Hallyn <serge@hallyn.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Fixes: 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  kernel/ptrace.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index cb9ddcc08119..d146133e97f1 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -264,12 +264,13 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
>  	return ret;
>  }
>  
> -static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
> +static int ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
> +			  unsigned int mode)
>  {
>  	if (mode & PTRACE_MODE_NOAUDIT)
> -		return has_ns_capability_noaudit(current, ns, CAP_SYS_PTRACE);
> +		return security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NOAUDIT);
>  	else
> -		return has_ns_capability(current, ns, CAP_SYS_PTRACE);
> +		return security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NONE);
>  }

Style nit -- can we just make this a single invocation of
security_capable(), something like:

	return security_capable(cred, ns, CAP_SYS_PTRACE,
				mode & PTRACE_MODE_NOAUDIT
					?  CAP_OPT_NOAUDIT,
					: CAP_OPT_NONE) == 0;

Obviously not required, but the longer if hurts my eyes. ;)

>  
>  /* Returns 0 on success, -errno on denial. */
> @@ -321,7 +322,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>  	    gid_eq(caller_gid, tcred->sgid) &&
>  	    gid_eq(caller_gid, tcred->gid))
>  		goto ok;
> -	if (ptrace_has_cap(tcred->user_ns, mode))
> +	if (ptrace_has_cap(cred, tcred->user_ns, mode))
>  		goto ok;
>  	rcu_read_unlock();
>  	return -EPERM;
> @@ -340,7 +341,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>  	mm = task->mm;
>  	if (mm &&
>  	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
> -	     !ptrace_has_cap(mm->user_ns, mode)))
> +	     !ptrace_has_cap(cred, mm->user_ns, mode)))
>  	    return -EPERM;
>  
>  	return security_ptrace_access_check(task, mode);
> 
> base-commit: b3a987b0264d3ddbb24293ebff10eddfc472f653
> -- 
> 2.25.0
> 

So, I think this change looks correct, but I find the commit subject
and log confusing (perhaps because I am dense) and misleading (again,
perhaps because I am dense).

-- 
Kees Cook
