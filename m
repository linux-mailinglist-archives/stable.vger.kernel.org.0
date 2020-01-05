Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B61309CC
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 21:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgAEUGT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 5 Jan 2020 15:06:19 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33432 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgAEUGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 15:06:19 -0500
Received: by mail-yw1-f65.google.com with SMTP id 192so21095128ywy.0;
        Sun, 05 Jan 2020 12:06:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hfNkMg16ML0AjVnvsnzrmGTTV58CAeyk3QhuSCdBRME=;
        b=IBceYQfpDJQZcIhsBMSb4WQUuZPLLE3F3uUxktjHOyPR2U4y2eid2IYCIS3TPyfPWW
         GGJCFpnSvLsPa35UFZo+NiEhRCj6yR1z6EtC7/kpIlmpNqeNeoqfHHJBnnN9wx1BBs3R
         F3x/9S9SwlP8Ls8WNbt+ahjtwMxyvxaS2Of02mdTOnpF3PLI0ZpBgsUCBx8V0FDDIXsl
         VA3Pgh768JH2bEvrbGw5Im4rt2eX9qeu9g/pRASVG26MySaiHRZY8BSuIdvdE+v1i4+l
         R4Gj9IxDRgqAta6f2e/RwtjFohOLDbM2rEm1AAsujT9ZwtfuRz6yHnuENwixeNfLM+ce
         vlpw==
X-Gm-Message-State: APjAAAVuXV3lHTf8NP/hFhlQN40l5sJZMjWJAWfIjTe2rq864JegxhI3
        fLN5GhLIgauSk4CrCaUvc8DQpZlnpmowMT0QflA=
X-Google-Smtp-Source: APXvYqz0pi9ReUkM7x43jc6QBlqnBX0vKtDDieWGeT43rG7ULUQsmA2oc7ygowDWvo/a/KdCNOFtF5LXxamfWiysd0k=
X-Received: by 2002:a81:380b:: with SMTP id f11mr21733505ywa.145.1578254778630;
 Sun, 05 Jan 2020 12:06:18 -0800 (PST)
MIME-Version: 1.0
References: <CAMx4oe38RytiyqWfYb=So8iC6N=8nebqy3DsekiT7A5DGjpe+w@mail.gmail.com>
 <CAMx4oe2JKTsOKg3P324PYRH=0ajOVDaXTLa7p=16Fo9fGiQSpQ@mail.gmail.com>
 <CABA31DrtCwUj-wzPP+dwUP+=jTOHnt8eoS+d+N2yfAn22W19vA@mail.gmail.com> <20200105193550.GA177781@krava>
In-Reply-To: <20200105193550.GA177781@krava>
From:   Akemi Yagi <toracat@elrepo.org>
Date:   Sun, 5 Jan 2020 12:06:07 -0800
Message-ID: <CABA31DoxzzoOgQXfLmaF2+msqi9F_sFRBN2thxe7W6+1QmWWgA@mail.gmail.com>
Subject: Re: 4.9.208 regression in perf building
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Gordan Bobic <gordan@redsleeve.org>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ElRepo <contact@elrepo.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 5, 2020 at 11:36 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Sun, Jan 05, 2020 at 10:21:25AM -0800, Akemi Yagi wrote:
> > Adding Arnaldo and Jiri to the CC list.
> >
> > On Sun, Jan 5, 2020 at 9:01 AM Gordan Bobic <gordan@redsleeve.org> wrote:
> > >
> > > It looks like 4.9.208 introduces a build regression for perf:
> > >
> > > make -f /builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/build/Makefile.build
> > > dir=. obj=perf
> >
> > >  -c -o builtin-report.o builtin-report.c
> > > builtin-report.c: In function ‘report__setup_sample_type’:
> > > builtin-report.c:296:6: error: ‘dwarf_callchain_users’ undeclared
> > > (first use in this function)
> > >   if (dwarf_callchain_users) {
> > >       ^
> > > builtin-report.c:296:6: note: each undeclared identifier is reported
> > > only once for each function it appears in
> > > mv: cannot stat ‘./.builtin-report.o.tmp’: No such file or directory
> > > make[3]: *** [builtin-report.o] Error 1
> > > make[2]: *** [perf-in.o] Error 2
> > > make[1]: *** [sub-make] Error 2
> > > make: *** [all] Error 2
> > >
> > > 4,9.207 works fine.
> >
> > The regression was caused by the following patch:
> >
> > https://lore.kernel.org/lkml/20191021133834.25998-7-acme@kernel.org/
> >
> > To fix this, 'dwarf_callchain_users' needs to be declared.
>
> hum, I see it's declared in callchain.h which is included in builtin-report.c
> also I can't see that same stuff like you have on line 296.. what sources are you on?
>
> could you please check with latest Arnaldo's perf/core?
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
>
> thanks,
> jirka

This is kernel 4.4.208 that was released today.
'dwarf_callchain_users' is not declared in this kernel. I'm afraid it
was missed when the aforementioned patch was backported.

Akemi
