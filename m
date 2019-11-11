Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0B4F7693
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfKKOjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:39:00 -0500
Received: from foss.arm.com ([217.140.110.172]:46336 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfKKOjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 09:39:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9886B31B;
        Mon, 11 Nov 2019 06:38:59 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA9923F52E;
        Mon, 11 Nov 2019 06:38:58 -0800 (PST)
Date:   Mon, 11 Nov 2019 14:38:53 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     marek.vasut+renesas@gmail.com, linux-pci@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] Revert "PCI: rcar: Fix missing MACCTLR register
 setting in rcar_pcie_hw_init()"
Message-ID: <20191111143853.GA9653@e121166-lin.cambridge.arm.com>
References: <1572951089-19956-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572951089-19956-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572951089-19956-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 07:51:28PM +0900, Yoshihiro Shimoda wrote:
> This reverts commit 175cc093888ee74a17c4dd5f99ba9a6bc86de5be.
> 
> The commit description/code don't follow the manual accurately,
> it's difficult to understand. So, this patch reverts the commit.
> 
> Fixes: 175cc093888e ("PCI: rcar: Fix missing MACCTLR register setting in rcar_pcie_hw_init()"

This patch is not in the mainline, I will just drop it.

> Cc: <stable@vger.kernel.org>

This is valid for any fix: there is no reason to send to stable a fix
for a patch that is not in the mainline yet.

Lorenzo

> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/pci/controller/pcie-rcar.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
> index 0dadccb..40d8c54 100644
> --- a/drivers/pci/controller/pcie-rcar.c
> +++ b/drivers/pci/controller/pcie-rcar.c
> @@ -91,7 +91,6 @@
>  #define  LINK_SPEED_2_5GTS	(1 << 16)
>  #define  LINK_SPEED_5_0GTS	(2 << 16)
>  #define MACCTLR			0x011058
> -#define  MACCTLR_RESERVED	BIT(0)
>  #define  SPEED_CHANGE		BIT(24)
>  #define  SCRAMBLE_DISABLE	BIT(27)
>  #define PMSR			0x01105c
> @@ -614,8 +613,6 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
>  	if (IS_ENABLED(CONFIG_PCI_MSI))
>  		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
>  
> -	rcar_rmw32(pcie, MACCTLR, MACCTLR_RESERVED, 0);
> -
>  	/* Finish initialization - establish a PCI Express link */
>  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>  
> @@ -1238,7 +1235,6 @@ static int rcar_pcie_resume_noirq(struct device *dev)
>  		return 0;
>  
>  	/* Re-establish the PCIe link */
> -	rcar_rmw32(pcie, MACCTLR, MACCTLR_RESERVED, 0);
>  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
>  	return rcar_pcie_wait_for_dl(pcie);
>  }
> -- 
> 2.7.4
> 
