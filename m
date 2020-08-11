Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429152417FE
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 10:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgHKIKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 04:10:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35422 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727998AbgHKIKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 04:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597133440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ETM5SVJgSYa28QAQrXzkvKzwfyNa1RWXhMMsF/tbcjU=;
        b=Ry1jfhA/4kYEQLqyobDyRiZ1TofbbK6Gx7L+9cMbLLoBVWvJgm21L1RmYPRPFnFVl2Eeob
        VOvi7L4BzhT590GLE9isFDRCh9jHSgwshuJt2cCxiyWUrlgcu871OaQrAgN5jvIPck4gSp
        Y/l1hGdKl5rlvsgYdPk9AWfJ5dsocJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-H20mh8tYNymRfg1oA-_Fkw-1; Tue, 11 Aug 2020 04:10:38 -0400
X-MC-Unique: H20mh8tYNymRfg1oA-_Fkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01C998015F0;
        Tue, 11 Aug 2020 08:10:37 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.186])
        by smtp.corp.redhat.com (Postfix) with SMTP id 547D617B9B;
        Tue, 11 Aug 2020 08:10:35 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 11 Aug 2020 10:10:36 +0200 (CEST)
Date:   Tue, 11 Aug 2020 10:10:34 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200811081033.GD21797@redhat.com>
References: <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
 <20200811064516.GA21797@redhat.com>
 <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
 <20200811071401.GB21797@redhat.com>
 <20200811074538.GS3982@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811074538.GS3982@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/11, Peter Zijlstra wrote:
>
> On Tue, Aug 11, 2020 at 09:14:02AM +0200, Oleg Nesterov wrote:
> > On 08/11, Peter Zijlstra wrote:
> > >
> > > On Tue, Aug 11, 2020 at 08:45:16AM +0200, Oleg Nesterov wrote:
> > > >
> > > > ->jobctl is always modified with ->siglock held, do we really need
> > > > WRITE_ONCE() ?
> > >
> > > In theory, yes. The compiler doesn't know about locks, it can tear
> > > writes whenever it feels like it.
> >
> > Yes, but why does this matter? Could you spell please?
>
> Ah, well, that I don't konw. Why do we need the READ_ONCE() ?
>
> It does:
>
> > +               if (!(task->jobctl & JOBCTL_TASK_WORK) &&
> > +                   lock_task_sighand(task, &flags)) {
>
> and the lock_task_sighand() implies barrier(), so I thought the reason
> for the READ_ONCE() was load-tearing, and then we need WRITE_ONCE() to
> avoid store-tearing.

I don't think we really need READ_ONCE() for correctness, compiler can't
reorder this LOAD with cmpxchg() above, and I think we don't care about
load-tearing.

But I guess we need READ_ONCE() or data_race() to shut kcsan up.

Oleg.

