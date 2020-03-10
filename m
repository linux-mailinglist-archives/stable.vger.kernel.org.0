Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0CA180237
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgCJPq2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 10 Mar 2020 11:46:28 -0400
Received: from 5.mo69.mail-out.ovh.net ([46.105.43.105]:58207 "EHLO
        5.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgCJPq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:46:28 -0400
X-Greylist: delayed 1797 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 11:46:26 EDT
Received: from player778.ha.ovh.net (unknown [10.110.103.76])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 2D99987F88
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 16:09:26 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player778.ha.ovh.net (Postfix) with ESMTPSA id C440B1048A9AF;
        Tue, 10 Mar 2020 15:09:18 +0000 (UTC)
Date:   Tue, 10 Mar 2020 16:09:16 +0100
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] powerpc/xive: Use XIVE_BAD_IRQ instead of zero to
 catch non configured IPIs
Message-ID: <20200310160916.37de59c2@bahia.home>
In-Reply-To: <20200306150143.5551-2-clg@kaod.org>
References: <20200306150143.5551-1-clg@kaod.org>
 <20200306150143.5551-2-clg@kaod.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 12512407139747600779
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgjedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejjeekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  6 Mar 2020 16:01:40 +0100
Cédric Le Goater <clg@kaod.org> wrote:

> When a CPU is brought up, an IPI number is allocated and recorded
> under the XIVE CPU structure. Invalid IPI numbers are tracked with
> interrupt number 0x0.
> 
> On the PowerNV platform, the interrupt number space starts at 0x10 and
> this works fine. However, on the sPAPR platform, it is possible to
> allocate the interrupt number 0x0 and this raises an issue when CPU 0
> is unplugged. The XIVE spapr driver tracks allocated interrupt numbers
> in a bitmask and it is not correctly updated when interrupt number 0x0
> is freed. It stays allocated and it is then impossible to reallocate.
> 
> Fix by using the XIVE_BAD_IRQ value instead of zero on both platforms.
> 
> Reported-by: David Gibson <david@gibson.dropbear.id.au>
> Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
> Cc: stable@vger.kernel.org # v4.14+
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---

This looks mostly good. I'm juste wondering about potential overlooks:

