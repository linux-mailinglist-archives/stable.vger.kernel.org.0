Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9F34DB3B4
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356986AbiCPOxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356936AbiCPOw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:52:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 243885F4C6;
        Wed, 16 Mar 2022 07:51:45 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E14A81476;
        Wed, 16 Mar 2022 07:51:44 -0700 (PDT)
Received: from slackpad.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 030303F7D7;
        Wed, 16 Mar 2022 07:51:43 -0700 (PDT)
Date:   Wed, 16 Mar 2022 14:51:02 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] irqchip/gic-v3: Fix GICR_CTLR.RWP polling
Message-ID: <20220316145102.28ad0a74@slackpad.lan>
In-Reply-To: <20220315165034.794482-2-maz@kernel.org>
References: <20220315165034.794482-1-maz@kernel.org>
        <20220315165034.794482-2-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Mar 2022 16:50:32 +0000
Marc Zyngier <maz@kernel.org> wrote:

> It turns out that our polling of RWP is totally wrong when checking
> for it in the redistributors, as we test the *distributor* bit index,
> whereas it is a different bit number in the RDs... Oopsie boo.
> 
> This is embarassing. Not only because it is wrong, but also because
> it took *8 years* to notice the blunder...

Indeed, I wonder why we didn't see issues before. I guess it's either
the UWP bit at position GICR_CTLR[31] having a similar implementation,
or the MMIO access alone providing enough delay for the writes to
finish.

Anyway:

> Just fix the damn thing.
> 
> Fixes: 021f653791ad ("irqchip: gic-v3: Initial support for GICv3")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre


> ---
>  drivers/irqchip/irq-gic-v3.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 5e935d97207d..736163d36b13 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -206,11 +206,11 @@ static inline void __iomem *gic_dist_base(struct irq_data *d)
>  	}
>  }
>  
> -static void gic_do_wait_for_rwp(void __iomem *base)
> +static void gic_do_wait_for_rwp(void __iomem *base, u32 bit)
>  {
>  	u32 count = 1000000;	/* 1s! */
>  
> -	while (readl_relaxed(base + GICD_CTLR) & GICD_CTLR_RWP) {
> +	while (readl_relaxed(base + GICD_CTLR) & bit) {
>  		count--;
>  		if (!count) {
>  			pr_err_ratelimited("RWP timeout, gone fishing\n");
> @@ -224,13 +224,13 @@ static void gic_do_wait_for_rwp(void __iomem *base)
>  /* Wait for completion of a distributor change */
>  static void gic_dist_wait_for_rwp(void)
>  {
> -	gic_do_wait_for_rwp(gic_data.dist_base);
> +	gic_do_wait_for_rwp(gic_data.dist_base, GICD_CTLR_RWP);
>  }
>  
>  /* Wait for completion of a redistributor change */
>  static void gic_redist_wait_for_rwp(void)
>  {
> -	gic_do_wait_for_rwp(gic_data_rdist_rd_base());
> +	gic_do_wait_for_rwp(gic_data_rdist_rd_base(), GICR_CTLR_RWP);
>  }
>  
>  #ifdef CONFIG_ARM64

