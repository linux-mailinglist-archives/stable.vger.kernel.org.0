Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2763C5FD8C5
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 14:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJMMF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 08:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJMMF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 08:05:57 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE35E6F40;
        Thu, 13 Oct 2022 05:05:56 -0700 (PDT)
Received: by mail-qk1-f170.google.com with SMTP id o22so902980qkl.8;
        Thu, 13 Oct 2022 05:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=16cYVu5ALm2doSHIwW+39wbA8KNFIbJOgONdVUyn1fM=;
        b=FL8q7gaEyOAGDS8Kn6sX+Sm7JtrrODcL0UHe6qTmzFkQU9UeSdk2DVEhPU6yS1BWCm
         TUD2MMJQ2YOvFiTbxgmCOxvu9yN9R/ylwti+SR/oGWsU79fZ1Rpk6zEuZ+mGGgFrmadX
         vis+SfUvDR07c96pZJJRb7PFN4xpIZfLFbU1ff7N462B+Ixc5B0dfe6imSq9OeHzBm6x
         tduPos+sI5M9nwo/FvwR0IiFk5hxiiAKtVx+IokH59/ep9GmSi7qe+vdtsisLT8BuIVQ
         desbUCNrOZ9cu1k+Yw/MmLSTEmcmtY/dSeD44sPDuKZwc7G+M7WXF4j29YVxtRjdyPjd
         wzmw==
X-Gm-Message-State: ACrzQf0f03m8fqLeyIN2PEOoKw5Mk124mgDpWSq6KGbP4LG35gpbRcGu
        4DYWNjaMOt9zQViutA+IPWxHFLx+VdyVcDBWL3k=
X-Google-Smtp-Source: AMsMyM7EwQBvUr4NZ4U8Mu+KXnp4xIvhuPCqceMwMMvV/Cg4Gosc+vZypNwqOoxFkA5yFzLtpHfcKvso06U7Uz6NauU=
X-Received: by 2002:a05:620a:158f:b0:6ee:93d5:e249 with SMTP id
 d15-20020a05620a158f00b006ee93d5e249mr6330407qkk.505.1665662755545; Thu, 13
 Oct 2022 05:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20221009205508.1204042-1-sashal@kernel.org> <20221009205508.1204042-4-sashal@kernel.org>
 <20221011113646.GA12080@duo.ucw.cz> <Y0VuKmt5BGfB6nAE@chenyu5-mobl1>
 <CAJZ5v0iHu3ZZuHeC7q6x4ZERaAu0pP2ubqzUv3v2upxLwOFXsg@mail.gmail.com> <731def9d99e6e199ed4b6e29119746121c41ca32.camel@linux.intel.com>
In-Reply-To: <731def9d99e6e199ed4b6e29119746121c41ca32.camel@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 13 Oct 2022 14:05:44 +0200
Message-ID: <CAJZ5v0g0TsW4inN-XZCpApjbkwWE5Z_hRuZ7eij-VS0ytkY1FQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 4/4] thermal: intel_powerclamp: Use get_cpu()
 instead of smp_processor_id() to avoid crash
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Chen Yu <yu.c.chen@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 5:06 AM srinivas pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> On Wed, 2022-10-12 at 18:58 +0200, Rafael J. Wysocki wrote:
> > On Tue, Oct 11, 2022 at 3:23 PM Chen Yu <yu.c.chen@intel.com> wrote:
> > >
> > > Hi Pavel,
> > > On 2022-10-11 at 13:36:46 +0200, Pavel Machek wrote:
> > > > Hi!
> > > >
> > > > > From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > > > >
> > > > > [ Upstream commit 68b99e94a4a2db6ba9b31fe0485e057b9354a640 ]
> > > > >
> > > > > When CPU 0 is offline and intel_powerclamp is used to inject
> > > > > idle, it generates kernel BUG:
> > > > >
> > > > > BUG: using smp_processor_id() in preemptible [00000000] code:
> > > > > bash/15687
> > > > > caller is debug_smp_processor_id+0x17/0x20
> > > > > CPU: 4 PID: 15687 Comm: bash Not tainted 5.19.0-rc7+ #57
> > > > > Call Trace:
> > > > > <TASK>
> > > > > dump_stack_lvl+0x49/0x63
> > > > > dump_stack+0x10/0x16
> > > > > check_preemption_disabled+0xdd/0xe0
> > > > > debug_smp_processor_id+0x17/0x20
> > > > > powerclamp_set_cur_state+0x7f/0xf9 [intel_powerclamp]
> > > > > ...
> > > > > ...
> > > > >
> > > > > Here CPU 0 is the control CPU by default and changed to the
> > > > > current CPU,
> > > > > if CPU 0 offlined. This check has to be performed under
> > > > > cpus_read_lock(),
> > > > > hence the above warning.
> > > > >
> > > > > Use get_cpu() instead of smp_processor_id() to avoid this BUG.
> > > >
> > > > This has exactly the same problem as smp_processor_id(), you just
> > > > worked around the warning. If it is okay that control_cpu
> > > > contains
> > > > stale value, could we have a comment explaining why?
> > > >
> > > May I know why does control_cpu have stale value? The control_cpu
> > > is a random picked online CPU which will be used later to collect
> > > statistics.
> > > As long as the control_cpu is online, it is valid IMO.
> >
> > So this is confusing, because the code makes the impression that
> > getting the number of the CPU running the code matters in some way,
> > which isn't the case.
> >
> > Something like cpumask_first(cpu_online_mask) should work as well if
> > I'm not mistaken and it would be less confusing to use this instead
> > IMO.
> That should work as we are under hotplug lock anyway here.

Well, that's my point.

I guess I'll send a patch with this change.
