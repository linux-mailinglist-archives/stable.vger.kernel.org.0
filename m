Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87004272FE
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243398AbhJHV00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhJHV0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:26:25 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB080C061764
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 14:24:29 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id i24so42730414lfj.13
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 14:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k0EYZkuPR71XsiCTlWd0a9Iaorj/CJH5/iJemSUM6lY=;
        b=CB+zFtRT+SWYOCVXvnjab2ZxnSTYp48pax/Ux3XcXjnV8nn/eX8c47eCIBGFvOo7YJ
         LxYiLLqLvIk7YyvRCXudrtjCydUsaZBwoXMZUqvyCi3SjvyRroDokpfsZYmE406ekFGk
         oPZGl9Ms5HlaeReDXl2OAUeYqbl+WJzHFUCtkbc/2HO1H5gqFmoH25Se8leqv8dIqNry
         pP8rTyAHu8uL/ost4LkK9NY+iYjvaGMwoJptXdot/l8hD+EXybgSfdiHYplZ9XsL2lEs
         B5oDl1xi6wDx4Pnpb0EKpXK8N/IbbbaJo8+VCTcktB1qiyZRDRZAD933g5cpGdZcx5pv
         gsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k0EYZkuPR71XsiCTlWd0a9Iaorj/CJH5/iJemSUM6lY=;
        b=iPgy/ky67iLfz4Ek9IXgjrtwHAbuL8IuhFM+MWc9yGtLSujwY+uE4JNY5xIG4cGKqF
         IAK069u/qnSVa15Ybd+oAWwfcFK+mImQkQF4qeZxDJUCFsQPIIvoccSnl06KV1Fz+mYD
         I8Tgu9naipFZ3uFyjkSoDEBaIn7ljO/Cn3o04MA9eRcTm0efr0EZnywVYGHEgB3IF9Tc
         lhrDEHWCMt93Ujz+S4BqVTsmDtdQPj3+8fTwxLmM4rvHALK0dk40/SMPU3+A3/anhIMN
         kyms8VDchFgjBXVTdvsn7FbH1IAwt0bn5cBeOHUottog5c6jsa+yARhA6Rb/9lfIug8T
         mFfw==
X-Gm-Message-State: AOAM530eSgU+9rUijxvTeVToxG+ub4KUT4oCa7U/GJLT10k/aVxBiqxE
        eeqSmz//uW5UvD/MKhrJHVMs7GHPbvmPs34wAokxkA==
X-Google-Smtp-Source: ABdhPJw7QAvfd/PMBjVjoa/pBLk9iJwNrx/edGEOwARQnSyd73LqRwyNZlxISZX3d+E+YbInh0NqAq1innFWJxtJ4Cc=
X-Received: by 2002:a2e:b6c8:: with SMTP id m8mr6256568ljo.238.1633728267669;
 Fri, 08 Oct 2021 14:24:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211007004629.1113572-1-tkjos@google.com> <20211007004629.1113572-4-tkjos@google.com>
 <CAHC9VhTRTcZW9eyXXvAN7T=ZCQ_zwH5iBz+d0h2ntf7=XHE-Vw@mail.gmail.com>
In-Reply-To: <CAHC9VhTRTcZW9eyXXvAN7T=ZCQ_zwH5iBz+d0h2ntf7=XHE-Vw@mail.gmail.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Fri, 8 Oct 2021 14:24:15 -0700
Message-ID: <CAHRSSEy=eC0rbHUzDmCo6Na7Ya=uCq7zJ6_cXysi0oWQB=19YQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] binder: use euid from cred instead of using task
To:     Paul Moore <paul@paul-moore.com>
Cc:     casey@schaufler-ca.com, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, keescook@chromium.org,
        jannh@google.com, Jeffrey Vander Stoep <jeffv@google.com>,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 8, 2021 at 2:12 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Wed, Oct 6, 2021 at 8:46 PM Todd Kjos <tkjos@google.com> wrote:
> >
> > Set a transaction's sender_euid from the 'struct cred'
> > saved at binder_open() instead of looking up the euid
> > from the binder proc's 'struct task'. This ensures
> > the euid is associated with the security context that
> > of the task that opened binder.
> >
> > Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
> > Signed-off-by: Todd Kjos <tkjos@google.com>
> > Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > Cc: stable@vger.kernel.org # 4.4+
> > ---
> > v3: added this patch to series
> >
> >  drivers/android/binder.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> This is an interesting ordering of the patches.  Unless I'm missing
> something I would have expected patch 3/3 to come first, followed by
> 2/3, with patch 1/3 at the end; basically the reverse of what was
> posted here.

2/3 and 3/3 both depend on 1/3 (add "cred" member of struct
binder_proc). I kept that in 1/3 to keep that patch the same as what
had already been reviewed. I didn't think much about the ordering
between 2/3 and 3/3 -- but I agree that it would have been sensible to
reverse their order.

>
> My reading of the previous thread was that Casey has made his peace
> with these changes so unless anyone has any objections I'll plan on
> merging 2/3 and 3/3 into selinux/stable-5.15 and merging 1/3 into
> selinux/next.

Thanks Paul. I'm not familiar with the branch structure, but you need
1/3 in selinux/stable-5.15 to resolve the dependency on proc->cred.

>
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
>
> --
> paul moore
> www.paul-moore.com
