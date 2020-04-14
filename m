Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D879F1A8E97
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 00:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391977AbgDNW22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 18:28:28 -0400
Received: from mx1.riseup.net ([198.252.153.129]:36766 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391879AbgDNW21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 18:28:27 -0400
Received: from bell.riseup.net (unknown [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4920WG0yVhzFfs9;
        Tue, 14 Apr 2020 15:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1586903306; bh=QFz5HFs9FircilZnI1DxbpSNA57dFUy6JMqFiZSVp/U=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=q65NXim5CXhws0QHEoFMwsnyJukXIam+qF4VnWqrCBnvouyYoOp8+Hwba8GSjCZRe
         UJUFSz1nBc6vr/QT//Y99Muha2b9neGgig0uIIMDdOJIStM9vXIrNNYv5EWbMd+UNR
         5BDIV8ZOQ1h+GHDfufUOV1rkf+r/e+5sBR7i000k=
X-Riseup-User-ID: 7755368B2B0CBFA6AEEE1E39A0A175F0169DCB03C6F12D041543CB11025736E7
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4920WF6PBvzJncc;
        Tue, 14 Apr 2020 15:28:25 -0700 (PDT)
From:   Francisco Jerez <currojerez@riseup.net>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        "Wilson\, Chris P" <chris.p.wilson@intel.com>
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915/gt: Shrink the RPS evalution intervals
In-Reply-To: <158690112767.24667.10470136433913366578@build.alporthouse.com>
References: <20200414161423.23830-1-chris@chris-wilson.co.uk> <20200414161423.23830-2-chris@chris-wilson.co.uk> <158688212611.24667.7132327074792389398@build.alporthouse.com> <87pnc9zwjf.fsf@riseup.net> <158689519187.24667.5193852715594735657@build.alporthouse.com> <87lfmxzst2.fsf@riseup.net> <158690112767.24667.10470136433913366578@build.alporthouse.com>
Date:   Tue, 14 Apr 2020 15:28:34 -0700
Message-ID: <87eespzoq5.fsf@riseup.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="==-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Chris Wilson <chris@chris-wilson.co.uk> writes:

> Quoting Francisco Jerez (2020-04-14 22:00:25)
>> Chris Wilson <chris@chris-wilson.co.uk> writes:
>>=20
>> > Quoting Francisco Jerez (2020-04-14 20:39:48)
>> >> Chris Wilson <chris@chris-wilson.co.uk> writes:
>> >>=20
>> >> > Quoting Chris Wilson (2020-04-14 17:14:23)
>> >> >> Try to make RPS dramatically more responsive by shrinking the eval=
uation
>> >> >> intervales by a factor of 100! The issue is as we now park the GPU
>> >> >> rapidly upon idling, a short or bursty workload such as the compos=
ited
>> >> >> desktop never sustains enough work to fill and complete an evaluat=
ion
>> >> >> window. As such, the frequency we program remains stuck. This was =
first
>> >> >> reported as once boosted, we never relinquished the boost [see com=
mit
>> >> >> 21abf0bf168d ("drm/i915/gt: Treat idling as a RPS downclock event"=
)] but
>> >> >> it equally applies in the order direction for bursty workloads that
>> >> >> *need* low latency, like desktop animations.
>> >> >>=20
>> >> >> What we could try is preserve the incomplete EI history across idl=
ing,
>> >> >> it is not clear whether that would be effective, nor whether the
>> >> >> presumption of continuous workloads is accurate. A clearer path se=
ems to
>> >> >> treat it as symptomatic that we fail to handle bursty workload wit=
h the
>> >> >> current EI, and seek to address that by shrinking the EI so the
>> >> >> evaluations are run much more often.
>> >> >>=20
>> >> >> This will likely entail more frequent interrupts, and by the time =
we
>> >> >> process the interrupt in the bottom half [from inside a worker], t=
he
>> >> >> workload on the GPU has changed. To address the changeable nature,=
 in
>> >> >> the previous patch we compared the previous complete EI with the
>> >> >> interrupt request and only up/down clock if both agree. The impact=
 of
>> >> >> asking for, and presumably, receiving more interrupts is still to =
be
>> >> >> determined and mitigations sought. The first idea is to differenti=
ate
>> >> >> between up/down responsivity and make upclocking more responsive t=
han
>> >> >> downlocking. This should both help thwart jitter on bursty workloa=
ds by
>> >> >> making it easier to increase than it is to decrease frequencies, a=
nd
>> >> >> reduce the number of interrupts we would need to process.
>> >> >
>> >> > Another worry I'd like to raise, is that by reducing the EI we risk
>> >> > unstable evaluations. I'm not sure how accurate the HW is, and I wo=
rry
>> >> > about borderline workloads (if that is possible) but mainly the wor=
ry is
>> >> > how the HW is sampling.
>> >> >
>> >> > The other unmentioned unknown is the latency in reprogramming the
>> >> > frequency. At what point does it start to become a significant fact=
or?
>> >> > I'm presuming the RPS evaluation itself is free, until it has to ta=
lk
>> >> > across the chip to send an interrupt.
>> >> > -Chris
>> >>=20
>> >> At least on ICL the problem which this patch and 21abf0bf168d were
>> >> working around seems to have to do with RPS interrupt delivery being
>> >> inadvertently blocked for extended periods of time.  Looking at the G=
PU
>> >> utilization and RPS events on a graph I could see the GPU being stuck=
 at
>> >> low frequency without any RPS interrupts firing, for a time interval
>> >> orders of magnitude greater than the EI we're theoretically programmi=
ng
>> >> today.  IOW it seems like the real problem isn't that our EIs are too
>> >> long, but that we're missing a bunch of them.
>> >>=20
>> >> The solution I was suggesting for this on IRC during the last couple =
of
>> >> days wouldn't have any of the drawbacks you mention above, I'll send =
it
>> >> to this list in a moment if the general approach seems okay to you:
>> >>=20
>> >> https://github.com/curro/linux/commit/f7bc31402aa727a52d957e62d985c6d=
ae6be4b86
>> >
>> > We were explicitly told to mask the interrupt generation at source
>> > to conserve power. So I would hope for a statement as to whether that =
is
>> > still a requirement from the HW architects; but I can't see why we wou=
ld
>> > not apply the mask and that this is just paper. If the observation abo=
ut
>> > forcewake tallies, would this not suggest that it is still conserving
>> > power on icl?
>> >
>>=20
>> Yeah, it's hard to see how disabling interrupt generation could save any
>> additional power in a unit which is powered off -- At least on ICL where
>> even the interrupt masking register is powered off...
>>=20
>> > I haven't looked at whether I see the same phenomenon as you [missing
>> > interrupts on icl] locally, but I was expecting something like the bug
>> > report since the observation that render times are less than EI was
>> > causing the clocks to stay high. And I noticed your problem statement
>> > and was hopeful for a link.
>> >
>>=20
>> Right.  In the workloads I was looking at last week the GPU would often
>> be active for periods of time several times greater than the EI, and we
>> would still fail to clock up.
>>=20
>> > They sound like two different problems. (Underclocking for animations =
is
>> > not icl specific.)
>> >
>>=20
>> Sure.  But it seems like the underclocking problem has been greatly
>> exacerbated by 21abf0bf168d, which may have been mitigating the same ICL
>> problem I was looking at leading to RPS interrupt loss.  Maybe
>> 21abf0bf168d wouldn't be necessary with working RPS interrupt delivery?
>> And without 21abf0bf168d platforms earlier than ICL wouldn't have as
>> much of an underclocking problem either.
>
> 21abf0bf168d ("drm/i915/gt: Treat idling as a RPS downclock event")
>
> is necessary due to that we can set a boost frequency and then never run
> the RPS worker due to short activity cycles. See
> igt/i915_pm_rc6_residency for rc6-idle, the bg_load is essentially just
>
> for (;;) {
> 	execbuf(&nop);
> 	sleep(.1);
> }
>
> Without 21abf0bf168d if you trigger a waitboost just before, it never
> recovers and power utilisation is measurably higher.
>

I can believe that, but can you confirm that the problem isn't a symptom
of the PMINTRMSK issue I was talking about earlier?  Assuming it isn't,
couldn't you do something like 21abf0bf168d which simply stores a
timestamp at GPU parking time and delays the actual frequency ramp-down
to GPU unpark, at which point it's performed *only* if the time spent
idle goes over a down-clock threshold based on the current "power" mode
(e.g. something like the value of GEN6_RP_DOWN_EI minus
GEN6_RP_DOWN_THRESHOLD) -- So the behavior of frequency rampdown due to
parking more closely matches what the RPS would have done if it had been
active.

>> >> That said it *might* be helpful to reduce the EIs we use right now in
>> >> addition, but a factor of 100 seems over the top since that will cause
>> >> the evaluation interval to be roughly two orders of magnitude shorter
>> >> than the rendering time of a typical frame, which can lead to massive
>> >> oscillations even in workloads that use a small fraction of the GPU t=
ime
>> >> to render a single frame.  Maybe we want something in between?
>> >
>> > Probably; as you can guess these were pulled out of nowhere based on t=
he
>> > observation that the frame lengths are much shorter than the current EI
>> > and that in order for us to ramp up to maxclocks in a single frame of
>> > animation would take about 4 samples per frame. Based on the reporter's
>> > observations, we do have to ramp up very quickly for single frame of
>> > rendering in order to hit the vblank, as we are ramping down afterward=
s.
>> >
>> > With a target of 4 samples within say 1ms, 160us isn't too far of the
>> > mark. (We have to allow some extra time to catch up rendering.)
>>=20
>>=20
>> How about we stop ramping down after the rendering of a single frame?
>> It's not like we save any power by doing that, since the GPU seems to be
>> forced to the minimum frequency for as long as it remains parked anyway.
>> If the GPU remains idle long enough for the RPS utilization counters to
>> drop below the threshold and qualify for a ramp-down the RPS should send
>> us an interrupt, at which point we will ramp down the frequency.
>
> Because it demonstrably and quite dramatically reduces power consumption
> for very light desktop workloads.
>
>> Unconditionally ramping down on parking seems to disturb the accuracy of
>> that RPS feedback loop, which then needs to be worked around by reducing
>> the averaging window of the RPS to a tiny fraction of the oscillation
>> period of any typical GPU workload, which is going to prevent the RPS
>> from seeing a whole oscillation period before it reacts, which is almost
>> guaranteed to have a serious energy-efficiency cost.
>
> There is no feedback loop in these workloads. There are no completed RPS
> workers, they are all cancelled if they were even scheduled. (Now we
> might be tempted to look at the results if they scheduled and take that
> into consideration instead of unconditionally downclocking.)
>

Processing any pending RPS work seems better IMHO than unconditionally
assuming they indicate a clock-down.

>> > As for steady state workloads, I'm optimistic the smoothing helps. (It=
's
>> > harder to find steady state, unthrottled workloads!)
>>=20
>> I'm curious, how is that smoothing you do in PATCH 1 better than simply
>> setting 2x the EIs? (Which would also mean half the interrupt processing
>> overhead as in this series)
>
> I'm anticipating where the RPS worker may not run until the next jiffie
> or two, by which point the iir is stale. But yes, there's only a subtle
> difference between comparing the last 320us every 160us and comparing
> the last 320us every 320us.

Sounds like the benefit from smoothing is very slight, considering its
accuracy and interrupt processing overhead costs.

> -Chris

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREIAB0WIQST8OekYz69PM20/4aDmTidfVK/WwUCXpY5EgAKCRCDmTidfVK/
W9rtAQCf+YY6DVhrNnByU4fIwHpR7PaIdmiVuIHwQ9x7lw42wgD/XNAaOOd2zICW
3OPQ9mcAeRvgZVUp7u1yJjcqA0rFJYo=
=aEqb
-----END PGP SIGNATURE-----
--==-=-=--
