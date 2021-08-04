Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6AB3E0741
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 20:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240055AbhHDSKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 14:10:38 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:44555 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240054AbhHDSKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 14:10:36 -0400
Received: by mail-oi1-f179.google.com with SMTP id w6so3811147oiv.11;
        Wed, 04 Aug 2021 11:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BHP1RoSVeBBQbedfLc0h0dS6upuWC946jvdxT2uP/us=;
        b=dXO5AmJDhrdMrc+zECtyi0zh5aV7nNqZZBOxtXsl1dK0G3HfxGP+hECd5v3eYuRnCG
         icxTHtBs/Z7W5CpB89xoQnoD4DV45RQ6Huh6u6UbIVUrNdodea3Jeb2vO8p2GTtjIFOR
         fvVjrIwLWYD8DSy7UootRoDMTeCHfU4+0rU5rbuxPwznhGaXtjt4hAp5ciGSTZAtPhw6
         uvl2RnRheN9EY+fXkYBz/UXXiw4DeiI3xlCOzQasjiVkHg7pOUT7M7ja/9loN+l1Vf+0
         awUXEcPX5dzMjHX1bnUMrlKi/v8gESjBRd1SmExgMufvQAKZbx8YTOyFWWGZ7wv0DbnB
         GqJA==
X-Gm-Message-State: AOAM532sOLTz40cr2QUM0c8OKY4BPd9BeSkZusEbDq8BdYgmjLTbIOTS
        92HYqzAJfa/X8K9GGVNprrqZVHKfM1EXJv8or9M=
X-Google-Smtp-Source: ABdhPJxQ4c65snW88xWZ5QHVpT273X+/XzM8e5NOX+d+920CdPyV1upZrtYZLElLkCUcX8kuRnSUwD641SssBH//43w=
X-Received: by 2002:aca:d7d5:: with SMTP id o204mr531239oig.69.1628100622488;
 Wed, 04 Aug 2021 11:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210803102744.23654-1-lukasz.luba@arm.com> <4e6b02fb-b421-860b-4a07-ed6cccdc1570@arm.com>
In-Reply-To: <4e6b02fb-b421-860b-4a07-ed6cccdc1570@arm.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 4 Aug 2021 20:10:11 +0200
Message-ID: <CAJZ5v0hgpM+ErHMTYLFFasvn=Ptc0MyaaFn=HSxOcGcDcBwMVg@mail.gmail.com>
Subject: Re: [PATCH v3] PM: EM: Increase energy calculation precision
To:     Lukasz Luba <lukasz.luba@arm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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

On Tue, Aug 3, 2021 at 3:31 PM Lukasz Luba <lukasz.luba@arm.com> wrote:
>
> Hi Rafael,
>
> On 8/3/21 11:27 AM, Lukasz Luba wrote:
>
> [snip]
>
> >
> > Fixes: 27871f7a8a341ef ("PM: Introduce an Energy Model management framework")
> > Reported-by: CCJ Yeh <CCj.Yeh@mediatek.com>
> > Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> > Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
> > ---
> >
> > v3 changes:
> > - adjusted patch description according to Dietmar's comments
> > - added Dietmar's review tag
> > - added one empty line in the code to separate them
> >
> >   include/linux/energy_model.h | 16 ++++++++++++++++
> >   kernel/power/energy_model.c  |  4 +++-
> >   2 files changed, 19 insertions(+), 1 deletion(-)
> >
>
> Could you take this patch via your PM tree, please?

I can do that, but do you want a Cc:stable tag on it?
