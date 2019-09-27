Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8822FC05C7
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 14:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfI0My7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 08:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0My6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 08:54:58 -0400
Received: from localhost (173-25-179-30.client.mchsi.com [173.25.179.30])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1207520872;
        Fri, 27 Sep 2019 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569588898;
        bh=w3XEylaO3Qc+K7bAJgMP04bk+svHue7waGNxI0le2lw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=195lv9RzhoE+bN696fHGZIL9z0prRuuLIdJ0HNFPsg2Xr1bguxTlr/QqlNVTu8FYr
         Ym6ur319dPtAMsK8g4vzeJ6CRFM4P1qkBtzi9Yjr+lJNaeIW0AaWETieAgq7O1/9u3
         sYZ5HBltvUCLbiqmgFm1tpSseNK7ZhLdBx5p1cWc=
Date:   Fri, 27 Sep 2019 07:54:57 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
Cc:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Andrew Murray <andrew.murray@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v2] PCI: quirks: Fix register location for UPDCR
Message-ID: <20190927125457.GA34765@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a3505df-79ba-8a28-464c-88b83eefffa6@kernkonzept.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Andrew, Alex, Ashok]

Please cc people who commented on previous versions of a patch.  I
added them for you here.

This is probably fine, but I'm waiting to see if Ashok gets a response
from the chipset folks.  Hopefully he can ack this as a simple typo
fix.

On Wed, Sep 18, 2019 at 03:16:52PM +0200, Steffen Liebergeld wrote:
> According to documentation [0] the correct offset for the
> Upstream Peer Decode Configuration Register (UPDCR) is 0x1014.
> It was previously defined as 0x1114.
> 
> Commit d99321b63b1f intends to enforce isolation between PCI
> devices allowing them to be put into separate IOMMU groups.
> Due to the wrong register offset the intended isolation was not
> fully enforced. This is fixed with this patch.
> 
> Please note that I did not test this patch because I have
> no hardware that implements this register.
> 
> [0]
> https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/4th-gen-core-family-mobile-i-o-datasheet.pdf
> (page 325)
> 
> Fixes: d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
> Reviewed-by: Andrew Murray <andrew.murray@arm.com>
> Signed-off-by: Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
> ---
>  drivers/pci/quirks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 208aacf39329..7e184beb2aa4 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -4602,7 +4602,7 @@ int pci_dev_specific_acs_enabled(struct pci_dev
> *dev, u16 acs_flags)
>  #define INTEL_BSPR_REG_BPPD  (1 << 9)
>   /* Upstream Peer Decode Configuration Register */
> -#define INTEL_UPDCR_REG 0x1114
> +#define INTEL_UPDCR_REG 0x1014
>  /* 5:0 Peer Decode Enable bits */
>  #define INTEL_UPDCR_REG_MASK 0x3f
>  -- 2.11.0
> 
> 
