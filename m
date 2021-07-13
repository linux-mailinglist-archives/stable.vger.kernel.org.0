Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15B73C6ADF
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 08:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhGMHCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 03:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232908AbhGMHCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 03:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A2ED600CD;
        Tue, 13 Jul 2021 06:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626159597;
        bh=6rBzLPz4Fdb3aNnNZxATbJcz5hKV232AVCf6INOntSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w0hm+dieFvVQIpmu3s3uem9rUlG6UaLq800KUP0bUgMGlJ3IjOQpK8f6oxnMXjyNs
         8M7DX7kcT4YJ8vtfGT44VN9JeoH7QH3E9jijlB4gopqda5u3TTyneT28+aC+sRB0ur
         RzwPIHCtEDXU9VrL/pUqHMhesjFURhOTEQvwXTyk=
Date:   Tue, 13 Jul 2021 08:59:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yongxin Liu <yongxin.liu@windriver.com>
Cc:     tglx@linutronix.de, evgreen@chromium.org, rajatja@google.com,
        bhelgaas@google.com, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org, maz@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/apic/msi: check interupt context before reporting
 warning
Message-ID: <YO056/qui/vCvCcV@kroah.com>
References: <20210713064609.25429-1-yongxin.liu@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713064609.25429-1-yongxin.liu@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 02:46:09PM +0800, Yongxin Liu wrote:
> Affinity change can happen in both interrupt context and non-interrupt
> context. The paranoia check for interrupt target cpu is not always true
> in non-interrupt context.
> 
> For example:
>   Set affinity for irq to CPU#7
>   $ echo 80 > /proc/irq/default_smp_affinity
> 
>   Open serial port on different CPU.
>   $taskset -c 4 agetty -L 115200 ttyS1
> 
> Will triger the following warning.
> 
>   WARNING: CPU: 4 PID: 765 at arch/x86/kernel/apic/msi.c:75 msi_set_affinity+0x16f/0x190
>   Call Trace:
>    irq_do_set_affinity+0x57/0x1b0
>    irq_setup_affinity+0x136/0x190
>    irq_startup+0xaf/0xf0
>    __setup_irq+0x745/0x7e0
>    ? kmem_cache_alloc_trace+0x2b5/0x450
>    request_threaded_irq+0x110/0x180
>    univ8250_setup_irq+0x1e2/0x220
>    serial8250_do_startup+0x481/0x760
>    serial8250_startup+0x1e/0x20
>    uart_startup.part.22+0xf8/0x260
>    uart_port_activate+0x41/0x60
>    tty_port_open+0x82/0xd0
>    ? _raw_spin_unlock+0x16/0x30
>    uart_open+0x1e/0x30
>    tty_open+0x100/0x4d0
>    ? cdev_purge+0x60/0x60
>    chrdev_open+0xa3/0x1c0
>    ? cdev_put.part.3+0x20/0x20
>    do_dentry_open+0x21f/0x380
>    vfs_open+0x2f/0x40
>    path_openat+0xd67/0xf60
>    ? page_add_file_rmap+0xad/0x140
>    ? do_set_pte+0xd7/0x210
>    do_filp_open+0xc5/0x140
>    do_sys_openat2+0x239/0x300
>    ? do_sys_openat2+0x239/0x300
>    do_sys_open+0x59/0x80
>    __x64_sys_openat+0x20/0x30
>    do_syscall_64+0x3f/0x90
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> With this patch, the warning is only reported in interrupt context and when
> the target CPU is not local CPU.
> 
> Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
> ---
>  arch/x86/kernel/apic/msi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
> index 44ebe25e7703..c4c73f227eeb 100644
> --- a/arch/x86/kernel/apic/msi.c
> +++ b/arch/x86/kernel/apic/msi.c
> @@ -72,7 +72,7 @@ msi_set_affinity(struct irq_data *irqd, const struct cpumask *mask, bool force)
>  	 * Paranoia: Validate that the interrupt target is the local
>  	 * CPU.
>  	 */
> -	if (WARN_ON_ONCE(cpu != smp_processor_id())) {
> +	if (in_interrupt() && WARN_ON_ONCE(cpu != smp_processor_id())) {
>  		irq_msi_update_msg(irqd, cfg);
>  		return ret;
>  	}
> -- 
> 2.14.5
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
