Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB52453413
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbhKPO0v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 16 Nov 2021 09:26:51 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:57294 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237169AbhKPO0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 09:26:49 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-nZSW1G1SOM2Oj2THJUBt6Q-1; Tue, 16 Nov 2021 09:23:47 -0500
X-MC-Unique: nZSW1G1SOM2Oj2THJUBt6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9211742377;
        Tue, 16 Nov 2021 14:23:46 +0000 (UTC)
Received: from bahia (unknown [10.39.192.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 503BD5FC13;
        Tue, 16 Nov 2021 14:23:45 +0000 (UTC)
Date:   Tue, 16 Nov 2021 15:23:43 +0100
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Marc Zyngier <maz@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/xive: Change IRQ domain to a tree domain
Message-ID: <20211116152343.782c687c@bahia>
In-Reply-To: <20211116134022.420412-1-clg@kaod.org>
References: <20211116134022.420412-1-clg@kaod.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021 14:40:22 +0100
Cédric Le Goater <clg@kaod.org> wrote:

> Commit 4f86a06e2d6e ("irqdomain: Make normal and nomap irqdomains
> exclusive") introduced an IRQ_DOMAIN_FLAG_NO_MAP flag to isolate the
> 'nomap' domains still in use under the powerpc arch. With this new
> flag, the revmap_tree of the IRQ domain is not used anymore. This
> change broke the support of shared LSIs [1] in the XIVE driver because
> it was relying on a lookup in the revmap_tree to query previously
> mapped interrupts. Linux now creates two distinct IRQ mappings on the
> same HW IRQ which can lead to unexpected behavior in the drivers.
> 
> The XIVE IRQ domain is not a direct mapping domain and its HW IRQ
> interrupt number space is rather large : 1M/socket on POWER9 and
> POWER10, change the XIVE driver to use a 'tree' domain type instead.
> 
> [1] For instance, a linux KVM guest with virtio-rng and virtio-balloon
>     devices.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org # v5.14+
> Fixes: 4f86a06e2d6e ("irqdomain: Make normal and nomap irqdomains exclusive")
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
> 

Tested-by: Greg Kurz <groug@kaod.org>

with a KVM guest + virtio-rng + virtio-balloon on a POWER9 host.

>  Marc,
> 
>  The Fixes tag is there because the patch in question revealed that
>  something was broken in XIVE. genirq is not in cause. However, I
>  don't know for PS3 and Cell. May be less critical for now. 
>  
>  arch/powerpc/sysdev/xive/common.c | 3 +--
>  arch/powerpc/sysdev/xive/Kconfig  | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index fed6fd16c8f4..9d0f0fe25598 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1536,8 +1536,7 @@ static const struct irq_domain_ops xive_irq_domain_ops = {
>  
>  static void __init xive_init_host(struct device_node *np)
>  {
> -	xive_irq_domain = irq_domain_add_nomap(np, XIVE_MAX_IRQ,
> -					       &xive_irq_domain_ops, NULL);
> +	xive_irq_domain = irq_domain_add_tree(np, &xive_irq_domain_ops, NULL);
>  	if (WARN_ON(xive_irq_domain == NULL))
>  		return;
>  	irq_set_default_host(xive_irq_domain);
> diff --git a/arch/powerpc/sysdev/xive/Kconfig b/arch/powerpc/sysdev/xive/Kconfig
> index 97796c6b63f0..785c292d104b 100644
> --- a/arch/powerpc/sysdev/xive/Kconfig
> +++ b/arch/powerpc/sysdev/xive/Kconfig
> @@ -3,7 +3,6 @@ config PPC_XIVE
>  	bool
>  	select PPC_SMP_MUXED_IPI
>  	select HARDIRQS_SW_RESEND
> -	select IRQ_DOMAIN_NOMAP
>  
>  config PPC_XIVE_NATIVE
>  	bool

