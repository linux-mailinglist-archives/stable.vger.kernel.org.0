Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0285624CB36
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 05:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHUDQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 23:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgHUDQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 23:16:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D181C061385;
        Thu, 20 Aug 2020 20:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=oAY+ROTTJJQR3iPt2JQ1lkA+1apv58uojBryWs9cKTI=; b=u4QxWI9+OygIHweKPZ0qOgSPo+
        /2ZTVwnRxGyCx6Os/OuTPgCurrTCIxVxEIIk+PbtpqSGDofOzC0du6gg3H8F3SGsuZaz73irPEBwc
        rjqOvVdED9O6+UflvW2ZkYQNK+GjE9wWHAkUXLzqajIB9PslSJpt7ibnt47hLlPGogrDVqh5vXdtv
        bICjSZU346tdrMEz/YTVtLlrAdZUU7eM6MBEaJirkRmiqAGmp4hRtcP+xkEjPhBHEVdmRqzFCZo4n
        oHuPbS2VSelA/DwU3edOk8+xJaFPgadZyhfGdB4BUG/rS/mNFhEk6zKPxUYvOJ1O/GVLsVZrYirSC
        u0jjYsMg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8xXd-0007pr-2E; Fri, 21 Aug 2020 03:16:33 +0000
Subject: Re: [PATCH v2] x86/hotplug: Silence APIC only after all irq's are
 migrated
To:     Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Sukumar Ghorai <sukumar.ghorai@intel.com>,
        Srikanth Nandamuri <srikanth.nandamuri@intel.com>,
        Evan Green <evgreen@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
References: <1597970523-24797-1-git-send-email-ashok.raj@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <595d331e-59f3-309c-a25d-f92c8aafb812@infradead.org>
Date:   Thu, 20 Aug 2020 20:16:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597970523-24797-1-git-send-email-ashok.raj@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 5:42 PM, Ashok Raj wrote:
> When offlining CPUs, fixup_irqs() migrates all interrupts away from the
> outgoing CPU to an online CPU. It's always possible the device sent an
> interrupt to the previous CPU destination. Pending interrupt bit in IRR in
> LAPIC identifies such interrupts. apic_soft_disable() will not capture any
> new interrupts in IRR. This causes interrupts from device to be lost during
> CPU offline. The issue was found when explicitly setting MSI affinity to a
> CPU and immediately offlining it. It was simple to recreate with a USB
> ethernet device and doing I/O to it while the CPU is offlined. Lost
> interrupts happen even when Interrupt Remapping is enabled.
> 
> Current code does apic_soft_disable() before migrating interrupts.
> 
> native_cpu_disable()
> {
> 	...
> 	apic_soft_disable();
> 	cpu_disable_common();
> 	  --> fixup_irqs(); // Too late to capture anything in IRR.
> }
> 
> Just flipping the above call sequence seems to hit the IRR checks
> and the lost interrupt is fixed for both legacy MSI and when
> interrupt remapping is enabled.
> 
> Fixes: 60dcaad5736f ("x86/hotplug: Silence APIC and NMI when CPU is dead")
> Link: https://lore.kernel.org/lkml/875zdarr4h.fsf@nanos.tec.linutronix.de/
> Reported-by: Evan Green <evgreen@chromium.org>
> Tested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Tested-by: Evan Green <evgreen@chromium.org>
> Reviewed-by: Evan Green <evgreen@chromium.org>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> ---
> v2:
> - Typos and fixes suggested by Randy Dunlap

Those all look good now.  Thanks for the update.

> To: linux-kernel@vger.kernel.org
> To: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sukumar Ghorai <sukumar.ghorai@intel.com>
> Cc: Srikanth Nandamuri <srikanth.nandamuri@intel.com>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/smpboot.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)


-- 
~Randy

