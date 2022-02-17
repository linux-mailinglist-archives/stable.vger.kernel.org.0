Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49994BA6CE
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 18:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243616AbiBQRPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 12:15:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiBQRPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 12:15:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0854F29C11C;
        Thu, 17 Feb 2022 09:14:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B474DB822BE;
        Thu, 17 Feb 2022 17:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329FFC340E8;
        Thu, 17 Feb 2022 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645118094;
        bh=V8FuLE6Vxn5siPMWjHbj01sVGcq0wCo+yDT7Qdj4S+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=prPz3oAb28oHgqc4mcWzSNRx5FXQu0mAbL9h5AQ+Xq6nRY8BFpfyBA8Sad5O1Moqo
         LAcMm18rIZDMGP7TgaPxPRxVWQil48c0fLKusHLKyk3K6h/v7liYYQiLoiUhPy330p
         /OMfUc9rD0FlTJQlzP1Vdh08IYFH8k7uXANvQro8EkJgdmsxm8X0APAUp/dfPnMwtd
         Ais7+AVvGPNl+Lsil9g4AuTVf9GFMIpfkbpkUgVA1x7PQGyfAFnasYv+yaHHHnqVVA
         w9Tta0/nCa9kqA+0henKt3+KyBUdQmydMulacsb3AoUBXhJNLcCaTkpzi9yCSB97UL
         JHjcB+yD85tLw==
Date:   Thu, 17 Feb 2022 11:14:52 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, pali@kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 11/23] PCI: aardvark: Fix setting MSI address
Message-ID: <20220217171452.GA286231@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220110015018.26359-12-kabel@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 02:50:06AM +0100, Marek Behún wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> MSI address for receiving MSI interrupts needs to be correctly set before
> enabling processing of MSI interrupts.
> 
> Move code for setting PCIE_MSI_ADDR_LOW_REG and PCIE_MSI_ADDR_HIGH_REG
> from advk_pcie_init_msi_irq_domain() to advk_pcie_setup_hw(), before
> enabling PCIE_CORE_CTRL2_MSI_ENABLE.
> 
> After this we can remove the now unused member msi_msg, which was used
> only for MSI doorbell address. MSI address can be any address which cannot
> be used to DMA to. So change it to the address of the main struct advk_pcie.
> 
> Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: stable@vger.kernel.org # f21a8b1b6837 ("PCI: aardvark: Move to MSI handling using generic MSI support")
> ---
>  drivers/pci/controller/pci-aardvark.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
> index 51fedbcb41fb..79102704d82f 100644
> --- a/drivers/pci/controller/pci-aardvark.c
> +++ b/drivers/pci/controller/pci-aardvark.c
> @@ -278,7 +278,6 @@ struct advk_pcie {
>  	raw_spinlock_t msi_irq_lock;
>  	DECLARE_BITMAP(msi_used, MSI_IRQ_NUM);
>  	struct mutex msi_used_lock;
> -	u16 msi_msg;
>  	int link_gen;
>  	struct pci_bridge_emul bridge;
>  	struct gpio_desc *reset_gpio;
> @@ -473,6 +472,7 @@ static void advk_pcie_disable_ob_win(struct advk_pcie *pcie, u8 win_num)
>  
>  static void advk_pcie_setup_hw(struct advk_pcie *pcie)
>  {
> +	phys_addr_t msi_addr;
>  	u32 reg;
>  	int i;
>  
> @@ -561,6 +561,11 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
>  	reg |= LANE_COUNT_1;
>  	advk_writel(pcie, reg, PCIE_CORE_CTRL0_REG);
>  
> +	/* Set MSI address */
> +	msi_addr = virt_to_phys(pcie);

Strictly speaking, msi_addr should be a pci_bus_addr_t, not a
phys_addr_t, and virt_to_phys() doesn't return a bus address.

> +	advk_writel(pcie, lower_32_bits(msi_addr), PCIE_MSI_ADDR_LOW_REG);
> +	advk_writel(pcie, upper_32_bits(msi_addr), PCIE_MSI_ADDR_HIGH_REG);
> +
>  	/* Enable MSI */
>  	reg = advk_readl(pcie, PCIE_CORE_CTRL2_REG);
>  	reg |= PCIE_CORE_CTRL2_MSI_ENABLE;
> @@ -1184,10 +1189,10 @@ static void advk_msi_irq_compose_msi_msg(struct irq_data *data,
>  					 struct msi_msg *msg)
>  {
>  	struct advk_pcie *pcie = irq_data_get_irq_chip_data(data);
> -	phys_addr_t msi_msg = virt_to_phys(&pcie->msi_msg);
> +	phys_addr_t msi_addr = virt_to_phys(pcie);
>  
> -	msg->address_lo = lower_32_bits(msi_msg);
> -	msg->address_hi = upper_32_bits(msi_msg);
> +	msg->address_lo = lower_32_bits(msi_addr);
> +	msg->address_hi = upper_32_bits(msi_addr);
>  	msg->data = data->hwirq;
>  }
>  
> @@ -1346,18 +1351,10 @@ static struct msi_domain_info advk_msi_domain_info = {
>  static int advk_pcie_init_msi_irq_domain(struct advk_pcie *pcie)
>  {
>  	struct device *dev = &pcie->pdev->dev;
> -	phys_addr_t msi_msg_phys;
>  
>  	raw_spin_lock_init(&pcie->msi_irq_lock);
>  	mutex_init(&pcie->msi_used_lock);
>  
> -	msi_msg_phys = virt_to_phys(&pcie->msi_msg);
> -
> -	advk_writel(pcie, lower_32_bits(msi_msg_phys),
> -		    PCIE_MSI_ADDR_LOW_REG);
> -	advk_writel(pcie, upper_32_bits(msi_msg_phys),
> -		    PCIE_MSI_ADDR_HIGH_REG);
> -
>  	pcie->msi_inner_domain =
>  		irq_domain_add_linear(NULL, MSI_IRQ_NUM,
>  				      &advk_msi_domain_ops, pcie);
> -- 
> 2.34.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
