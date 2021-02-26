Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53E2326022
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 10:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhBZJeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 04:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhBZJdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 04:33:04 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3D5C061756
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 01:32:23 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id c8so9825351ljd.12
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 01:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2j0v9/++oo1nREjYMkhdHiO+3+LGu2RSZ2BTupmAla4=;
        b=ophkVSbst+ACqsyZFIiOp79lI2xxUl3LTnFt38oEalw/lQhYiComoPd8ijpD3Cvs6b
         cFI7zSVaYrOq61d/V5+i1JkNmr12hiKpRSEHr8gR2wlCsNdpDrIPUUifibpC9lQQcpxE
         t9/zYhSgsN90TVSI7GkaQZAVAJv9gO6s0+VjYYrmiEKzpztvbp0MvHtOxsoGtakVk3Aw
         JF/9bzvQPT+ot3SJpxr7RlkFzvYbf8wW4FBT4L2IiWmOtvZ59g3SUWHN8yM/IHwbrAxc
         fJhbQ0mnqFDXqitVUA7ghcrSxSJSlVWsZrjdYYpLp9s/mZyFpo9kQ1CxIfR9f0b1yRFJ
         S2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2j0v9/++oo1nREjYMkhdHiO+3+LGu2RSZ2BTupmAla4=;
        b=IGMeR70XcQlGbDtEJSaf7oKHRi1f/rXWy3yHDi3Qmn44zMkfnRHuxv95Kx7GXn+Mkz
         aweSigQGJe4H3fWYU5vyz9sMvgfzejMVA6hHImI3IclVOUxJ9Ub5rKrVvag/3zsZH8Gv
         eVch2tK6sq1WZTymYRm/xu4iDz3msRU47Mn7uSmyfdOhWyt8MOAmPlnUnq+vYlGopeUY
         PB1P8rQmCYlanbCS6AOLQHZddtUKoxmc3vkPRx9zWNEpZEhVZiSucMGN0maytsSma/+R
         2TpPSr6jjTo8VobPWmEWiG5krOSYA48Mzk1/+hkihSMT4+8833D7KE3wxH7a6GkycMg2
         1Ewg==
X-Gm-Message-State: AOAM532dc2dVbteZcVrT8Nuk2h0gWGZFqlVBSGEiC1T3scPhf3cfngJ/
        pTF67ggkPy5l/20xWMp8MfMp4B7a8fdWWC11Nnimikrl5bnrFw==
X-Google-Smtp-Source: ABdhPJxLOkSkEiUl2P7/vAViwKIgnITzNFziDn2z3wSwQ8KotDtSrVgAn+bJD8uGHGxHDbB8+J8Yr1MI0QZIhnT3tPA=
X-Received: by 2002:a2e:b01a:: with SMTP id y26mr1205089ljk.442.1614331941504;
 Fri, 26 Feb 2021 01:32:21 -0800 (PST)
MIME-Version: 1.0
References: <20210224081652.587785-1-sumit.garg@linaro.org>
 <20210225155607.634snzzq3w62kpkn@maple.lan> <CAFA6WYMYDNk2S=7crfYsrbP7XONTA-ytEypoqeo1GTpxf8NhAQ@mail.gmail.com>
 <YDij234n3KAxWuXf@kroah.com>
In-Reply-To: <YDij234n3KAxWuXf@kroah.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 26 Feb 2021 15:02:09 +0530
Message-ID: <CAFA6WYOij9-o35CVeZxi94+x8_cTpfXORmhn5YpfOgz0a-Ertg@mail.gmail.com>
Subject: Re: [PATCH] kgdb: Fix to kill breakpoints on initmem after boot
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Douglas Anderson <dianders@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, stefan.saecherl@fau.de,
        qy15sije@cip.cs.fau.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Feb 2021 at 13:01, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 26, 2021 at 12:32:07PM +0530, Sumit Garg wrote:
> > + stable ML
> >
> > On Thu, 25 Feb 2021 at 21:26, Daniel Thompson
> > <daniel.thompson@linaro.org> wrote:
> > >
> > > On Wed, Feb 24, 2021 at 01:46:52PM +0530, Sumit Garg wrote:
> > > > Currently breakpoints in kernel .init.text section are not handled
> > > > correctly while allowing to remove them even after corresponding pa=
ges
> > > > have been freed.
> > > >
> > > > Fix it via killing .init.text section breakpoints just prior to ini=
tmem
> > > > pages being freed.
> > > >
> > > > Suggested-by: Doug Anderson <dianders@chromium.org>
> > > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > >
> > > I saw Andrew has picked this one up. That's ok for me:
> > > Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
> > >
> > > I already enriched kgdbtest to cover this (and they pass) so I guess
> > > this is also:
> > > Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
> > >
> >
> > Thanks Daniel.
> >
> > > BTW this is not Cc:ed to stable and I do wonder if it crosses the
> > > threshold to be considered a fix rather than a feature. Normally I
> > > consider adding safety rails for kgdb to be a new feature but, in thi=
s
> > > case, the problem would easily ensnare an inexperienced developer who=
 is
> > > doing nothing more than debugging their own driver (assuming they
> > > correctly marked their probe function as .init) so I think this weigh=
s
> > > in favour of being a fix.
> > >
> >
> > Makes sense, Cc:ed stable.
>
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
> for how to do this properly.
>
> </formletter>

Thanks for the pointer, let me wait for this patch to land in Linus=E2=80=
=99
tree and then will drop a mail to stable@vger.kernel.org.

-Sumit
