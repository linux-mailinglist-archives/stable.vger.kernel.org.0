Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6E91F5678
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 16:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgFJOE1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 10 Jun 2020 10:04:27 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60382 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726157AbgFJOE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 10:04:27 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21454376-1500050 
        for multiple; Wed, 10 Jun 2020 15:03:58 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <bf5c088a-731a-7bc4-ff90-492f18e55045@intel.com>
References: <20200609122856.10207-1-chris@chris-wilson.co.uk> <20200609151723.12971-1-chris@chris-wilson.co.uk> <bf5c088a-731a-7bc4-ff90-492f18e55045@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Incrementally check for rewinding
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     "Chang, Bruce" <yu.bruce.chang@intel.com>,
        intel-gfx@lists.freedesktop.org
Message-ID: <159179783861.19008.3331899086436292993@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Wed, 10 Jun 2020 15:03:58 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chang, Bruce (2020-06-10 05:25:39)
> On 6/9/2020 8:17 AM, Chris Wilson wrote:
> > In commit 5ba32c7be81e ("drm/i915/execlists: Always force a context
> > reload when rewinding RING_TAIL"), we placed the check for rewinding a
> > context on actually submitting the next request in that context. This
> > was so that we only had to check once, and could do so with precision
> > avoiding as many forced restores as possible. For example, to ensure
> > that we can resubmit the same request a couple of times, we include a
> > small wa_tail such that on the next submission, the ring->tail will
> > appear to move forwards when resubmitting the same request. This is very
> > common as it will happen for every lite-restore to fill the second port
> > after a context switch.
> >
> > However, intel_ring_direction() is limited in precision to movements of
> > upto half the ring size. The consequence being that if we tried to
> > unwind many requests, we could exceed half the ring and flip the sense
> > of the direction, so missing a force restore. As no request can be
> > greater than half the ring (i.e. 2048 bytes in the smallest case), we
> > can check for rollback incrementally. As we check against the tail that
> > would be submitted, we do not lose any sensitivity and allow lite
> > restores for the simple case. We still need to double check upon
> > submitting the context, to allow for multiple preemptions and
> > resubmissions.
> >
> > Fixes: 5ba32c7be81e ("drm/i915/execlists: Always force a context reload when rewinding RING_TAIL")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> > Cc: <stable@vger.kernel.org> # v5.4+
> 
> Verified this has fixed the issue regarding the GPU hang with incomplete 
> error state.

But it does not entirely... tgl b0 still has the issue of a lite restore
being processed while it is doing an [implicit] semaphore wait at just
the wrong time, dies (or something that looks suspiciously like that).
That can be reproduced without any preemption rollback, so I suspect a
placebo effect.
-Chris
