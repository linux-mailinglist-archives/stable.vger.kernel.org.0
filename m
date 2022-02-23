Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC754C1559
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 15:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiBWOYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 09:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiBWOYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 09:24:34 -0500
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94E6B1A80;
        Wed, 23 Feb 2022 06:24:06 -0800 (PST)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2d68d519a33so211447127b3.7;
        Wed, 23 Feb 2022 06:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XDlv3ux3jKTWYHbjpT5ZPHS0c02nw63FWOML+f+Eem8=;
        b=iGjNmyoZfiK24YfgxUxvSnDOtedRX/DDu5TFfBSl2U43CNRxedw89HA1lPsS9wDDS3
         QwAuPvPhjsqjKC6mIP+1NN92zUPd/9daCPVvzmLpY9gwxmqmAcCXrj6iQGQNxWeU12xX
         QfJBIT2wn3DEjduz8V2CFZR2wf0OTam9g+NstkHB808KVR4yIit2HHBYYa2Hf6yFLUll
         10dDh+Cjk3X0Xr50AR29l35CGeF8ehMCr8UxpK23blufcE2S95juKLwFzFL8n071rMUM
         FLBR2t5JfPxMxdXK1L6EFRJXsCal2kS38onulAJrJ57iV8BZ73Q3IHhQ2epo3mSwtVW6
         dUsQ==
X-Gm-Message-State: AOAM531K6eSbH8/lYXAbMJ/g3MsWGcsxVHS+7T72iQO7isEox0vPwEjZ
        pCPIvELEPDz9sg1DcCaeG6XQt5CGnqhAyyfo63xIJdNw
X-Google-Smtp-Source: ABdhPJzHN0zaDSgBcNUb+ezq5KWtwG3UQZkW34QvCwu4LUrwY1NT6tCgXFTO64odUNdVZggjE+6B0LJ9lfCaXMiamFI=
X-Received: by 2002:a81:b65f:0:b0:2d6:d29c:63fd with SMTP id
 h31-20020a81b65f000000b002d6d29c63fdmr23032944ywk.196.1645626246157; Wed, 23
 Feb 2022 06:24:06 -0800 (PST)
MIME-Version: 1.0
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net> <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com> <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com> <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com> <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
 <87ley1j4yl.ffs@tglx>
In-Reply-To: <87ley1j4yl.ffs@tglx>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 23 Feb 2022 15:23:54 +0100
Message-ID: <CAJZ5v0js1tcxsO7Yk9YkJufFA2fnue9oqx=fmweYpqpFKbjbQA@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Doug Smythies <dsmythies@telus.net>,
        "Zhang, Rui" <rui.zhang@intel.com>,
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

On Wed, Feb 23, 2022 at 10:40 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Rafael,
>
> On Tue, Feb 22 2022 at 19:04, Rafael J. Wysocki wrote:
> > On Tue, Feb 22, 2022 at 8:41 AM Feng Tang <feng.tang@intel.com> wrote:
> >> There is periodic activity in between, related to active load balancing
> >> in scheduler (since last frequency was higher these small work will
> >> also run at higher frequency). But those threads are not CFS class, so
> >> scheduler callback will not be called for them.
> >>
> >> So removing the patch removed a trigger which would have caused a
> >> sched_switch to a CFS task and call a cpufreq/intel_pstate callback.
> >
> > And so this behavior needs to be restored for the time being which
> > means reverting the problematic commit for 5.17 if possible.
>
> No. This is just papering over the problem. Just because the clocksource
> watchdog has the side effect of making cpufreq "work", does not make it
> a prerequisite for cpufreq. The commit unearthed a problem in the
> cpufreq code, so it needs to be fixed there.
>
> Even if we'd revert it then, you can produce the same effect by adding
> 'tsc=reliable' to the kernel command line which disables the clocksource
> watchdog too. The commit is there to deal with modern hardware without
> requiring people to add 'tsc=reliable' to the command line.

Allright (but I'll remember this exception).
