Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E16BF76A7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKKOml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:42:41 -0500
Received: from foss.arm.com ([217.140.110.172]:46424 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbfKKOmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 09:42:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9C7331B;
        Mon, 11 Nov 2019 06:42:39 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27DAF3F52E;
        Mon, 11 Nov 2019 06:42:39 -0800 (PST)
Date:   Mon, 11 Nov 2019 14:42:36 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     marek.vasut+renesas@gmail.com, linux-pci@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/2] PCI: rcar: Fix missing MACCTLR register setting
 in initialize sequence
Message-ID: <20191111144236.GB9653@e121166-lin.cambridge.arm.com>
References: <1572951089-19956-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572951089-19956-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572951089-19956-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Never ever add stable@vger.kernel.org in the CC list of the email
header. You should add the tag in the commit log as you did but
never CC stable when sending the patch email.

On Tue, Nov 05, 2019 at 07:51:29PM +0900, Yoshihiro Shimoda wrote:
> According to the R-Car Gen2/3 manual, "Be sure to write the initial
> value (= H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT".
> To avoid unexpected behaviors, this patch fixes it. Note that
> the SPCHG bit of MACCTLR register description said "Only writing 1
> is valid and writing 0 is invalid" but this "invalid" means
> "ignored", not "prohibited". So, any documentation conflict doesn't
> exist about writing the MACCTLR register.

I am sorry but I don't understand what you mean, if either you or
any rcar maintainer can help me rewrite this log I will merge this
patch then, appreciated.

Thanks,
Lorenzo

> Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/pci/controller/pcie-rcar.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
> index 40d8c54..94ba4fe 100644
> --- a/drivers/pci/controller/pcie-rcar.c
> +++ b/drivers/pci/controller/pcie-rcar.c
> @@ -91,8 +91,11 @@
>  #define  LINK_SPEED_2_5GTS	(1 << 16)
>  #define  LINK_SPEED_5_0GTS	(2 << 16)
>  #define MACCTLR			0x011058
> +#define  MACCTLR_NFTS_MASK	GENMASK(23, 16)	/* The name is from SH7786 */
>  #define  SPEED_CHANGE		BIT(24)
>  #define  SCRAMBLE_DISABLE	BIT(27)
> +#define  LTSMDIS		BIT(31)
> +#define  MACCTLR_INIT_VAL	(LTSMDIS | MACCTLR_NFTS_MASK)
>  #define PMSR			0x01105c
>  #define MACS2R			0x011078
>  #define MACCGSPSETR		0x011084
> @@ -613,6 +616,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
>  	if (IS_ENABLED(CONFIG_PCI_MSI))
>  		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
>  
> +	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
> +
>  	/* Finish initialization - establish a PCI Express link */
>  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>  
> @@ -1235,6 +1240,7 @@ static int rcar_pcie_resume_noirq(struct device *dev)
>  		return 0;
>  
>  	/* Re-establish the PCIe link */
> +	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
>  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>  	return rcar_pcie_wait_for_dl(pcie);
>  }
> -- 
> 2.7.4
> 
