Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77D4210EC
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 16:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhJDOIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 10:08:46 -0400
Received: from foss.arm.com ([217.140.110.172]:39770 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233312AbhJDOIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 10:08:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3909BD6E;
        Mon,  4 Oct 2021 07:06:57 -0700 (PDT)
Received: from lpieralisi (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 375383F70D;
        Mon,  4 Oct 2021 07:06:56 -0700 (PDT)
Date:   Mon, 4 Oct 2021 15:06:53 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        pali@kernel.org, stable@vger.kernel.org, maz@kernel.org
Subject: Re: [PATCH 06/13] PCI: aardvark: Do not clear status bits of masked
 interrupts
Message-ID: <20211004140653.GB24914@lpieralisi>
References: <20211001195856.10081-1-kabel@kernel.org>
 <20211001195856.10081-7-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211001195856.10081-7-kabel@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+Marc - always better to have his eyes on IRQ handling code]

On Fri, Oct 01, 2021 at 09:58:49PM +0200, Marek Behún wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> It is incorrect to clear status bits of masked interrupts.
> 
> The aardvark driver clears all status interrupt bits if no unmasked
> status bit is set. Masked bits should never be cleared.
> 
> Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/pci/controller/pci-aardvark.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
> index d5d6f92e5143..e4986806a189 100644
> --- a/drivers/pci/controller/pci-aardvark.c
> +++ b/drivers/pci/controller/pci-aardvark.c
> @@ -1295,11 +1295,8 @@ static void advk_pcie_handle_int(struct advk_pcie *pcie)
>  	isr1_mask = advk_readl(pcie, PCIE_ISR1_MASK_REG);
>  	isr1_status = isr1_val & ((~isr1_mask) & PCIE_ISR1_ALL_MASK);
>  
> -	if (!isr0_status && !isr1_status) {
> -		advk_writel(pcie, isr0_val, PCIE_ISR0_REG);
> -		advk_writel(pcie, isr1_val, PCIE_ISR1_REG);

This looks fine - on the other hand if no interrupt is set in the status
registers (that are filtered with the masks) we are dealing with a
spurious IRQ right ? Just gauging how severe this is.

Lorenzo

> +	if (!isr0_status && !isr1_status)
>  		return;
> -	}
>  
>  	/* Process MSI interrupts */
>  	if (isr0_status & PCIE_ISR0_MSI_INT_PENDING)
> -- 
> 2.32.0
> 
