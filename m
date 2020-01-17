Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C37C714033B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 06:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgAQFQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 00:16:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35423 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgAQFQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 00:16:27 -0500
Received: from ip5f5bd663.dynamic.kabel-deutschland.de ([95.91.214.99] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1isJzc-0007pW-2m; Fri, 17 Jan 2020 05:16:24 +0000
Date:   Fri, 17 Jan 2020 06:16:23 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [REVIEW PATCH v2] ptrace: reintroduce usage of subjective
 credentials in ptrace_has_cap()
Message-ID: <20200117051622.yre42znvc4r3i7ta@wittgenstein>
References: <20200116224518.30598-1-christian.brauner@ubuntu.com>
 <202001161753.27427AD@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202001161753.27427AD@keescook>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 06:29:26PM -0800, Kees Cook wrote:
> On Thu, Jan 16, 2020 at 11:45:18PM +0100, Christian Brauner wrote:
> > Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> > introduced the ability to opt out of audit messages for accesses to
> > various proc files since they are not violations of policy.
> > While doing so it somehow switched the check from ns_capable() to
> > has_ns_capability{_noaudit}(). That means it switched from checking the
> > subjective credentials of the task to using the objective credentials. I
> > couldn't find the original lkml thread and so I don't know why this switch
> > was done. But it seems wrong since ptrace_has_cap() is currently only used
> > in ptrace_may_access(). And it's used to check whether the calling task
> > (subject) has the CAP_SYS_PTRACE capability in the provided user namespace
> > to operate on the target task (object). According to the cred.h comments
> > this would mean the subjective credentials of the calling task need to be
> > used.
> 
> I don't follow this description. As far as I can see, both the current
> code and your patch end up using current's cred, yes? I'm not following
> the subjective/objective change mentioned here.
> 
> Before:
> bool has_ns_capability(struct task_struct *t,
>                        struct user_namespace *ns, int cap)
> {
>         int ret;
> 
>         rcu_read_lock();
>         ret = security_capable(__task_cred(t), ns, cap, CAP_OPT_NONE);

If I'm not mistaken, you're looking at the cuplrit: "__task_cred()":

 /**
 * __task_cred - Access a task's objective credentials
 * @task: The task to query
 *
 * Access the objective credentials of a task.  The caller must hold the RCU
 * readlock.
 *
 * The result of this function should not be passed directly to get_cred();
 * rather get_task_cred() should be used instead.
 */
#define __task_cred(task)	\
	rcu_dereference((task)->real_cred)

>         rcu_read_unlock();
> 
>         return (ret == 0);
> }
> ...
> 		return has_ns_capability(current, ns, CAP_SYS_PTRACE)
> 
> After:
> 	const struct cred *cred = current_cred(), ...
> ...
> 		return security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NOAUDIT);
> 
> The cred passed to security_capable() is the subject before and after.
> 
> > This switches it to use security_capable() because we only call
> > ptrace_has_cap() in ptrace_may_access() and in there we already have a
> > stable reference to the calling tasks creds under cred_guard_mutex so
> > there's no need to go through another series of dereferences and rcu
> > locking done in ns_capable{_noaudit}().
> 
> This makes sense to me -- now there's no possible race on the cred
> changing between the two ptrace_has_cap() checks, yes?
> 
> However, I'm still trying to see where cred_guard_mutex() comes into
> play for callers of ptrace_may_access(). I see it for the object
> ("task" arg in ptrace_may_access()), but if this is dealing with the cred
> on current, it's just the RCU read lock protecting it (which I think is
> fine here), but seems confusing in the commit log.

Ah, right. I'll drop that from the commit message and place in the rcu
lock.

Christian
