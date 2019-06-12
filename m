Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFB042983
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 16:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392033AbfFLOiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 10:38:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55672 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2392070AbfFLOiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 10:38:12 -0400
Received: (qmail 3180 invoked by uid 2102); 12 Jun 2019 10:38:11 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 12 Jun 2019 10:38:11 -0400
Date:   Wed, 12 Jun 2019 10:38:11 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Soeren Moch <smoch@web.de>
cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
In-Reply-To: <fb64b378-57a1-19f4-0fd2-1689fc3d8540@web.de>
Message-ID: <Pine.LNX.4.44L0.1906121033550.1557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Jun 2019, Soeren Moch wrote:

> On 01.06.19 13:02, Sebastian Andrzej Siewior wrote:
> > On 2019-06-01 12:50:08 [+0200], To Soeren Moch wrote:
> >> I will look into this.
> >
> > nothing obvious. If there is really blocken lock, could you please
> > enable lockdep
> > |CONFIG_LOCK_DEBUGGING_SUPPORT=y
> > |CONFIG_PROVE_LOCKING=y
> > |# CONFIG_LOCK_STAT is not set
> > |CONFIG_DEBUG_RT_MUTEXES=y
> > |CONFIG_DEBUG_SPINLOCK=y
> > |CONFIG_DEBUG_MUTEXES=y
> > |CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
> > |CONFIG_DEBUG_RWSEMS=y
> > |CONFIG_DEBUG_LOCK_ALLOC=y
> > |CONFIG_LOCKDEP=y
> > |# CONFIG_DEBUG_LOCKDEP is not set
> > |CONFIG_DEBUG_ATOMIC_SLEEP=y
> >
> > and send me the splat that lockdep will report?
> >
> 
> Nothing interesting:
> 
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 5.1.0 (root@matrix) (gcc version 7.4.0
> (Debian 7.4.0-6)) #6 SMP PREEMPT Wed Jun 12 11:28:41 CEST 2019
> [    0.000000] CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7),
> cr=10c5387d
> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
> instruction cache
> [    0.000000] OF: fdt: Machine model: TBS2910 Matrix ARM mini PC
> ...
> [    0.000000] rcu: Preemptible hierarchical RCU implementation.
> [    0.000000] rcu:     RCU lockdep checking is enabled.
> ...
> [    0.003546] Lock dependency validator: Copyright (c) 2006 Red Hat,
> Inc., Ingo Molnar
> [    0.003657] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.003713] ... MAX_LOCK_DEPTH:          48
> [    0.003767] ... MAX_LOCKDEP_KEYS:        8191
> [    0.003821] ... CLASSHASH_SIZE:          4096
> [    0.003876] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.003931] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.003986] ... CHAINHASH_SIZE:          32768
> [    0.004042]  memory used by lock dependency info: 5243 kB
> 
> Nothing else.
> 
> When stopping hostapd after it hangs:
> [  903.504475] ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue
> 14 failed to flush

Instead of reverting the original commit, can you prevent the problem 
by adding local_irq_save() and local_irq_restore() to the URB 
completion routines in that wireless driver?

Probably people who aren't already pretty familiar with the driver code
won't easily be able to locate the race.  Still, a little overkill may
be an acceptable solution.

Alan Stern

