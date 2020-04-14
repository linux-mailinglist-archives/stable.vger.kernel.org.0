Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4371E1A8B37
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 21:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505051AbgDNTkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 15:40:42 -0400
Received: from mx1.riseup.net ([198.252.153.129]:34092 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505025AbgDNTjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 15:39:46 -0400
Received: from capuchin.riseup.net (unknown [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 491wmZ5fW5zFfrn;
        Tue, 14 Apr 2020 12:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1586893182; bh=L/2CdWmt5gF4mKn7Vs3u2+aPwTt2oAo+hqt6cYczmIw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JAhaza8FYtDCA2Z/8IB/MS2kIWN8Wf1VMYVpnD5m2yEBa3tSbf0qVX+FRBpIyrELh
         r1+UEhtOnmpPdI7qun8N3nJMWShItbm5y5VG6LARLymyIux1oodGUOFaJQnaqUrPWv
         EQ1O5ERG/Zru+H7AOp+yeQ9eVZCp8ZlIu0s5uMik=
X-Riseup-User-ID: 958E0A922B1A24D785162A56EE6F17BF502905CDD379AA46ED3B19F813A79FCC
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 491wmZ18MDz8tJ1;
        Tue, 14 Apr 2020 12:39:42 -0700 (PDT)
From:   Francisco Jerez <currojerez@riseup.net>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        Lyude Paul <lyude@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915/gt: Shrink the RPS evalution intervals
In-Reply-To: <158688212611.24667.7132327074792389398@build.alporthouse.com>
References: <20200414161423.23830-1-chris@chris-wilson.co.uk> <20200414161423.23830-2-chris@chris-wilson.co.uk> <158688212611.24667.7132327074792389398@build.alporthouse.com>
Date:   Tue, 14 Apr 2020 12:39:48 -0700
Message-ID: <87pnc9zwjf.fsf@riseup.net>
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

> Quoting Chris Wilson (2020-04-14 17:14:23)
>> Try to make RPS dramatically more responsive by shrinking the evaluation
>> intervales by a factor of 100! The issue is as we now park the GPU
>> rapidly upon idling, a short or bursty workload such as the composited
>> desktop never sustains enough work to fill and complete an evaluation
>> window. As such, the frequency we program remains stuck. This was first
>> reported as once boosted, we never relinquished the boost [see commit
>> 21abf0bf168d ("drm/i915/gt: Treat idling as a RPS downclock event")] but
>> it equally applies in the order direction for bursty workloads that
>> *need* low latency, like desktop animations.
>>=20
>> What we could try is preserve the incomplete EI history across idling,
>> it is not clear whether that would be effective, nor whether the
>> presumption of continuous workloads is accurate. A clearer path seems to
>> treat it as symptomatic that we fail to handle bursty workload with the
>> current EI, and seek to address that by shrinking the EI so the
>> evaluations are run much more often.
>>=20
>> This will likely entail more frequent interrupts, and by the time we
>> process the interrupt in the bottom half [from inside a worker], the
>> workload on the GPU has changed. To address the changeable nature, in
>> the previous patch we compared the previous complete EI with the
>> interrupt request and only up/down clock if both agree. The impact of
>> asking for, and presumably, receiving more interrupts is still to be
>> determined and mitigations sought. The first idea is to differentiate
>> between up/down responsivity and make upclocking more responsive than
>> downlocking. This should both help thwart jitter on bursty workloads by
>> making it easier to increase than it is to decrease frequencies, and
>> reduce the number of interrupts we would need to process.
>
> Another worry I'd like to raise, is that by reducing the EI we risk
> unstable evaluations. I'm not sure how accurate the HW is, and I worry
> about borderline workloads (if that is possible) but mainly the worry is
> how the HW is sampling.
>
> The other unmentioned unknown is the latency in reprogramming the
> frequency. At what point does it start to become a significant factor?
> I'm presuming the RPS evaluation itself is free, until it has to talk
> across the chip to send an interrupt.
> -Chris

At least on ICL the problem which this patch and 21abf0bf168d were
working around seems to have to do with RPS interrupt delivery being
inadvertently blocked for extended periods of time.  Looking at the GPU
utilization and RPS events on a graph I could see the GPU being stuck at
low frequency without any RPS interrupts firing, for a time interval
orders of magnitude greater than the EI we're theoretically programming
today.  IOW it seems like the real problem isn't that our EIs are too
long, but that we're missing a bunch of them.

The solution I was suggesting for this on IRC during the last couple of
days wouldn't have any of the drawbacks you mention above, I'll send it
to this list in a moment if the general approach seems okay to you:

https://github.com/curro/linux/commit/f7bc31402aa727a52d957e62d985c6dae6be4=
b86

That said it *might* be helpful to reduce the EIs we use right now in
addition, but a factor of 100 seems over the top since that will cause
the evaluation interval to be roughly two orders of magnitude shorter
than the rendering time of a typical frame, which can lead to massive
oscillations even in workloads that use a small fraction of the GPU time
to render a single frame.  Maybe we want something in between?

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREIAB0WIQST8OekYz69PM20/4aDmTidfVK/WwUCXpYRhAAKCRCDmTidfVK/
W5EKAP9+iKcFKDM4oZVco6h6GaeSBgveqxYpq+WpPlQqslW20AD/RTB08QKoYV9n
xkggg0JmtQunTBH1Kqi4HeeAg2FXzMI=
=g9Ng
-----END PGP SIGNATURE-----
--==-=-=--
