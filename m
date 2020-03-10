Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BABA1808FB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgCJUSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:18:00 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33325 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJUSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:18:00 -0400
Received: by mail-pg1-f193.google.com with SMTP id m5so6832796pgg.0
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 13:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RKigTXtTZ1YImDJinI4wU2TyC7WQeMLqFQfSK2SiClo=;
        b=i6PwcH1Y6dzAld5+0ItdFH0DNwVNQDvVoI3rFkpU5glNp7p1gPAzHwUVGup1Aj6YPT
         mm52T1lUrybAlYpwBILDBxSuJksLBuWK9y1KWBhigTnvRKG8n9iDhSzGEkU4ueiYuSvY
         EiCKda6MTerB6wqJNRGHCZxbLU3xNZ5OT1LFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RKigTXtTZ1YImDJinI4wU2TyC7WQeMLqFQfSK2SiClo=;
        b=EgGMWOcI/BwSwQR9LElgHppwYUfgevfOe2TpTeCMZLIhgFpm9SpfW4HMD2zMoSRwhy
         vZBFd9K1Zefu0FB9Z3+AEnnT819gKdrpVm3E1KTD9sw7dcFFgn7Rx1gd36ft9/WMcIb6
         2VvvURmjlO9xArMLyWgheuHnc4KroQmmY1zxEZTXRYo6Xx0B9fuD+IR+ABpmZPXv+axv
         cdw8aXbldoFYfMribhjbg06+dTA3uawiJFegW+tUb5rAbqlxkl/joJtIxX6CnELZ/+SO
         d7BvhFGf6z1y2w1TrWiHr8b0WMgas5acN/YwJANKtSTy/332UvR86TbOl9aUgGQsoOMs
         Ks8A==
X-Gm-Message-State: ANhLgQ0WLa0aJy+EeSqyzkgOtwQ/CvZW8h7WbfoagY1pDV/bceFBd4ED
        tEEyOl42C0lTPM4RXvkWtM5CSQ==
X-Google-Smtp-Source: ADFU+vt2t4dqM/StQkYgOOR3czOMhuaGQySe+8w6u+0IAx0TkUIOlTLogaEjfIx9xPXJuWMsrEQx6g==
X-Received: by 2002:a65:5383:: with SMTP id x3mr22185221pgq.279.1583871478687;
        Tue, 10 Mar 2020 13:17:58 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 199sm51876404pfv.81.2020.03.10.13.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 13:17:57 -0700 (PDT)
Date:   Tue, 10 Mar 2020 13:17:56 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
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
Subject: Re: [PATCH v2 1/5] exec: Only compute current once in flush_old_exec
Message-ID: <202003101317.20BD018D9@keescook>
References: <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87pndm5y3l.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pndm5y3l.fsf_-_@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 08, 2020 at 04:35:26PM -0500, Eric W. Biederman wrote:
> 
> Make it clear that current only needs to be computed once in
> flush_old_exec.  This may have some efficiency improvements and it
> makes the code easier to change.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

modulo my suggestion of adding more comments (it could even be kerndoc!)
that explicitly states that "me" should always be "current", yup, looks
good:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  fs/exec.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index db17be51b112..c3f34791f2f0 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1260,13 +1260,14 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
>   */
>  int flush_old_exec(struct linux_binprm * bprm)
>  {
> +	struct task_struct *me = current;
>  	int retval;
>  
>  	/*
>  	 * Make sure we have a private signal table and that
>  	 * we are unassociated from the previous thread group.
>  	 */
> -	retval = de_thread(current);
> +	retval = de_thread(me);
>  	if (retval)
>  		goto out;
>  
> @@ -1294,10 +1295,10 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	bprm->mm = NULL;
>  
>  	set_fs(USER_DS);
> -	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
> +	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>  					PF_NOFREEZE | PF_NO_SETAFFINITY);
>  	flush_thread();
> -	current->personality &= ~bprm->per_clear;
> +	me->personality &= ~bprm->per_clear;
>  
>  	/*
>  	 * We have to apply CLOEXEC before we change whether the process is
> @@ -1305,7 +1306,7 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	 * trying to access the should-be-closed file descriptors of a process
>  	 * undergoing exec(2).
>  	 */
> -	do_close_on_exec(current->files);
> +	do_close_on_exec(me->files);
>  	return 0;
>  
>  out:
> -- 
> 2.25.0
> 

-- 
Kees Cook
