Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4C44B2E47
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 21:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348367AbiBKUPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 15:15:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbiBKUPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 15:15:38 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E4ACF9
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 12:15:36 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id u6so18711188lfc.3
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 12:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=akw+F2hkLlIx1zx4pGqLno/WqoCLfLF+9C33bhKHXXA=;
        b=HUU6SdkM6LBsvdup/PD0lWZgy6/ryJ47CutLjO78bSfQjk58z09KwVzWhty+y5iViA
         vfi9/F4l8vCsLg7iCMNjFKjOgZacD9q+CuVyF+U/WnInP0soTdRar79I8dc/Duc7d4Aw
         tHCRHyNSm7bRx9v6yPM5H5DtDMBHBB5CbS3c2HcG07IPaIq5T8Nwl1w170zcS/b8eQsB
         RBuH+ilHUprX4knao6DxzesRQHN2VGIL4o23zshaUr2pYhZPpfjsfmbsGdToAFXLz2Tm
         20lHlnz/Ld2GMxxmqhpf3cNmTLKsXyUp/DMuHQJNB6TLfmFqI2WRaXkJJq9AOWH00GnA
         nECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=akw+F2hkLlIx1zx4pGqLno/WqoCLfLF+9C33bhKHXXA=;
        b=50rt06NlexD2e34t0bsD34zrpqlsQKWl5RPs9DxHq55hp9PjAJkRL3eHmuhdua9rri
         aNzNr05aGUa2PtZLfVvnj/ZXxxQ3zgNhXsJJjhgYp465iOttJWb4oPm3rBKEbiFpjbpD
         D+KF5UbVARB75WN7LdmJXmCeS2osFV+lu9X6+r0eW4MPzejl+JmLyj4iAY+dHwQqGQvA
         MqVU1UX4QgJwqotxIBcbsHIq1k0U5b3AL68kxFLZGKqxpUFVZfCONm7XtYWMtmp+/swG
         wxlWNkA5jT1zCkozSkX/CZoJctpG3VGW2I0XGYNFkQxxp1IkJK5uVsBkAxorv1CLwidV
         7Anw==
X-Gm-Message-State: AOAM533kzIUkkSI7nxmO6rt9XYVAu9HgNEui7CJJVJAogYt36sejdbOQ
        mC2Aj3qrJCA+IjKSx/QgO9lg/oQ5ErTJM1kdGGThZQ==
X-Google-Smtp-Source: ABdhPJwxuRGJlb59/HO/KFupbtqn1lGMApRIpVAemnjvZ04sgT9KZ9Pb8LdGhWzkwKG7zykKNWEL3OKZw+Qxo0VpISY=
X-Received: by 2002:a19:ee13:: with SMTP id g19mr2315780lfb.288.1644610534329;
 Fri, 11 Feb 2022 12:15:34 -0800 (PST)
MIME-Version: 1.0
References: <20220210025321.787113-1-keescook@chromium.org>
 <20220210025321.787113-2-keescook@chromium.org> <CAG48ez1m7XJ1wJvTHtNorH480jTWNgdrn5Q1LTZZQ4uve3r4Sw@mail.gmail.com>
 <202202100935.FB3E60FA5@keescook> <CAG48ez3fG7S1dfE2-JAtyOZUK=0_iZ03scf+oD6gwVyD1Qp33g@mail.gmail.com>
 <202202101254.1174AB2B@keescook>
