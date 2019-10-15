Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E0D7900
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 16:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbfJOOqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 10:46:44 -0400
Received: from foss.arm.com ([217.140.110.172]:40150 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfJOOqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 10:46:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DABFE28;
        Tue, 15 Oct 2019 07:46:43 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (unknown [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17A3E3F718;
        Tue, 15 Oct 2019 07:46:42 -0700 (PDT)
Date:   Tue, 15 Oct 2019 15:46:37 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     horms@verge.net.au, linux-pci@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] PCI: rcar: Fix missing MACCTLR register setting in
 rcar_pcie_hw_init()
Message-ID: <20191015144637.GA22698@e121166-lin.cambridge.arm.com>
References: <1570769432-15358-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570769432-15358-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 01:50:32PM +0900, Yoshihiro Shimoda wrote:
> According to the R-Car Gen2/3 manual, the bit 0 of MACCTLR register
> should be written to 0 before enabling PCIETCTLR.CFINIT because
> the bit 0 is set to 1 on reset. To avoid unexpected behaviors from
> this incorrect setting, this patch fixes it.
> 
> Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Changes from v3:
>  - Add the setting in rcar_pcie_resume_noirq().
>  - Add Fixes tag for rcar_pcie_resume_noirq().
>  - Change the version of the stable ML from v3.16 to v5.2.
>  https://patchwork.kernel.org/patch/11181005/
> 
>  Changes from v2:
>  - Change the subject.
>  - Fix commit log again.
>  - Add the register setting into the initialization, instead of speedup.
>  - Change commit hash/target version on Fixes and Cc stable tags.
>  - Add Geert-san's Reviewed-by.
>  https://patchwork.kernel.org/patch/11180429/
> 
>  Changes from v1:
>  - Fix commit log.
>  - Add Sergei-san's Reviewed-by.
>  https://patchwork.kernel.org/patch/11179279/
> 
>  drivers/pci/controller/pcie-rcar.c | 4 ++++
>  1 file changed, 4 insertions(+)

Applied to pci/rcar, thanks.

Lorenzo

> diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
> index f6a669a..302c9ea 100644
> --- a/drivers/pci/controller/pcie-rcar.c
> +++ b/drivers/pci/controller/pcie-rcar.c
> @@ -93,6 +93,7 @@
>  #define  LINK_SPEED_2_5GTS	(1 << 16)
>  #define  LINK_SPEED_5_0GTS	(2 << 16)
>  #define MACCTLR			0x011058
> +#define  MACCTLR_RESERVED	BIT(0)
>  #define  SPEED_CHANGE		BIT(24)
>  #define  SCRAMBLE_DISABLE	BIT(27)
>  #define PMSR			0x01105c
> @@ -615,6 +616,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
>  	if (IS_ENABLED(CONFIG_PCI_MSI))
>  		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
>  
> +	rcar_rmw32(pcie, MACCTLR, MACCTLR_RESERVED, 0);
> +
>  	/* Finish initialization - establish a PCI Express link */
>  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>  
> @@ -1237,6 +1240,7 @@ static int rcar_pcie_resume_noirq(struct device *dev)
>  		return 0;
>  
>  	/* Re-establish the PCIe link */
> +	rcar_rmw32(pcie, MACCTLR, MACCTLR_RESERVED, 0);
>  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>  	return rcar_pcie_wait_for_dl(pcie);
>  }
> -- 
> 2.7.4
> 
