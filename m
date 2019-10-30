Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C54DEA1D4
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfJ3Qer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 12:34:47 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:55252 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3Qeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 12:34:46 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id D87733C0585;
        Wed, 30 Oct 2019 17:34:42 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gPYWxzqq8IGP; Wed, 30 Oct 2019 17:34:35 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id D77463C0582;
        Wed, 30 Oct 2019 17:34:35 +0100 (CET)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Wed, 30 Oct
 2019 17:34:35 +0100
Date:   Wed, 30 Oct 2019 17:34:31 +0100
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     <horms@verge.net.au>, <linux-pci@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <stable@vger.kernel.org>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Asano Yasushi <yasano@jp.adit-jv.com>,
        Yohhei Fukui <yohhei.fukui@denso-ten.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Message-ID: <20191030163431.GA882@vmlxhi-102.adit-jv.com>
References: <1572434824-1850-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572434824-1850-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1572434824-1850-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mutt/1.12.1+40 (7f8642d4ee82) (2019-06-28)
X-Originating-IP: [10.72.93.184]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Shimoda-san, hi Geert, hi Sergei,

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

Actually, I do believe there is an inconsistency in the manual,
since the following statements pretty much contradict one another:

1. (as quoted by Shimoda-san from "Initial Setting of PCI Express")
   > Be sure to write the initial value (= H'80FF 0000) to MACCTLR
   > before enabling PCIETCTLR.CFINIT.
2. Description of SPCHG bit in "54.2.98 MAC Control Register (MACCTLR)"
   > Only writing 1 is valid and writing 0 is invalid.

The last "invalid" sounds like "bad things can happen" aka "expect
undefined behaviors" when SPCHG is written "0".

While leaving the decision on the patch inclusion to the maintainers, I
hope, in the long run, Renesas can resolve the documentation conflict
with the HW team and the tech writers.

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

-- 
Best Regards,
Eugeniu
