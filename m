Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62591AA278
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbgDOMzm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 Apr 2020 08:55:42 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:57160 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2897193AbgDOLhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:37:02 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20905638-1500050 
        for multiple; Wed, 15 Apr 2020 12:36:58 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <158693622761.6982.16961571297064928576@build.alporthouse.com>
References: <20200414161423.23830-1-chris@chris-wilson.co.uk> <20200414161423.23830-2-chris@chris-wilson.co.uk> <158688212611.24667.7132327074792389398@build.alporthouse.com> <87pnc9zwjf.fsf@riseup.net> <158693622761.6982.16961571297064928576@build.alporthouse.com>
To:     Francisco Jerez <currojerez@riseup.net>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915/gt: Shrink the RPS evalution intervals
From:   Chris Wilson <chris@chris-wilson.co.uk>
Message-ID: <158695061645.24667.18024114483475762648@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Wed, 15 Apr 2020 12:36:56 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-04-15 08:37:07)
> Quoting Francisco Jerez (2020-04-14 20:39:48)
> > Chris Wilson <chris@chris-wilson.co.uk> writes:
> > 
> > > Quoting Chris Wilson (2020-04-14 17:14:23)
> > >> Try to make RPS dramatically more responsive by shrinking the evaluation
> > >> intervales by a factor of 100! The issue is as we now park the GPU
> > >> rapidly upon idling, a short or bursty workload such as the composited
> > >> desktop never sustains enough work to fill and complete an evaluation
> > >> window. As such, the frequency we program remains stuck. This was first
> > >> reported as once boosted, we never relinquished the boost [see commit
> > >> 21abf0bf168d ("drm/i915/gt: Treat idling as a RPS downclock event")] but
> > >> it equally applies in the order direction for bursty workloads that
> > >> *need* low latency, like desktop animations.
> > >> 
> > >> What we could try is preserve the incomplete EI history across idling,
> > >> it is not clear whether that would be effective, nor whether the
> > >> presumption of continuous workloads is accurate. A clearer path seems to
> > >> treat it as symptomatic that we fail to handle bursty workload with the
> > >> current EI, and seek to address that by shrinking the EI so the
> > >> evaluations are run much more often.
> > >> 
> > >> This will likely entail more frequent interrupts, and by the time we
> > >> process the interrupt in the bottom half [from inside a worker], the
> > >> workload on the GPU has changed. To address the changeable nature, in
> > >> the previous patch we compared the previous complete EI with the
> > >> interrupt request and only up/down clock if both agree. The impact of
> > >> asking for, and presumably, receiving more interrupts is still to be
> > >> determined and mitigations sought. The first idea is to differentiate
> > >> between up/down responsivity and make upclocking more responsive than
> > >> downlocking. This should both help thwart jitter on bursty workloads by
> > >> making it easier to increase than it is to decrease frequencies, and
> > >> reduce the number of interrupts we would need to process.
> > >
> > > Another worry I'd like to raise, is that by reducing the EI we risk
> > > unstable evaluations. I'm not sure how accurate the HW is, and I worry
> > > about borderline workloads (if that is possible) but mainly the worry is
> > > how the HW is sampling.
> > >
> > > The other unmentioned unknown is the latency in reprogramming the
> > > frequency. At what point does it start to become a significant factor?
> > > I'm presuming the RPS evaluation itself is free, until it has to talk
> > > across the chip to send an interrupt.
> > > -Chris
> > 
> > At least on ICL the problem which this patch and 21abf0bf168d were
> > working around seems to have to do with RPS interrupt delivery being
> > inadvertently blocked for extended periods of time.  Looking at the GPU
> > utilization and RPS events on a graph I could see the GPU being stuck at
> > low frequency without any RPS interrupts firing, for a time interval
> > orders of magnitude greater than the EI we're theoretically programming
> > today.  IOW it seems like the real problem isn't that our EIs are too
> > long, but that we're missing a bunch of them.
> > 
> > The solution I was suggesting for this on IRC during the last couple of
> > days wouldn't have any of the drawbacks you mention above, I'll send it
> > to this list in a moment if the general approach seems okay to you:
> > 
> > https://github.com/curro/linux/commit/f7bc31402aa727a52d957e62d985c6dae6be4b86
> 
> Confirmed that the PMINTRMSK is sufficiently delayed to cause problems.

[   68.462428] rcs0: UP interrupt not recorded for spinner, pm_iir:0, prev_up:2ee0, up_threshold:2c88, up_ei:2ee0
Have selftest \o/
FW fixes selftest.
-Chris
