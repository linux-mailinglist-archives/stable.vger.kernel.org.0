Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9514C939C
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 23:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfJBVqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 17:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbfJBVqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 17:46:00 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25B7217D7;
        Wed,  2 Oct 2019 21:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570052759;
        bh=O7NvbZugYvMLZ/+OzzjuvSo6dEQ9WQ3OuCN4ONY0600=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IoJhq4Pv0UhAVg1ket7V7IvKUNoWBUnQpaVqvxZCay/k28RCXEZQxTzXpCbrPbPME
         cgkeE7CWmXA8qmksbohVGhqJPnTg7I3v9HBgfbHffqP5+Ygdrbzc8YDtX+LZlPMol+
         KmZyg78A51sNcAs9ORccMZAsCuWoBGBtM3/Z25FY=
Date:   Wed, 2 Oct 2019 14:45:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        contact@xogium.me, Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH] panic: Ensure preemption is disabled during panic()
Message-Id: <20191002144558.87531ea9f68b535453fedd3e@linux-foundation.org>
In-Reply-To: <20191002123538.22609-1-will@kernel.org>
References: <20191002123538.22609-1-will@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed,  2 Oct 2019 13:35:38 +0100 Will Deacon <will@kernel.org> wrote:

> Calling 'panic()' on a kernel with CONFIG_PREEMPT=y can leave the
> calling CPU in an infinite loop, but with interrupts and preemption
> enabled. From this state, userspace can continue to be scheduled,
> despite the system being "dead" as far as the kernel is concerned. This
> is easily reproducible on arm64 when booting with "nosmp" on the command
> line; a couple of shell scripts print out a periodic "Ping" message
> whilst another triggers a crash by writing to /proc/sysrq-trigger:
> 
>   | sysrq: Trigger a crash
>   | Kernel panic - not syncing: sysrq triggered crash
>   | CPU: 0 PID: 1 Comm: init Not tainted 5.2.15 #1
>   | Hardware name: linux,dummy-virt (DT)
>   | Call trace:
>   |  dump_backtrace+0x0/0x148
>   |  show_stack+0x14/0x20
>   |  dump_stack+0xa0/0xc4
>   |  panic+0x140/0x32c
>   |  sysrq_handle_reboot+0x0/0x20
>   |  __handle_sysrq+0x124/0x190
>   |  write_sysrq_trigger+0x64/0x88
>   |  proc_reg_write+0x60/0xa8
>   |  __vfs_write+0x18/0x40
>   |  vfs_write+0xa4/0x1b8
>   |  ksys_write+0x64/0xf0
>   |  __arm64_sys_write+0x14/0x20
>   |  el0_svc_common.constprop.0+0xb0/0x168
>   |  el0_svc_handler+0x28/0x78
>   |  el0_svc+0x8/0xc
>   | Kernel Offset: disabled
>   | CPU features: 0x0002,24002004
>   | Memory Limit: none
>   | ---[ end Kernel panic - not syncing: sysrq triggered crash ]---
>   |  Ping 2!
>   |  Ping 1!
>   |  Ping 1!
>   |  Ping 2!
> 
> The issue can also be triggered on x86 kernels if CONFIG_SMP=n, otherwise
> local interrupts are disabled in 'smp_send_stop()'.
> 
> Disable preemption in 'panic()' before re-enabling interrupts.
> 
> ...
>
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -180,6 +180,7 @@ void panic(const char *fmt, ...)
>  	 * after setting panic_cpu) from invoking panic() again.
>  	 */
>  	local_irq_disable();
> +	preempt_disable_notrace();
>  
>  	/*
>  	 * It's possible to come here directly from a panic-assertion and

We still do a lot of stuff (kexec, kgdb, etc) after this
preempt_disable() and I worry that something in there will now trigger
a might_sleep() warning as a result?

