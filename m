Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22669CBC34
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388662AbfJDNt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 09:49:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:51321 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388625AbfJDNt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 09:49:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 06:49:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,256,1566889200"; 
   d="scan'208";a="198860595"
Received: from feng-iot.sh.intel.com (HELO localhost) ([10.239.13.115])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Oct 2019 06:49:19 -0700
Date:   Fri, 4 Oct 2019 21:51:48 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Will Deacon <will@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, contact@xogium.me
Subject: Re: [PATCH] panic: Ensure preemption is disabled during panic()
Message-ID: <20191004135148.GB25371@feng-iot>
References: <20191002123538.22609-1-will@kernel.org>
 <201910021355.E578D2FFAF@keescook>
 <20191003205633.w26geqhq67u4ysit@willie-the-truck>
 <20191004091142.57iylai22aqpu6lu@pathway.suse.cz>
 <20191004092917.GY25745@shell.armlinux.org.uk>
 <20191004104947.vbxe5kv3nbjxqs55@willie-the-truck>
 <20191004111521.y6iera4eico6ezfq@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004111521.y6iera4eico6ezfq@pathway.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 01:15:21PM +0200, Petr Mladek wrote:
> On Fri 2019-10-04 11:49:48, Will Deacon wrote:
> > On Fri, Oct 04, 2019 at 10:29:17AM +0100, Russell King - ARM Linux admin wrote:
> > > On Fri, Oct 04, 2019 at 11:11:42AM +0200, Petr Mladek wrote:
> > > > On Thu 2019-10-03 21:56:34, Will Deacon wrote:
> > > > > I've deliberately left the irq part alone, since I think
> > > > > having magic sysrq work via the keyboard interrupt is desirable from the
> > > > > panic loop.
> > > > 
> > > > I agree that we should keep sysrq working.
> > > > 
> > > > One pity thing is that led_panic_blink() in
> > > > leds/drivers/trigger/ledtrig-panic.c uses workqueues:
> > > > 
> > > >   + led_panic_blink()
> > > >     + led_trigger_event()
> > > >       + led_set_brightness()
> > > > 	+ schedule_work()
> > > > 
> > > > It means that it depends on the scheduler. I guess that it
> > > > does not work in many panic situations. But this patch
> > > > will always block it.
> > > > 
> > > > I agree that it is strange that userspace still works at
> > > > this stage. But does it cause any real problems?
> > > 
> > > Yes, there are watchdog drivers that continue to pat their watchdog
> > > after the kernel has panic'd.  It makes watchdogs useless (which is
> > > exactly how this problem was discovered.)
> > 
> > Indeed, and I think the LED blinking is already unreliable if the
> > brightness operation needs to sleep. For example, if the kernel isn't
> > preemptible or the work gets queued up on a different CPU which is
> > sitting in panic_smp_self_stop().
> 
> To make it clear. I do not want to block this patch. I just wanted
> to point out the problem. I am not sure how the blinking is important
> these days. Well, I could imagine that it might be useful on some
> embedded devices.

When reviewing the c39ea0b9dd24 ("panic: avoid the extra noise dmesg"),
there was similar discussion about what's the expectation for kernel
when panic happens, as the earlier version patch is simply keeping the
the local irq disabled, which may break the sysrq and the panic blink
code, so we turned to handling it together with printk.

> 
> Another question is how many people want to end up with dead system
> these days. The watchdogs are likely used in data centers. I guess
> that automatic reboot in panic() is a better choice there.
> 
> Anyway, it might make sense to remove the panic blinking code when
> it will not have a chance to work.

I was also wondering if the panic blinking code still really works
on any platforms.

Thanks,
Feng

> 
> Best Regards,
> Petr
