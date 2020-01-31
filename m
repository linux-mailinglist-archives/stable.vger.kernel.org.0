Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8039514EE27
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 15:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgAaOEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 09:04:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43528 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbgAaOEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 09:04:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XBHh8Jcg5JcYYWEBA1VUeT5BCvY8QB1ar+PJ8lieNiY=; b=fDqrWDdq+x30ocPMDCy6nhXtjN
        usL85bsjhKI/f9+JZXciry2vi6BdtELy+r9YDzliX2vIQXSx2IHbLbOPRzDIXJEZXMAzOjKBzFBJ6
        EeMrDoHD8hOFqZlO11bvmjMS3Qkzh+5wiP2G9YOm8/nxXY+oyJwHpyuqWUXn+FbvTyiNClLawLnyc
        wDoIwaEoY/rblI77ir+BJGuaqAMx1458ECd5ssz+Hnvtk/AvJT0I2bMeBtH6CI+yfXI0eCSZ9mJ+d
        AI4c0NtHG6vhYktms6P/z3cAFbJVauVwIAiudeT/t1Wvu5UzOl6aHvSFupxs6vst1uZlQOpRz0aXU
        cy6eUO4A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixWtg-0004tq-AO; Fri, 31 Jan 2020 14:03:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 48F1E3007F2;
        Fri, 31 Jan 2020 15:02:01 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CCCA42024716E; Fri, 31 Jan 2020 15:03:44 +0100 (CET)
Date:   Fri, 31 Jan 2020 15:03:44 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 36/55] drivers/net/b44: Change to non-atomic bit
 operations on pwol_mask
Message-ID: <20200131140344.GE14914@hirez.programming.kicks-ass.net>
References: <20200130183608.563083888@linuxfoundation.org>
 <20200130183615.120752961@linuxfoundation.org>
 <20200131125730.GA20888@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200131125730.GA20888@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 01:57:31PM +0100, Pavel Machek wrote:
> On Thu 2020-01-30 19:39:17, Greg Kroah-Hartman wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >=20
> > [ Upstream commit f11421ba4af706cb4f5703de34fa77fba8472776 ]
>=20
> This is not suitable for stable. It does not fix anything.

It fixes the code for BE at the very least.

> It prepares
> for theoretical bug that author claims might be introduced to BIOS in
> future... I doubt it, even BIOS authors boot their machines from time
> to time.

BIOS authors might not enable this (optional) feature.

> > Atomic operations that span cache lines are super-expensive on x86
> > (not just to the current processor, but also to other processes as all
> > memory operations are blocked until the operation completes). Upcoming
> > x86 processors have a switch to cause such operations to generate a #AC
> > trap. It is expected that some real time systems will enable this mode
> > in BIOS.
>=20
> And I wonder if this is even good idea for mainline. x86 architecture
> is here for long time, and I doubt Intel is going to break it like
> this. Do you have documentation pointer?=20

Or you could, you know, like google it. Try "intel split lock
detection". It is a feature the OS can enable which will result in #AC
exceptions when memops to LOCK prefixed instructions are not properly
aligned (because their performance sucks and it impacts execution across
the machine, not just the local CPU).

> > In preparation for this, it is necessary to fix code that may execute
> > atomic instructions with operands that cross cachelines because the #AC
> > trap will crash the kernel.
>=20
> How does single bit operation "cross cacheline"? How is this going to
> impact non-x86 architectures?

The actual instruction is "LOCK BTSQ", which is a 64bit wide instruction
(LOCK BTSL on 32bit kernels). The memory operand of that instruction is
(stupidly IMO) allowed to be non aligned.

Any sane architecture (ie, pretty much everyone else) will already trap
when you try unaligned atomic ops (or even unaligned anything for most
RISCs).

> > Since "pwol_mask" is local and never exposed to concurrency, there is
> > no need to set bits in pwol_mask using atomic operations.
> >=20
> > Directly operate on the byte which contains the bit instead of using
> > __set_bit() to avoid any big endian concern due to type cast to
> > unsigned long in __set_bit().
>=20
> What concerns? Is __set_bit() now useless and are we going to open-code
> it everywhere? Is set_bit() now unusable on x86?

As David already explained, the bitops are defined on long[], are
employed on u8[] here (clue the (unsigned long *) cast) and would do
completely the wrong thing on BE.

set_bit() works as advertised when used as specified; on long[].
