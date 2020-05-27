Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6161E3B3A
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgE0IJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbgE0IJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 04:09:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CBFD20FC3;
        Wed, 27 May 2020 08:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590566986;
        bh=75qOp4dQIOYfaLlRNroM43f7CQ5NQA6BK7Z1FNB3fWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q36g94b+zVXLZrH0uWcSYzYJlDbH8L9aPOmbwIyls5bsJVsKfl1HD2ek0r0oKABpg
         xC6sAcqCDLSC6lplD/UDW94OZ7t1yR7Vh+T0+JCiBCnR1MyTR/5Dgm71WsDkCfFSH7
         UU+p/B++1IEf5ly86njJAkEjs79l0v2dcIXHmwa0=
Date:   Wed, 27 May 2020 10:09:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, lvenanci@redhat.com,
        torvalds@linux-foundation.org, efault@gmx.de, riel@redhat.com,
        tglx@linutronix.de, lwang@redhat.com, mingo@kernel.org,
        daniel.m.jordan@oracle.com, sashal@kernel.org
Subject: Re: [PATCH 4.4 26/65] sched/fair, cpumask: Export for_each_cpu_wrap()
Message-ID: <20200527080944.GB119903@kroah.com>
References: <20200526183905.988782958@linuxfoundation.org>
 <20200526183915.976645661@linuxfoundation.org>
 <OSBPR01MB29836310986EC6E2E132A02F92B10@OSBPR01MB2983.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB29836310986EC6E2E132A02F92B10@OSBPR01MB2983.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 07:50:56AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> Hi,
> 
> > -----Original Message-----
> > From: stable-owner@vger.kernel.org [mailto:stable-owner@vger.kernel.org] On Behalf Of Greg Kroah-Hartman
> > Sent: Wednesday, May 27, 2020 3:53 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; stable@vger.kernel.org; Peter Zijlstra (Intel)
> > <peterz@infradead.org>; Lauro Ramos Venancio <lvenanci@redhat.com>; Linus Torvalds <torvalds@linux-foundation.org>;
> > Mike Galbraith <efault@gmx.de>; Rik van Riel <riel@redhat.com>; Thomas Gleixner <tglx@linutronix.de>;
> > lwang@redhat.com; Ingo Molnar <mingo@kernel.org>; Daniel Jordan <daniel.m.jordan@oracle.com>; Sasha Levin
> > <sashal@kernel.org>
> > Subject: [PATCH 4.4 26/65] sched/fair, cpumask: Export for_each_cpu_wrap()	
> > 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > [ Upstream commit c743f0a5c50f2fcbc628526279cfa24f3dabe182 ]
> > 
> > More users for for_each_cpu_wrap() have appeared. Promote the construct
> > to generic cpumask interface.
> > 
> > The implementation is slightly modified to reduce arguments.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: Lauro Ramos Venancio <lvenanci@redhat.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: lwang@redhat.com
> > Link: http://lkml.kernel.org/r/20170414122005.o35me2h5nowqkxbv@hirez.programming.kicks-ass.net
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > [dj: include only what's added to the cpumask interface, 4.4 doesn't
> >      have them in the scheduler]
> > Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  include/linux/cpumask.h | 17 +++++++++++++++++
> >  lib/cpumask.c           | 32 ++++++++++++++++++++++++++++++++
> >  2 files changed, 49 insertions(+)
> 
> This commit also needs the following commits:
> 
> commit d207af2eab3f8668b95ad02b21930481c42806fd
> Author: Michael Kelley <mhkelley@outlook.com>
> Date:   Wed Feb 14 02:54:03 2018 +0000
> 
>     cpumask: Make for_each_cpu_wrap() available on UP as well
>     
>     for_each_cpu_wrap() was originally added in the #else half of a
>     large "#if NR_CPUS == 1" statement, but was omitted in the #if
>     half.  This patch adds the missing #if half to prevent compile
>     errors when NR_CPUS is 1.
>     
>     Reported-by: kbuild test robot <fengguang.wu@intel.com>
>     Signed-off-by: Michael Kelley <mhkelley@outlook.com>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Cc: kys@microsoft.com
>     Cc: martin.petersen@oracle.com
>     Cc: mikelley@microsoft.com
>     Fixes: c743f0a5c50f ("sched/fair, cpumask: Export for_each_cpu_wrap()")
>     Link: http://lkml.kernel.org/r/SN6PR1901MB2045F087F59450507D4FCC17CBF50@SN6PR1901MB2045.namprd19.prod.outlook.com
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Please apply this commit.

Good catch, now queued up, thanks.

greg k-h
