Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05A714D22B
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 21:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgA2U52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 15:57:28 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51913 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgA2U52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 15:57:28 -0500
Received: from 51.26-246-81.adsl-static.isp.belgacom.be ([81.246.26.51] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iwuOZ-0006F3-FS; Wed, 29 Jan 2020 21:57:07 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 317BA105CFD; Wed, 29 Jan 2020 21:57:02 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        vipul kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
In-Reply-To: <20200129155353.GI32742@smile.fi.intel.com>
References: <87iml11ccf.fsf@nanos.tec.linutronix.de> <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com> <87ftg5131x.fsf@nanos.tec.linutronix.de> <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com> <87sgjz434v.fsf@nanos.tec.linutronix.de> <20200129130350.GD32742@smile.fi.intel.com> <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com> <20200129141444.GE32742@smile.fi.intel.com> <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com> <87imku2t3w.fsf@nanos.tec.linutronix.de> <20200129155353.GI32742@smile.fi.intel.com>
Date:   Wed, 29 Jan 2020 21:57:02 +0100
Message-ID: <87a7662d7l.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andy,

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> On Wed, Jan 29, 2020 at 04:13:39PM +0100, Thomas Gleixner wrote:
>> Andy, can you please make sure that people inside Intel who can look
>> into the secrit documentation confirm what we are aiming for?
>> 
>> Ideally they should provide the X-tal frequency and the mult/div pair
>> themself :)
>
> So, I don't have access to the CPU core documentation (and may be will not be
> given), nevertheless I dug a bit to what I have for Cherrytrail. So, the XTAL
> is 19.2MHz, which becomes 100MHz and 1600MHz by some root PLL, then, the latter
> two frequencies are being used by another PLL to provide a reference clock (*)
> to PLL which derives CPU clock.
>
> *) According to colleagues of mine it's a fixed rate source.
>
> That's all what I have.

I'm surely not blaming you for this, you're just the messenger.

Just to make it entirely clear. We are wasting days already due to the
fact that Intel, who designs, specifies and most importantly sells these
CPUs is either unable or unwilling to provide accurate information about
the trivial and essential information to support these CPUs:

    1) The crystal frequency

    2) The nominator/denominator pair to calculate the TSC frequency
       from #1

The numbers which are in the kernel have been provided by Intel, but
they are inaccurate as we have proven.

Sure, we can reverse engineer the exact numbers assumed that we have
access to all variants of affected devices and enough spare time to
waste.

But why should we do that?

Intel has the exact numbers at their fingertip and is just not providing
them for whatever reasons (I really don't want to know).

So instead of wasting our precious time further, I'm going to apply the
patch below unless Intel comes forth with the information they should
have provided many years ago.

Thanks,

        tglx

8<--------------
 arch/x86/kernel/tsc_msr.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -73,6 +73,13 @@ static const struct x86_cpu_id tsc_msr_c
 	{}
 };
 
+static char msr_warning[] = \
+	"The TSC/APIC timer frequency for your CPU is guesswork.\n\n"	\
+	"It is derived from frequency tables provided by Intel.\n"	\
+	"These tables are demonstrably inaccurate, but Intel is\n"	\
+	"either unable or unwilling to provide the correct data.\n"	\
+	"Please report this to Intel and not on LKML.\n";
+
 /*
  * MSR-based CPU/TSC frequency discovery for certain CPUs.
  *
@@ -90,6 +97,8 @@ unsigned long cpu_khz_from_msr(void)
 	if (!id)
 		return 0;
 
+	WARN_ONCE(1, "%s\n", msr_warning);
+
 	freq_desc = (struct freq_desc *)id->driver_data;
 	if (freq_desc->msr_plat) {
 		rdmsr(MSR_PLATFORM_INFO, lo, hi);

