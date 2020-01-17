Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAEB14129A
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 22:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgAQVHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 16:07:42 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45516 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729818AbgAQVHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 16:07:42 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so12484489pfg.12
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 13:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YCsqNVhAm1Di2ZHCi7r9WDsSeSKbdfgtbe1b6IQVMR8=;
        b=E7h8E3+iNPnPKbULvSeSjkaSmiituhuO69cMDLqUOnoUXMVsx2OnVL0+YvFiDp56YI
         G3qgW2BGPaNqNa/7GL2mLvawMMVyUJ3CXBfzy2rh0Zf1uFi3fLXBpZo/7X8MJTZFvVNp
         wbmRQTeAuhoPXkt+1Euo3AeHJzb5a4CUU8JjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YCsqNVhAm1Di2ZHCi7r9WDsSeSKbdfgtbe1b6IQVMR8=;
        b=kd9PCLo3YMiHkBE+SsJbio7e23NuGRz851WgO3PIVYFBaHB6hLmVgclDmdie1/hRd0
         tgiYngBax6AXPWyp+xdyH2zIjF0b22Xc0iSRdapVzDj3XE4iq+DxhqA5+TpXwCdnc7AR
         T9LLwba0tAivVb8ENlc6QNOwyN965itLGxha9pNLyErQ8iKBVR/znBDzya9K5UfQwZbK
         NIHpbaWxkEUth1JVB/CZ8pXW1V7HU2UD83KfxxGl5hZ0qJCM/6xsX9/hQTD1B3pTcSZ7
         PJ6yt/XDrfCu/o6uZa3nABOzvLkggd7YnjE/nS1w3TLVaxAIoKI/FYW5xAYEQNPnhjhn
         NVvQ==
X-Gm-Message-State: APjAAAX5r2uegkSjlD2FtVFO6/8Tx7Vm2yzYW4BxVkoAPWHdnOOXQ9Pg
        4A5lV5xJd9FFLPyRpIG6uLBv6g==
X-Google-Smtp-Source: APXvYqzTfRUQytNCdU+h7w7eD9SUYQYpYSTDn6eIEjE3LOv1yzJWpeRIrNT7R1FFOHnW245zwomxTQ==
X-Received: by 2002:a63:5fd7:: with SMTP id t206mr48142029pgb.281.1579295261638;
        Fri, 17 Jan 2020 13:07:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j7sm32686601pgn.0.2020.01.17.13.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 13:07:40 -0800 (PST)
Date:   Fri, 17 Jan 2020 13:07:39 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [REVIEW PATCH v2] ptrace: reintroduce usage of subjective
 credentials in ptrace_has_cap()
Message-ID: <202001171303.B27CCDA544@keescook>
References: <20200116224518.30598-1-christian.brauner@ubuntu.com>
 <202001161753.27427AD@keescook>
 <20200117051622.yre42znvc4r3i7ta@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117051622.yre42znvc4r3i7ta@wittgenstein>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 06:16:23AM +0100, Christian Brauner wrote:
> On Thu, Jan 16, 2020 at 06:29:26PM -0800, Kees Cook wrote:
> > On Thu, Jan 16, 2020 at 11:45:18PM +0100, Christian Brauner wrote:
> > > Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> > > introduced the ability to opt out of audit messages for accesses to
> > > various proc files since they are not violations of policy.
> > > While doing so it somehow switched the check from ns_capable() to
> > > has_ns_capability{_noaudit}(). That means it switched from checking the
> > > subjective credentials of the task to using the objective credentials. I
> > > couldn't find the original lkml thread and so I don't know why this switch
> > > was done. But it seems wrong since ptrace_has_cap() is currently only used
> > > in ptrace_may_access(). And it's used to check whether the calling task
> > > (subject) has the CAP_SYS_PTRACE capability in the provided user namespace
> > > to operate on the target task (object). According to the cred.h comments
> > > this would mean the subjective credentials of the calling task need to be
> > > used.
> > 
> > I don't follow this description. As far as I can see, both the current
> > code and your patch end up using current's cred, yes? I'm not following
> > the subjective/objective change mentioned here.
> > 
> > Before:
> > bool has_ns_capability(struct task_struct *t,
> >                        struct user_namespace *ns, int cap)
> > {
> >         int ret;
> > 
> >         rcu_read_lock();
> >         ret = security_capable(__task_cred(t), ns, cap, CAP_OPT_NONE);
> 
> If I'm not mistaken, you're looking at the cuplrit: "__task_cred()":
> [...]
> #define __task_cred(task)	\
> 	rcu_dereference((task)->real_cred)

Ah! Yes, thank you. cred vs real_cred. That's what I missed!

> > However, I'm still trying to see where cred_guard_mutex() comes into
> > play for callers of ptrace_may_access(). I see it for the object
> > ("task" arg in ptrace_may_access()), but if this is dealing with the cred
> > on current, it's just the RCU read lock protecting it (which I think is
> > fine here), but seems confusing in the commit log.
> 
> Ah, right. I'll drop that from the commit message and place in the rcu
> lock.

Thanks for the clarification. With that adjusted, please consider it:

Reviewed-by: Kees Cook <keescook@chromium.org>

(I wonder how hard it might be to build some self-tests for this to
catch future glitches...)

-- 
Kees Cook