In-Reply-To: <202202101254.1174AB2B@keescook>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 11 Feb 2022 21:15:07 +0100
Message-ID: <CAG48ez0GX5NzAu72DMHaN4u4cwTb51tGm+opwV5uNsUdgL1fVQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] signal: HANDLER_EXIT should clear SIGNAL_UNKILLABLE
To:     Kees Cook <keescook@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 10:09 PM Kees Cook <keescook@chromium.org> wrote:
> On Thu, Feb 10, 2022 at 07:01:39PM +0100, Jann Horn wrote:
> > On Thu, Feb 10, 2022 at 6:37 PM Kees Cook <keescook@chromium.org> wrote=
:
> > > On Thu, Feb 10, 2022 at 05:18:39PM +0100, Jann Horn wrote:
> > > > On Thu, Feb 10, 2022 at 3:53 AM Kees Cook <keescook@chromium.org> w=
rote:
> > > > > Fatal SIGSYS signals were not being delivered to pid namespace in=
it
> > > > > processes. Make sure the SIGNAL_UNKILLABLE doesn't get set for th=
ese
> > > > > cases.
> > > > >
> > > > > Reported-by: Robert =C5=9Awi=C4=99cki <robert@swiecki.net>
> > > > > Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced s=
iganls do not get changed")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > > ---
> > > > >  kernel/signal.c | 5 +++--
> > > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/kernel/signal.c b/kernel/signal.c
> > > > > index 38602738866e..33e3ee4f3383 100644
> > > > > --- a/kernel/signal.c
> > > > > +++ b/kernel/signal.c
> > > > > @@ -1342,9 +1342,10 @@ force_sig_info_to_task(struct kernel_sigin=
fo *info, struct task_struct *t,
> > > > >         }
> > > > >         /*
> > > > >          * Don't clear SIGNAL_UNKILLABLE for traced tasks, users =
won't expect
> > > > > -        * debugging to leave init killable.
> > > > > +        * debugging to leave init killable, unless it is intende=
d to exit.
> > > > >          */
> > > > > -       if (action->sa.sa_handler =3D=3D SIG_DFL && !t->ptrace)
> > > > > +       if (action->sa.sa_handler =3D=3D SIG_DFL &&
> > > > > +           (!t->ptrace || (handler =3D=3D HANDLER_EXIT)))
> > > > >                 t->signal->flags &=3D ~SIGNAL_UNKILLABLE;
> > > >
> > > > You're changing the subclause:
> > > >
> > > > !t->ptrace
> > > >
> > > > to:
> > > >
> > > > (!t->ptrace || (handler =3D=3D HANDLER_EXIT))
> > > >
> > > > which means that the change only affects cases where the process ha=
s a
> > > > ptracer, right? That's not the scenario the commit message is talki=
ng
> > > > about...
> > >
> > > Sorry, yes, I was not as accurate as I should have been in the commit
> > > log. I have changed it to:
> > >
> > > Fatal SIGSYS signals (i.e. seccomp RET_KILL_* syscall filter actions)
> > > were not being delivered to ptraced pid namespace init processes. Mak=
e
> > > sure the SIGNAL_UNKILLABLE doesn't get set for these cases.
> >
> > So basically force_sig_info() is trying to figure out whether
> > get_signal() will later on check for SIGNAL_UNKILLABLE (the SIG_DFL
> > case), and if so, it clears the flag from the target's signal_struct
> > that marks the process as unkillable?
> >
> > This used to be:
> >
> > if (action->sa.sa_handler =3D=3D SIG_DFL)
> >     t->signal->flags &=3D ~SIGNAL_UNKILLABLE;
> >
> > Then someone noticed that in the ptrace case, the signal might not
> > actually end up being consumed by the target process, and added the
> > "&& !t->ptrace" clause in commit
> > eb61b5911bdc923875cde99eb25203a0e2b06d43.
> >
> > And now Robert Swiecki noticed that that still didn't accurately model
> > what'll happen in get_signal().
> >
> > This seems hacky to me, and also racy: What if, while you're going
> > through a SECCOMP_RET_KILL_PROCESS in an unkillable process, some
> > other thread e.g. concurrently changes the disposition of SIGSYS from
> > a custom handler to SIG_DFL?
>
> Do you mean after force_sig_info_to_task() has finished but before
> get_signal()? SA_IMMUTABLE will block changes to the action.

Yeah, that's what I meant.
Thanks, I missed SA_IMMUTABLE. Ugh, this is not pretty code...
