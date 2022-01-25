Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6E749B3E7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 13:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383115AbiAYM0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 07:26:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37148 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382639AbiAYMWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 07:22:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00C836126C;
        Tue, 25 Jan 2022 12:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2169DC340E0;
        Tue, 25 Jan 2022 12:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643113342;
        bh=WZgO22+Z41hUUnG+yTkDEt6WmhMHvEbX48CXDgypOPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=TVGn6ji+04fRMq28KB/1cjlHYNpIIJ4OywZA1vkyTcwNt2WHJnhyFsE/xPiAe1262
         btXQ4AoQC5lzEfK8o48szz2vCf70IWVeVjk1ix1mz3uFRKXWmHgabEQ043FXD9U6tP
         6t6X/ejgdZROZKkGyzxqB8Hu6vSQpEXHKqixF7u3Lz4ZaIChC/XKfza0zpDFlTnX3M
         VAsbTH782DGRhDP/8uLVqwmHhOn/WNZ6Cjnl1EihIdYpY9kiVhCfCJoOyGL/PK+T3j
         tkgdJ1uwr+juxUDNhXktkXwoGzYfyFuMVVFIZnLhFLstHAlr3cgS3TtJdE3ioYwqiB
         lHu2MhpmqRbRQ==
Date:   Tue, 25 Jan 2022 06:22:19 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joseph Bao <joseph.bao@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: Re: [PATCH 5.4 260/320] PCI: pciehp: Fix infinite loop in IRQ
 handler upon power fault
Message-ID: <20220125122219.GA1597322@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124184002.827563143@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 07:44:04PM +0100, Greg Kroah-Hartman wrote:
> From: Lukas Wunner <lukas@wunner.de>
> 
> commit 23584c1ed3e15a6f4bfab8dc5a88d94ab929ee12 upstream.

I would hold off on backporting the pciehp changes until we resolve
this regression in v5.17-rc1:

  https://bugzilla.kernel.org/show_bug.cgi?id=215525

> The Power Fault Detected bit in the Slot Status register differs from
> all other hotplug events in that it is sticky:  It can only be cleared
> after turning off slot power.  Per PCIe r5.0, sec. 6.7.1.8:
> 
>   If a power controller detects a main power fault on the hot-plug slot,
>   it must automatically set its internal main power fault latch [...].
>   The main power fault latch is cleared when software turns off power to
>   the hot-plug slot.
> 
> The stickiness used to cause interrupt storms and infinite loops which
> were fixed in 2009 by commits 5651c48cfafe ("PCI pciehp: fix power fault
> interrupt storm problem") and 99f0169c17f3 ("PCI: pciehp: enable
> software notification on empty slots").
> 
> Unfortunately in 2020 the infinite loop issue was inadvertently
> reintroduced by commit 8edf5332c393 ("PCI: pciehp: Fix MSI interrupt
> race"):  The hardirq handler pciehp_isr() clears the PFD bit until
> pciehp's power_fault_detected flag is set.  That happens in the IRQ
> thread pciehp_ist(), which never learns of the event because the hardirq
> handler is stuck in an infinite loop.  Fix by setting the
> power_fault_detected flag already in the hardirq handler.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=214989
> Link: https://lore.kernel.org/linux-pci/DM8PR11MB5702255A6A92F735D90A4446868B9@DM8PR11MB5702.namprd11.prod.outlook.com
> Fixes: 8edf5332c393 ("PCI: pciehp: Fix MSI interrupt race")
> Link: https://lore.kernel.org/r/66eaeef31d4997ceea357ad93259f290ededecfd.1637187226.git.lukas@wunner.de
> Reported-by: Joseph Bao <joseph.bao@intel.com>
> Tested-by: Joseph Bao <joseph.bao@intel.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: stable@vger.kernel.org # v4.19+
> Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/pci/hotplug/pciehp_hpc.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -577,6 +577,8 @@ read_status:
>  	 */
>  	if (ctrl->power_fault_detected)
>  		status &= ~PCI_EXP_SLTSTA_PFD;
> +	else if (status & PCI_EXP_SLTSTA_PFD)
> +		ctrl->power_fault_detected = true;
>  
>  	events |= status;
>  	if (!events) {
> @@ -586,7 +588,7 @@ read_status:
>  	}
>  
>  	if (status) {
> -		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
> +		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, status);
>  
>  		/*
>  		 * In MSI mode, all event bits must be zero before the port
> @@ -660,8 +662,7 @@ static irqreturn_t pciehp_ist(int irq, v
>  	}
>  
>  	/* Check Power Fault Detected */
> -	if ((events & PCI_EXP_SLTSTA_PFD) && !ctrl->power_fault_detected) {
> -		ctrl->power_fault_detected = 1;
> +	if (events & PCI_EXP_SLTSTA_PFD) {
>  		ctrl_err(ctrl, "Slot(%s): Power fault\n", slot_name(ctrl));
>  		pciehp_set_indicators(ctrl, PCI_EXP_SLTCTL_PWR_IND_OFF,
>  				      PCI_EXP_SLTCTL_ATTN_IND_ON);
> 
> 
