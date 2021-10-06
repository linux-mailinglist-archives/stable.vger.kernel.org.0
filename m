Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4B742480D
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 22:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbhJFUkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 16:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239460AbhJFUkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 16:40:23 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE0FC061760
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 13:38:30 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y23so15808182lfb.0
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 13:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sch4r++lRpWjMNWm6J3bRObYHgBNc9lQrCbgQx2Tuoo=;
        b=a4pZ+3Br7NaYQ2Kzf0S9JsFgIpq4GtOWcP82qqLDPevvFWGxm/mxbnaYhDvd0NjDzX
         ByDUN83WSmy4t7uZxInG6536asXx/W9SjkQt5krKh7okGsyVux0QZoI8LaU9tQq8LPaj
         ZqUEde7CRF+GnW8R8o5wp+0gkC+ZwoxlHuPEoYHOPaUN6vXiA6cQmpWgsAsIlLQ4JGzq
         yFffrdE1JxW7PNPvPLd5UBxf2aYT/M43/9HFg9f236FAPnyEh9AZF/PBmEKUUV2XMoUR
         me52kJBEfFV/8PhDgWlR+aZwczihZijcNWYIkBnKH8NufaVp6pDbdQz/I++4VCTzM07s
         uyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sch4r++lRpWjMNWm6J3bRObYHgBNc9lQrCbgQx2Tuoo=;
        b=biubPqy6+kihqTVZf987JFbAlR+g3m/FUL91VOJ3mj03fqKzwHRuQYW6xcfcXvXB/L
         SGuRjYBJnpnjJqlxZqqlwbLd+FJxDNuoMGbVcXe3vIR/RZEIG/L3Pin3Say0wI1wGFM2
         8ZInR7YF563Mxu/A3gEaefzHSWP8gfmGPXPqd/J1nXaKw7F//nY4UKcdPpJ1cGHWvHqx
         me6JVU3VeEMLnu7WCy/KNMlQ2n1k1pmazGybTkh6wSsbghYpwFFtvVX7fykt1HJ4/sXv
         FOCZdBTFxFWkHQJFl4gx/ooUSueY97DbJNTzLqRBxszdksGEfvLB0UUBRwSy+Qv/lZKi
         2+OA==
X-Gm-Message-State: AOAM533GLjglBqq6aPcs6FPcGMVqY1/aO9bmPL1T5GiYZRTAradXFJhz
        IHr1k+N7Y1nBZ+NvCy4VhCKBVunRhIenLKha5LHI/Q==
X-Google-Smtp-Source: ABdhPJxedfCoEzB5tZdpBasgE/9MbGIE0zJY6OR1GtP4jFj59lIv6nV246bFd8nVlFKClxucfJ/Bsa7/IVMSMHTLXW0=
X-Received: by 2002:a05:6512:239f:: with SMTP id c31mr176934lfv.19.1633552708433;
 Wed, 06 Oct 2021 13:38:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211006194610.953319-1-tkjos@google.com> <20211006194610.953319-4-tkjos@google.com>
 <CAHRSSExN4g0qubjjLhdGx5DA7njT5ZwPkAzCY1OEdR1dbscLVA@mail.gmail.com>
In-Reply-To: <CAHRSSExN4g0qubjjLhdGx5DA7njT5ZwPkAzCY1OEdR1dbscLVA@mail.gmail.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Wed, 6 Oct 2021 13:38:15 -0700
Message-ID: <CAHRSSEyHWvcLhjera_Gx_rJk+xOA8mTRpodEpHuHhYuLqrNEdQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] binder: use euid from cred instead of using task
To:     gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, jannh@google.com, jeffv@google.com,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 6, 2021 at 12:55 PM Todd Kjos <tkjos@google.com> wrote:
>
> On Wed, Oct 6, 2021 at 12:46 PM Todd Kjos <tkjos@google.com> wrote:
> >
> > Set a transaction's sender_euid from the the 'struct cred'

Sigh...and I forgot to run checkpatch before submitting which would
have caught this "the the"

> > saved at binder_open() instead of looking up the euid
> > from the binder proc's 'struct task'. This ensures
> > the euid is associated with the security context that
> > of the task that opened binder.
> >
> > Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
> > Signed-off-by: Todd Kjos <tkjos@google.com>
> > Stephen Smalley <stephen.smalley.work@gmail.com>
>
> This should have been "Suggested-by: Stephen Smalley
> <stephen.smalley.work@gmail.com>"
>
> > Cc: stable@vger.kernel.org # 4.4+
> > ---
> > v3: added this patch to series
> >
> >  drivers/android/binder.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> > index 989afd0804ca..26382e982c5e 100644
> > --- a/drivers/android/binder.c
> > +++ b/drivers/android/binder.c
> > @@ -2711,7 +2711,7 @@ static void binder_transaction(struct binder_proc *proc,
> >                 t->from = thread;
> >         else
> >                 t->from = NULL;
> > -       t->sender_euid = task_euid(proc->tsk);
> > +       t->sender_euid = proc->cred->euid;
> >         t->to_proc = target_proc;
> >         t->to_thread = target_thread;
> >         t->code = tr->code;
> > --
> > 2.33.0.800.g4c38ced690-goog
> >
