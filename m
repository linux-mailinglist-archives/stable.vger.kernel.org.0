Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87097728
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 12:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfHUKaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 06:30:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfHUKaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 06:30:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8zp6S8Iv44NclUZi/IYCMzStVxccs6F1yCeJgKpoeH8=; b=a8L4Dq/aCr8gnwdzhMMrkGdX9
        BskOgh+y9z0CTn/F6FSad/M/j6HHWwSy+ZqDnBzj2u9kTLwcuN+giohlH1nNtFjtmDXxRrhKefmHh
        h3qH1yWlfgZLsJgrTF1Jji/uRxBau28zxmgLoHgetvsX4/H+sMV0xcrdLMQBHff1NKbICi8qAPKGn
        g1arbtzq1HcniDUYbJmejwx1T4KCm+SZ810uMKz+he2jHRV8m3cQ8/CGnv74ayQk2zCYXNzVVIc+s
        GdbdE0i7qc8DbfiHZW6VtwVNAUstNyfONn1rY7sDd/CJCG6pLDgSHje1hhbG4sI0it+T37usnkOOc
        fCNzqpNUw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i0Nsb-0002wj-V1; Wed, 21 Aug 2019 10:30:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 23ED2306B81;
        Wed, 21 Aug 2019 12:29:39 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BA91920A21FC4; Wed, 21 Aug 2019 12:30:10 +0200 (CEST)
Date:   Wed, 21 Aug 2019 12:30:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-team@fb.com, stable@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
Message-ID: <20190821103010.GJ2386@hirez.programming.kicks-ass.net>
References: <20190820202314.1083149-1-songliubraving@fb.com>
 <20190821101008.GX2349@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821101008.GX2349@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 21, 2019 at 12:10:08PM +0200, Peter Zijlstra wrote:
> On Tue, Aug 20, 2019 at 01:23:14PM -0700, Song Liu wrote:

> > host-5.2-after # grep "x  pmd" /sys/kernel/debug/page_tables/dump_pid
> > 0x0000000000600000-0x0000000000e00000           8M USR ro         PSE         x  pmd
> > 0xffffffff81000000-0xffffffff81e00000          14M     ro         PSE     GLB x  pmd
> > 
> > So after this patch, the 5.2 based kernel has 7 PMDs instead of 1 PMD
> > in 4.16 kernel.
> 
> This basically gives rise to more questions than it provides answers.
> You seem to have 'forgotten' to provide the equivalent mappings on the
> two older kernels. The fact that they're not PMD is evident, but it
> would be very good to know what is mapped, and what -- if anything --
> lives in the holes we've (accidentally) created.
> 
> Can you please provide more complete mappings? Basically provide the
> whole cpu_entry_area mapping.

I tried on my local machine and:

  cat /debug/page_tables/kernel | awk '/^---/ { p=0 } /CPU entry/ { p=1 } { if (p) print $0 }' > ~/cea-{before,after}.txt

resulted in _identical_ files ?!?!

Can you share your before and after dumps?
