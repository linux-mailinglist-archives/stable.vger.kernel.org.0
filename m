Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0947C2B939B
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 14:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgKSNZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 08:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgKSNZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 08:25:18 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A872C0613D4
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 05:25:18 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id u19so8217613lfr.7
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 05:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KLQf36DeOut5/5BOL2GcUQMrMJwzUV5j8KCDhBu2E+k=;
        b=iht9VFEu0IoOXoakcowuQegaWzvNUB079aNJiHsBjuQGCXqC/IP+4OEEOAHES8o/N3
         a4yjIvhvwGK08M6wWpjQ/m/kk1bdfQBGIuCAaiap1PpzVAi2y8tdqics7XCDyV1fzJ6i
         pQXaXHgZvt/F2P+14xTwdEwULl1VRCF4gDMBzwKAOYbeY2yWB7xdVz5dooqRtKpkvZyY
         oZw6kBUfP9jSKkfNf7Xiax4jy7VbHldPSz3MSEYkoBBzBUsvsu6G+RjmTrrp+g27YtUN
         OGEK5KD41ujZfWmTuWQSSPRgtq6kP+vX7mm5+XtD9La8qHGYyzHRnF12/fhCcmYU+JBG
         DLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KLQf36DeOut5/5BOL2GcUQMrMJwzUV5j8KCDhBu2E+k=;
        b=iGMf+tXra0IduXfnmQash+U8khpcS70iXYfN0FCC/OsjnyX19mSTXF4h9UT6CrR1Bc
         MHh/jhjNnuRWuPuuz5AU3Rm+xcdxvRUQ6Bdm5okUHjjL5M0Uk1pS6Ccp/I5P6Vg8SbSC
         i0fsvn/R5V1KIBiu5QgE5dRibuEY8jWz3PJSjpGtjXJ+2qyF/i1PLhaGNRHdPC6WAThK
         cNszrbAl392H8YaRTykwBLFjP7Ky4OdSTZmcIDj6bwRoWMtk+HenL04fCOXdv3i5XIqO
         MD8jh2dMmiXCj7XMlqbPvW0uiedSu6tN4h3XXPqIL6HV0X02MAmQ5M9p7C5Y05jn4rb5
         HsHQ==
X-Gm-Message-State: AOAM5308tuOeNiM98CzvhoQ/R2oFQZeYy9wTZdyG/NH44OwP8LXSfp1d
        Dj51rhEv7ihqSvqxBo7UZaJIxIAr3yzSE6bCfuoX7w==
X-Google-Smtp-Source: ABdhPJyOzK0Kea8uVCED1TnJFYe2hbyhH6rNZcb5m72i+hCtQQ80j7LJ2WsPyw1/5uCdaulSo3B7yoofIKqFlgXyvfE=
X-Received: by 2002:a19:a0c:: with SMTP id 12mr6292839lfk.568.1605792316677;
 Thu, 19 Nov 2020 05:25:16 -0800 (PST)
MIME-Version: 1.0
References: <17fc60a3-cc50-7cff-eb46-904c2f0c416e@canonical.com>
 <20201118235015.GB6015@geo.homenetwork> <20201119003319.GA6805@geo.homenetwork>
 <CAKfTPtBYm8UtBBnbc7qddA2_OAa3vwH=KoHNgvsQJ9zO2KocYQ@mail.gmail.com> <7c9462c9-8908-8592-0727-9117d4173724@canonical.com>
In-Reply-To: <7c9462c9-8908-8592-0727-9117d4173724@canonical.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Thu, 19 Nov 2020 14:25:05 +0100
Message-ID: <CAKfTPtAfzxbm0qM+8r2i+3jWjpJ2OLbU4F1WE8GrzTZH6Ck7FA@mail.gmail.com>
Subject: Re: [PATCH v3] sched/fair: fix unthrottle_cfs_rq for leaf_cfs_rq list
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     Tao Zhou <t1zhou@163.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        SeongJae Park <sjpark@amazon.com>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Tao Zhou <ouwen210@hotmail.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavan Kondeti <pkondeti@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Gavin Guo <gavin.guo@canonical.com>, halves@canonical.com,
        nivedita.singhvi@canonical.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Nov 2020 at 12:36, Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
>
>
> On 19/11/2020 05:36, Vincent Guittot wrote:
> > On Thu, 19 Nov 2020 at 01:36, Tao Zhou <t1zhou@163.com> wrote:
> >>
> >> On Thu, Nov 19, 2020 at 07:50:15AM +0800, Tao Zhou wrote:
> >>> On Wed, Nov 18, 2020 at 07:56:38PM -0300, Guilherme G. Piccoli wrote:
> >>>> Hi Vincent (and all CCed), I'm sorry to ping about such "old" patch, but
> >>>> we experienced a similar condition to what this patch addresses; it's an
> >>>> older kernel (4.15.x) but when suggesting the users to move to an
> >>>> updated 5.4.x kernel, we noticed that this patch is not there, although
> >>>> similar ones are (like [0] and [1]).
> >>>>
> >>>> So, I'd like to ask if there's any particular reason to not backport
> >>>> this fix to stable kernels, specially the longterm 5.4. The main reason
> >>>> behind the question is that the code is very complex for non-experienced
> >>>> scheduler developers, and I'm afraid in suggesting such backport to 5.4
> >>>> and introduce complex-to-debug issues.
> >>>>
> >>>> Let me know your thoughts Vincent (and all CCed), thanks in advance.
> >>>> Cheers,
> >>>>
> >>>>
> >>>> Guilherme
> >>>>
> >>>>
> >>>> P.S. For those that deleted this thread from the email client, here's a
> >>>> link:
> >>>> https://lore.kernel.org/lkml/20200513135528.4742-1-vincent.guittot@linaro.org/
> >>>>
> >>>>
> >>>> [0]
> >>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe61468b2cb
> >>>>
> >>>> [1]
> >>>> https://lore.kernel.org/lkml/20200506141821.GA9773@lorien.usersys.redhat.com/
> >>>> <- great thread BTW!
> >>>
> >>> 'sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list" failed to apply to
> >>> 5.4-stable tree'
> >>>
> >>> You could check above. But I do not have the link about this. Can't search it
> >>> on LKML web: https://lore.kernel.org/lkml/
> >>>
> >>> BTW: 'ouwen210@hotmail.com' and 'zohooouoto@zoho.com.cn' all is myself.
> >>>
> >>> Sorry for the confusing..
> >>>
> >>> Thanks.
> >>
> >> Sorry again. I forget something. It is in the stable.
> >>
> >> Here it is:
> >>
> >>   https://lore.kernel.org/stable/159041776924279@kroah.com/
> >
> > I think it has never been applied to stable.
> > As you mentioned, the backport has been sent :
> > https://lore.kernel.org/stable/20200525172709.GB7427@vingu-book/
> >
> > I received another emailed in September and pointed out to the
> > backport : https://www.spinics.net/lists/stable/msg410445.html
> >
> >
> >>
>
> Thanks a lot Tao and Vincent! Nice to know that you already worked the
> backport, gives much more confidence when the author does that heheh
>
> So, this should go to stable 5.4.y, but not 4.19.y IIUC?

Yeah. they should be backported up to v5.1 but not earlier

Regards,
Vincent

> Cheers,
>
>
> Guilherme
