Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012D418218E
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 20:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbgCKTIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 15:08:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46686 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730926AbgCKTIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 15:08:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id w12so1511071pll.13
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 12:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DbOSuRE3mJHRT6NEoUnJAt4STBzgkZE2dyC9jqZCCLc=;
        b=ezUxUUOXDCiz09sL7ns9GljqAjBmqhyjSwvJorFlESxa+y3+f/0qlxnha+BOKyFFyf
         ERAU18z6eUiNgcbSjL1jsVciaLtO3QRYSLsFs8TwKJvof5riGga9gNTN9V0/psEVhU2x
         V/bi7iIGw3G5TZdWYOJ4NUQjucYxGZhfQRnwo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DbOSuRE3mJHRT6NEoUnJAt4STBzgkZE2dyC9jqZCCLc=;
        b=N3Tsa+q2Z5m0Tezwa65plfzzWza/pUapsRkozvazYfyl+fjVlwU19LDPBzWiXGiPfo
         RiRgGu+IPWYzNCXyRLCH+4oetue93vbuFRI0k3pdROcgqG/sEMNw956PASBSmaRKDwd1
         v2qvCqpdo25komkmTWA6AZKGoSt0VE0eaSonOJzW+S7X/Z+Law4KeFRzFYgONnpTnp/9
         aGX2M9HWckkT5A+zA8O7R/pvKLKnTWuyBMivwTK/pSDb0A+uR9hRZXtoyxCdy8W6MiXc
         RcjA/vNhaXXMdduucszgpfY4WrZnIecBEKZxehiTZchsYttZBvD7lu1PjRqpE5e66lpA
         HykA==
X-Gm-Message-State: ANhLgQ3HgiA3pfnrAicufSAB8w99iym/FTJ1J8MPvVQYJiFknOALLdDK
        3b/Qc188mMsBVVWvUHEZDEAJKw==
X-Google-Smtp-Source: ADFU+vu1bU3k2S+HEZmBvCgVu915jbj4h0AdjuUzNnkHJx+FiemZBhEAG7aEg6xbQtj5ITkHsDfXoA==
X-Received: by 2002:a17:90a:da01:: with SMTP id e1mr225598pjv.100.1583953691168;
        Wed, 11 Mar 2020 12:08:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y207sm1468232pfb.189.2020.03.11.12.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 12:08:09 -0700 (PDT)
Date:   Wed, 11 Mar 2020 12:08:08 -0700
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
Subject: Re: [PATCH 3/4] proc: io_accounting: Use new infrastructure to fix
 deadlocks in execve
Message-ID: <202003111203.738487D@keescook>
References: <87r1y12yc7.fsf@x220.int.ebiederm.org>
 <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfcxlwy.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 06:45:47PM +0100, Bernd Edlinger wrote:
> This changes do_io_accounting to use the new exec_update_mutex
> instead of cred_guard_mutex.
> 
> This fixes possible deadlocks when the trace is accessing
> /proc/$pid/io for instance.
> 
> This should be safe, as the credentials are only used for reading.

I'd like to see the rationale described better here for why it should be
safe. I'm still not seeing why this is safe here, as we might check
ptrace_may_access() with one cred and then iterate io accounting with a
different credential...

What am I missing?

-Kees

> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>  fs/proc/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 4fdfe4f..529d0c6 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2770,7 +2770,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>  	unsigned long flags;
>  	int result;
>  
> -	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
> +	result = mutex_lock_killable(&task->signal->exec_update_mutex);
>  	if (result)
>  		return result;
>  
> @@ -2806,7 +2806,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>  	result = 0;
>  
>  out_unlock:
> -	mutex_unlock(&task->signal->cred_guard_mutex);
> +	mutex_unlock(&task->signal->exec_update_mutex);
>  	return result;
>  }
>  
> -- 
> 1.9.1

-- 
Kees Cook
