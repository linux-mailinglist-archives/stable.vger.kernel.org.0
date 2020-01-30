Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA43814DC34
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 14:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgA3NnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 08:43:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbgA3NnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 08:43:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jYhjR/5YILbh7BPbn/+YKb6pgodhq2Z9d9eAv2TzBqc=; b=P3a8OvLVUUircv8bnSBppFjpQ
        a8c4IxcERcbLTTlHkArLvJskXT04pJJpMDIr2L7nTysDctV2/PwAo44psvYD6lGC3yW7evZwITk08
        LYRntxIVdzFugqn2Diz7v2LR7eo2eRPVE51NdAmxaCAEMJ0W4uX9v0vmfmNqSDstGcPZbic02Ibfe
        7W+5qZqMP4mFYF8LYQweQboAdi5AkLBkEpiquQonWBKhXgHb1GbtOt+Em5dQyGET8I97fWAHly5IX
        Wh2drjCzYeO3rWJu4O8fOEj7bI2Mmqo+/yaNTqL1xwdVjGVlY8YphSGs1AaEuqpfiBst5qCKhPiWX
        mDRKoQG2Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixA6C-0007qd-6p; Thu, 30 Jan 2020 13:43:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 03366300E0C;
        Thu, 30 Jan 2020 14:41:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 418DA2B6563BA; Thu, 30 Jan 2020 14:43:10 +0100 (CET)
Date:   Thu, 30 Jan 2020 14:43:10 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
Message-ID: <20200130134310.GX14914@hirez.programming.kicks-ass.net>
References: <20200130115255.20840-1-hdegoede@redhat.com>
 <20200130115255.20840-3-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130115255.20840-3-hdegoede@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 12:52:55PM +0100, Hans de Goede wrote:

> This does not matter though, we can model the chain of PLLs as a single
> PLL with a quotient equal to the quotients of all PLLs in the chain
> multiplied.
> 
> So we can create a simplified model of the CPU clock setup using a
> reference clock of 100 MHz plus a quotient which gets us as close to the
> frequency from the DSM as possible.

s/DSM/SDM/ ?

> For the 83.3 MHz example from above this would give us 100 MHz * 5 / 6 =
> 83 and 1/3 MHz, which matches exactly what has been measured on actual hw.
> 
> This commit makes the tsc_msr.c code use a simplified PLL model with a
> reference clock of 100 MHz for all Bay and Cherry Trail models.


> + * Bay Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
> + *  000:   100 *  5 /  6  =  83.3333 MHz
> + *  001:   100 *  1 /  1  = 100.0000 MHz
> + *  010:   100 *  4 /  3  = 133.3333 MHz
> + *  011:   100 *  7 /  6  = 116.6667 MHz
> + *  100:   100 *  4 /  5  =  80.0000 MHz

> + * Cherry Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
> + * 0000:   100 *  5 /  6  =  83.3333 MHz
> + * 0001:   100 *  1 /  1  = 100.0000 MHz
> + * 0010:   100 *  4 /  3  = 133.3333 MHz
> + * 0011:   100 *  7 /  6  = 116.6667 MHz
> + * 0100:   100 *  4 /  5  =  80.0000 MHz
> + * 0101:   100 * 14 / 15  =  93.3333 MHz
> + * 0110:   100 *  9 / 10  =  90.0000 MHz
> + * 0111:   100 *  8 /  9  =  88.8889 MHz
> + * 1000:   100 *  7 /  8  =  87.5000 MHz

> + * Merriefield (BYT MID) SDM MSR_FSB_FREQ frequencies simplified PLL model:
> + * 0001:   100 *  1 /  1  = 100.0000 MHz
> + * 0010:   100 *  4 /  3  = 133.3333 MHz

> + * Moorefield (CHT MID) SDM MSR_FSB_FREQ frequencies simplified PLL model:
> + * 0000:   100 *  5 /  6  =  83.3333 MHz
> + * 0001:   100 *  1 /  1  = 100.0000 MHz
> + * 0010:   100 *  4 /  3  = 133.3333 MHz
> + * 0011:   100 *  1 /  1  = 100.0000 MHz

Unless I'm going cross-eyed, that's 4 times the exact same table.

Do we want to use the Cherry Trail table (for being the most complete)
for all of them?
