Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A2F170CAA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 00:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgBZXjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 18:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgBZXjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 18:39:51 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72C3220658;
        Wed, 26 Feb 2020 23:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582760390;
        bh=DPuL42Ac68Bp5B6NVtAoWjXnKWpjAKeOpZ0w0H6U1kc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A07f4ZkkbOfDWwVakUEUj4izTXPaeHO/hqomgrI+VvzOc6An58wFiOvgYdlzj0EDG
         Ml6VkSihUDPMywCzFGYt133EBA6oTotjRt+CB9NCKGqhXqtRTbBDCWETL/iEjnVS0U
         LIX2lN8Q3YL/fp9e6cur5TBqraU98SASStlYkEB8=
Date:   Wed, 26 Feb 2020 18:39:49 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     andriy.shevchenko@linux.intel.com, kurt@linutronix.de,
        lirongqing@baidu.com, stable@vger.kernel.org, vikram.pandita@ti.com
Subject: Re: FAILED: patch "[PATCH] serial: 8250: Check UPF_IRQ_SHARED in
 advance" failed to apply to 4.14-stable tree
Message-ID: <20200226233949.GC22178@sasha-vm>
References: <158271336456142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158271336456142@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 11:36:04AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 7febbcbc48fc92e3f33863b32ed715ba4aff18c4 Mon Sep 17 00:00:00 2001
>From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Date: Tue, 11 Feb 2020 15:55:59 +0200
>Subject: [PATCH] serial: 8250: Check UPF_IRQ_SHARED in advance
>
>The commit 54e53b2e8081
>  ("tty: serial: 8250: pass IRQ shared flag to UART ports")
>nicely explained the problem:
>
>---8<---8<---
>
>On some systems IRQ lines between multiple UARTs might be shared. If so, the
>irqflags have to be configured accordingly. The reason is: The 8250 port startup
>code performs IRQ tests *before* the IRQ handler for that particular port is
>registered. This is performed in serial8250_do_startup(). This function checks
>whether IRQF_SHARED is configured and only then disables the IRQ line while
>testing.
>
>This test is performed upon each open() of the UART device. Imagine two UARTs
>share the same IRQ line: On is already opened and the IRQ is active. When the
>second UART is opened, the IRQ line has to be disabled while performing IRQ
>tests. Otherwise an IRQ might handler might be invoked, but the IRQ itself
>cannot be handled, because the corresponding handler isn't registered,
>yet. That's because the 8250 code uses a chain-handler and invokes the
>corresponding port's IRQ handling routines himself.
>
>Unfortunately this IRQF_SHARED flag isn't configured for UARTs probed via device
>tree even if the IRQs are shared. This way, the actual and shared IRQ line isn't
>disabled while performing tests and the kernel correctly detects a spurious
>IRQ. So, adding this flag to the DT probe solves the issue.
>
>Note: The UPF_SHARE_IRQ flag is configured unconditionally. Therefore, the
>IRQF_SHARED flag can be set unconditionally as well.
>
>Example stack trace by performing `echo 1 > /dev/ttyS2` on a non-patched system:
>
>|irq 85: nobody cared (try booting with the "irqpoll" option)
>| [...]
>|handlers:
>|[<ffff0000080fc628>] irq_default_primary_handler threaded [<ffff00000855fbb8>] serial8250_interrupt
>|Disabling IRQ #85
>
>---8<---8<---
>
>But unfortunately didn't fix the root cause. Let's try again here by moving
>IRQ flag assignment from serial_link_irq_chain() to serial8250_do_startup().
>
>This should fix the similar issue reported for 8250_pnp case.
>
>Since this change we don't need to have custom solutions in 8250_aspeed_vuart
>and 8250_of drivers, thus, drop them.
>
>Fixes: 1c2f04937b3e ("serial: 8250: add IRQ trigger support")
>Reported-by: Li RongQing <lirongqing@baidu.com>
>Cc: Kurt Kanzenbach <kurt@linutronix.de>
>Cc: Vikram Pandita <vikram.pandita@ti.com>
>Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Cc: stable <stable@vger.kernel.org>
>Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
>Link: https://lore.kernel.org/r/20200211135559.85960-1-andriy.shevchenko@linux.intel.com
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For 4.14, I've worked around these missing commits:

5909c0bf9c7a ("serial/aspeed-vuart: Implement quick throttle mechanism")
989983ea849d ("serial/aspeed-vuart: Implement rx throttling")
54e53b2e8081 ("tty: serial: 8250: pass IRQ shared flag to UART ports")

And queued up a backport. Older kernels are a bit trickier than that.

-- 
Thanks,
Sasha
