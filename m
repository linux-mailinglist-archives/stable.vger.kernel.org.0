Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D560D5FC999
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 18:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiJLQ64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 12:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJLQ6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 12:58:55 -0400
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55115DED17;
        Wed, 12 Oct 2022 09:58:54 -0700 (PDT)
Received: by mail-qt1-f172.google.com with SMTP id a24so3006865qto.10;
        Wed, 12 Oct 2022 09:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5vBHj8epZRV6r337mAeq8QE108Ef9pXuaSsp4XqN2Uk=;
        b=Gb/EH5aKWlECGmXyOVAcbJxze8i6OWvlcr7CGGEvnu51SGCfqRfotUjPLeiulhWCSU
         5tSNwRnKp2tY1cZax0EOUxpF+QV0mm1sCvFlGl0c73lTKCmyxmpZi1ZEqK/S0KNyllrU
         9WVFxddOZMnpigpNAkwpECsxuC+fD3+pGWKgT1fC9hMEXYqmnGgo2ZgQVFk16Tcx2zr4
         bYbyYHnGu1vI6I6LmF2u2WlHU+PIzDbK2pZM1foSstgTOauftzDddgkF7RRBMG64PYeg
         3JUOzZIITFd2EE24svJNgNUKa+pgxxdnMmo3mv991uSh9v8dwmOpm1OH88Y0SYiJplxt
         MtMA==
X-Gm-Message-State: ACrzQf1fwcB9xhW2X1L0FgHebONhOtrbZKJiZtXlU8vbOmgDGpolM/pF
        Z6TBEO7FTAaZZwP6rC6hhujrAEFb9Lka9ix4d0E=
X-Google-Smtp-Source: AMsMyM5Lvg1ooUuM9Fb/ql4O0ZXlsMI64qCW+6Yz0+tjKs/OW14aLENf5EDw+Gl+F34qXcmdrDEPYN45B/hK0VB4LGY=
X-Received: by 2002:a05:622a:11c7:b0:39c:b4bc:7030 with SMTP id
 n7-20020a05622a11c700b0039cb4bc7030mr6813339qtk.17.1665593933419; Wed, 12 Oct
 2022 09:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221009205508.1204042-1-sashal@kernel.org> <20221009205508.1204042-4-sashal@kernel.org>
 <20221011113646.GA12080@duo.ucw.cz> <Y0VuKmt5BGfB6nAE@chenyu5-mobl1>
In-Reply-To: <Y0VuKmt5BGfB6nAE@chenyu5-mobl1>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 12 Oct 2022 18:58:42 +0200
Message-ID: <CAJZ5v0iHu3ZZuHeC7q6x4ZERaAu0pP2ubqzUv3v2upxLwOFXsg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 4/4] thermal: intel_powerclamp: Use get_cpu()
 instead of smp_processor_id() to avoid crash
To:     Chen Yu <yu.c.chen@intel.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        rafael@kernel.org, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org
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

On Tue, Oct 11, 2022 at 3:23 PM Chen Yu <yu.c.chen@intel.com> wrote:
>
> Hi Pavel,
> On 2022-10-11 at 13:36:46 +0200, Pavel Machek wrote:
> > Hi!
> >
> > > From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > >
> > > [ Upstream commit 68b99e94a4a2db6ba9b31fe0485e057b9354a640 ]
> > >
> > > When CPU 0 is offline and intel_powerclamp is used to inject
> > > idle, it generates kernel BUG:
> > >
> > > BUG: using smp_processor_id() in preemptible [00000000] code: bash/15687
> > > caller is debug_smp_processor_id+0x17/0x20
> > > CPU: 4 PID: 15687 Comm: bash Not tainted 5.19.0-rc7+ #57
> > > Call Trace:
> > > <TASK>
> > > dump_stack_lvl+0x49/0x63
> > > dump_stack+0x10/0x16
> > > check_preemption_disabled+0xdd/0xe0
> > > debug_smp_processor_id+0x17/0x20
> > > powerclamp_set_cur_state+0x7f/0xf9 [intel_powerclamp]
> > > ...
> > > ...
> > >
> > > Here CPU 0 is the control CPU by default and changed to the current CPU,
> > > if CPU 0 offlined. This check has to be performed under cpus_read_lock(),
> > > hence the above warning.
> > >
> > > Use get_cpu() instead of smp_processor_id() to avoid this BUG.
> >
> > This has exactly the same problem as smp_processor_id(), you just
> > worked around the warning. If it is okay that control_cpu contains
> > stale value, could we have a comment explaining why?
> >
> May I know why does control_cpu have stale value? The control_cpu
> is a random picked online CPU which will be used later to collect statistics.
> As long as the control_cpu is online, it is valid IMO.

So this is confusing, because the code makes the impression that
getting the number of the CPU running the code matters in some way,
which isn't the case.

Something like cpumask_first(cpu_online_mask) should work as well if
I'm not mistaken and it would be less confusing to use this instead
IMO.