$ git grep 'if.*hw_i' arch/powerpc/ | egrep -v 'xics|XIVE_BAD_IRQ'
arch/powerpc/kvm/book3s_xive.h:         if (out_hw_irq)
arch/powerpc/kvm/book3s_xive.h:         if (out_hw_irq)
arch/powerpc/kvm/book3s_xive_template.c:        else if (hw_irq && xd->flags & XIVE_IRQ_FLAG_EOI_FW)
arch/powerpc/sysdev/xive/common.c:      else if (hw_irq && xd->flags & XIVE_IRQ_FLAG_EOI_FW) {

This hw_irq check in xive_do_source_eoi() for example is related to:

	/*
	 * Note: We pass "0" to the hw_irq argument in order to
	 * avoid calling into the backend EOI code which we don't
	 * want to do in the case of a re-trigger. Backends typically
	 * only do EOI for LSIs anyway.
	 */
	xive_do_source_eoi(0, xd);

but it can get hw_irq from:

	xive_do_source_eoi(xc->hw_ipi, &xc->ipi_data);

It seems that these should use XIVE_BAD_IRQ as well or I'm missing
something ?

arch/powerpc/sysdev/xive/common.c:      if (hw_irq)
arch/powerpc/sysdev/xive/common.c:              if (d->domain != xive_irq_domain || hw_irq == 0)



>  arch/powerpc/sysdev/xive/xive-internal.h |  7 +++++++
>  arch/powerpc/sysdev/xive/common.c        | 12 +++---------
>  arch/powerpc/sysdev/xive/native.c        |  4 ++--
>  arch/powerpc/sysdev/xive/spapr.c         |  4 ++--
>  4 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/xive-internal.h b/arch/powerpc/sysdev/xive/xive-internal.h
> index 59cd366e7933..382980f4de2d 100644
> --- a/arch/powerpc/sysdev/xive/xive-internal.h
> +++ b/arch/powerpc/sysdev/xive/xive-internal.h
> @@ -5,6 +5,13 @@
>  #ifndef __XIVE_INTERNAL_H
>  #define __XIVE_INTERNAL_H
>  
> +/*
> + * A "disabled" interrupt should never fire, to catch problems
> + * we set its logical number to this
> + */
> +#define XIVE_BAD_IRQ		0x7fffffff
> +#define XIVE_MAX_IRQ		(XIVE_BAD_IRQ - 1)
> +
>  /* Each CPU carry one of these with various per-CPU state */
>  struct xive_cpu {
>  #ifdef CONFIG_SMP
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index fa49193206b6..550baba98ec9 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -68,13 +68,6 @@ static u32 xive_ipi_irq;
>  /* Xive state for each CPU */
>  static DEFINE_PER_CPU(struct xive_cpu *, xive_cpu);
>  
> -/*
> - * A "disabled" interrupt should never fire, to catch problems
> - * we set its logical number to this
> - */
> -#define XIVE_BAD_IRQ		0x7fffffff
> -#define XIVE_MAX_IRQ		(XIVE_BAD_IRQ - 1)
> -
>  /* An invalid CPU target */
>  #define XIVE_INVALID_TARGET	(-1)
>  
> @@ -1153,7 +1146,7 @@ static int xive_setup_cpu_ipi(unsigned int cpu)
>  	xc = per_cpu(xive_cpu, cpu);
>  
>  	/* Check if we are already setup */
> -	if (xc->hw_ipi != 0)
> +	if (xc->hw_ipi != XIVE_BAD_IRQ)
>  		return 0;
>  
>  	/* Grab an IPI from the backend, this will populate xc->hw_ipi */
> @@ -1190,7 +1183,7 @@ static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
>  	/* Disable the IPI and free the IRQ data */
>  
>  	/* Already cleaned up ? */
> -	if (xc->hw_ipi == 0)
> +	if (xc->hw_ipi == XIVE_BAD_IRQ)
>  		return;
>  
>  	/* Mask the IPI */
> @@ -1346,6 +1339,7 @@ static int xive_prepare_cpu(unsigned int cpu)
>  		if (np)
>  			xc->chip_id = of_get_ibm_chip_id(np);
>  		of_node_put(np);
> +		xc->hw_ipi = XIVE_BAD_IRQ;
>  
>  		per_cpu(xive_cpu, cpu) = xc;
>  	}
> diff --git a/arch/powerpc/sysdev/xive/native.c b/arch/powerpc/sysdev/xive/native.c
> index 0ff6b739052c..50e1a8e02497 100644
> --- a/arch/powerpc/sysdev/xive/native.c
> +++ b/arch/powerpc/sysdev/xive/native.c
> @@ -312,7 +312,7 @@ static void xive_native_put_ipi(unsigned int cpu, struct xive_cpu *xc)
>  	s64 rc;
>  
>  	/* Free the IPI */
> -	if (!xc->hw_ipi)
> +	if (xc->hw_ipi == XIVE_BAD_IRQ)
>  		return;
>  	for (;;) {
>  		rc = opal_xive_free_irq(xc->hw_ipi);
> @@ -320,7 +320,7 @@ static void xive_native_put_ipi(unsigned int cpu, struct xive_cpu *xc)
>  			msleep(OPAL_BUSY_DELAY_MS);
>  			continue;
>  		}
> -		xc->hw_ipi = 0;
> +		xc->hw_ipi = XIVE_BAD_IRQ;
>  		break;
>  	}
>  }
> diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
> index 55dc61cb4867..3f15615712b5 100644
> --- a/arch/powerpc/sysdev/xive/spapr.c
> +++ b/arch/powerpc/sysdev/xive/spapr.c
> @@ -560,11 +560,11 @@ static int xive_spapr_get_ipi(unsigned int cpu, struct xive_cpu *xc)
>  
>  static void xive_spapr_put_ipi(unsigned int cpu, struct xive_cpu *xc)
>  {
> -	if (!xc->hw_ipi)
> +	if (xc->hw_ipi == XIVE_BAD_IRQ)
>  		return;
>  
>  	xive_irq_bitmap_free(xc->hw_ipi);
> -	xc->hw_ipi = 0;
> +	xc->hw_ipi = XIVE_BAD_IRQ;
>  }
>  #endif /* CONFIG_SMP */
>  

