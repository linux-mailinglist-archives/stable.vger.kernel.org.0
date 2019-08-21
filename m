Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0F976F9
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 12:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfHUKRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 06:17:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55197 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbfHUKRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 06:17:07 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i0Nfp-00012g-VP; Wed, 21 Aug 2019 12:17:02 +0200
Date:   Wed, 21 Aug 2019 12:17:00 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Song Liu <songliubraving@fb.com>
cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
In-Reply-To: <2CB1A3FD-33EF-4D8B-B74A-CF35F9722993@fb.com>
Message-ID: <alpine.DEB.2.21.1908211210160.2223@nanos.tec.linutronix.de>
References: <20190820202314.1083149-1-songliubraving@fb.com> <2CB1A3FD-33EF-4D8B-B74A-CF35F9722993@fb.com>
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

On Wed, 21 Aug 2019, Song Liu wrote:
> > On Aug 20, 2019, at 1:23 PM, Song Liu <songliubraving@fb.com> wrote:
> > 
> > Before 32-bit support, pti_clone_pmds() always adds PMD_SIZE to addr.
> > This behavior changes after the 32-bit support:  pti_clone_pgtable()
> > increases addr by PUD_SIZE for pud_none(*pud) case, and increases addr by
> > PMD_SIZE for pmd_none(*pmd) case. However, this is not accurate because
> > addr may not be PUD_SIZE/PMD_SIZE aligned.
> > 
> > Fix this issue by properly rounding up addr to next PUD_SIZE/PMD_SIZE
> > in these two cases.
> 
> After poking around more, I found the following doesn't really make 
> sense. 

I'm glad you figured that out yourself. Was about to write up something to
that effect.

Still interesting questions remain:

  1) How did you end up feeding an unaligned address into that which points
     to a 0 PUD?

  2) Is this related to Facebook specific changes and unlikely to affect any
     regular kernel? I can't come up with a way to trigger that in mainline

  3) As this is a user page table and the missing mapping is related to
     mappings required by PTI, how is the machine going in/out of user
     space in the first place? Or did I just trip over what you called
     nonsense?

Thanks,

	tglx



