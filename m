Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC2B3DF0D9
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbhHCOzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbhHCOzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 10:55:39 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D375C061757;
        Tue,  3 Aug 2021 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=F74UGIITlPyfA3peXisMBcwyx6rHLr75K3DVyOZUtF0=; b=PYH+giH19IloHFBCsdZBZqqSqR
        NiEDT1Ca9ROL4KVVB+Gg52oFSQt+VIorCSI7hk6FCe2VGl75rrpVR7Nj8V4RPTua+Qd1EKC+s5u3L
        kiquelKkunmsv4j74frFg8pxjiAE8/9vd8jYm8PdXZBSbJDrbvl3J7bNL70E5xtUhEg5phydIbote
        Ql/tUkUtfLwhb4qEdcmek0oHS3XqVkf95SkWiKhrqBQ/XhsE+AxzEgBLgBy+w8l3N4bpv6GDK7HbH
        W7mtrdwRCS8tzcLurbOwdIuPIE3j8nm2l7dTDZCIHdcHaCHPKJNyDaSJMwTjLXsHafdIDNO1bM0TA
        DU3ti67A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mAvpD-005R80-DY; Tue, 03 Aug 2021 14:55:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 149173000F2;
        Tue,  3 Aug 2021 16:55:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C3D1520262923; Tue,  3 Aug 2021 16:55:22 +0200 (CEST)
Date:   Tue, 3 Aug 2021 16:55:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     kan.liang@linux.intel.com
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] perf/x86/intel: Apply mid ACK for small core
Message-ID: <YQlY2o62E5A9xcdq@hirez.programming.kicks-ass.net>
References: <1627997128-57891-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627997128-57891-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 03, 2021 at 06:25:28AM -0700, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> A warning as below may be occasionally triggered in an ADL machine when
> these conditions occur,
> - Two perf record commands run one by one. Both record a PEBS event.
> - Both runs on small cores.
> - They have different adaptive PEBS configuration (PEBS_DATA_CFG).
> 
> [  673.663291] WARNING: CPU: 4 PID: 9874 at
> arch/x86/events/intel/ds.c:1743
> setup_pebs_adaptive_sample_data+0x55e/0x5b0
> [  673.663348] RIP: 0010:setup_pebs_adaptive_sample_data+0x55e/0x5b0
> [  673.663357] Call Trace:
> [  673.663357]  <NMI>
> [  673.663357]  intel_pmu_drain_pebs_icl+0x48b/0x810
> [  673.663360]  perf_event_nmi_handler+0x41/0x80
> [  673.663368]  </NMI>
> [  673.663370]  __perf_event_task_sched_in+0x2c2/0x3a0
> 
> Different from the big core, the small core requires the ACK right
> before re-enabling counters in the NMI handler, otherwise a stale PEBS
> record may be dumped into the later NMI handler, which trigger the
> warning.
> 
> Add a new mid_ack flag to track the case. Add all PMI handler bits in
> the struct x86_hybrid_pmu to track the bits for different types of PMUs.
> Apply mid ACK for the small cores on an Alder Lake machine.

Why do we need a new option? Why isn't early (as in not late) good
enough?
