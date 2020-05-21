Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD8C1DD9E1
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 00:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgEUWGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 18:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730402AbgEUWGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 18:06:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A5AC05BD43
        for <stable@vger.kernel.org>; Thu, 21 May 2020 15:06:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y198so4150828pfb.4
        for <stable@vger.kernel.org>; Thu, 21 May 2020 15:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=z4qjWDJS+dDEG6zsJVodzvcv2AJMK5S0YVhak8+CMXA=;
        b=x7AysmNp0uZndl6qCVfHpRaL6qwKwUKih6h6F4bYJ5i+no/SnDwO35gG5Eo7C+oaOm
         MpxI+tMIP+WzltyQEgPNkG4DBL9GqCf2buVXoU52+/n6bdMlcqcRv/fF6yC22dQsOLWI
         noZAmJZVDt3ryDt9cyeG5ibC6Lb59+K63CG/9HNRRRVEQYuydaiZdkiVUxoHN14A3/WK
         9h7rpwKhDRYjxQfg1kvKiLx/+OIF0y8/HnFr+pziSjuL3HV21wLfoE2PCtUuYzC20XYn
         Zie6+tByf13dxvZD5BQaBzKuYgmptdAZIrdjAayFYNJdPej5FLb8RuBsZsdzrX6DWxYF
         0kCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=z4qjWDJS+dDEG6zsJVodzvcv2AJMK5S0YVhak8+CMXA=;
        b=s0Z7hKjrihJ3BCJw1WW7BQpnjS3jd2FScol1rh73vFveCPkWXIiVzdedQmrqp2kpJE
         PEt5VAClbVme3yGOT8PxkbDtewqyaQ3Q5mzzt+ZkPxLbJ/j/SwNKv+Rp8YepzqfIbeq6
         7+nPPftRxhG3KHk5QzNwMBRHR8Nu4o1btOuepP04+mpri7K6Bzv+Rzhqgxnkuh71y8L/
         VK9fPN1hiSttrpsimOsVGrdrAvwnEL38MyAG4PZZ3Pjf+RkdEcQu9XAyZy5Jvfzg3SMi
         TjPulunXlc1PMfPkROcamNBbdhi9USk74bpskU+5Bg3W8H+zxl9jb5pOG9LP+jYukHyt
         O/KA==
X-Gm-Message-State: AOAM530ihcJUa84p7HGmcpGEem2R4TT7sMPn8JaZXFuejfazAT7KL9rx
        Wvump5W1r6om+pfLcvXVKbj+hA==
X-Google-Smtp-Source: ABdhPJzX1rMTBYpTHR0AQoHMU8WuWYu6PtLRSmk111NXu1EZlrTns2JDN2mP6/jPDZFUnz++IQpRjw==
X-Received: by 2002:a62:fc4c:: with SMTP id e73mr755715pfh.305.1590098777630;
        Thu, 21 May 2020 15:06:17 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id u17sm4961524pgo.90.2020.05.21.15.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 15:06:16 -0700 (PDT)
Date:   Thu, 21 May 2020 15:06:16 -0700 (PDT)
X-Google-Original-Date: Thu, 21 May 2020 14:58:47 PDT (-0700)
Subject:     Re: [PATCH v2 2/3] irqchip/sifive-plic: Setup cpuhp once after boot CPU handler is present
In-Reply-To: <20200518091441.94843-3-anup.patel@wdc.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, tglx@linutronix.de,
        jason@lakedaemon.net, Marc Zyngier <maz@kernel.org>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        anup@brainfault.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <Anup.Patel@wdc.com>,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Anup Patel <Anup.Patel@wdc.com>
Message-ID: <mhng-06a48d36-b37c-481f-97aa-8fc0b1f9795e@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 May 2020 02:14:40 PDT (-0700), Anup Patel wrote:
> For multiple PLIC instances, the plic_init() is called once for each
> PLIC instance. Due to this we have two issues:
> 1. cpuhp_setup_state() is called multiple times
> 2. plic_starting_cpu() can crash for boot CPU if cpuhp_setup_state()
>    is called before boot CPU PLIC handler is available.
>
> This patch fixes both above issues.
>
> Fixes: f1ad1133b18f ("irqchip/sifive-plic: Add support for multiple PLICs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  drivers/irqchip/irq-sifive-plic.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
> index 9f7f8ce88c00..6c54abf5cc5e 100644
> --- a/drivers/irqchip/irq-sifive-plic.c
> +++ b/drivers/irqchip/irq-sifive-plic.c
> @@ -76,6 +76,7 @@ struct plic_handler {
>  	void __iomem		*enable_base;
>  	struct plic_priv	*priv;
>  };
> +static bool plic_cpuhp_setup_done;
>  static DEFINE_PER_CPU(struct plic_handler, plic_handlers);
>
>  static inline void plic_toggle(struct plic_handler *handler,
> @@ -285,6 +286,7 @@ static int __init plic_init(struct device_node *node,
>  	int error = 0, nr_contexts, nr_handlers = 0, i;
>  	u32 nr_irqs;
>  	struct plic_priv *priv;
> +	struct plic_handler *handler;
>
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
> @@ -313,7 +315,6 @@ static int __init plic_init(struct device_node *node,
>
>  	for (i = 0; i < nr_contexts; i++) {
>  		struct of_phandle_args parent;
> -		struct plic_handler *handler;
>  		irq_hw_number_t hwirq;
>  		int cpu, hartid;
>
> @@ -367,9 +368,18 @@ static int __init plic_init(struct device_node *node,
>  		nr_handlers++;
>  	}
>
> -	cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
> +	/*
> +	 * We can have multiple PLIC instances so setup cpuhp state only
> +	 * when context handler for current/boot CPU is present.
> +	 */
> +	handler = this_cpu_ptr(&plic_handlers);
> +	if (handler->present && !plic_cpuhp_setup_done) {
> +		cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
>  				  "irqchip/sifive/plic:starting",
>  				  plic_starting_cpu, plic_dying_cpu);
> +		plic_cpuhp_setup_done = true;

So presumably something else is preventing multiple plic_init() calls from
executing at the same time?  Assuming that's the case

Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>

> +	}
> +
>  	pr_info("mapped %d interrupts with %d handlers for %d contexts.\n",
>  		nr_irqs, nr_handlers, nr_contexts);
>  	set_handle_irq(plic_handle_irq);
