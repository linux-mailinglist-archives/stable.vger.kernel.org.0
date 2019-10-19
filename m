Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729D1DD7DA
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 12:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbfJSKBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 06:01:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59086 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfJSKBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Oct 2019 06:01:48 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iLlYH-0004Fy-IZ; Sat, 19 Oct 2019 12:01:37 +0200
Date:   Sat, 19 Oct 2019 12:01:32 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Huacai Chen <chenhc@lemote.com>
cc:     Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] lib/vdso: Use __arch_use_vsyscall() to indicate
 fallback
In-Reply-To: <CAAhV-H6VkW5-hMOrzAQeyHT4pYGExZR6eTRbPHSPK50GAkigCw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1910191156240.2098@nanos.tec.linutronix.de>
References: <1571367619-13573-1-git-send-email-chenhc@lemote.com> <CALCETrWXRgkQOJGRqa_sOLAG2zhjsEX6b86T2VTsNYN9ECRrtA@mail.gmail.com> <CAAhV-H6VkW5-hMOrzAQeyHT4pYGExZR6eTRbPHSPK50GAkigCw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 19 Oct 2019, Huacai Chen wrote:
> On Fri, Oct 18, 2019 at 11:15 AM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Thu, Oct 17, 2019 at 7:57 PM Huacai Chen <chenhc@lemote.com> wrote:
> > >
> > > In do_hres(), we currently use whether the return value of __arch_get_
> > > hw_counter() is negtive to indicate fallback, but this is not a good
> > > idea. Because:
> > >
> > > 1, ARM64 returns ULL_MAX but MIPS returns 0 when clock_mode is invalid;
> > > 2, For a 64bit counter, a "negtive" value of counter is actually valid.
> >
> > s/negtive/negative
> >
> > What's the actual bug?  Is it that MIPS is returning 0 but the check
> > is < 0?  Sounds like MIPS should get fixed.
> My original bug is what Vincenzo said, MIPS has a boot failure if no
> valid clock_mode, and surely MIPS need to fix. However, when I try to
> fix it, I found that clock_getres() has another problem, because
> __cvdso_clock_getres_common() get vd[CS_HRES_COARSE].hrtimer_res, but
> hrtimer_res is set in update_vdso_data() which relies on
> __arch_use_vsyscall().

__arch_use_vsyscall() is a pointless exercise TBH. The VDSO data should be
updated unconditionally so all the trivial interfaces like time() and
getres() just work independently of the functions which depend on the
underlying clocksource.

This functions have a fallback operation already:

Let __arch_get_hw_counter() return U64_MAX and the syscall fallback is
invoked.

__arch_use_vsyscall() should just be removed.

Thanks,

	tglx
