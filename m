Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37662296EE
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390760AbfEXLSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 07:18:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37842 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390759AbfEXLSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 07:18:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MwsXLs7WTZaHxJpnrqoGN4CLjyg7waRkeF8Z+h9pCfA=; b=dWcgLrZoVDg62DirK77o+eC7x
        wxkOHptuRv34IPZg2fqfuDEf6hyMn/LD2xO3ZHyILpKXC4tM1ngwnCthGFgR2rIjAWHT/GVmnF51O
        1yda5LCb1txf0XlYovXt7RubaokJKOGKRXr5RJYNoU6VLvd89D8nCREMM4DgNYog35uIJ9vf3o3fh
        7QE0auEW8jgKa/i90HKXp8nCDU7WZS/tRqSRwAikitk5LLL048PsizIudFbJSH22Gj9cnwNvaivMz
        tlaUJ6NGTbuwHEderejD+yg0bd41IniWaRXaxxYQ/2IPEiBCBLImAfvTpBuinnxJV/lOdKBvzVuWu
        tvdK2oLSg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hU8DB-0007nx-Ar; Fri, 24 May 2019 11:18:09 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A486A2029B0A3; Fri, 24 May 2019 13:18:07 +0200 (CEST)
Date:   Fri, 24 May 2019 13:18:07 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, will.deacon@arm.com,
        aou@eecs.berkeley.edu, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, davem@davemloft.net, fenghua.yu@intel.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        ink@jurassic.park.msu.ru, jhogan@kernel.org, linux@armlinux.org.uk,
        mattst88@gmail.com, mingo@kernel.org, mpe@ellerman.id.au,
        palmer@sifive.com, paul.burton@mips.com, paulus@samba.org,
        ralf@linux-mips.org, rth@twiddle.net, stable@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, vgupta@synopsys.com,
        gregkh@linuxfoundation.org, jhansen@vmware.com, vdasa@vmware.com,
        aditr@vmware.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
Message-ID: <20190524111807.GS2650@hirez.programming.kicks-ass.net>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
 <20190523101926.GA3370@lakrids.cambridge.arm.com>
 <20190524103731.GN2606@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524103731.GN2606@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 12:37:31PM +0200, Peter Zijlstra wrote:
> On Thu, May 23, 2019 at 11:19:26AM +0100, Mark Rutland wrote:
> 
> > [mark@lakrids:~/src/linux]% git grep '\(return\|=\)\s\+atomic\(64\)\?_set'
> > include/linux/vmw_vmci_defs.h:  return atomic_set((atomic_t *)var, (u32)new_val);
> > include/linux/vmw_vmci_defs.h:  return atomic64_set(var, new_val);
> > 
> 
> Oh boy, what a load of crap you just did find.
> 
> How about something like the below? I've not read how that buffer is
> used, but the below preserves all broken without using atomic*_t.

Clarified by something along these lines?

---
 Documentation/atomic_t.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/atomic_t.txt b/Documentation/atomic_t.txt
index dca3fb0554db..125c95ddbbc0 100644
--- a/Documentation/atomic_t.txt
+++ b/Documentation/atomic_t.txt
@@ -83,6 +83,9 @@ The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
 implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
 smp_store_release() respectively.
 
+Therefore, if you find yourself only using the Non-RMW operations of atomic_t,
+you do not in fact need atomic_t at all and are doing it wrong.
+
 The one detail to this is that atomic_set{}() should be observable to the RMW
 ops. That is:
 
