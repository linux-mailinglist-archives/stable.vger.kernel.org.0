Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608AB1374D7
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 18:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgAJRbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 12:31:32 -0500
Received: from foss.arm.com ([217.140.110.172]:49090 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbgAJRbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 12:31:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B621E30E;
        Fri, 10 Jan 2020 09:31:31 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAB183F6C4;
        Fri, 10 Jan 2020 09:31:30 -0800 (PST)
Date:   Fri, 10 Jan 2020 17:31:28 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Yurii Monakov <monakov.y@gmail.com>
Cc:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        andrew.murray@arm.com, m-karicheri2@ti.com
Subject: Re: [PATCH v2] PCI: keystone: Fix link training retries initiation
Message-ID: <20200110173128.GB885@e121166-lin.cambridge.arm.com>
References: <20191217143836.3449cfe2@monakov-y.xu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217143836.3449cfe2@monakov-y.xu>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 02:38:36PM +0300, Yurii Monakov wrote:
> ks_pcie_stop_link() function does not clear LTSSM_EN_VAL bit so
> link training was not triggered more than once after startup.
> In configurations where link can be unstable during early boot,
> for example, under low temperature, it will never be established.
> 
> Fixes: 0c4ffcfe1fbc ("PCI: keystone: Add TI Keystone PCIe driver")
> Signed-off-by: Yurii Monakov <monakov.y@gmail.com>
> CC:stable@vger.kernel.org
> ---
>  drivers/pci/controller/dwc/pci-keystone.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to pci/keystone, thanks.

Lorenzo

> diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
> index af677254a072..d4de4f6cff8b 100644
> --- a/drivers/pci/controller/dwc/pci-keystone.c
> +++ b/drivers/pci/controller/dwc/pci-keystone.c
> @@ -510,7 +510,7 @@ static void ks_pcie_stop_link(struct dw_pcie *pci)
>  	/* Disable Link training */
>  	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
>  	val &= ~LTSSM_EN_VAL;
> -	ks_pcie_app_writel(ks_pcie, CMD_STATUS, LTSSM_EN_VAL | val);
> +	ks_pcie_app_writel(ks_pcie, CMD_STATUS, val);
>  }
>  
>  static int ks_pcie_start_link(struct dw_pcie *pci)
> -- 
> 2.17.1
