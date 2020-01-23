Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADC4147447
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 00:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgAWXBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 18:01:32 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34644 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbgAWXBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 18:01:32 -0500
Received: by mail-pg1-f196.google.com with SMTP id r11so917pgf.1;
        Thu, 23 Jan 2020 15:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k5c7h89QBsGnx1sKF1lZNrXB89jqLvVgTVCHNSa0+3o=;
        b=gcF+U7eYmM7gB/elKE6pO77Y6c0brgr7/sVyjLbl5Dc3nKwq4CxH+ybtIBDBNoGf6S
         fcPbJzLID1XnrU5HsJnRBM64IWRAdA8jnsoUYugG3jzQhk9vjY7lGC6/elkruXSsRfU2
         EiJ4NQCesFoqCPv7ILq/G3I3OA7+ytjztmQ34Wa2t7BA0/kl23bYLD7y0ASYZLuL+i0V
         565KhUOJoJB75Ra/Zj3VlxUygyxw4D6hXZ+4uBHyp3GEXjsTE8jVOCraR5p9aCQE1Csb
         fxAmkrzllaQs9uCWPSrql8D+WMBR1JKhzgz3KlArDw0ptBo6iesKP1MDCFzRLnWBkhZd
         8oWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=k5c7h89QBsGnx1sKF1lZNrXB89jqLvVgTVCHNSa0+3o=;
        b=sMzXFodBu+8sROYvd3LkyArml4ms6XYWRGH6PutlgM4La7gPx9AEN/tzSLS1wX4g2e
         2MsBtX6ZkPp+U8O5623SXxz5M5mFEQUUURBRrixqsNjKNKkrTmIXiWOWtCfgzW5p8UlY
         SXMsTEZGjh8RrAP97tWw/QtkUeE2/mVLFb/qSkMRlIiOuggnAJb14aKyu/ZoZfm4QaHn
         4xUokfc+N5uNO1kBqOPQQXT+pB2ThZwRptrCffuYP+PF9jznCebXCA8q8SRd1OjAVkwO
         1XF7FHesUthPdN61TXgPYRWFncrGBqTCedWiuKiIg5GP/AkbhEyWboiHIML+KgMnKQ8K
         W/6A==
X-Gm-Message-State: APjAAAXU8w8xkAjL7V9y+5pZyxFWRtTVXYrbpHDB7k0PwoJe4SDK5x4p
        v2M+f/ou0l4AqTsCykA8ul4=
X-Google-Smtp-Source: APXvYqwG1cCuEhyVaiHuGSMoNd0FwJy8BJ/gM3MBWs9g9G8+VrVVPPmVPXubFYDbcxKpLBmHsw1jBQ==
X-Received: by 2002:a63:1c5e:: with SMTP id c30mr807745pgm.30.1579820491377;
        Thu, 23 Jan 2020 15:01:31 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l14sm3824859pjq.5.2020.01.23.15.01.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jan 2020 15:01:30 -0800 (PST)
Date:   Thu, 23 Jan 2020 15:01:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge@hallyn.com>, Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 4.14 20/65] ptrace: reintroduce usage of subjective
 credentials in ptrace_has_cap()
Message-ID: <20200123230129.GA3737@roeck-us.net>
References: <20200122092750.976732974@linuxfoundation.org>
 <20200122092754.007578340@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122092754.007578340@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 10:29:05AM +0100, Greg Kroah-Hartman wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> commit 6b3ad6649a4c75504edeba242d3fd36b3096a57f upstream.
> 
> Commit 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> introduced the ability to opt out of audit messages for accesses to various
> proc files since they are not violations of policy.  While doing so it
> somehow switched the check from ns_capable() to
> has_ns_capability{_noaudit}(). That means it switched from checking the
> subjective credentials of the task to using the objective credentials. This
> is wrong since. ptrace_has_cap() is currently only used in
> ptrace_may_access() And is used to check whether the calling task (subject)
> has the CAP_SYS_PTRACE capability in the provided user namespace to operate
> on the target task (object). According to the cred.h comments this would
> mean the subjective credentials of the calling task need to be used.
> This switches ptrace_has_cap() to use security_capable(). Because we only
> call ptrace_has_cap() in ptrace_may_access() and in there we already have a
> stable reference to the calling task's creds under rcu_read_lock() there's
> no need to go through another series of dereferences and rcu locking done
> in ns_capable{_noaudit}().
> 
> As one example where this might be particularly problematic, Jann pointed
> out that in combination with the upcoming IORING_OP_OPENAT feature, this
> bug might allow unprivileged users to bypass the capability checks while
> asynchronously opening files like /proc/*/mem, because the capability
> checks for this would be performed against kernel credentials.
> 
> To illustrate on the former point about this being exploitable: When
> io_uring creates a new context it records the subjective credentials of the
> caller. Later on, when it starts to do work it creates a kernel thread and
> registers a callback. The callback runs with kernel creds for
> ktask->real_cred and ktask->cred. To prevent this from becoming a
> full-blown 0-day io_uring will call override_cred() and override
> ktask->cred with the subjective credentials of the creator of the io_uring
> instance. With ptrace_has_cap() currently looking at ktask->real_cred this
> override will be ineffective and the caller will be able to open arbitray
> proc files as mentioned above.
> Luckily, this is currently not exploitable but will turn into a 0-day once
> IORING_OP_OPENAT{2} land in v5.6. Fix it now!
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Serge Hallyn <serge@hallyn.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Fixes: 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  kernel/ptrace.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -258,12 +258,17 @@ static int ptrace_check_attach(struct ta
>  	return ret;
>  }
>  
> -static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
> +static bool ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
> +			   unsigned int mode)
>  {
> +	int ret;
> +
>  	if (mode & PTRACE_MODE_NOAUDIT)
> -		return has_ns_capability_noaudit(current, ns, CAP_SYS_PTRACE);
> +		ret = security_capable(cred, ns, CAP_SYS_PTRACE);
>  	else
> -		return has_ns_capability(current, ns, CAP_SYS_PTRACE);
> +		ret = security_capable(cred, ns, CAP_SYS_PTRACE);
> +
> +	return ret == 0;

This results in
	if (condition)
		do_something;
	else
		do_the_same;

Is that really correct ? The upstream patch calls security_capable()
with additional CAP_OPT_NOAUDIT vs. CAP_OPT_NONE parameter, which does
make sense. But I don't really see the benefit of the change above.

Guenter 
