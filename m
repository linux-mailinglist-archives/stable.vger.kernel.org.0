Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F2815CCEE
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 22:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgBMVGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 16:06:42 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53318 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgBMVGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 16:06:42 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2Lgr-0003aw-CE; Thu, 13 Feb 2020 22:06:29 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id AEADE100F5A; Thu, 13 Feb 2020 22:06:28 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
In-Reply-To: <3d35fda5-418b-f022-1191-c53bd9468f4d@intel.com>
References: <87iml11ccf.fsf@nanos.tec.linutronix.de> <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com> <87ftg5131x.fsf@nanos.tec.linutronix.de> <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com> <87sgjz434v.fsf@nanos.tec.linutronix.de> <20200129130350.GD32742@smile.fi.intel.com> <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com> <20200129141444.GE32742@smile.fi.intel.com> <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com> <87imku2t3w.fsf@nanos.tec.linutronix.de> <20200129155353.GI32742@smile.fi.intel.com> <87a7662d7l.fsf@nanos.tec.linutronix.de> <3d35fda5-418b-f022-1191-c53bd9468f4d@intel.com>
Date:   Thu, 13 Feb 2020 22:06:28 +0100
Message-ID: <87zhdmgpt7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dave Hansen <dave.hansen@intel.com> writes:
> On 1/29/20 12:57 PM, Thomas Gleixner wrote:
>> Just to make it entirely clear. We are wasting days already due to the
>> fact that Intel, who designs, specifies and most importantly sells these
>> CPUs is either unable or unwilling to provide accurate information about
>> the trivial and essential information to support these CPUs:
>> 
>>     1) The crystal frequency
>> 
>>     2) The nominator/denominator pair to calculate the TSC frequency
>>        from #1
>
> Circling back...  The problem here, as I understand it is that we have
> some of these tables:
>
> static const struct freq_desc freq_desc_byt = {
>         1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
> };
>
> Where "83300" means "83.3 MHz".  the 83.3 came literally from the SDM.
> Talking to some of the folks who work on the silicon, they confirmed
> that when the SDM says "083.3 MHz", it represents an approximation of
> 2000/24.
> Intel can go through and explain the values more precisely in the
> documentation.  The big-core tables already have more significant
> digits, for instance.  To me, it also seems like the SDM should probably
> just explicitly state the actual ratios rather than a decimal
> approximation.

Yes please.

> But, in the end, the CPU is just enumerating frequencies that are
> derived from crystals outside the CPU.  The hardware in question here
> tended to be put on boards which were not using the highest-end
> components and probably don't have the most accurate crystals.
>
> So, while we can add precision to the numbers in the documentation,
> we're not super confident that it will result in a meaningfully more
> accurate frequency across a big fleet of systems.

Even if you have a cheapo 24MHz crystal it's way less off than the
rounding error in these tables.

Thanks,

        tglx
