Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A934796AA
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 22:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhLQV6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 16:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhLQV6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 16:58:18 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8553C061574;
        Fri, 17 Dec 2021 13:58:18 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id a14so6988391uak.0;
        Fri, 17 Dec 2021 13:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w0EpaHpJoul0Q9bbGLBoLrcsIU31hxjUakOhu205FPI=;
        b=P1+fIdlSekoNWbxvUKQJZ/ftKMsuTpTIn7iDEb75oVJpLPjRlpAWHgIcz4IiQxRmy+
         VotbCHPAIktZy3ouA3gYyRFlmgfi5W1XcY0Qo4KcsSNhO2mj8jZF60QfyVPxks6RPvtE
         d3GUSbje+UECToYTTbLyJ7Uu2u5H65BJJQj8KpomlzV7Yo1ecBv6BSaUkH3sRWm40K9t
         Y+xcBmH86d//4PrYvHcEjsX4zv417fMOQC3huLsgSiXTr5xI+ZTViyUa59eQeMFWQuax
         SNovmLo9a95kkpS3YEvXiUGojeDJ80raoARKMDPd1qH6CJEv07NURlTQzo1ILZK55o7L
         yZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w0EpaHpJoul0Q9bbGLBoLrcsIU31hxjUakOhu205FPI=;
        b=2valk9RmFSjgXtzfYHsMSCyEc9/77iGrlslDce3xBM75etm+XPpTtivGN8mM/mPHQ2
         oXPLzOUF55T/oF//FV2OfSdWXMVvndCzXQ2vCYn2VMCQP5GYf7GryBgnyLAMvmdCI1C8
         FJ6mfbeYtfbhL6NYFXRb0u5X+GjsFzsfWkcUGIEyeaGqkyNApb74NKlSuG0HebvC5KNx
         pv5UNRovtke7bJ5ezlFuUFZT3TOKPlzsJ5b1AEw6XjQIN1903pYlIUaaAqG8BWEdo0zw
         fXL5W/v3KK3M1xWjGOBTADC83ZnJ/9TAqUYBgygJ4/+VBb6OEByty1XYvBAyo0iVgY33
         a5/Q==
X-Gm-Message-State: AOAM533BQEaA/5enTG7khl60Uch0Nkk0F9cmEtaMzAVqh2YP76xILpMx
        a0wVyJ2StsOBC1gzBqbCh+g8jb/kdR3MmlzfZgc=
X-Google-Smtp-Source: ABdhPJxdEokLcy6TnKuzKYNrRmiUszqUcSRv+B93tg0HIsrSYCkKn3cvFcC1lq3sew6+EJZH/HyELdojmnP/JTBqIg0=
X-Received: by 2002:a67:d31c:: with SMTP id a28mr1881898vsj.20.1639778297922;
 Fri, 17 Dec 2021 13:58:17 -0800 (PST)
MIME-Version: 1.0
References: <20211217021610.12801-1-yajun.deng@linux.dev> <YbyTuRWkB0gYbn7x@linutronix.de>
In-Reply-To: <YbyTuRWkB0gYbn7x@linutronix.de>
From:   Daniel Vacek <neelx.g@gmail.com>
Date:   Fri, 17 Dec 2021 22:58:06 +0100
Message-ID: <CAA7rmPEbRbztCHzanF148UVnL=Q_iAsA28yPJiu51aA=BhCwag@mail.gmail.com>
Subject: Re: [PATCH v3] lib/raid6: Reduce high latency by using migrate
 instead of preempt
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Yajun Deng <yajun.deng@linux.dev>, song@kernel.org,
        masahiroy@kernel.org, williams@redhat.com, pmenzel@molgen.mpg.de,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        linux-raid@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 8:09 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2021-12-17 10:16:10 [+0800], Yajun Deng wrote:
> > We found an abnormally high latency when executing modprobe raid6_pq, the
> > latency is greater than 1.2s when CONFIG_PREEMPT_VOLUNTARY=y, greater than
> > 67ms when CONFIG_PREEMPT=y, and greater than 16ms when CONFIG_PREEMPT_RT=y.
> >
> > How to reproduce:
> >  - Install cyclictest
> >      sudo apt install rt-tests
> >  - Run cyclictest example in one terminal
> >      sudo cyclictest -S -p 95 -d 0 -i 1000 -D 24h -m
> >  - Modprobe raid6_pq in another terminal
> >      sudo modprobe raid6_pq
> >
> > This is caused by ksoftirqd fail to scheduled due to disable preemption,
> > this time is too long and unreasonable.
> >
> > Reduce high latency by using migrate_disabl()/emigrate_enable() instead of
> > preempt_disable()/preempt_enable(), the latency won't greater than 100us.
> >
> > This patch beneficial for CONFIG_PREEMPT=y or CONFIG_PREEMPT_RT=y, but no
> > effect for CONFIG_PREEMPT_VOLUNTARY=y.
>
> Why does it matter? This is only during boot-up/ module loading or do I
> miss something?
> The delay is a jiffy so it depends on CONFIG_HZ. You do benchmark for
> the best algorithm and if you get preempted during that period then your
> results may be wrong and you make a bad selection.
>
> You can either enable one algorithm and or disable
> CONFIG_RAID6_PQ_BENCHMARK. I don't see the need for this patch not to
> mention the stable tree.

Exactly. We should not touch this. I've just sent a verbose
explanation in the original report thread.

--nX

> Sebastian
