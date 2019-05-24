Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB97629765
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 13:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390961AbfEXLi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 07:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390714AbfEXLi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 07:38:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F8442168B;
        Fri, 24 May 2019 11:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558697906;
        bh=Zhhg//BfGeL3tcsPNX0Bm+RkAxei7MrcqCr6feaoOzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KVaJZM07X99hL8TrcI1XzkxkEmHIbQl5KGD7llIQ55p0Mt+yT1jkDRIa/kfoZTOSu
         M7F2rqoetBBc8qMlYqr8PnT5wbki/ZMB6gFsyDDzh5cNA/3zbj0oPtWu7w/OxOn/OR
         yqC5FkK1qPyd0kqrkCh+0Qcx50ifKLpZbST3IJYk=
Date:   Fri, 24 May 2019 13:38:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, will.deacon@arm.com,
        aou@eecs.berkeley.edu, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, davem@davemloft.net, fenghua.yu@intel.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        ink@jurassic.park.msu.ru, jhogan@kernel.org, linux@armlinux.org.uk,
        mattst88@gmail.com, mingo@kernel.org, mpe@ellerman.id.au,
        palmer@sifive.com, paul.burton@mips.com, paulus@samba.org,
        ralf@linux-mips.org, rth@twiddle.net, stable@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, vgupta@synopsys.com,
        jhansen@vmware.com, vdasa@vmware.com, aditr@vmware.com,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
Message-ID: <20190524113822.GA32272@kroah.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
 <20190523101926.GA3370@lakrids.cambridge.arm.com>
 <20190524103731.GN2606@hirez.programming.kicks-ass.net>
 <20190524111807.GS2650@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524111807.GS2650@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 01:18:07PM +0200, Peter Zijlstra wrote:
> On Fri, May 24, 2019 at 12:37:31PM +0200, Peter Zijlstra wrote:
> > On Thu, May 23, 2019 at 11:19:26AM +0100, Mark Rutland wrote:
> > 
> > > [mark@lakrids:~/src/linux]% git grep '\(return\|=\)\s\+atomic\(64\)\?_set'
> > > include/linux/vmw_vmci_defs.h:  return atomic_set((atomic_t *)var, (u32)new_val);
> > > include/linux/vmw_vmci_defs.h:  return atomic64_set(var, new_val);
> > > 
> > 
> > Oh boy, what a load of crap you just did find.
> > 
> > How about something like the below? I've not read how that buffer is
> > used, but the below preserves all broken without using atomic*_t.
> 
> Clarified by something along these lines?
> 
> ---
>  Documentation/atomic_t.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/atomic_t.txt b/Documentation/atomic_t.txt
> index dca3fb0554db..125c95ddbbc0 100644
> --- a/Documentation/atomic_t.txt
> +++ b/Documentation/atomic_t.txt
> @@ -83,6 +83,9 @@ The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
>  implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
>  smp_store_release() respectively.
>  
> +Therefore, if you find yourself only using the Non-RMW operations of atomic_t,
> +you do not in fact need atomic_t at all and are doing it wrong.
> +
>  The one detail to this is that atomic_set{}() should be observable to the RMW
>  ops. That is:
>  

I like it!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
