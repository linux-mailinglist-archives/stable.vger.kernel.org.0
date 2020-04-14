Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B3F1A8E91
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 00:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391949AbgDNW1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 18:27:44 -0400
Received: from mx1.riseup.net ([198.252.153.129]:36442 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391947AbgDNW1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 18:27:30 -0400
Received: from bell.riseup.net (unknown [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4920V80tk5zFdhL;
        Tue, 14 Apr 2020 15:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1586903248; bh=ImSiTQYnJ08okrh1dR7QHJfBndEXY9ZPRKD4qtJyOM0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Shi99aQaGmeBTaaUl7uhOM8VhPwRrWPWziEmBc6E5/mLU3Yti6S85RmMIl3TjorLU
         aQu5pEhQ6ioVFzeUiTewPGvPG7nS/ALLnS7RGWdQT9HpAFXeKX6RNDhhQnbgAUn5F9
         bU2dqytB0rAWMeJbxNYiLP7H3A8/fQAZ9htQXqcM=
X-Riseup-User-ID: 08AF7C783DF52D3F3053F4D331955192FE1ADB25C3901236AE9AFD09BDCA1B55
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4920V74MkRzJncg;
        Tue, 14 Apr 2020 15:27:27 -0700 (PDT)
From:   Francisco Jerez <currojerez@riseup.net>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915/gt: Shrink the RPS evalution intervals
In-Reply-To: <158690010150.24667.4991755951851899304@build.alporthouse.com>
References: <20200414161423.23830-1-chris@chris-wilson.co.uk> <20200414161423.23830-2-chris@chris-wilson.co.uk> <158688212611.24667.7132327074792389398@build.alporthouse.com> <87pnc9zwjf.fsf@riseup.net> <158690010150.24667.4991755951851899304@build.alporthouse.com>
Date:   Tue, 14 Apr 2020 15:27:33 -0700
Message-ID: <87ftd5zoru.fsf@riseup.net>
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

> Quoting Francisco Jerez (2020-04-14 20:39:48)
>> Chris Wilson <chris@chris-wilson.co.uk> writes:
>>=20
>> > Quoting Chris Wilson (2020-04-14 17:14:23)
>> >> Try to make RPS dramatically more responsive by shrinking the evaluat=
ion
>> >> intervales by a factor of 100! The issue is as we now park the GPU
>> >> rapidly upon idling, a short or bursty workload such as the composited
>> >> desktop never sustains enough work to fill and complete an evaluation
>> >> window. As such, the frequency we program remains stuck. This was fir=
st
>> >> reported as once boosted, we never relinquished the boost [see commit
>> >> 21abf0bf168d ("drm/i915/gt: Treat idling as a RPS downclock event")] =
but
>> >> it equally applies in the order direction for bursty workloads that
>> >> *need* low latency, like desktop animations.
>> >>=20
>> >> What we could try is preserve the incomplete EI history across idling,
>> >> it is not clear whether that would be effective, nor whether the
>> >> presumption of continuous workloads is accurate. A clearer path seems=
 to
>> >> treat it as symptomatic that we fail to handle bursty workload with t=
he
>> >> current EI, and seek to address that by shrinking the EI so the
>> >> evaluations are run much more often.
>> >>=20
>> >> This will likely entail more frequent interrupts, and by the time we
>> >> process the interrupt in the bottom half [from inside a worker], the
>> >> workload on the GPU has changed. To address the changeable nature, in
>> >> the previous patch we compared the previous complete EI with the
>> >> interrupt request and only up/down clock if both agree. The impact of
>> >> asking for, and presumably, receiving more interrupts is still to be
>> >> determined and mitigations sought. The first idea is to differentiate
>> >> between up/down responsivity and make upclocking more responsive than
>> >> downlocking. This should both help thwart jitter on bursty workloads =
by
>> >> making it easier to increase than it is to decrease frequencies, and
>> >> reduce the number of interrupts we would need to process.
>> >
>> > Another worry I'd like to raise, is that by reducing the EI we risk
>> > unstable evaluations. I'm not sure how accurate the HW is, and I worry
>> > about borderline workloads (if that is possible) but mainly the worry =
is
>> > how the HW is sampling.
>> >
>> > The other unmentioned unknown is the latency in reprogramming the
>> > frequency. At what point does it start to become a significant factor?
>> > I'm presuming the RPS evaluation itself is free, until it has to talk
>> > across the chip to send an interrupt.
>> > -Chris
>>=20
>> At least on ICL the problem which this patch and 21abf0bf168d were
>> working around seems to have to do with RPS interrupt delivery being
>> inadvertently blocked for extended periods of time.  Looking at the GPU
>> utilization and RPS events on a graph I could see the GPU being stuck at
>> low frequency without any RPS interrupts firing, for a time interval
>> orders of magnitude greater than the EI we're theoretically programming
>> today.  IOW it seems like the real problem isn't that our EIs are too
>> long, but that we're missing a bunch of them.
>
> Just stuck a pr_err() into gen11_handle_rps_events(), and momentarily
> before we were throttled (and so capped at 100% load), interrupts were
> being delivered:
>
> [  887.521727] gen11_rps_irq_handler: { iir:20, events:20 }
> [  887.538039] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.538253] gen11_rps_irq_handler: { iir:20, events:20 }
> [  887.538555] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.554731] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.554857] gen11_rps_irq_handler: { iir:20, events:20 }
> [  887.555604] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.571373] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.571496] gen11_rps_irq_handler: { iir:20, events:20 }
> [  887.571646] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.588199] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.588380] gen11_rps_irq_handler: { iir:20, events:20 }
> [  887.588692] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.604718] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.604937] gen11_rps_irq_handler: { iir:20, events:20 }
> [  887.621591] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.621755] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.637988] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.638166] gen11_rps_irq_handler: { iir:20, events:20 }
> [  887.638803] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.654812] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.655029] gen11_rps_irq_handler: { iir:20, events:20 }
> [  887.671423] gen11_rps_irq_handler: { iir:10, events:10 }
> [  887.671649] gen11_rps_irq_handler: { iir:20, events:20 }
>
> That looks within expectations for the short EI settings. So many
> interrupts is a drag, and I would be tempted to remove the process bottom
> half.
>
> Oh well, I should check how many of those are translated into frequency
> updates. I just wanted to first check if in the first try I stumbled
> into the same loss of interrupts issue.

The interrupt loss seems to be non-deterministic, it's not like we lose
100% of them, since there is always a chance that the GPU is awake
during the PMINTRMSK write.  It's easily noticeable anyway with most
GPU-bound workloads on ICL, particularly with the current long EIs.

> -Chris

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREIAB0WIQST8OekYz69PM20/4aDmTidfVK/WwUCXpY41QAKCRCDmTidfVK/
WyqQAP0d5MKOAsb/6gbnQynJpLg+MyVVMiy8ayGZkFmXamaPlQD9GqrIt5kkdNKK
mUMj0ZTTBO0DlDnaSdUAB7Q7Nr3iDkk=
=22LL
-----END PGP SIGNATURE-----
--==-=-=--
