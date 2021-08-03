Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E294A3DF251
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhHCQSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 12:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbhHCQSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 12:18:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF30C06175F;
        Tue,  3 Aug 2021 09:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=o5WIJXw4OhovZW77GVtEGa75EtcToMDnfWsVm0wBfcM=; b=IIHCz30SYSL7wEDdanuLgMvjob
        kBgtum0VVNYUcGvZGHRoc+Dt7Q1vXffBD5brcK82hmhUZzGXVc8qEUhxaeJ3cLV6Ucc7PqzP5Zcv3
        qtB1zsAg/fS9eLYUdvV1EscXSUIzHu6HgPDY7MrekKzAXZ2JBE6Q21IOnmGQT30rjNgoQrJwMkasZ
        jmWSNhkv2BZmNDHT2EabIhys0K0OoHifS10a19JYPm40dmaAk/Trci1JQnTPAcVND4PhoESesxRqT
        MaXAA2zU22j4LcMRTcHYpWkU2r2A98NiDljiKXZgtjUO3Jwk+01xdvHoj51AGcJYu1m8fgyn0GcOi
        FURgxk9w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mAx6p-005S2v-Du; Tue, 03 Aug 2021 16:17:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 537E5300220;
        Tue,  3 Aug 2021 18:17:38 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 14C8120660CBC; Tue,  3 Aug 2021 18:17:38 +0200 (CEST)
Date:   Tue, 3 Aug 2021 18:17:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] perf/x86/intel: Apply mid ACK for small core
Message-ID: <YQlsIvh7vwLt3f6g@hirez.programming.kicks-ass.net>
References: <1627997128-57891-1-git-send-email-kan.liang@linux.intel.com>
 <YQlY2o62E5A9xcdq@hirez.programming.kicks-ass.net>
 <9b0cb4ec-e8b8-3739-7b8d-e1c05785023a@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b0cb4ec-e8b8-3739-7b8d-e1c05785023a@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 03, 2021 at 11:20:20AM -0400, Liang, Kan wrote:
> 
> 
> On 8/3/2021 10:55 AM, Peter Zijlstra wrote:
> > On Tue, Aug 03, 2021 at 06:25:28AM -0700, kan.liang@linux.intel.com wrote:
> > > From: Kan Liang <kan.liang@linux.intel.com>
> > > 
> > > A warning as below may be occasionally triggered in an ADL machine when
> > > these conditions occur,
> > > - Two perf record commands run one by one. Both record a PEBS event.
> > > - Both runs on small cores.
> > > - They have different adaptive PEBS configuration (PEBS_DATA_CFG).
> > > 
> > > [  673.663291] WARNING: CPU: 4 PID: 9874 at
> > > arch/x86/events/intel/ds.c:1743
> > > setup_pebs_adaptive_sample_data+0x55e/0x5b0
> > > [  673.663348] RIP: 0010:setup_pebs_adaptive_sample_data+0x55e/0x5b0
> > > [  673.663357] Call Trace:
> > > [  673.663357]  <NMI>
> > > [  673.663357]  intel_pmu_drain_pebs_icl+0x48b/0x810
> > > [  673.663360]  perf_event_nmi_handler+0x41/0x80
> > > [  673.663368]  </NMI>
> > > [  673.663370]  __perf_event_task_sched_in+0x2c2/0x3a0
> > > 
> > > Different from the big core, the small core requires the ACK right
> > > before re-enabling counters in the NMI handler, otherwise a stale PEBS
> > > record may be dumped into the later NMI handler, which trigger the
> > > warning.
> > > 
> > > Add a new mid_ack flag to track the case. Add all PMI handler bits in
> > > the struct x86_hybrid_pmu to track the bits for different types of PMUs.
> > > Apply mid ACK for the small cores on an Alder Lake machine.
> > 
> > Why do we need a new option? Why isn't early (as in not late) good
> > enough?
> > 
> 
> The early ACK can fix this issue, however it triggers a spurious NMI during
> the stress test. I'm told to do the ACK right before re-enabling counters
> for small cores. That indeed fixes all the issues.

Any chance that would also work for the chips that now use late_ack?

I'm just (desperately) trying to minimize the amount of quirks here ;-)
