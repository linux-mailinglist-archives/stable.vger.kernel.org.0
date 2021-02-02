Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C1E30BE29
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 13:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhBBM2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 07:28:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhBBM2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 07:28:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F243764E58;
        Tue,  2 Feb 2021 12:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612268860;
        bh=gtbMfcCUSPFzqLg2V2TWa9A/4eSnnBEQENPDa9ZZUQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=tWMPpkt3fx/1U6e446tfkJTmavztKbYIyVIqXe48+N8TmNrasuXH6mJoZpBIAedV0
         sU6Pw+dwDIVtk90n8KzPEm+6sD3JBWdmqNuiVxs5VmJFEPokOOBywlweSXIHzPtlCr
         /Cl6rZSCn/o9wD0KIeQxLpMqTMuizL8QAsDYel0AjYzVbAEDbjll09BYklOVBbZNjl
         3KVE9RWS84QIzIoh4iEfNFyL7Cd7NPlm9L86AjrwLp67bq5w8VMhmeIIALmlPu4cjE
         EfRGIS4D8+J/PrVyH7SQNU0x9yCm6QW9jcewYs5wVqjfQHQYLWtecmhw16Zj5LipOo
         x2EkbsxcnV9iA==
Date:   Tue, 2 Feb 2021 06:27:38 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     ricky_wu@realtek.com
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, yuehaibing@huawei.com,
        ulf.hansson@linaro.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] misc: rtsx: modify rts522a init flow
Message-ID: <20210202122738.GA87016@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202105641.29330-1-ricky_wu@realtek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The subject line could be more descriptive.  All patches modify
something, so the only real information it contains is "rts522a" and
"init".  Maybe it could say something about powering off OCP (whatever
that is) when no memory card is present.

On Tue, Feb 02, 2021 at 06:56:41PM +0800, ricky_wu@realtek.com wrote:
> From: Ricky Wu <ricky_wu@realtek.com>
> 
> Power down OCP for power consumption
> when card is not exist at init_hw()

I assume "card is not exist" means "no SD/MMC card is present".

Why do you only do this for 5227?  "card_exist" seems to be a generic
concept (it's in struct rtsx_pcr and set by the generic
rtsx_pci_init_hw()).  Could/should this be done for other card readers
as well?

> Cc: stable@vger.kernel.org

Per https://www.kernel.org/doc/html/v5.10/process/stable-kernel-rules.html
(option 1) this is sufficient.  You should not include
stable@kernel.org in the cc: list above.

> Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
> ---
>  drivers/misc/cardreader/rts5227.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/misc/cardreader/rts5227.c b/drivers/misc/cardreader/rts5227.c
> index 8859011672cb..8200af22b529 100644
> --- a/drivers/misc/cardreader/rts5227.c
> +++ b/drivers/misc/cardreader/rts5227.c
> @@ -398,6 +398,11 @@ static int rts522a_extra_init_hw(struct rtsx_pcr *pcr)
>  {
>  	rts5227_extra_init_hw(pcr);
>  
> +	/* Power down OCP for power consumption */
> +	if (!pcr->card_exist)
> +		rtsx_pci_write_register(pcr, FPDCTL, OC_POWER_DOWN,
> +				OC_POWER_DOWN);
> +
>  	rtsx_pci_write_register(pcr, FUNC_FORCE_CTL, FUNC_FORCE_UPME_XMT_DBG,
>  		FUNC_FORCE_UPME_XMT_DBG);
>  	rtsx_pci_write_register(pcr, PCLK_CTL, 0x04, 0x04);
> -- 
> 2.17.1
> 
