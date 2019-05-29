Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A6F2E84C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 00:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfE2Wcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 18:32:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34381 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2Wcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 18:32:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id h1so4692369qtp.1;
        Wed, 29 May 2019 15:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bhcaQuR9YSEQybP2ekpRZxM00TsWewuQkxFdS2ijASs=;
        b=o5JTyJbmqM4zgeEKLd+Ztdf2hwDDFFfWl+ndu71PPdrdakz2WUuhhLWCs5up4D+qv6
         XLQO2IQDV0Lz+nWTRzRd7TwVDNFigTYLfzTdBGFpsYzKj2Z8Tm3tquv/r+X+Ci0cLNTY
         6S49Jz4mHZFeHGG8bkguon5NlI1AOU5Q/FRGwgXAHyCCR+4INKoozDvAShGMO8K1UjqA
         36baRRJjzn5N52ytOoOtIdbG86rpTsGLoVBEbrkq98tWbT5K+B1/xxobdp3H9k9jLg27
         ApbAgGhbTg9Wdbq7dK9FJaQhLCOEheSG6jmVnBeRRcNSl/wdCJ7xvp7PxSxNrA8dpgTB
         gCSQ==
X-Gm-Message-State: APjAAAU41JjFRz0dPER56lLDIYn/5ROdXnIH63vRBttEfCEHmnaUGZdG
        r3sTvh2Lq0lbsU8rhp5y9UFxTQyLm/VOWTeeT88=
X-Google-Smtp-Source: APXvYqzjWc05T9BIUjfMN8/lfoIoLNUkz68qr+FmtCCk7e/p0sSEAdKNYq5z9uqUmaxIhN8RqRHwL2xJ+hWqCzO3yr8=
X-Received: by 2002:ac8:6750:: with SMTP id n16mr414503qtp.142.1559169169422;
 Wed, 29 May 2019 15:32:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com> <20190529161157.GA27659@redhat.com>
In-Reply-To: <20190529161157.GA27659@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 30 May 2019 00:32:32 +0200
Message-ID: <CAK8P3a1fsrz6kAB1z-mqcaNvXL4Hf3XMiN=Q5rzAJ3rLGPK_Yg@mail.gmail.com>
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

On Wed, May 29, 2019 at 6:12 PM Oleg Nesterov <oleg@redhat.com> wrote:
>
> Al, Linus, Eric, please help.
>
> The previous discussion was very confusing, we simply can not understand each
> other.
>
> To me everything looks very simple and clear, but perhaps I missed something
> obvious? Please correct me.

Thanks for the elaborate explanation in this patch, it all starts making sense
to me now. I also looked at your patch in detail and thought I had found
a few mistakes at first but those all turned out to be mistakes in my reading.

> See the compile-tested patch at the end. Of course, the new _xxx() helpers
> should be renamed somehow. fs/aio.c doesn't look right with or without this
> patch, but iiuc this is what it did before 854a6ed56839a.

I think this is a nice simplification, but it would help not to mix up the
minimal regression fix with the rewrite of those functions. For the stable
kernels, I think we want just the addition of the 'bool interrupted' argument
to restore_user_sigmask() to close the race that was introduced
854a6ed56839a. Following up on that for future kernels, your patch
improves the readability, but we can probably take it even further.

> -       ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
> +       ret = set_xxx(ksig.sigmask, ksig.sigsetsize);
>         if (ret)
>                 return ret;
>
>         ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> -       restore_user_sigmask(ksig.sigmask, &sigsaved);
> -       if (signal_pending(current) && !ret)
> +
> +       interrupted = signal_pending(current);
> +       update_xxx(interrupted);

Maybe name this

           restore_saved_sigmask_if(!interrupted);

and make restore_saved_sigmask_if() an inline function
next to restore_saved_sigmask()?

> @@ -2201,13 +2205,15 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
>         if (usig && copy_from_user(&ksig, usig, sizeof(ksig)))
>                 return -EFAULT;
>
> -       ret = set_compat_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
> +       ret = set_compat_xxx(ksig.sigmask, ksig.sigsetsize);
>         if (ret)
>                 return ret;

With some of the recent discussions about compat syscall handling,
I now think that we want to just fold set_compat_user_sigmask()
into set_user_sigmask() (whatever they get called in the end)
with an in_compat_syscall() conditional inside it, and completely get
rid of the COMPAT_SYSCALL_DEFINEx() definitions for those
system calls for which this is the only difference.

Unfortunately we still need the time32/time64 distinction, but removing
syscall handlers is a significant cleanup here already, and we can
move most of the function body of sys_io_pgetevents() into
do_io_getevents() in the process. Same for some of the other calls.

Not sure about the order of the cleanups, but probably something like
this would work:

1. fix the race (to be backported)
2. unify set_compat_user_sigmask/set_user_sigmask
3. remove unneeded compat handlers
4. replace restore_user_sigmask with restore_saved_sigmask_if()
5. also unify compat_get_fd_set()/get_fd_set() and kill off
    compat select() variants.

       Arnd
