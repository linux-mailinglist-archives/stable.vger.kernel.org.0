Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B583A1DFB
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 22:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhFIUMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 16:12:02 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:35791 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFIUMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 16:12:02 -0400
Received: by mail-lf1-f50.google.com with SMTP id i10so39979586lfj.2
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 13:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lH+j2KiVN2G/yHhVjeQt6p3BwbyIHnyM+0CcxE7yrDU=;
        b=AA02DUQuVWJT5MsI3unO8Y7QIOeiM7ojSOf+tqLac1WvD6nIyHkv7Pa0qjcMI+hTcR
         0zNRwRgAg7m2VsUhZD7G21UqsG1aPq/XdzJPGqoO5RrowffR7FXb+T/ICZxJJuMRYvvw
         NdivjzlAyufhdDOwqw5p5T7ogMbkumjfEy93w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lH+j2KiVN2G/yHhVjeQt6p3BwbyIHnyM+0CcxE7yrDU=;
        b=i5V65TluzI7+fGtQkYp03J32MIR0Y9GJNV6WBhftR3KYlSuQSrV+Ep3DIfcYUDsCLb
         l5A/SPqGQ9ON3zdoL026G9sa1WU1XxAQwKkKHi6oOnQk0CXxfzX0uxwX3XcU59YgKxYW
         nuZndVEFG2U/Vf+hj0Gcdtq1PO2eoEmn9vVevd9t3r8b5jYUs8Xio+4DU6HcvA96AaOz
         k++UIUySGBXqp8tBB3B38xCWpkVkGbgD8AqHnRviZ/pXEy8xpsmgaAzrETg1QbOMvVrm
         MdlkEsdp/L9zE51CrRXaHUaaRA+RnwUjpOt6B+wl5lyOb6kzwGhb0DnzjAr2CotoKvME
         T9AQ==
X-Gm-Message-State: AOAM530283eoJyFBZsPyl+l2chBnX5dBi+TACzXGbaIcOIKl9tRTbbxN
        GzhbyAb3B3eEEG7G4Zj+uyHKSLyRMNLHZ0VPlAA=
X-Google-Smtp-Source: ABdhPJz1itouhvFCV33Am+tpokWCh6t0mOSbO9xB0j+k9+1LHTeCv1VmdhGriVE8ryMv5wML35221A==
X-Received: by 2002:ac2:41cf:: with SMTP id d15mr693943lfi.574.1623269332416;
        Wed, 09 Jun 2021 13:08:52 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id y4sm78408lfe.275.2021.06.09.13.08.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 13:08:51 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id j20so10662256lfe.8
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 13:08:50 -0700 (PDT)
X-Received: by 2002:a19:7d04:: with SMTP id y4mr684978lfc.201.1623269330357;
 Wed, 09 Jun 2021 13:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210607125734.1770447-1-liangyan.peng@linux.alibaba.com> <71fa2e69-a60b-0795-5fef-31658f89591a@linux.alibaba.com>
In-Reply-To: <71fa2e69-a60b-0795-5fef-31658f89591a@linux.alibaba.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Jun 2021 13:08:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=whKbJkuVmzb0hD3N6q7veprUrSpiBHRxVY=AffWZPtxmg@mail.gmail.com>
Message-ID: <CAHk-=whKbJkuVmzb0hD3N6q7veprUrSpiBHRxVY=AffWZPtxmg@mail.gmail.com>
Subject: Re: [PATCH] tracing: Correct the length check which causes memory corruption
To:     James Wang <jnwang@linux.alibaba.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Liangyan <liangyan.peng@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        yinbinbin@alibabacloud.com, wetp <wetp.zy@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Steven?

On Mon, Jun 7, 2021 at 6:46 AM James Wang <jnwang@linux.alibaba.com> wrote:
>
> >
> > James Wang has reproduced it stably on the latest 4.19 LTS.
> > After some debugging, we finally proved that it's due to ftrace
> > buffer out-of-bound access using a debug tool as follows:
[..]

Looks about right:

> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index a21ef9cd2aae..9299057feb56 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -2736,7 +2736,7 @@ trace_event_buffer_lock_reserve(struct trace_buffer **current_rb,
> >           (entry = this_cpu_read(trace_buffered_event))) {
> >               /* Try to use the per cpu buffer first */
> >               val = this_cpu_inc_return(trace_buffered_event_cnt);
> > -             if ((len < (PAGE_SIZE - sizeof(*entry))) && val == 1) {
> > +             if ((len < (PAGE_SIZE - sizeof(*entry) - sizeof(entry->array[0]))) && val == 1) {
> >                       trace_event_setup(entry, type, trace_ctx);
> >                       entry->array[0] = len;
> >                       return entry;

I have to say that I don't love that code. Not before, and not with the fix.

That "sizeof(*entry)" is clearly wrong, because it doesn't take the
unsized array into account.

But adding the sizeof() for a single array entry doesn't make that
already unreadable and buggy code much more readable.

It would probably be better to use "struct_size(entry, buffer, 1)"
instead, and I think it would be good to just split things up a bit to
be more legibe:

        unsigned long max_len = PAGE_SIZE - struct_size(entry, array, 1);

        if (val == 1 && len < max_len && val == 1) {
                trace_event_setup(entry, type, trace_ctx);
                ..

instead.

However, I have a few questions:

 - why "len < max_offset" rather than "<="?

 - why don't we check the length before we even try to reserve that
percpu buffer with the expensive atomic this_cpu_inc_return()?

 - is the size of that array guaranteed to always be 1? If so, why is
it unsized? Why is it an array at all?

 - clearly the array{} size must not be guaranteed to be 1, but why a
size of 1 then always sufficient here? Clearly a size of 1 is the
minimum required since we do that

        entry->array[0] = len;

   and thus use one entry, but what is it that makes it ok that it
really is just one entry?

Steven, please excuse the above stupid questions of mine, but that
code looks really odd.

               Linus
