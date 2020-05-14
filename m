Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026A51D41AA
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 01:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgENX1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 19:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgENX1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 19:27:48 -0400
Received: from localhost (mobile-166-175-190-200.mycingular.net [166.175.190.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116A320709;
        Thu, 14 May 2020 23:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589498868;
        bh=AQY4+McOXBJ8Bgqfpict8ufAkz7fFZ3oprMxOYY8ixU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=r+GiirYZANGu8cTCMyRPrTUVQPEYDOwPGzyywhtK78Wq6c50xjNzrIpJAO9nbSNN1
         x450DFUgVAM3hFtDeuT+ZZyNH8sx074eepnoOliETkEwZau4vQqDfp3j8Kk8fh5zym
         UptBPq6ig7hYhqUZrRPIN29FFNULJwu7t6KpmVgA=
Date:   Thu, 14 May 2020 18:27:46 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ashok Raj <ashok.raj@intel.com>
Cc:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pci: Fixes MaxPayloadSize (MPS) programming for RCiEP
 devices.
Message-ID: <20200514232746.GA478643@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585343775-4019-1-git-send-email-ashok.raj@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 02:16:15PM -0700, Ashok Raj wrote:
> Root Complex Integrated devices (RCiEP) do not have a Root Port before the
> device. pci_configure_mps() should simply stick the max value for MaxPayload
> size in Device Control, and for MaxReadReq. Unless pcie=pcie_bus-peer2peer
> is used in kernel commandline PCIE_BUS_PEER2PEER.
> 
> When MPS is configured lower, it could result in reduced performance.
> 
> Fixes: 9dae3a97297f ("PCI: Move MPS configuration check to pci_configure_device()")
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Tested-by: Dave Jiang <dave.jiang@intel.com>
> To: Bjorn Helgaas <bhelgaas@google.com>
> To: linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: Ashok Raj <ashok.raj@intel.com>

Applied to pci/enumeration for v5.8, thanks!

> ---
>  drivers/pci/probe.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index eeff8a07..a738b1c 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1895,13 +1895,34 @@ static void pci_configure_mps(struct pci_dev *dev)
>  	struct pci_dev *bridge = pci_upstream_bridge(dev);
>  	int mps, mpss, p_mps, rc;
>  
> -	if (!pci_is_pcie(dev) || !bridge || !pci_is_pcie(bridge))
> +	if (!pci_is_pcie(dev))
>  		return;
>  
>  	/* MPS and MRRS fields are of type 'RsvdP' for VFs, short-circuit out */
>  	if (dev->is_virtfn)
>  		return;
>  
> +	/*
> +	 * If this is a Root Complex Integrated Endpoint
> +	 * Simply program the max value from DEVCAP. No additional
> +	 * Lookup is necessary
> +	 */
> +	if (pci_pcie_type(dev) == PCI_EXP_TYPE_RC_END) {
> +		if (pcie_bus_config == PCIE_BUS_PEER2PEER)
> +			mps = 128;
> +		else
> +			mps = 128 << dev->pcie_mpss;
> +		rc = pcie_set_mps(dev, mps);
> +		if (rc) {
> +			pci_warn(dev, "can't set Max Payload Size to %d; if necessary, use \"pci=pcie_bus_safe\" and report a bug\n",
> +			 mps);
> +			return;
> +		}
> +	}
> +
> +	if (!bridge || !pci_is_pcie(bridge))
> +		return;
> +
>  	mps = pcie_get_mps(dev);
>  	p_mps = pcie_get_mps(bridge);
>  
> -- 
> 2.7.4
> 
