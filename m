Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0046142C1B
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 14:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgATNbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 08:31:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726619AbgATNbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 08:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579527081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ae6sHOn1ghXeqvmZk29iuHjafGzoNs8lLIkps8wijQw=;
        b=K6/y0bEzItSCDtZyeNojOWMR683orfvFKYDD8p8vj/QPkOwymfV6nU0Zc7F4tGAO8ZMbkl
        VztMUO2EwaPcK9jczGpSLSyrZT8VNde7KLHNva1lW261UnCo+0RrNDeL+M+J7q+fK2HZpN
        N0RMWJqNjhXPEXac4VeR2QPqhT+LUbc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-g9dnvO0JPdSqAUAbzP89EA-1; Mon, 20 Jan 2020 08:31:19 -0500
X-MC-Unique: g9dnvO0JPdSqAUAbzP89EA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B9301005513;
        Mon, 20 Jan 2020 13:31:18 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id B57585D9E1;
        Mon, 20 Jan 2020 13:31:16 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon, 20 Jan 2020 14:31:18 +0100 (CET)
Date:   Mon, 20 Jan 2020 14:31:16 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>, avagin@gmail.com,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v4] ptrace: reintroduce usage of subjective credentials
 in ptrace_has_cap()
Message-ID: <20200120133115.GA30403@redhat.com>
References: <20200118011908.23582-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118011908.23582-1-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/18, Christian Brauner wrote:
>
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -264,12 +264,17 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
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
> +		ret = security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NOAUDIT);
>  	else
> -		return has_ns_capability(current, ns, CAP_SYS_PTRACE);
> +		ret = security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NONE);
> +
> +	return ret == 0;
>  }
>  
>  /* Returns 0 on success, -errno on denial. */
> @@ -321,7 +326,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>  	    gid_eq(caller_gid, tcred->sgid) &&
>  	    gid_eq(caller_gid, tcred->gid))
>  		goto ok;
> -	if (ptrace_has_cap(tcred->user_ns, mode))
> +	if (ptrace_has_cap(cred, tcred->user_ns, mode))
>  		goto ok;
>  	rcu_read_unlock();
>  	return -EPERM;
> @@ -340,7 +345,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
>  	mm = task->mm;
>  	if (mm &&
>  	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
> -	     !ptrace_has_cap(mm->user_ns, mode)))
> +	     !ptrace_has_cap(cred, mm->user_ns, mode)))
>  	    return -EPERM;

I never understood these security checks and thus I don't understand the
security impact. Say, has_capability_noaudit() in __set_oom_adj(). Isn't
it equally wrong?

However, the patch looks "obviously correct" to me.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

