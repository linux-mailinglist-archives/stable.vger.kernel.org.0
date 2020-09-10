Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4305264349
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 12:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgIJKIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 06:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgIJKIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 06:08:37 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 645E920BED;
        Thu, 10 Sep 2020 10:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599732516;
        bh=GSM8J+48mwsvILRs4rmqaKqBdd8oi047X8MVr/4pEOQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AGn50qCzqlhgIZc4JK7k4G+YPcOs3M4SFoiMYMAYsbkrULYwsOqdLoDcT49/wpTwi
         mkPK5r1z2D4fugmTfvnJhunpwBWBfSEH0P1mbyj+BN2UQol6snDyYoMRgZtW0hSOig
         a6FHgyYXmWhSTCeYy/feVHkJjZQIBScn+ZBAWhKU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kGJVK-00Ae3W-DK; Thu, 10 Sep 2020 11:08:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Sep 2020 11:08:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] irqchip/loongson-pch-pic: Reserve legacy LPC irqs
In-Reply-To: <1599624552-17523-3-git-send-email-chenhc@lemote.com>
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
 <1599624552-17523-3-git-send-email-chenhc@lemote.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <613dd7bc4d7eeec1a5fd30f679fc83eb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: chenhc@lemote.com, tsbogend@alpha.franken.de, tglx@linutronix.de, jason@lakedaemon.net, linux-mips@vger.kernel.org, zhangfx@lemote.com, chenhuacai@gmail.com, jiaxun.yang@flygoat.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-09 05:09, Huacai Chen wrote:
> Reserve legacy LPC irqs (0~15) to avoid spurious interrupts.

How can they be spurious? Why are they enabled the first place?

This looks like you are papering over a much bigger issue.

         M.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  drivers/irqchip/irq-loongson-pch-pic.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-loongson-pch-pic.c
> b/drivers/irqchip/irq-loongson-pch-pic.c
> index 9bf6b9a..9f6719c 100644
> --- a/drivers/irqchip/irq-loongson-pch-pic.c
> +++ b/drivers/irqchip/irq-loongson-pch-pic.c
> @@ -35,6 +35,7 @@
> 
>  struct pch_pic {
>  	void __iomem		*base;
> +	struct irq_domain	*lpc_domain;
>  	struct irq_domain	*pic_domain;
>  	u32			ht_vec_base;
>  	raw_spinlock_t		pic_lock;
> @@ -184,9 +185,9 @@ static void pch_pic_reset(struct pch_pic *priv)
>  static int pch_pic_of_init(struct device_node *node,
>  				struct device_node *parent)
>  {
> +	int i, base, err;
>  	struct pch_pic *priv;
>  	struct irq_domain *parent_domain;
> -	int err;
> 
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
> @@ -213,6 +214,22 @@ static int pch_pic_of_init(struct device_node 
> *node,
>  		goto iounmap_base;
>  	}
> 
> +	base = irq_alloc_descs(-1, 0, NR_IRQS_LEGACY, 0);
> +	if (base < 0) {
> +		pr_err("Failed to allocate LPC IRQ numbers\n");
> +		goto iounmap_base;
> +	}
> +
> +	priv->lpc_domain = irq_domain_add_legacy(node, NR_IRQS_LEGACY, 0, 0,
> +						 &irq_domain_simple_ops, NULL);
> +	if (!priv->lpc_domain) {
> +		pr_err("Failed to add irqdomain for LPC controller");
> +		goto iounmap_base;
> +	}
> +
> +	for (i = 0; i < NR_IRQS_LEGACY; i++)
> +		irq_set_chip_and_handler(i, &dummy_irq_chip, handle_simple_irq);
> +
>  	priv->pic_domain = irq_domain_create_hierarchy(parent_domain, 0,
>  						       PIC_COUNT,
>  						       of_node_to_fwnode(node),

-- 
Jazz is not dead. It just smells funny...
