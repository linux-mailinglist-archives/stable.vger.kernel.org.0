Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10944244E7E
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 20:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgHNSjJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 Aug 2020 14:39:09 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:65489 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726298AbgHNSjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 14:39:08 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22131229-1500050 
        for multiple; Fri, 14 Aug 2020 19:38:58 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4e8f3929-06d9-9183-f5ed-9cf18abf40dc@intel.com>
References: <20200814155735.29138-1-chris@chris-wilson.co.uk> <20200814155735.29138-2-chris@chris-wilson.co.uk> <4e8f3929-06d9-9183-f5ed-9cf18abf40dc@intel.com>
Subject: Re: [Intel-gfx] [PATCH 2/3] drm/i915/gt: Wait for CSB entries on Tigerlake
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     "Chang, Bruce" <yu.bruce.chang@intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Fri, 14 Aug 2020 19:38:55 +0100
Message-ID: <159743033592.31882.10893400044974332038@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chang, Bruce (2020-08-14 19:07:53)
> On 8/14/2020 8:57 AM, Chris Wilson wrote:
> > On Tigerlake, we are seeing a repeat of commit d8f505311717 ("drm/i915/icl:
> > Forcibly evict stale csb entries") where, presumably, due to a missing
> > Global Observation Point synchronisation, the write pointer of the CSB
> > ringbuffer is updated _prior_ to the contents of the ringbuffer. That is
> > we see the GPU report more context-switch entries for us to parse, but
> > those entries have not been written, leading us to process stale events,
> > and eventually report a hung GPU.
> >
> > However, this effect appears to be much more severe than we previously
> > saw on Icelake (though it might be best if we try the same approach
> > there as well and measure), and Bruce suggested the good idea of resetting
> > the CSB entry after use so that we can detect when it has been updated by
> > the GPU. By instrumenting how long that may be, we can set a reliable
> > upper bound for how long we should wait for:
> >
> >      513 late, avg of 61 retries (590 ns), max of 1061 retries (10099 ns)
> >
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2045
> > References: d8f505311717 ("drm/i915/icl: Forcibly evict stale csb entries")
> > Suggested-by: Bruce Chang <yu.bruce.chang@intel.com>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Bruce Chang <yu.bruce.chang@intel.com>
> > Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> > Cc: stable@vger.kernel.org # v5.4
> > ---
> >   drivers/gpu/drm/i915/gt/intel_lrc.c | 21 ++++++++++++++++++---
> >   1 file changed, 18 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> > index db982fc0f0bc..3b8161c6b601 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> > @@ -2498,9 +2498,22 @@ invalidate_csb_entries(const u64 *first, const u64 *last)
> >    */
> >   static inline bool gen12_csb_parse(const u64 *csb)
> >   {
> > -     u64 entry = READ_ONCE(*csb);
> > -     bool ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
> > -     bool new_queue =
> > +     bool ctx_away_valid;
> > +     bool new_queue;
> > +     u64 entry;
> > +
> > +     /* XXX HSD */
> > +     entry = READ_ONCE(*csb);
> > +     if (unlikely(entry == -1)) {
> > +             preempt_disable();
> > +             if (wait_for_atomic_us((entry = READ_ONCE(*csb)) != -1, 50))
> > +                     GEM_WARN_ON("50us CSB timeout");
> 
> Out tests showed that 10us is not long enough, but 20us worked well. So 
> 50us should be good enough.
> 
> > +             preempt_enable();
> > +     }
> > +     WRITE_ONCE(*(u64 *)csb, -1);
> 
> A wmb() is probably needed here. it should be ok if CSB is in SMEM, but 
> in the case CSB is allocated in LMEM, the memory type will be WC, so the 
> memory write (WRITE_ONCE) is potentially still in the write combine 
> buffer and not in any cache system, i.e., not visible to HW.

There's a trick here. Before the GPU can wrap the CSB ringbuffer, there
must be a register write that itself will flush the WCB. Not only that,
we will have an explicit wmb() prior to that register write. Sneaky.

We probably want to avoid putting the HWSP into WC and fix whatever
cache snooping is required. At least to the point of being able to
measure the impact as we read from HWSP (and "HWSP") frequently.
-Chris
