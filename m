Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18304DCBFC
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 18:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbiCQREy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 13:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiCQREx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 13:04:53 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30DB2C3372;
        Thu, 17 Mar 2022 10:03:37 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E708F1682;
        Thu, 17 Mar 2022 10:03:36 -0700 (PDT)
Received: from lpieralisi (unknown [10.57.40.134])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0C5C3F7B4;
        Thu, 17 Mar 2022 10:03:35 -0700 (PDT)
Date:   Thu, 17 Mar 2022 17:03:31 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Andre Przywara <andre.przywara@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] irqchip/gic-v3: Fix GICR_CTLR.RWP polling
Message-ID: <YjNp4wzdGM3y2Rji@lpieralisi>
References: <20220315165034.794482-1-maz@kernel.org>
 <20220315165034.794482-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315165034.794482-2-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 04:50:32PM +0000, Marc Zyngier wrote:
> It turns out that our polling of RWP is totally wrong when checking
> for it in the redistributors, as we test the *distributor* bit index,
> whereas it is a different bit number in the RDs... Oopsie boo.
> 
> This is embarassing. Not only because it is wrong, but also because
> it took *8 years* to notice the blunder...
> 
> Just fix the damn thing.
> 
> Fixes: 021f653791ad ("irqchip: gic-v3: Initial support for GICv3")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/irqchip/irq-gic-v3.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

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
> -- 
> 2.34.1
> 
