Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3DD30209
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 20:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfE3Shq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 14:37:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46379 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfE3Shq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 14:37:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id z19so8178917qtz.13;
        Thu, 30 May 2019 11:37:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QtDItTOKG0oEuYgA/AzlL7vWHCZCAXyrTV6+oZdO3RI=;
        b=t4LTECWexeRis1nwkZ4ukEbdTcRKcXleNUuqEq7EshDhHwCiajhu0cTM9A9slqP9JB
         RlnKUOQBQC3OQ+vqwmV4ijb2LgJAdATVDGNfBqHuoLuelsvb+StTTSlRxnTrNC5nNMXc
         qGS/TbOVRJCNuGdmwF2wPAqXEDhVG3Vb0Y6OcR3/ES2xhXKJkxRD8ZWiaKNS7+Yu5SHz
         u3ZcBbff3Uo9ZecUCrJXm1TX7n7obIggVD4yapVBk+kuWEuGNB1Bo8bYVxgEsqBhpdWH
         pu3ZnROIt8DHJToHhg+WLlEBhLqx8Nmx9X6l0XqTm9MDEls/SfcEi/evW+3qh3xIRNAj
         iaTg==
X-Gm-Message-State: APjAAAXj0VaWuvJSUq/ZdEmSsKK8BXCJpQjzsx6ByoA8RHp+2ZGOVe/s
        0/+yIQJ3gMcuAbb7ccc+Q4ICgBPL6CrRzJXznFU=
X-Google-Smtp-Source: APXvYqzLTIr9hnY4VamvBbGXgDqhOWM+DId1eEn9j5p3MUoL2aeyzJLJmTc3J4WjWBULvqEaQSjsTb5gGB8bLa2FTjk=
X-Received: by 2002:a0c:e78b:: with SMTP id x11mr1178890qvn.93.1559241465438;
 Thu, 30 May 2019 11:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <CAK8P3a1fsrz6kAB1z-mqcaNvXL4Hf3XMiN=Q5rzAJ3rLGPK_Yg@mail.gmail.com>
 <20190530144044.GG22536@redhat.com>
In-Reply-To: <20190530144044.GG22536@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 30 May 2019 20:37:29 +0200
Message-ID: <CAK8P3a2g_58+n6+T6rspcp_kvYiyjB0WqtxoYfshwQ7vXMmdWw@mail.gmail.com>
Subject: Re: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error codes
 according to restore_user_sigmask())
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, dbueso@suse.de,
        Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 4:41 PM Oleg Nesterov <oleg@redhat.com> wrote:
> On 05/30, Arnd Bergmann wrote:
> Plus every file touched by this patch asks for more cleanups. Say, do_poll()
> should return -ERESTARTNOHAND, not -EINTR, after that we can remove the ugly
> EINTR->ERESTARTNOHAND in its callers. And more.
>
> > For the stable
> > kernels, I think we want just the addition of the 'bool interrupted' argument
> > to restore_user_sigmask()
>
> or simply revert this patch. I will check if this is possible today... At first
> glance 854a6ed56839a40f6 fixed another bug by accident, do_pselect() did
> "ret == -ERESTARTNOHAND" after "ret = poll_select_copy_remaining()" which can
> turn ERESTARTNOHAND into EINTR, but this is simple. I'll check tomorrow.

Right, there were several differences between the system calls
that Deepa's original change got rid of. I don't know if any ones besides
the do_pselect() return code can be observed in practice.

> > > -       ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
> > > +       ret = set_xxx(ksig.sigmask, ksig.sigsetsize);
> > >         if (ret)
> > >                 return ret;
> > >
> > >         ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> > > -       restore_user_sigmask(ksig.sigmask, &sigsaved);
> > > -       if (signal_pending(current) && !ret)
> > > +
> > > +       interrupted = signal_pending(current);
> > > +       update_xxx(interrupted);
> >
> > Maybe name this
> >
> >            restore_saved_sigmask_if(!interrupted);
>
> Yes, I thought about restore_if(), but to me
>
>                 restore_saved_sigmask_if(ret != -EINTR);
>
> doesn't look readable... May be
>
>                 restore_saved_sigmask_unless(ret == -EINTR);
>
> ? but actually I agree with any naming.

Yes, restore_saved_sigmask_unless() probably better.

> > With some of the recent discussions about compat syscall handling,
> > I now think that we want to just fold set_compat_user_sigmask()
> > into set_user_sigmask()
>
> agreed, and I thought about this too. But again, I'd prefer to do this
> and other cleanups later, on top of this patch.

Ok, fair enough. I don't care much about the order as long as the
regression fix comes first.

     Arnd
