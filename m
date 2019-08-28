Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465629FC83
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 10:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfH1IDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 04:03:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45282 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfH1IDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 04:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=X8NAp/0+k3yUu9F7t1wR4sHl+yZyZQ5B/4oEW32AXWg=; b=W/EQ3G5BB1zRMFZI/y4P7qBWr
        Zp8xbHHFbkrDr/4b6Q+5JqoQ2+jfdwelIwQ3yQqEGnfS2EUU1UFO6HBLQ/OG0cGMsy5XoK/unxRSC
        5c3+k3gdgYA7XE7uy0cyb3LDd2asRdIx1TfIElR4/w5oHIYFbrsGmuD84kBEEP84d082ZieFuOiIy
        cVacYt7vnnsXnwnJxs+0cFCjLwLV37OU30lm1vXyi4cs8LYs+FiqhcqbEhJNJjUo5wd8zfKN5Lr7S
        njIVeYc5AE1/rWxHymdnPtbhgAVPcvMkLcojLalg6v3mwl32CKCH88DcSEmRykAeGvMehZNSNAGWS
        SZLxF8EWw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i2suz-0007KT-81; Wed, 28 Aug 2019 08:03:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 968273070F4;
        Wed, 28 Aug 2019 10:02:25 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8129820230B0A; Wed, 28 Aug 2019 10:02:59 +0200 (CEST)
Date:   Wed, 28 Aug 2019 10:02:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/amd/ibs: Fix sample bias for dispatched
 micro-ops
Message-ID: <20190828080259.GM2332@hirez.programming.kicks-ass.net>
References: <20190826195730.30614-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826195730.30614-1-kim.phillips@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 02:57:30PM -0500, Kim Phillips wrote:

> diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
> index 62f317c9113a..f2625b4a5a8b 100644
> --- a/arch/x86/events/amd/ibs.c
> +++ b/arch/x86/events/amd/ibs.c
> @@ -663,8 +663,15 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
>  out:
>  	if (throttle)
>  		perf_ibs_stop(event, 0);
> -	else
> -		perf_ibs_enable_event(perf_ibs, hwc, period >> 4);
> +	else {

Coding Style requires braces on both legs of a conditional.

> +		period >>= 4;
> +
> +		if ((ibs_caps & IBS_CAPS_RDWROPCNT) &&
> +		    (*config & IBS_OP_CNT_CTL))
> +			period |= *config & IBS_OP_CUR_CNT_RAND;
> +
> +		perf_ibs_enable_event(perf_ibs, hwc, period);
> +	}
>  
>  	perf_event_update_userpage(event);
>  
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 1392d5e6e8d6..67d94696a1d6 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -259,9 +259,12 @@ struct pebs_lbr {
>  #define IBS_FETCH_CNT		0xFFFF0000ULL
>  #define IBS_FETCH_MAX_CNT	0x0000FFFFULL
>  
> -/* ibs op bits/masks */
> -/* lower 4 bits of the current count are ignored: */
> -#define IBS_OP_CUR_CNT		(0xFFFF0ULL<<32)
> +/* ibs op bits/masks
> + * The lower 7 bits of the current count are random bits
> + * preloaded by hardware and ignored in software
> + */

Malformed comment style.

> +#define IBS_OP_CUR_CNT		(0xFFF80ULL<<32)
> +#define IBS_OP_CUR_CNT_RAND	(0x0007FULL<<32)
>  #define IBS_OP_CNT_CTL		(1ULL<<19)
>  #define IBS_OP_VAL		(1ULL<<18)
>  #define IBS_OP_ENABLE		(1ULL<<17)

Fixed up both issues and applied.

Thanks!
