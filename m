Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA95241670
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 08:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgHKGpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 02:45:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27140 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727066AbgHKGpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 02:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597128323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=czXFqG4tjLmePzUl08OufkGazYH+w8veG3hkn0vFyZc=;
        b=g5p+FVA/4mKi5zxaaU/y9WHoYYB2DVbUxPSQhU1/HaprBzI3JZMgibkh/Y87Cx22aZEl/b
        oNrWv+5wYuJNwOZmHn1QRE00H2VDnPdRp1mBmC/nYBjgxyXlymYfWyxJYLtZlfMbqqHqEB
        Mtim2rg5Z2tFpb8UfnK/YkewRNMShX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-u18WSPM6Nt-7SBb5LvgW4Q-1; Tue, 11 Aug 2020 02:45:21 -0400
X-MC-Unique: u18WSPM6Nt-7SBb5LvgW4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B68211DE0;
        Tue, 11 Aug 2020 06:45:19 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.186])
        by smtp.corp.redhat.com (Postfix) with SMTP id C57B990E9B;
        Tue, 11 Aug 2020 06:45:17 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 11 Aug 2020 08:45:19 +0200 (CEST)
Date:   Tue, 11 Aug 2020 08:45:16 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200811064516.GA21797@redhat.com>
References: <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
 <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/11, Jann Horn wrote:
>
> > --- a/kernel/task_work.c
> > +++ b/kernel/task_work.c
> > @@ -42,7 +42,8 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
> >                 set_notify_resume(task);
> >                 break;
> >         case TWA_SIGNAL:
> > -               if (lock_task_sighand(task, &flags)) {
> > +               if (!(task->jobctl & JOBCTL_TASK_WORK) &&
> > +                   lock_task_sighand(task, &flags)) {
> >                         task->jobctl |= JOBCTL_TASK_WORK;
> >                         signal_wake_up(task, 0);
> >                         unlock_task_sighand(task, &flags);
> 
> I think that should work in theory, but if you want to be able to do a
> proper unlocked read of task->jobctl here, then I think you'd have to
> use READ_ONCE() here

Agreed,

> and make all existing writes to ->jobctl use
> WRITE_ONCE().

->jobctl is always modified with ->siglock held, do we really need
WRITE_ONCE() ?

> Also, I think that to make this work, stuff like get_signal() will
> need to use memory barriers to ensure that reads from ->task_works are
> ordered after ->jobctl has been cleared

Why? I don't follow.

Afaics, we only need to ensure that task_work_add() checks JOBCTL_TASK_WORK
after it adds the new work to the ->task_works list, and we can rely on
cmpxchg() ?

Oleg.

