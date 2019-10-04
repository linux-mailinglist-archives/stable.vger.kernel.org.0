Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CBFCB8F2
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 13:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbfJDLP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 07:15:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:37160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbfJDLP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 07:15:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF9F0ACEC;
        Fri,  4 Oct 2019 11:15:24 +0000 (UTC)
Date:   Fri, 4 Oct 2019 13:15:21 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Will Deacon <will@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, contact@xogium.me
Subject: Re: [PATCH] panic: Ensure preemption is disabled during panic()
Message-ID: <20191004111521.y6iera4eico6ezfq@pathway.suse.cz>
References: <20191002123538.22609-1-will@kernel.org>
 <201910021355.E578D2FFAF@keescook>
 <20191003205633.w26geqhq67u4ysit@willie-the-truck>
 <20191004091142.57iylai22aqpu6lu@pathway.suse.cz>
 <20191004092917.GY25745@shell.armlinux.org.uk>
 <20191004104947.vbxe5kv3nbjxqs55@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004104947.vbxe5kv3nbjxqs55@willie-the-truck>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 2019-10-04 11:49:48, Will Deacon wrote:
> On Fri, Oct 04, 2019 at 10:29:17AM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Oct 04, 2019 at 11:11:42AM +0200, Petr Mladek wrote:
> > > On Thu 2019-10-03 21:56:34, Will Deacon wrote:
> > > > I've deliberately left the irq part alone, since I think
> > > > having magic sysrq work via the keyboard interrupt is desirable from the
> > > > panic loop.
> > > 
> > > I agree that we should keep sysrq working.
> > > 
> > > One pity thing is that led_panic_blink() in
> > > leds/drivers/trigger/ledtrig-panic.c uses workqueues:
> > > 
> > >   + led_panic_blink()
> > >     + led_trigger_event()
> > >       + led_set_brightness()
> > > 	+ schedule_work()
> > > 
> > > It means that it depends on the scheduler. I guess that it
> > > does not work in many panic situations. But this patch
> > > will always block it.
> > > 
> > > I agree that it is strange that userspace still works at
> > > this stage. But does it cause any real problems?
> > 
> > Yes, there are watchdog drivers that continue to pat their watchdog
> > after the kernel has panic'd.  It makes watchdogs useless (which is
> > exactly how this problem was discovered.)
> 
> Indeed, and I think the LED blinking is already unreliable if the
> brightness operation needs to sleep. For example, if the kernel isn't
> preemptible or the work gets queued up on a different CPU which is
> sitting in panic_smp_self_stop().

To make it clear. I do not want to block this patch. I just wanted
to point out the problem. I am not sure how the blinking is important
these days. Well, I could imagine that it might be useful on some
embedded devices.

Another question is how many people want to end up with dead system
these days. The watchdogs are likely used in data centers. I guess
that automatic reboot in panic() is a better choice there.

Anyway, it might make sense to remove the panic blinking code when
it will not have a chance to work.

Best Regards,
Petr
