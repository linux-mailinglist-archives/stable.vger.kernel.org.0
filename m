Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A6C4B1460
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 18:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245230AbiBJRhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 12:37:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245231AbiBJRhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 12:37:37 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ED2264E
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:37:37 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i21so10012080pfd.13
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 09:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=N0oLRk9WeOqKeOJsm7SffWghsKhMRhJhnNCJ7hAOzHs=;
        b=TuUkbtECnMw5pstxW8Vf9MzxmHFnzQ3VrFEtni7dbPixYPAbEo7NkMJuM1Qgj661KE
         VJk9b0PYPRSKeDN+YxctUa3QcAVCD7gNix6N+IkF65J+3xW2bM603Gziaqz6EhHSn7Mb
         /8xvocsd5u5OmtK/6qYupEdGZ7DajwT8DsAUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=N0oLRk9WeOqKeOJsm7SffWghsKhMRhJhnNCJ7hAOzHs=;
        b=587pZHLbXAlq1W2JD8MCrU2Lt1OV7Ol1dl0PJ7bCD6K1U1Wq3AcEJiDfx9jWkVaqCB
         ikbST6s02Y9VrRgaU6edpWFMUxsfPcdE2eeJ0uJZyEsU4lsk5AYQRO12pNTozR8KWhsm
         2K0348osC9++OTZnarCQKZmf3+PSUQHwSfIlLr6kFbCCllF+o1GM1/V5BfbJWn6KQLY9
         HAv6bE24Aq7tVjm0p0VQ9hx7LG3lwCZ22dOl0R/3zQOL9iCLsay5N0KvEqqYulMKZVx6
         2eEZ/vNCaTBg05IqtQNVlI2pcrbaFPGjYECX7j1mdH+Pefcinrb0w6VSEAAmpzCkY+Ww
         PoMQ==
X-Gm-Message-State: AOAM531FFfYtLi3/+oObKJgTckZoZ8tQtNBrm2Ms1bnoXekzno2eKshs
        sUt4lQLSpdqRbmXF1kfk62ZBIA==
X-Google-Smtp-Source: ABdhPJxa+zZlprJsPdRL16Vv3RjWBcmKKx4NXwfBhSgmfxd679Na+4oIMIPpYFm1OsZM+mHYkOu5PQ==
X-Received: by 2002:a05:6a00:134b:: with SMTP id k11mr8674137pfu.33.1644514656966;
        Thu, 10 Feb 2022 09:37:36 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 13sm23620222pfm.161.2022.02.10.09.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:37:36 -0800 (PST)
Date:   Thu, 10 Feb 2022 09:37:36 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jann Horn <jannh@google.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/3] signal: HANDLER_EXIT should clear SIGNAL_UNKILLABLE
Message-ID: <202202100935.FB3E60FA5@keescook>
References: <20220210025321.787113-1-keescook@chromium.org>
 <20220210025321.787113-2-keescook@chromium.org>
 <CAG48ez1m7XJ1wJvTHtNorH480jTWNgdrn5Q1LTZZQ4uve3r4Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1m7XJ1wJvTHtNorH480jTWNgdrn5Q1LTZZQ4uve3r4Sw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 05:18:39PM +0100, Jann Horn wrote:
> On Thu, Feb 10, 2022 at 3:53 AM Kees Cook <keescook@chromium.org> wrote:
> > Fatal SIGSYS signals were not being delivered to pid namespace init
> > processes. Make sure the SIGNAL_UNKILLABLE doesn't get set for these
> > cases.
> >
> > Reported-by: Robert Święcki <robert@swiecki.net>
> > Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  kernel/signal.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index 38602738866e..33e3ee4f3383 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -1342,9 +1342,10 @@ force_sig_info_to_task(struct kernel_siginfo *info, struct task_struct *t,
> >         }
> >         /*
> >          * Don't clear SIGNAL_UNKILLABLE for traced tasks, users won't expect
> > -        * debugging to leave init killable.
> > +        * debugging to leave init killable, unless it is intended to exit.
> >          */
> > -       if (action->sa.sa_handler == SIG_DFL && !t->ptrace)
> > +       if (action->sa.sa_handler == SIG_DFL &&
> > +           (!t->ptrace || (handler == HANDLER_EXIT)))
> >                 t->signal->flags &= ~SIGNAL_UNKILLABLE;
> 
> You're changing the subclause:
> 
> !t->ptrace
> 
> to:
> 
> (!t->ptrace || (handler == HANDLER_EXIT))
> 
> which means that the change only affects cases where the process has a
> ptracer, right? That's not the scenario the commit message is talking
> about...

Sorry, yes, I was not as accurate as I should have been in the commit
log. I have changed it to:

Fatal SIGSYS signals (i.e. seccomp RET_KILL_* syscall filter actions)
were not being delivered to ptraced pid namespace init processes. Make
sure the SIGNAL_UNKILLABLE doesn't get set for these cases.

> 
> >         ret = send_signal(sig, info, t, PIDTYPE_PID);
> >         spin_unlock_irqrestore(&t->sighand->siglock, flags);
> > --
> > 2.30.2
> >

-- 
Kees Cook
