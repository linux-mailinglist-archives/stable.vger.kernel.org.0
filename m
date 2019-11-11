Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A617AF83AE
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 00:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfKKXiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 18:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfKKXiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 18:38:01 -0500
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82A1721872;
        Mon, 11 Nov 2019 23:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573515480;
        bh=N4LdVomlV5wfhw+NRmcdZPmiX3mmfeGZAuQC/B3EpoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=qM/zLk1/WrsCo5v0Nm0GKewIM1w3xpGfNmEJDKEpuuOzEjHtoVwnz3RzZOYz/jq/u
         rbLk0gXQWzEDjvPBhwMh/9kwuuKRSmM7Nkq8ksfcqDlToD+OqEb6hDmUoG6JQjvUdI
         8gPgLVI1JqoNXNU7tSQTvK5QSLio1Mday0jGnarM=
Date:   Mon, 11 Nov 2019 17:37:56 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     sundeep.lkml@gmail.com
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [v2 PATCH] PCI: Do not use bus number zero from EA capability
Message-ID: <20191111233756.GA65477@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572850664-9861-1-git-send-email-sundeep.lkml@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 12:27:44PM +0530, sundeep.lkml@gmail.com wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> As per the spec, "Enhanced Allocation (EA) for Memory
> and I/O Resources" ECN, approved 23 October 2014,
> sec 6.9.1.2, fixed bus numbers of a bridge must be zero
> when no function that uses EA is located behind it.
> Hence assign bus numbers normally instead of assigning
> zeroes from EA capability. Failing to do this and using
> zeroes from EA would make the bridges non-functional.
> 
> Fixes: '2dbce5901179 ("PCI: Assign bus numbers present in
> EA capability for bridges")'
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Cc: stable@vger.kernel.org	# v5.2+

Applied to pci/resource for v5.5, thanks!

I tweaked it as below so the logic about how to interpret the EA Fixed
Secondary Bus Number is more localized.  Let me know if that doesn't
make sense.

> ---
>  drivers/pci/probe.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 3d5271a..116b276 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1090,27 +1090,28 @@ static unsigned int pci_scan_child_bus_extend(struct pci_bus *bus,
>   * @sub: updated with subordinate bus number from EA
>   *
>   * If @dev is a bridge with EA capability, update @sec and @sub with
> - * fixed bus numbers from the capability and return true.  Otherwise,
> - * return false.
> + * fixed bus numbers from the capability. Otherwise @sec and @sub
> + * will be zeroed.
>   */
> -static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
> +static void pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
>  {
>  	int ea, offset;
>  	u32 dw;
>  
> +	*sec = *sub = 0;
> +
>  	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
> -		return false;
> +		return;
>  
>  	/* find PCI EA capability in list */
>  	ea = pci_find_capability(dev, PCI_CAP_ID_EA);
>  	if (!ea)
> -		return false;
> +		return;
>  
>  	offset = ea + PCI_EA_FIRST_ENT;
>  	pci_read_config_dword(dev, offset, &dw);
>  	*sec =  dw & PCI_EA_SEC_BUS_MASK;
>  	*sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
> -	return true;
>  }
>  
>  /*
> @@ -1146,7 +1147,6 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  	u16 bctl;
>  	u8 primary, secondary, subordinate;
>  	int broken = 0;
> -	bool fixed_buses;
>  	u8 fixed_sec, fixed_sub;
>  	int next_busnr;
>  
> @@ -1249,11 +1249,12 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  		pci_write_config_word(dev, PCI_STATUS, 0xffff);
>  
>  		/* Read bus numbers from EA Capability (if present) */
> -		fixed_buses = pci_ea_fixed_busnrs(dev, &fixed_sec, &fixed_sub);
> -		if (fixed_buses)
> +		pci_ea_fixed_busnrs(dev, &fixed_sec, &fixed_sub);
> +
> +		next_busnr = max + 1;
> +		/* Use secondary bus number in EA */
> +		if (fixed_sec)
>  			next_busnr = fixed_sec;
> -		else
> -			next_busnr = max + 1;
>  
>  		/*
>  		 * Prevent assigning a bus number that already exists.
> @@ -1331,7 +1332,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  		 * If fixed subordinate bus number exists from EA
>  		 * capability then use it.
>  		 */
> -		if (fixed_buses)
> +		if (fixed_sub)
>  			max = fixed_sub;
>  		pci_bus_update_busn_res_end(child, max);
>  		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
> -- 
> 2.7.4
> 

commit 25328e0447de ("PCI: Do not use bus number zero from EA capability")
Author: Subbaraya Sundeep <sbhatta@marvell.com>
Date:   Mon Nov 4 12:27:44 2019 +0530

    PCI: Do not use bus number zero from EA capability
    
    As per PCIe r5.0, sec 7.8.5.2, fixed bus numbers of a bridge must be zero
    when no function that uses EA is located behind it.  Hence, if EA supplies
    bus numbers of zero, assign bus numbers normally.  A secondary bus can
    never have a bus number of zero, so setting a bridge's Secondary Bus Number
    to zero makes downstream devices unreachable.
    
    [bhelgaas: retain bool return value so "zero is invalid" logic is local]
    Fixes: 2dbce5901179 ("PCI: Assign bus numbers present in EA capability for bridges")
    Link: https://lore.kernel.org/r/1572850664-9861-1-git-send-email-sundeep.lkml@gmail.com
    Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Cc: stable@vger.kernel.org	# v5.2+

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bdbc8490f962..d3033873395d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1090,14 +1090,15 @@ static unsigned int pci_scan_child_bus_extend(struct pci_bus *bus,
  * @sec: updated with secondary bus number from EA
  * @sub: updated with subordinate bus number from EA
  *
- * If @dev is a bridge with EA capability, update @sec and @sub with
- * fixed bus numbers from the capability and return true.  Otherwise,
- * return false.
+ * If @dev is a bridge with EA capability that specifies valid secondary
+ * and subordinate bus numbers, return true with the bus numbers in @sec
+ * and @sub.  Otherwise return false.
  */
 static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 {
 	int ea, offset;
 	u32 dw;
+	u8 ea_sec, ea_sub;
 
 	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
 		return false;
@@ -1109,8 +1110,13 @@ static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 
 	offset = ea + PCI_EA_FIRST_ENT;
 	pci_read_config_dword(dev, offset, &dw);
-	*sec =  dw & PCI_EA_SEC_BUS_MASK;
-	*sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
+	ea_sec =  dw & PCI_EA_SEC_BUS_MASK;
+	ea_sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
+	if (ea_sec  == 0 || ea_sub < ea_sec)
+		return false;
+
+	*sec = ea_sec;
+	*sub = ea_sub;
 	return true;
 }
 
