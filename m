Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D16C2EC156
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 11:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbfKAKps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 06:45:48 -0400
Received: from foss.arm.com ([217.140.110.172]:33802 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbfKAKps (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 06:45:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8FE01FB;
        Fri,  1 Nov 2019 03:45:47 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EFAD3F6C4;
        Fri,  1 Nov 2019 03:45:46 -0700 (PDT)
Date:   Fri, 1 Nov 2019 10:45:45 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     horms@verge.net.au, linux-pci@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Lorenzo.Pieralisi@arm.com
Subject: Re: [PATCH 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Message-ID: <20191101104544.GA9723@e119886-lin.cambridge.arm.com>
References: <1572434824-1850-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572434824-1850-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572434824-1850-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 30, 2019 at 08:27:04PM +0900, Yoshihiro Shimoda wrote:
> According to the R-Car Gen2/3 manual, "Be sure to write the initial
> value (= H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT."
> To avoid unexpected behaviors, this patch fixes it.
> 
> Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/pci/controller/pcie-rcar.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
> index 40d8c54..d470ab8 100644
> --- a/drivers/pci/controller/pcie-rcar.c
> +++ b/drivers/pci/controller/pcie-rcar.c
> @@ -91,6 +91,7 @@
>  #define  LINK_SPEED_2_5GTS	(1 << 16)
>  #define  LINK_SPEED_5_0GTS	(2 << 16)
>  #define MACCTLR			0x011058
> +#define  MACCTLR_INIT_VAL	0x80ff0000

Geert's previous feedback was to avoid using magic numbers such as this. Is it
possible to define the bits you set instead?

Also perhaps Lorenzo has some feedback as if he prefers these two patches to
be squashed together or not, rather than a revert commit.

Thanks,

Andrew Murray

>  #define  SPEED_CHANGE		BIT(24)
>  #define  SCRAMBLE_DISABLE	BIT(27)
>  #define PMSR			0x01105c
> @@ -613,6 +614,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
>  	if (IS_ENABLED(CONFIG_PCI_MSI))
>  		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
>  
> +	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
> +
>  	/* Finish initialization - establish a PCI Express link */
>  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>  
> @@ -1235,6 +1238,7 @@ static int rcar_pcie_resume_noirq(struct device *dev)
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
