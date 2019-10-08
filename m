Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04A9D0110
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 21:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfJHTSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 15:18:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43196 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfJHTSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 15:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ME1BnonkhshqxMfctofPIhF2CHKZ2ZAEIXQ0ulRQ3lE=; b=o1O6FNkZzqWDcXwvJ3hHDOq0o
        BMkJQzyt6YzaVcyMuCfeC9jgl8zgqJ+gzVrQoF8DjbgxM+b6eVIzIKscRV2QVQAvdWFGu6k5MpXca
        u/QPjUfbHMlQ/iy6d0geZ1TVMCU5Vmoa4yRhy4anVHM+hfWj3ElKYBAZRXk+iTRKglgDtSRduQ3j+
        1zZyfxnd7YQisu13+bG13p7383jY+VR514dHVsxTYDqwZ0Yhp6ZJMD3e93OSznC8Y+qpCMIj6SLnl
        4qhBAKyoF8UVP6FCMiO4jC6iVErOhZGe2QrRX+UDoXKhDcYKiZCJw3JdxbTw3ihIUYL1laD6iinuz
        EpmRMA0pA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHuzv-0005Va-H5; Tue, 08 Oct 2019 19:18:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9009D30034F;
        Tue,  8 Oct 2019 21:17:21 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 14806202448A4; Tue,  8 Oct 2019 21:18:13 +0200 (CEST)
Date:   Tue, 8 Oct 2019 21:18:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2] perf/core: fix corner case in perf_rotate_context()
Message-ID: <20191008191813.GG2328@hirez.programming.kicks-ass.net>
References: <20191008165949.920548-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008165949.920548-1-songliubraving@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 09:59:49AM -0700, Song Liu wrote:
> In perf_rotate_context(), when the first cpu flexible event fail to
> schedule, cpu_rotate is 1, while cpu_event is NULL. Since cpu_event is
> NULL, perf_rotate_context will _NOT_ call cpu_ctx_sched_out(), thus
> cpuctx->ctx.is_active will have EVENT_FLEXIBLE set. Then, the next
> perf_event_sched_in() will skip all cpu flexible events because of the
> EVENT_FLEXIBLE bit.
> 
> In the next call of perf_rotate_context(), cpu_rotate stays 1, and
> cpu_event stays NULL, so this process repeats. The end result is, flexible
> events on this cpu will not be scheduled (until another event being added
> to the cpuctx).
> 
> Here is an easy repro of this issue. On Intel CPUs, where ref-cycles
> could only use one counter, run one pinned event for ref-cycles, one
> flexible event for ref-cycles, and one flexible event for cycles. The
> flexible ref-cycles is never scheduled, which is expected. However,
> because of this issue, the cycles event is never scheduled either.
> 
> perf stat -e ref-cycles:D,ref-cycles,cycles -C 5 -I 1000
>            time             counts unit events
>     1.000152973         15,412,480      ref-cycles:D
>     1.000152973      <not counted>      ref-cycles     (0.00%)
>     1.000152973      <not counted>      cycles         (0.00%)
>     2.000486957         18,263,120      ref-cycles:D
>     2.000486957      <not counted>      ref-cycles     (0.00%)
>     2.000486957      <not counted>      cycles         (0.00%)
> 
> To fix this, when the flexible_active list is empty, try rotate the
> first event in the flexible_groups. Also, rename ctx_first_active() to
> ctx_event_to_rotate(), which is more accurate.
> 
> Fixes: 8d5bce0c37fa ("perf/core: Optimize perf_rotate_context() event scheduling")
> Cc: stable@vger.kernel.org # v4.17+
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Thanks!
