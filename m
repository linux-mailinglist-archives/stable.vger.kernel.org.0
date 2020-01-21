Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00462144389
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 18:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgAURp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 12:45:58 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36082 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAURp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 12:45:57 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1itxax-0000jZ-CC; Tue, 21 Jan 2020 18:45:43 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 8020A1008BE; Tue, 21 Jan 2020 18:45:42 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Vipul Kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Vipul Kumar <vipulk0511@gmail.com>, x86@kernel.org,
        Bin Gao <bin.gao@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
In-Reply-To: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
Date:   Tue, 21 Jan 2020 18:45:42 +0100
Message-ID: <87eevs7lfd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vipul,

Vipul Kumar <vipulk0511@gmail.com> writes:

> commit f3a02ecebed7 ("x86/tsc: Set TSC_KNOWN_FREQ and TSC_RELIABLE
> flags on Intel Atom SoCs"), is setting TSC_KNOWN_FREQ and TSC_RELIABLE
> flags for Soc's which is causing time drift on Valleyview/Bay trail Soc.

This lacks any form of information what the difference is. I asked about
that before and got no answer.

> This patch introduces a new macro to skip these flags.

git grep 'This patch' Documentation/process/submitting-patches.rst

> Signed-off-by: Vipul Kumar <vipul_kumar@mentor.com>
> Cc: stable@vger.kernel.org

That stable tag is useless as you already have identied the commit which
is "Fixed" by your patch.

>  
> +config X86_FEATURE_TSC_UNKNOWN_FREQ
> +	bool "Support to skip tsc known frequency flag"
> +	help
> +	  Include support to skip X86_FEATURE_TSC_KNOWN_FREQ flag
> +
> +	  X86_FEATURE_TSC_KNOWN_FREQ flag is causing time-drift on Valleyview/
> +	  Baytrail SoC.
> +	  By selecting this option, user can skip X86_FEATURE_TSC_KNOWN_FREQ
> +	  flag to use refine tsc freq calibration.

This is exactly the same problem as before. How does anyone aside of you
know whether to enable this or not?

And if someone enables this option then _ALL_ platforms which utilize
cpu_khz_from_msr() are affected. How is that any different from your
previous approach? This works on local kernels where you build for a
specific platform and you know exactly what you're doing, but not for
general consumption. What should a distro do with this option?

Thanks,

        tglx


