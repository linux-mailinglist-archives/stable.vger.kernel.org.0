Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE665245425
	for <lists+stable@lfdr.de>; Sun, 16 Aug 2020 00:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgHOWMu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 15 Aug 2020 18:12:50 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:61176 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730105AbgHOWMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 18:12:44 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22135408-1500050 
        for multiple; Sat, 15 Aug 2020 10:53:10 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <66272f87-c6c1-2b45-87f4-cf54303ab44b@intel.com>
References: <20200814155735.29138-1-chris@chris-wilson.co.uk> <20200814155735.29138-2-chris@chris-wilson.co.uk> <4e8f3929-06d9-9183-f5ed-9cf18abf40dc@intel.com> <159743033592.31882.10893400044974332038@build.alporthouse.com> <66272f87-c6c1-2b45-87f4-cf54303ab44b@intel.com>
Subject: Re: [Intel-gfx] [PATCH 2/3] drm/i915/gt: Wait for CSB entries on Tigerlake
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     "Chang, Bruce" <yu.bruce.chang@intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Sat, 15 Aug 2020 10:53:09 +0100
Message-ID: <159748518914.31882.11207732178974792782@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chang, Bruce (2020-08-15 01:36:10)
> 
> >>> @@ -2498,9 +2498,22 @@ invalidate_csb_entries(const u64 *first, const u64 *last)
> >>>     */
> >>>    static inline bool gen12_csb_parse(const u64 *csb)
> >>>    {
> >>> -     u64 entry = READ_ONCE(*csb);
> >>> -     bool ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
> >>> -     bool new_queue =
> >>> +     bool ctx_away_valid;
> >>> +     bool new_queue;
> >>> +     u64 entry;
> >>> +
> >>> +     /* XXX HSD */
> >>> +     entry = READ_ONCE(*csb);
> >>> +     if (unlikely(entry == -1)) {
> >>> +             preempt_disable();
> >>> +             if (wait_for_atomic_us((entry = READ_ONCE(*csb)) != -1, 50))
> >>> +                     GEM_WARN_ON("50us CSB timeout");
> >> Out tests showed that 10us is not long enough, but 20us worked well. So
> >> 50us should be good enough.
> 
> Just realized this may not fully work, as one of the common issue we run 
> into is that higher 32bit is updated from the HW, but lower 32bit update 
> at a later time: meaning the csb will read like 0xFFFFFFFF:xxxxxxxx 
> (low:high) . So this check (!= -1) can still pass but with a partial 
> invalid csb status. So, we may need to check each 32bit separately.

Hence the transformation to use u64 as the entry type :)
-Chris
