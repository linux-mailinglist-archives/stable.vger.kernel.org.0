Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651721561BE
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 01:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgBHAGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 19:06:02 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41712 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgBHAGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 19:06:02 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j0Dcy-0004K9-EG; Sat, 08 Feb 2020 01:05:40 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id E6A6A1001FC; Sat,  8 Feb 2020 00:05:39 +0000 (GMT)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] x86/tsc_msr: Make MSR derived TSC frequency more accurate
In-Reply-To: <20200207205456.113758-3-hdegoede@redhat.com>
References: <20200207205456.113758-1-hdegoede@redhat.com> <20200207205456.113758-3-hdegoede@redhat.com>
Date:   Sat, 08 Feb 2020 01:05:39 +0100
Message-ID: <87eev67xkc.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hans,

Hans de Goede <hdegoede@redhat.com> writes:
> @@ -120,11 +180,23 @@ unsigned long cpu_khz_from_msr(void)
>  	rdmsr(MSR_FSB_FREQ, lo, hi);
>  	index = lo & freq_desc->mask;
>  
> -	/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
> -	freq = freq_desc->freqs[index];
> -
> -	/* TSC frequency = maximum resolved freq * maximum resolved bus ratio */
> -	res = freq * ratio;
> +	/*
> +	 * Note this also catches cases where the index points to an unpopulated
> +	 * part of muldiv, in that case the else will set freq and res to 0.
> +	 */
> +	if (freq_desc->muldiv[index].divider) {
> +		freq = DIV_ROUND_CLOSEST(TSC_REFERENCE_KHZ *
> +					   freq_desc->muldiv[index].multiplier,
> +					 freq_desc->muldiv[index].divider);
> +		/* Multiply by ratio before the divide for better accuracy */
> +		res = DIV_ROUND_CLOSEST(TSC_REFERENCE_KHZ *
> +					   freq_desc->muldiv[index].multiplier *
> +					   ratio,
> +					freq_desc->muldiv[index].divider);

What about:

        struct muldiv *md = &freq_desc->muldiv[index];

        if (md->divider) {
		tscref = TSC_REFERENCE_KHZ * md->multiplier;
        	freq = DIV_ROUND_CLOSEST(tscref, md->divider);
		/*
                 * Multiplying by ratio before the division has better
                 * accuracy than just calculating freq * ratio
                 */
                res = DIV_ROUND_CLOSEST(tscref * ratio, md->divider);

Hmm?

Thanks,

        tglx
