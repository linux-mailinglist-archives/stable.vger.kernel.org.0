Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403D5676C30
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 11:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjAVK6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 05:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjAVK6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 05:58:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE64D4C35;
        Sun, 22 Jan 2023 02:58:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8002BB80A36;
        Sun, 22 Jan 2023 10:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8154C433D2;
        Sun, 22 Jan 2023 10:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674385082;
        bh=ByCGf5RX78/mkAxYc+ERxDI9C5SV6TUWVm84iW4jpDw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lovkQmpNtvJJX4n1F8dwQ3UY08y4kjSEABo67kjYmujM4DycY+4aPd5XKzlVYVmyU
         WpfCEBLzmjPUtsEUV5i31xViPi5dR00JP9FhheHmbROXHogySyE1uUCHX7YrswffOd
         duYKQpN6ilEDD7m56A5aYm9EdgOxedvYziLV2AMM=
Date:   Sun, 22 Jan 2023 11:57:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, darwi@linutronix.de,
        elena.reshetova@intel.com, kirill.shutemov@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Message-ID: <Y80WtujnO7kfduAZ@kroah.com>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
 <Y8z7FPcuDXDBi+1U@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8z7FPcuDXDBi+1U@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 11:00:04AM +0200, Leon Romanovsky wrote:
> On Thu, Jan 19, 2023 at 07:06:32PM +0200, Alexander Shishkin wrote:
> > A malicious device can change its MSIX table size between the table
> > ioremap() and subsequent accesses, resulting in a kernel page fault in
> > pci_write_msg_msix().
> > 
> > To avoid this, cache the table size observed at the moment of table
> > ioremap() and use the cached value. This, however, does not help drivers
> > that peek at the PCIE_MSIX_FLAGS register directly.
> > 
> > Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/pci/msi/api.c | 7 ++++++-
> >  drivers/pci/msi/msi.c | 2 +-
> >  include/linux/pci.h   | 1 +
> >  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> I'm not security expert here, but not sure that this protects from anything.
> 1. Kernel relies on working and not-malicious HW. There are gazillion ways
> to cause crashes other than changing MSI-X.

Linux does NOT protect from malicious PCIe devices at this point in
time, you are correct.  If we wish to change that model, then we can
work on that with the explict understanding that most all drivers will
need to change as will the bus logic for the busses involved.

To do piece-meal patches like this for no good reason is not a good idea
as it achieves nothing in the end :(

thanks,

greg k-h
