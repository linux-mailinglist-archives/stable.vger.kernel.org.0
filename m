Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62310CB8A0
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 12:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfJDKty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 06:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbfJDKty (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 06:49:54 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 400C32133F;
        Fri,  4 Oct 2019 10:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570186193;
        bh=xrkcnenMAd2SVSf4T8S4GK2Q1eCTRcWLOsgnec3I/Wc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bwXio5FNvRtjyQbr6QsEPS/7Zevucaa0XLXZgDPzBj1LBpOQ5canyxrae64OIAOb+
         7X1SMeVBocFDDBLHN1yQyzfWEEl6hnnh+paV5Hszomp9e9VcZ9F5sunFCUQ7PvJy5s
         hzZKIRZqJaI25vdusBp5zvXwcpqHE2j4DLX6iato=
Date:   Fri, 4 Oct 2019 11:49:48 +0100
From:   Will Deacon <will@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, contact@xogium.me
Subject: Re: [PATCH] panic: Ensure preemption is disabled during panic()
Message-ID: <20191004104947.vbxe5kv3nbjxqs55@willie-the-truck>
References: <20191002123538.22609-1-will@kernel.org>
 <201910021355.E578D2FFAF@keescook>
 <20191003205633.w26geqhq67u4ysit@willie-the-truck>
 <20191004091142.57iylai22aqpu6lu@pathway.suse.cz>
 <20191004092917.GY25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004092917.GY25745@shell.armlinux.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 10:29:17AM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Oct 04, 2019 at 11:11:42AM +0200, Petr Mladek wrote:
> > On Thu 2019-10-03 21:56:34, Will Deacon wrote:
> > > I've deliberately left the irq part alone, since I think
> > > having magic sysrq work via the keyboard interrupt is desirable from the
> > > panic loop.
> > 
> > I agree that we should keep sysrq working.
> > 
> > One pity thing is that led_panic_blink() in
> > leds/drivers/trigger/ledtrig-panic.c uses workqueues:
> > 
> >   + led_panic_blink()
> >     + led_trigger_event()
> >       + led_set_brightness()
> > 	+ schedule_work()
> > 
> > It means that it depends on the scheduler. I guess that it
> > does not work in many panic situations. But this patch
> > will always block it.
> > 
> > I agree that it is strange that userspace still works at
> > this stage. But does it cause any real problems?
> 
> Yes, there are watchdog drivers that continue to pat their watchdog
> after the kernel has panic'd.  It makes watchdogs useless (which is
> exactly how this problem was discovered.)

Indeed, and I think the LED blinking is already unreliable if the
brightness operation needs to sleep. For example, if the kernel isn't
preemptible or the work gets queued up on a different CPU which is
sitting in panic_smp_self_stop().

Will
