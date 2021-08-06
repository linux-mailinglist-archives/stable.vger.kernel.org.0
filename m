Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4FC3E2B6B
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 15:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbhHFNdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 09:33:05 -0400
Received: from mail-oo1-f48.google.com ([209.85.161.48]:34480 "EHLO
        mail-oo1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243664AbhHFNdF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 09:33:05 -0400
Received: by mail-oo1-f48.google.com with SMTP id w2-20020a4a9e420000b02902859adadf0fso1364038ook.1;
        Fri, 06 Aug 2021 06:32:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VlUEltVPjDOqA4sdJqXGHn/FwTmAHCb9CTU/HCaOEy8=;
        b=gw+gvWWWp245wdq56EWI37r1coVxK0e1Q3INX4SEFNpLiGtLnpXHzOV15H2UK+dHwl
         7+WLMkVHV0Z1ydiCaKfMe81SeqpP9N1OnnTTsFJ0+yxUNOf/U60y+oPHl69f2nWlFL+A
         Pvg/+kFOV5rEFs5N1ucqTa630zbZMZnY2EHfRewxiIZjUTXtIaWRUFML15sm1T5yBq23
         pmoWnXnd+yvVm6yUWHFjBZ29uFRFCAa5SuMZRVY9Jp17EvsYzBWOrJ0HI9R52ZwBEDyo
         AQ4LKABUAkrZww82PD8AGFBbWu9/VlaHS3Fbozj7VqTuPCTIT/CI20BZ1Grj2Lsxj0UT
         SdIA==
X-Gm-Message-State: AOAM532lBPCqDK9SxmzCL66XCxpc4ukQ/o4SXhO1L2MWocQo+PU34rUj
        yRxe1nJ08xtfyjNHatvi5BkxA2G51JW3+fjhF10=
X-Google-Smtp-Source: ABdhPJyAwEzgWzXdyGc/qvPQD7aNe1AHQkem56COPaU8jhTLS0VDzcZrve2+CM3QoH56tYvEoH5OLoDreIQTStwLWj8=
X-Received: by 2002:a4a:3b85:: with SMTP id s127mr6453856oos.44.1628256768243;
 Fri, 06 Aug 2021 06:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210803102744.23654-1-lukasz.luba@arm.com> <4e6b02fb-b421-860b-4a07-ed6cccdc1570@arm.com>
 <CAJZ5v0hgpM+ErHMTYLFFasvn=Ptc0MyaaFn=HSxOcGcDcBwMVg@mail.gmail.com> <c23f8fac-4515-5891-0778-18e65eeb7087@arm.com>
In-Reply-To: <c23f8fac-4515-5891-0778-18e65eeb7087@arm.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 6 Aug 2021 15:32:37 +0200
Message-ID: <CAJZ5v0iB_vbbqzee6HSoLbVwVBWMmpvHWLZ_5_neWWqXr1JqoQ@mail.gmail.com>
Subject: Re: [PATCH v3] PM: EM: Increase energy calculation precision
To:     Lukasz Luba <lukasz.luba@arm.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Chris Redpath <Chris.Redpath@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Quentin Perret <qperret@google.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, segall@google.com,
        Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        CCj.Yeh@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 5, 2021 at 12:00 PM Lukasz Luba <lukasz.luba@arm.com> wrote:
>
>
>
> On 8/4/21 7:10 PM, Rafael J. Wysocki wrote:
> > On Tue, Aug 3, 2021 at 3:31 PM Lukasz Luba <lukasz.luba@arm.com> wrote:
> >>
> >> Hi Rafael,
> >>
> >> On 8/3/21 11:27 AM, Lukasz Luba wrote:
> >>
> >> [snip]
> >>
> >>>
> >>> Fixes: 27871f7a8a341ef ("PM: Introduce an Energy Model management framework")
> >>> Reported-by: CCJ Yeh <CCj.Yeh@mediatek.com>
> >>> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> >>> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
> >>> ---
> >>>
> >>> v3 changes:
> >>> - adjusted patch description according to Dietmar's comments
> >>> - added Dietmar's review tag
> >>> - added one empty line in the code to separate them
> >>>
> >>>    include/linux/energy_model.h | 16 ++++++++++++++++
> >>>    kernel/power/energy_model.c  |  4 +++-
> >>>    2 files changed, 19 insertions(+), 1 deletion(-)
> >>>
> >>
> >> Could you take this patch via your PM tree, please?
> >
> > I can do that, but do you want a Cc:stable tag on it?
> >
>
> No, thank you. I'll prepare a dedicated patches and send them after this
> patch gets a proper commit ID. I've done similar things recently with
> some thermal stuff and different stable versions [1].
>
> Please take this patch. I will handle the stable testing, preparation
> separately.
>
> [1] https://lore.kernel.org/lkml/20210514104916.19975-1-lukasz.luba@arm.com/

OK, applied as 5.15 material.

However, since I'm on vacation next week, it will show up in
linux-next after -rc6.

Thanks!
