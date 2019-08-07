Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7568385641
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 01:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbfHGXBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 19:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbfHGXBy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 19:01:54 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B4882171F;
        Wed,  7 Aug 2019 23:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565218913;
        bh=880CjrWqcw/b0n8e8loUwkiYFlbtOJVJsxG1uGHV1Ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BbLvpPEMmpazhnJCMsxKGQMri/b6UwTY2G01eANjdrk1kgPgQjO5BcVdhwrMtdD8Q
         ZqpwBCoCCS3SkcIdXzMH9Sk8xyumGYznOE02Oaq9WTjmtRmkG6n2jHH4feWHLT9Vie
         YPBkPOIdMFQ79/+nv6Zs9xYpheC8VcJcyAN7zlnw=
Date:   Wed, 7 Aug 2019 18:01:49 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Christian.Koenig@amd.com, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] PCI: set BAR size bits correctly in Resize BAR
 control register
Message-ID: <20190807230149.GA151852@google.com>
References: <20190725192552.24295-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725192552.24295-1-sumit.saxena@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 12:55:52AM +0530, Sumit Saxena wrote:
> In Resize BAR control register, bits[8:12] represents size of BAR.
> As per PCIe specification, below is encoded values in register bits
> to actual BAR size table:
> 
> Bits  BAR size
> 0     1 MB
> 1     2 MB
> 2     4 MB
> 3     8 MB
> --
> 
> For 1 MB BAR size, BAR size bits should be set to 0 but incorrectly
> these bits are set to "1f". Latest megaraid_sas and mpt3sas adapters
> which support Resizable BAR with 1 MB BAR size fails to initialize
> during system resume from S3 sleep.
> 
> Fix: Correctly calculate BAR size bits for Resize BAR control register.
> 
> V2:
> -Simplified calculation of BAR size bits as suggested by Christian Koenig.
> 
> CC: stable@vger.kernel.org # v4.16+
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203939
> Fixes: d3252ace0bc652a1a244455556b6a549f969bf99 ("PCI: Restore resized BAR state on resume")
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/pci/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 29ed5ec1ac27..e59921296125 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1438,7 +1438,7 @@ static void pci_restore_rebar_state(struct pci_dev *pdev)
>  		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
>  		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
>  		res = pdev->resource + bar_idx;
> -		size = order_base_2((resource_size(res) >> 20) | 1) - 1;
> +		size = order_base_2(resource_size(res) >> 20);

Since BAR sizes are always powers of 2, wouldn't this be simpler as:

		size = ilog2(resource_size(res)) - 20;

which nicely matches the table in PCIe r5.0, sec 7.8.6.3?

>  		ctrl &= ~PCI_REBAR_CTRL_BAR_SIZE;
>  		ctrl |= size << PCI_REBAR_CTRL_BAR_SHIFT;
>  		pci_write_config_dword(pdev, pos + PCI_REBAR_CTRL, ctrl);
> -- 
> 2.18.1
> 
