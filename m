Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254BBCB713
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfJDJLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:11:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:53964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730921AbfJDJLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:11:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9FDC6AEFB;
        Fri,  4 Oct 2019 09:11:43 +0000 (UTC)
Date:   Fri, 4 Oct 2019 11:11:42 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Will Deacon <will@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Russell King <linux@armlinux.org.uk>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, contact@xogium.me
Subject: Re: [PATCH] panic: Ensure preemption is disabled during panic()
Message-ID: <20191004091142.57iylai22aqpu6lu@pathway.suse.cz>
References: <20191002123538.22609-1-will@kernel.org>
 <201910021355.E578D2FFAF@keescook>
 <20191003205633.w26geqhq67u4ysit@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003205633.w26geqhq67u4ysit@willie-the-truck>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 2019-10-03 21:56:34, Will Deacon wrote:
> Hi Kees,
> 
> On Wed, Oct 02, 2019 at 01:58:46PM -0700, Kees Cook wrote:
> > On Wed, Oct 02, 2019 at 01:35:38PM +0100, Will Deacon wrote:
> > > Calling 'panic()' on a kernel with CONFIG_PREEMPT=y can leave the
> > > calling CPU in an infinite loop, but with interrupts and preemption
> > > enabled. From this state, userspace can continue to be scheduled,
> > > despite the system being "dead" as far as the kernel is concerned. This
> > > is easily reproducible on arm64 when booting with "nosmp" on the command
> > > line; a couple of shell scripts print out a periodic "Ping" message
> > > whilst another triggers a crash by writing to /proc/sysrq-trigger:
> > > 
> > >   | sysrq: Trigger a crash
> > >   | Kernel panic - not syncing: sysrq triggered crash
> > >   | CPU: 0 PID: 1 Comm: init Not tainted 5.2.15 #1
> > >   | Hardware name: linux,dummy-virt (DT)
> > >   | Call trace:
> > >   |  dump_backtrace+0x0/0x148
> > >   |  show_stack+0x14/0x20
> > >   |  dump_stack+0xa0/0xc4
> > >   |  panic+0x140/0x32c
> > >   |  sysrq_handle_reboot+0x0/0x20
> > >   |  __handle_sysrq+0x124/0x190
> > >   |  write_sysrq_trigger+0x64/0x88
> > >   |  proc_reg_write+0x60/0xa8
> > >   |  __vfs_write+0x18/0x40
> > >   |  vfs_write+0xa4/0x1b8
> > >   |  ksys_write+0x64/0xf0
> > >   |  __arm64_sys_write+0x14/0x20
> > >   |  el0_svc_common.constprop.0+0xb0/0x168
> > >   |  el0_svc_handler+0x28/0x78
> > >   |  el0_svc+0x8/0xc
> > >   | Kernel Offset: disabled
> > >   | CPU features: 0x0002,24002004
> > >   | Memory Limit: none
> > >   | ---[ end Kernel panic - not syncing: sysrq triggered crash ]---
> > >   |  Ping 2!
> > >   |  Ping 1!
> > >   |  Ping 1!
> > >   |  Ping 2!
> > > 
> > > The issue can also be triggered on x86 kernels if CONFIG_SMP=n, otherwise
> > > local interrupts are disabled in 'smp_send_stop()'.
> > > 
> > > Disable preemption in 'panic()' before re-enabling interrupts.
> > 
> > Is this perhaps the correct solution for what commit c39ea0b9dd24 ("panic:
> > avoid the extra noise dmesg") was trying to fix?
> 
> Hmm, maybe, although that looks like it's focussed more on irq handling
> than preemption.

Exactly, the backtrace mentioned in commit c39ea0b9dd24 ("panic: avoid
the extra noise dmesg") is printed by wake_up() called from
wake_up_klogd_work_func(). It is irq_work. Therefore disabling
preemption would not prevent this.


> I've deliberately left the irq part alone, since I think
> having magic sysrq work via the keyboard interrupt is desirable from the
> panic loop.

I agree that we should keep sysrq working.

One pity thing is that led_panic_blink() in
leds/drivers/trigger/ledtrig-panic.c uses workqueues:

  + led_panic_blink()
    + led_trigger_event()
      + led_set_brightness()
	+ schedule_work()

It means that it depends on the scheduler. I guess that it
does not work in many panic situations. But this patch
will always block it.

I agree that it is strange that userspace still works at
this stage. But does it cause any real problems?

Best Regards,
Petr
