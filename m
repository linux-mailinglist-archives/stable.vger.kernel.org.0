Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884241A8522
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391769AbgDNQfg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 14 Apr 2020 12:35:36 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60155 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391796AbgDNQfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 12:35:34 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20898028-1500050 
        for multiple; Tue, 14 Apr 2020 17:35:27 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200414161423.23830-2-chris@chris-wilson.co.uk>
References: <20200414161423.23830-1-chris@chris-wilson.co.uk> <20200414161423.23830-2-chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        Lyude Paul <lyude@redhat.com>,
        Francisco Jerez <currojerez@riseup.net>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915/gt: Shrink the RPS evalution intervals
From:   Chris Wilson <chris@chris-wilson.co.uk>
Message-ID: <158688212611.24667.7132327074792389398@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 14 Apr 2020 17:35:26 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-04-14 17:14:23)
> Try to make RPS dramatically more responsive by shrinking the evaluation
> intervales by a factor of 100! The issue is as we now park the GPU
> rapidly upon idling, a short or bursty workload such as the composited
> desktop never sustains enough work to fill and complete an evaluation
> window. As such, the frequency we program remains stuck. This was first
> reported as once boosted, we never relinquished the boost [see commit
> 21abf0bf168d ("drm/i915/gt: Treat idling as a RPS downclock event")] but
> it equally applies in the order direction for bursty workloads that
> *need* low latency, like desktop animations.
> 
> What we could try is preserve the incomplete EI history across idling,
> it is not clear whether that would be effective, nor whether the
> presumption of continuous workloads is accurate. A clearer path seems to
> treat it as symptomatic that we fail to handle bursty workload with the
> current EI, and seek to address that by shrinking the EI so the
> evaluations are run much more often.
> 
> This will likely entail more frequent interrupts, and by the time we
> process the interrupt in the bottom half [from inside a worker], the
> workload on the GPU has changed. To address the changeable nature, in
> the previous patch we compared the previous complete EI with the
> interrupt request and only up/down clock if both agree. The impact of
> asking for, and presumably, receiving more interrupts is still to be
> determined and mitigations sought. The first idea is to differentiate
> between up/down responsivity and make upclocking more responsive than
> downlocking. This should both help thwart jitter on bursty workloads by
> making it easier to increase than it is to decrease frequencies, and
> reduce the number of interrupts we would need to process.

Another worry I'd like to raise, is that by reducing the EI we risk
unstable evaluations. I'm not sure how accurate the HW is, and I worry
about borderline workloads (if that is possible) but mainly the worry is
how the HW is sampling.

The other unmentioned unknown is the latency in reprogramming the
frequency. At what point does it start to become a significant factor?
I'm presuming the RPS evaluation itself is free, until it has to talk
across the chip to send an interrupt.
-Chris
