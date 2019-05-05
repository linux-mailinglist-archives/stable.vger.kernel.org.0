Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9B714206
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 21:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfEETJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 15:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbfEETJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 15:09:15 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF26206DF;
        Sun,  5 May 2019 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557083354;
        bh=4a9Bj+P7pYzppgR+XAGFwmOPU9FoP0E5RLD7Tb28gb4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=D97UXnrnl0AtsC0B9sGMYTCi2lvpOjaFrNdwax0Dusj+M5yd1rJPPmIGj3bggQ3PD
         NqFrYWxbzKaKC4GXIkC/qQAjOkwobNOG5PDLv6E9d/BNtVUsqe527bpb2iMKD9m/m6
         rPYFSzx/50c+g0aTKCzUU+khEMLJbg4gr2WUCzwU=
Date:   Sun, 5 May 2019 21:09:09 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Rik van Riel <riel@surriel.com>
cc:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        stable@vger.kernel.org, Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
In-Reply-To: <86b8d81d760ac1f6e622f1c873a5f9aad7862734.camel@surriel.com>
Message-ID: <nycvar.YFH.7.76.1905052106550.17054@cbobk.fhfr.pm>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>  <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>  <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>  <20190504004747.GA107909@gmail.com>  <2238f6ed-9338-903c-760c-6200e73b1599@newmedia-net.de>
 <86b8d81d760ac1f6e622f1c873a5f9aad7862734.camel@surriel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 5 May 2019, Rik van Riel wrote:

> > Using fpu code in kernel space in a kernel module is a derived work of 
> > the kernel itself? dont get me wrong, but this is absurd. i mean you 
> > limit the use of cpu instructions. the use of cpu instructions should 
> > be free of any licensing issue. i would even argument you are 
> > violating the license of the cpu ower given to the kernel by executing 
> > it, by restricting its use for no reason
> 
> Using FPU code in kernel space in a kernel module does not require the 
> use of kernel_fpu_begin/end().
> 
> The kernel module could simply disable preemption, save the FPU 
> registers, use the FPU, restore the FPU registers, and reenable 
> preemption.

That means the module basically reimplemented kernel_fpu_begin/end() in 
its whole (not getting the further optimizations implemented by the 
kernel, sure). And therefore I sort of don't see the point of "hiding" it.

Thanks,

-- 
Jiri Kosina
SUSE Labs

