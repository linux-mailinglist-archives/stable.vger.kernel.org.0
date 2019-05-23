Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A096E27A34
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 12:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbfEWKTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 06:19:37 -0400
Received: from foss.arm.com ([217.140.101.70]:42386 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbfEWKTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 06:19:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DEBF341;
        Thu, 23 May 2019 03:19:36 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C8823F718;
        Thu, 23 May 2019 03:19:32 -0700 (PDT)
Date:   Thu, 23 May 2019 11:19:26 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        will.deacon@arm.com, aou@eecs.berkeley.edu, arnd@arndb.de,
        bp@alien8.de, catalin.marinas@arm.com, davem@davemloft.net,
        fenghua.yu@intel.com, heiko.carstens@de.ibm.com,
        herbert@gondor.apana.org.au, ink@jurassic.park.msu.ru,
        jhogan@kernel.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mingo@kernel.org, mpe@ellerman.id.au, palmer@sifive.com,
        paul.burton@mips.com, paulus@samba.org, ralf@linux-mips.org,
        rth@twiddle.net, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, vgupta@synopsys.com
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
Message-ID: <20190523101926.GA3370@lakrids.cambridge.arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523083013.GA4616@andrea>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 10:30:13AM +0200, Andrea Parri wrote:
> Hi Mark,

Hi Andrea,

> On Wed, May 22, 2019 at 02:22:32PM +0100, Mark Rutland wrote:
> > Currently architectures return inconsistent types for atomic64 ops. Some return
> > long (e..g. powerpc), some return long long (e.g. arc), and some return s64
> > (e.g. x86).
> 
> (only partially related, but probably worth asking:)
> 
> While reading the series, I realized that the following expression:
> 
> 	atomic64_t v;
>         ...
> 	typeof(v.counter) my_val = atomic64_set(&v, VAL);
> 
> is a valid expression on some architectures (in part., on architectures
> which #define atomic64_set() to WRITE_ONCE()) but is invalid on others.
> (This is due to the fact that WRITE_ONCE() can be used as an rvalue in
> the above assignment; TBH, I ignore the reasons for having such rvalue?)
> 
> IIUC, similar considerations hold for atomic_set().
> 
> The question is whether this is a known/"expected" inconsistency in the
> implementation of atomic64_set() or if this would also need to be fixed
> /addressed (say in a different patchset)?

In either case, I don't think the intent is that they should be used that way,
and from a quick scan, I can only fine a single relevant instance today:

[mark@lakrids:~/src/linux]% git grep '\(return\|=\)\s\+atomic\(64\)\?_set'
include/linux/vmw_vmci_defs.h:  return atomic_set((atomic_t *)var, (u32)new_val);
include/linux/vmw_vmci_defs.h:  return atomic64_set(var, new_val);


[mark@lakrids:~/src/linux]% git grep '=\s+atomic_set' | wc -l
0
[mark@lakrids:~/src/linux]% git grep '=\s+atomic64_set' | wc -l
0

Any architectures implementing arch_atomic_* will have both of these functions
returning void. Currently that's x86 and arm64, but (time permitting) I intend
to migrate other architectures, so I guess we'll have to fix the above up as
required.

I think it's best to avoid the construct above.

Thanks,
Mark.
