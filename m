Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E01CCB08F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 22:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbfJCU4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 16:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbfJCU4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 16:56:40 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 326B52086A;
        Thu,  3 Oct 2019 20:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570136199;
        bh=/p2jgYyOKcT9NYTQ/y2vi1K03zHRZaCjHgBMcuIA54o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uh2i/RKe7vbkxGt9MPDSea8a7B4iyrsw++G1FHTY47Wn3h2UBcIoLtTZ3bQJOJ59W
         LzQ4oBh/bNsfGim3b16sm5uDUTwtHowBnabsmhvqqwKi4xZzKgCwJbFWQvpE3prVIs
         JodR3BxpISXiGhTxbVuKjqR7WN9m4S0Nx2poVtAQ=
Date:   Thu, 3 Oct 2019 21:56:34 +0100
From:   Will Deacon <will@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        contact@xogium.me, Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] panic: Ensure preemption is disabled during panic()
Message-ID: <20191003205633.w26geqhq67u4ysit@willie-the-truck>
References: <20191002123538.22609-1-will@kernel.org>
 <201910021355.E578D2FFAF@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201910021355.E578D2FFAF@keescook>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kees,

On Wed, Oct 02, 2019 at 01:58:46PM -0700, Kees Cook wrote:
> On Wed, Oct 02, 2019 at 01:35:38PM +0100, Will Deacon wrote:
> > Calling 'panic()' on a kernel with CONFIG_PREEMPT=y can leave the
> > calling CPU in an infinite loop, but with interrupts and preemption
> > enabled. From this state, userspace can continue to be scheduled,
> > despite the system being "dead" as far as the kernel is concerned. This
> > is easily reproducible on arm64 when booting with "nosmp" on the command
> > line; a couple of shell scripts print out a periodic "Ping" message
> > whilst another triggers a crash by writing to /proc/sysrq-trigger:
> > 
> >   | sysrq: Trigger a crash
> >   | Kernel panic - not syncing: sysrq triggered crash
> >   | CPU: 0 PID: 1 Comm: init Not tainted 5.2.15 #1
> >   | Hardware name: linux,dummy-virt (DT)
> >   | Call trace:
> >   |  dump_backtrace+0x0/0x148
> >   |  show_stack+0x14/0x20
> >   |  dump_stack+0xa0/0xc4
> >   |  panic+0x140/0x32c
> >   |  sysrq_handle_reboot+0x0/0x20
> >   |  __handle_sysrq+0x124/0x190
> >   |  write_sysrq_trigger+0x64/0x88
> >   |  proc_reg_write+0x60/0xa8
> >   |  __vfs_write+0x18/0x40
> >   |  vfs_write+0xa4/0x1b8
> >   |  ksys_write+0x64/0xf0
> >   |  __arm64_sys_write+0x14/0x20
> >   |  el0_svc_common.constprop.0+0xb0/0x168
> >   |  el0_svc_handler+0x28/0x78
> >   |  el0_svc+0x8/0xc
> >   | Kernel Offset: disabled
> >   | CPU features: 0x0002,24002004
> >   | Memory Limit: none
> >   | ---[ end Kernel panic - not syncing: sysrq triggered crash ]---
> >   |  Ping 2!
> >   |  Ping 1!
> >   |  Ping 1!
> >   |  Ping 2!
> > 
> > The issue can also be triggered on x86 kernels if CONFIG_SMP=n, otherwise
> > local interrupts are disabled in 'smp_send_stop()'.
> > 
> > Disable preemption in 'panic()' before re-enabling interrupts.
> 
> Is this perhaps the correct solution for what commit c39ea0b9dd24 ("panic:
> avoid the extra noise dmesg") was trying to fix?

Hmm, maybe, although that looks like it's focussed more on irq handling
than preemption. I've deliberately left the irq part alone, since I think
having magic sysrq work via the keyboard interrupt is desirable from the
panic loop.

> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

Will
