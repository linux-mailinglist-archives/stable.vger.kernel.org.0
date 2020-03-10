Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66E11809B1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgCJU56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:57:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40587 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJU56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:57:58 -0400
Received: by mail-pg1-f195.google.com with SMTP id t24so6861653pgj.7
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 13:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NSnXjtw6BvnjWDGIhdIRejbxeFIsypmUSM0EVeQ+Uig=;
        b=XNQHeyRLT95Iz7HO7tqkWQ6/sSMwGKo5bd80/1Q/QaJ5M1YExD2yISBVWEW/n3lAUr
         tkv7AJhIRjzO2Hjw1Eu493BeCu5akkQFw7U5n327J4keqaqVy3NZZOnH0sOQ4c7EAwkY
         Nfumx3a1xGu9L0OrAtTbJl9mO3bqLw6ZrWiD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NSnXjtw6BvnjWDGIhdIRejbxeFIsypmUSM0EVeQ+Uig=;
        b=ilflCJWiXDiJDO2Vve9fo/eDjdgV4pZ9XlrFE/MlmZCup/OLFchbm0eRUNxhakN56r
         ZqfRP7I4BStSsl9mTd/xIrHznbx24Odb4fI+sSMS1UwqYel/KpT5UkuJiRBeykWEK4fb
         iv4eINKLvU6ZNBlDLwfZLICA8ySnR9ujHPWDf+ge/lqG50kQ9o1JU5KJjsHu+0OcafPW
         0NzMYUOGpyjdULiAgLhToO+er8XcOGOlqx5S+I/PLrehiqWXL/XL99rfUX/sU16sj5cM
         +/2LKyj/Xr6CjrGcLzdbuGoCjzm3ZF7kYxHvv+5RlZbf+3CdwK61QPqfpoH8Us4qh7se
         M4Vg==
X-Gm-Message-State: ANhLgQ0AsvqXoDFVyzs3It3luEu2cxCsbmeyW9kRXcFhvuVKAZb1b/N3
        /8tB2xpMxuqt8+pIxYUB7u29nA==
X-Google-Smtp-Source: ADFU+vu4EeH+yVMv9tpwMaGvHwzGMhYFOuE0iRroLbEdduwZiXXe1msMJtUJMFBKLAERB9nEKnQ+wg==
X-Received: by 2002:a63:650:: with SMTP id 77mr16314387pgg.201.1583873877277;
        Tue, 10 Mar 2020 13:57:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d186sm30572689pfc.8.2020.03.10.13.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 13:57:56 -0700 (PDT)
Date:   Tue, 10 Mar 2020 13:57:55 -0700
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
Subject: Re: [PATCH v2 2/5] exec: Factor unshare_sighand out of de_thread and
 call it separately
Message-ID: <202003101356.A2B9885F17@keescook>
References: <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87k13u5y26.fsf_-_@x220.int.ebiederm.org>
 <202003101319.BAE7B535A@keescook>
 <AM6PR03MB5170BDBF7D6E4AC63B40E9C0E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR03MB5170BDBF7D6E4AC63B40E9C0E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 09:34:03PM +0100, Bernd Edlinger wrote:
> On 3/10/20 9:29 PM, Kees Cook wrote:
> > On Sun, Mar 08, 2020 at 04:36:17PM -0500, Eric W. Biederman wrote:
> >>
> >> This makes the code clearer and makes it easier to implement a mutex
> >> that is not taken over any locations that may block indefinitely waiting
> >> for userspace.
> >>
> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> ---
> >>  fs/exec.c | 39 ++++++++++++++++++++++++++-------------
> >>  1 file changed, 26 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/fs/exec.c b/fs/exec.c
> >> index c3f34791f2f0..ff74b9a74d34 100644
> >> --- a/fs/exec.c
> >> +++ b/fs/exec.c
> >> @@ -1194,6 +1194,23 @@ static int de_thread(struct task_struct *tsk)
> >>  	flush_itimer_signals();
> >>  #endif
> > 
> > Semi-related (existing behavior): in de_thread(), what keeps the thread
> > group from changing? i.e.:
> > 
> >         if (thread_group_empty(tsk))
> >                 goto no_thread_group;
> > 
> >         /*
> >          * Kill all other threads in the thread group.
> >          */
> >         spin_lock_irq(lock);
> > 	... kill other threads under lock ...
> > 
> > Why is the thread_group_emtpy() test not under lock?
> > 
> 
> A new thread cannot created when only one thread is executing,
> right?

*face palm* Yes, of course. :) I'm thinking too hard.

-- 
Kees Cook
