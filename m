Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C32411CD
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgHJUgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgHJUgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:36:12 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826BBC061787
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 13:36:11 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 185so11070831ljj.7
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 13:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ys0PPIaowDblp47MmQ67XHzGcdkz/IvEj8kEa9cSJOg=;
        b=uwEeQUTc3SopDhbrB3fAuH9UiFcYvUf6cRMVHU9kvtWacwpPUeE3pVSHTyrfegjiY+
         Nac9twhqm1E7qgtV6bsnBhrSbtrAMUl0u3o//PXZcsBtiNgIUGjHza4B/WgFx3/ztTc/
         ZtkQ/xcitw9zu2OzpSvnitFK3tPHGXyHDLhryhbQVccyJ2eb0vQueijOxY6UkHrw+Iy+
         Wwq4Ot25NIA53P6g1uxV/Qof+n+KVTo9weWTEKzj6BoYL/xGgpyLU84gufAllZVQj+75
         d/f3jFhdaHu4IAiU18V8wuHD8dl2GXEF0N37zTB/VCTEiWVUORopTrDx9TUSB1X/C53U
         FgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ys0PPIaowDblp47MmQ67XHzGcdkz/IvEj8kEa9cSJOg=;
        b=dU5mJjcJWFTxl8oUtQYWbtbzebECEvntGTatQ+dz9+AqaabmA2gLoOzJcRKlIO3B/6
         R6b6847MhT0jqOTy6EYoEH5Cn0Cz3JJfZXk4JpIZFRgG8V3tPfuyqkn/P2bpy/+c4LtB
         8KEbytJA1qCv53mUG3TlviPPqvbhIiRhrTuT4lmKCa8mh4G+alfqUBsx1cIFa2kWkb5m
         okz7kjqM3RCd6v8nAoOj/cQ5yHf0FgDnIeyo+thYbFmwY7rqum5qxjx0OUyPZhaq6yAI
         QhZGkrRuP4OueXC27G4WhoWLrDPuYcp6wQmpFKtb+TSZkd4cQJ/DxCE89KXzUItKz384
         wZqQ==
X-Gm-Message-State: AOAM531QVOSGosCy/7+wVGvaSk+TIpgAKd9g+sHvf4emD+9XAanp7Vyz
        zu6TBdFsrk9oUEhvlwKIzmyQKvnaLigNzrE2BXIHUQ==
X-Google-Smtp-Source: ABdhPJw66y9OOJO9r1nbxjPpmNhECAHQcjYEwR3UNwwSknRVVPBmP2V+RXpeIZwyBpxfDC4Vmc9QvF0yBW9pugwF2s4=
X-Received: by 2002:a2e:302:: with SMTP id 2mr1289664ljd.156.1597091769650;
 Mon, 10 Aug 2020 13:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200808183439.342243-1-axboe@kernel.dk> <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net> <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk> <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk> <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
In-Reply-To: <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 10 Aug 2020 22:35:41 +0200
Message-ID: <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 10:25 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 8/10/20 2:13 PM, Jens Axboe wrote:
> >> Would it be clearer to write it like so perhaps?
> >>
> >>      /*
> >>       * Optimization; when the task is RUNNING we can do with a
> >>       * cheaper TWA_RESUME notification because,... <reason goes
> >>       * here>. Otherwise do the more expensive, but always correct
> >>       * TWA_SIGNAL.
> >>       */
> >>      if (READ_ONCE(tsk->state) == TASK_RUNNING) {
> >>              __task_work_notify(tsk, TWA_RESUME);
> >>              if (READ_ONCE(tsk->state) == TASK_RUNNING)
> >>                      return;
> >>      }
> >>      __task_work_notify(tsk, TWA_SIGNAL);
> >>      wake_up_process(tsk);
> >
> > Yeah that is easier to read, wasn't a huge fan of the loop since it's
> > only a single retry kind of condition. I'll adopt this suggestion,
> > thanks!
>
> Re-write it a bit on top of that, just turning it into two separate
> READ_ONCE, and added appropriate comments. For the SQPOLL case, the
> wake_up_process() is enough, so we can clean up that if/else.
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=49bc5c16483945982cf81b0109d7da7cd9ee55ed

I think I'm starting to understand the overall picture here, and I
think if my understanding is correct, your solution isn't going to
work properly.

My understanding of the scenario you're trying to address is:

 - task A starts up io_uring
 - task A tells io_uring to bump the counter of an eventfd E when work
has been completed
 - task A submits some work ("read a byte from file descriptor X", or
something like that)
 - io_uring internally starts an asynchronous I/O operation, with a callback C
 - task A calls read(E, &counter, sizeof(counter)) to wait for events
to be processed
 - the async I/O operation finishes, C is invoked, and C schedules
task_work for task A

And here you run into a deadlock, because the task_work will only run
when task A returns from the syscall, but the syscall will only return
once the task_work is executing and has finished the I/O operation.


If that is the scenario you're trying to solve here (where you're
trying to force a task that's in the middle of some syscall that's
completely unrelated to io_uring to return back to syscall context), I
don't think this will work: It might well be that the task has e.g.
just started entering the read() syscall, and is *about to* block, but
is currently still running.
