Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369C94C1555
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 15:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbiBWOYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 09:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbiBWOYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 09:24:00 -0500
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D204B1A86;
        Wed, 23 Feb 2022 06:23:33 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id j2so48511088ybu.0;
        Wed, 23 Feb 2022 06:23:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LGo4i9DT2LrZP1b7gYMoZoQajixztTdw4jKB4oelQQE=;
        b=VYojbCg4g3Qi8D5F/2indgDtWzoTC7NkJLsfdv0MkMXB5vFXje499UMLu3oczszqE0
         x8g0iqIRDikdkaewSc9FKeB60VmW8KeQLGIDFNAANSw+sx2QOCmXfe6ujEu9dKGEg3Qv
         1pwgDJ/jiH2LGMrvAHjNuDVBeL/RXyLyimQyDQkFCNxvfs+lMLTh1xT43Hc6Y8JZfjlI
         LL6eOrv/pBo2pb6/DtpHBD0KYQQGo73IbwaGG8azYQxy9nVxPi9GSeDQI7DDyYnzGwTv
         /37ucFh5yq3LGkREoiIQcYgHQvI1yT5jIksBVzlibMJgPAXmHXMafTlyfFJqHAfxLnXx
         ggIw==
X-Gm-Message-State: AOAM532M5JKO7X/c6pczshxJ9owPATsVOzd3I5SjYp3PBnq1HHjesxqV
        6CKOjB4SSkUE5IJUbHfDL1u7G2LzxrvSkZcesMI=
X-Google-Smtp-Source: ABdhPJw8GyZfbmnI3rKy5QTUMimE7f38mlsxBlDK81oPix0CxzF8Doya0m9/DI2Yc+PUM7IltLUYmzP64DgqYDsV4Hs=
X-Received: by 2002:a25:d90d:0:b0:615:e400:94c1 with SMTP id
 q13-20020a25d90d000000b00615e40094c1mr27995844ybg.81.1645626212451; Wed, 23
 Feb 2022 06:23:32 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com> <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com> <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com> <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
 <CAAYoRsX-iw+88R9ZizMwJw2qc99XJZ8Fe0M5ETOy4=RUNsxWhQ@mail.gmail.com>
 <24f7d485dc60ba3ed5938230f477bf22a220d596.camel@linux.intel.com> <20220223004041.GA4548@shbuild999.sh.intel.com>
In-Reply-To: <20220223004041.GA4548@shbuild999.sh.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 23 Feb 2022 15:23:20 +0100
Message-ID: <CAJZ5v0jsy0q3-ZqYvDrswY1F+tJsG6oNjNJPzz9zzkgdnoMwkw@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Feng Tang <feng.tang@intel.com>
Cc:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
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

On Wed, Feb 23, 2022 at 1:40 AM Feng Tang <feng.tang@intel.com> wrote:
>
> On Tue, Feb 22, 2022 at 04:32:29PM -0800, srinivas pandruvada wrote:
> > Hi Doug,
> >
> > On Tue, 2022-02-22 at 16:07 -0800, Doug Smythies wrote:
> > > Hi All,
> > >
> > > I am about 1/2 way through testing Feng's "hacky debug patch",
> > > let me know if I am wasting my time, and I'll abort. So far, it
> > > works fine.
> > This just proves that if you add some callback during long idle,  you
> > will reach a less aggressive p-state. I think you already proved that
> > with your results below showing 1W less average power ("Kernel 5.17-rc3
> > + Feng patch (6 samples at 300 sec per").
> >
> > Rafael replied with one possible option. Alternatively when planing to
> > enter deep idle, set P-state to min with a callback like we do in
> > offline callback.
>
> Yes, if the system is going to idle, it makes sense to goto a lower
> cpufreq first (also what my debug patch will essentially lead to).
>
> Given cprfreq-util's normal running frequency is every 10ms, doing
> this before entering idle is not a big extra burden.

But this is not related to idle as such, but to the fact that idle
sometimes stops the scheduler tick which otherwise would run the
cpufreq governor callback on a regular basis.

It is stopping the tick that gets us into trouble, so I would avoid
doing it if the current performance state is too aggressive.

In principle, PM QoS can be used for that from intel_pstate, but there
is a problem with that approach, because it is not obvious what value
to give to it and it is not always guaranteed to work (say when all of
the C-states except for C1 are disabled).

So it looks like a new mechanism is needed for that.
