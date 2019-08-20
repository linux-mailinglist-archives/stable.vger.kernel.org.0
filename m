Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A795A96045
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfHTNjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:39:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52033 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbfHTNjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 09:39:42 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i04MI-0006WU-TW; Tue, 20 Aug 2019 15:39:35 +0200
Date:   Tue, 20 Aug 2019 15:39:34 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Song Liu <songliubraving@fb.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] x86/mm/pti: in pti_clone_pgtable() don't increase addr
 by PUD_SIZE
In-Reply-To: <44EA504D-2388-49EF-A807-B9712903B146@fb.com>
Message-ID: <alpine.DEB.2.21.1908201539200.2223@nanos.tec.linutronix.de>
References: <20190820075128.2912224-1-songliubraving@fb.com> <20190820100055.GI2332@hirez.programming.kicks-ass.net> <alpine.DEB.2.21.1908201315450.2223@nanos.tec.linutronix.de> <44EA504D-2388-49EF-A807-B9712903B146@fb.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 20 Aug 2019, Song Liu wrote:
> > On Aug 20, 2019, at 4:16 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > On Tue, 20 Aug 2019, Peter Zijlstra wrote:
> >> What that code wants to do is skip to the end of the pud, a pmd_size
> >> increase will not do that. And right below this, there's a second
> >> instance of this exact pattern.
> >> 
> >> Did I get the below right?
> >> 
> >> ---
> >> diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
> >> index b196524759ec..32b20b3cb227 100644
> >> --- a/arch/x86/mm/pti.c
> >> +++ b/arch/x86/mm/pti.c
> >> @@ -330,12 +330,14 @@ pti_clone_pgtable(unsigned long start, unsigned long end,
> >> 
> >> 		pud = pud_offset(p4d, addr);
> >> 		if (pud_none(*pud)) {
> >> +			addr &= PUD_MASK;
> >> 			addr += PUD_SIZE;
> > 
> > 			round_up(addr, PUD_SIZE);
> 
> I guess we need "round_up(addr + PMD_SIZE, PUD_SIZE)". 

Right you are.
