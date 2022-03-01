Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC54C919A
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbiCARfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiCARfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:35:19 -0500
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA49240A9;
        Tue,  1 Mar 2022 09:34:38 -0800 (PST)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2dc0364d2ceso4001087b3.7;
        Tue, 01 Mar 2022 09:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iTyi2ipcTulwwvig7Nzi763q6AMtAMu2xsXlP+4t6rA=;
        b=F+PnaY2uwMEB4IqC1E8WFbMNooJpo97CyjYjf7YXzEHR5uFDFm2gVtN3otDwF2kgT+
         LR/3O4xCf+8ipCQU/5AX04huvGs+jp+qPKNBPNI4FnQFXMZ9++YgqjsovCYEsQPNAZDW
         +BT2yzyrmLxxteZTzzJtF04T6CG1UD+x+UlOs4Z76HR+Jo5dx9L2CFGWlbWLZy5dmEYG
         QexULn81CEGyVjvfxeksLLxBq2I7QSsLfOCMBp4rI1cKJtx5APqmQt2CONNe/LR824ve
         qSeGiaOge5cTWQYIgnuuthxwyDmsa5Y+1z3zN8UzJhB+s327SUYrkLGFTgXrBtyQEh1a
         5Zlg==
X-Gm-Message-State: AOAM531qFBnBjalvjbP6cB8pANvlXjpb6h2cSx0HkEGaf+6oCtfzdocU
        pOI9IwuWvvnC35/j5pbRt/oFMUi0vVKy4cGYQVk=
X-Google-Smtp-Source: ABdhPJxCTgyRMYkeAxcgNcOsSkwBodHdEDKrvezog5o9YvcneaD8XSAb1hgouGncJwJIMhUEeoxEH9iPmucx0PuYAwE=
X-Received: by 2002:a81:b65f:0:b0:2d6:d29c:63fd with SMTP id
 h31-20020a81b65f000000b002d6d29c63fdmr26629207ywk.196.1646156077485; Tue, 01
 Mar 2022 09:34:37 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com> <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com> <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
In-Reply-To: <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 1 Mar 2022 18:34:26 +0100
Message-ID: <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 1, 2022 at 6:18 PM Doug Smythies <dsmythies@telus.net> wrote:
>
> On Tue, Mar 1, 2022 at 3:58 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > On Tue, Mar 1, 2022 at 6:53 AM Feng Tang <feng.tang@intel.com> wrote:
> > > On Mon, Feb 28, 2022 at 08:36:03PM +0100, Rafael J. Wysocki wrote:
> ...
> > > >
> > > > However, it was a bit racy, so maybe it's good that it was not complete.
> > > >
> > > > Below is a new version.
> > >
> > > Thanks for the new version. I just gave it a try,  and the occasional
> > > long delay of cpufreq auto-adjusting I have seen can not be reproduced
> > > after applying it.
> >
> > OK, thanks!
> >
> > I'll wait for feedback from Dough, though.
>
> Hi Rafael,
>
> Thank you for your version 2 patch.
> I screwed up an overnight test and will have to re-do it.
> However, I do have some results.

Thanks for testing it!

> From reading the patch code, one worry was the
> potential to drive down the desired/required CPU
> frequency for the main periodic workflow, causing
> overruns, or inability of the task to complete its
> work before the next period.

It is not clear to me why you worried about that just from reading the
patch?  Can you explain, please?

> I have always had overrun
> information, but it has never been relevant before.
>
> The other worry was if the threshold of
> turbo/not turbo frequency is enough.

Agreed.

> I do not know how to test any final solution
> thoroughly, as so far I have simply found a
> good enough problematic example.
> We have so many years of experience with
> the convenient multi second NMI forcing
> lingering high pstate clean up. I'd keep it
> deciding within it if the TSC stuff needs to be
> executed or not.
>
> Anyway...
>
> Base Kernel 5.17-rc3.
> "stock" : unmodified.
> "revert" : with commit b50db7095fe reverted
> "rjw-2" : with this version2 patch added.
>
> Test 1 (as before. There is no test 2, yet.):
> 347 Hertz work/sleep frequency on one CPU while others do
> virtually no load but enough to increase the requested pstate,
> but at around 0.02 hertz aggregate.
>
> It is important to note the main load is approximately
> 38.6% @ 2.422 GHz, or 100% at 0.935 GHz.
> and almost exclusively uses idle state 2 (of
> 4 total idle states)
>
> /sys/devices/system/cpu/cpu7/cpuidle/state0/name:POLL
> /sys/devices/system/cpu/cpu7/cpuidle/state1/name:C1_ACPI
> /sys/devices/system/cpu/cpu7/cpuidle/state2/name:C2_ACPI
> /sys/devices/system/cpu/cpu7/cpuidle/state3/name:C3_ACPI
>
> Turbostat was used. ~10 samples at 300 seconds per.
> Processor package power (Watts):
>
> Workflow was run for 1 hour each time or 1249201 loops.
>
> revert:
> ave: 3.00
> min: 2.89
> max: 3.08

I'm not sure what the above three numbers are.

> ave freq: 2.422 GHz.
> overruns: 1.
> max overrun time: 113 uSec.
>
> stock:
> ave: 3.63 (+21%)
> min: 3.28
> max: 3.99
> ave freq: 2.791 GHz.
> overruns: 2.
> max overrun time: 677 uSec.
>
> rjw-2:
> ave: 3.14 (+5%)
> min: 2.97
> max: 3.28
> ave freq: 2.635 GHz

I guess the numbers above could be reduced still by using a P-state
below the max non-turbo one as a limit.

> overruns: 1042.
> max overrun time: 9,769 uSec.

This would probably get worse then, though.

ATM I'm not quite sure why this happens, but you seem to have some
insight into it, so it would help if you shared it.

Thanks!
