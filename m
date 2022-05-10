Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4365214D1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbiEJMMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 08:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241652AbiEJMLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:11:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B67224A65
        for <stable@vger.kernel.org>; Tue, 10 May 2022 05:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FF0C618EA
        for <stable@vger.kernel.org>; Tue, 10 May 2022 12:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CAEC385A6;
        Tue, 10 May 2022 12:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652184460;
        bh=wLkmdPvjuYmSP1dtPNW6BqAf/OxK8+9NjomJB7Q80ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UFjoEeKJ62UGOVVBH2IK2Io6oC5YMJ7s27AWBvy6IHsgbYAQ2s0ZS9tbc+CgUxAia
         3mdUjYfmlPDs8EjlyFMsbP1YyNDAbJVuMjuspjlBeLAi9q7UGgP7VS1SUbz1SLg3Df
         UzakV7AKPt982OMYL3yOxzMJthl+UXLnHdmcYAxA=
Date:   Tue, 10 May 2022 14:06:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        pali@kernel.org
Subject: Re: [PATCH 5.15 00/30] PCIe Aardvark controller backports for 5.15
Message-ID: <YnpVNRbRTvYIxeS4@kroah.com>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 06:57:25PM +0200, Marek Behún wrote:
> Hello Greg, Sasha,
> 
> this is backport of all the recet changes for the Aardvark PCIe controller
> for 5.15.
> These include
> - memory leak fix in driver unbind
> - more complete driver unbind
> - fixes for MSI support
> - add MSI-X support, which fixes support for some cards
> - add ERR interrupt support (which we really missed when debugging)
> 
> I also included some small cosmetic changes - this will make it easier
> to backport next fixes for the driver (there is another batch pending
> on linux-pci).
> 
> Marek
> 
> Marek Behún (5):
>   PCI: aardvark: Make MSI irq_chip structures static driver structures
>   PCI: aardvark: Make msi_domain_info structure a static driver
>     structure
>   PCI: aardvark: Use dev_fwnode() instead of
>     of_node_to_fwnode(dev->of_node)
>   PCI: aardvark: Drop __maybe_unused from advk_pcie_disable_phy()
>   PCI: aardvark: Update comment about link going down after link-up
> 
> Pali Rohár (25):
>   PCI: pci-bridge-emul: Add description for class_revision field
>   PCI: pci-bridge-emul: Add definitions for missing capabilities
>     registers
>   PCI: aardvark: Add support for DEVCAP2, DEVCTL2, LNKCAP2 and LNKCTL2
>     registers on emulated bridge
>   PCI: aardvark: Clear all MSIs at setup
>   PCI: aardvark: Comment actions in driver remove method
>   PCI: aardvark: Disable bus mastering when unbinding driver
>   PCI: aardvark: Mask all interrupts when unbinding driver
>   PCI: aardvark: Fix memory leak in driver unbind
>   PCI: aardvark: Assert PERST# when unbinding driver
>   PCI: aardvark: Disable link training when unbinding driver
>   PCI: aardvark: Disable common PHY when unbinding driver
>   PCI: aardvark: Replace custom PCIE_CORE_INT_* macros with
>     PCI_INTERRUPT_*
>   PCI: aardvark: Rewrite IRQ code to chained IRQ handler
>   PCI: aardvark: Check return value of generic_handle_domain_irq() when
>     processing INTx IRQ
>   PCI: aardvark: Refactor unmasking summary MSI interrupt
>   PCI: aardvark: Add support for masking MSI interrupts
>   PCI: aardvark: Fix setting MSI address
>   PCI: aardvark: Enable MSI-X support
>   PCI: aardvark: Add support for ERR interrupt on emulated bridge
>   PCI: aardvark: Optimize writing PCI_EXP_RTCTL_PMEIE and
>     PCI_EXP_RTSTA_PME on emulated bridge
>   PCI: aardvark: Add support for PME interrupts
>   PCI: aardvark: Fix support for PME requester on emulated bridge
>   PCI: aardvark: Use separate INTA interrupt for emulated root bridge
>   PCI: aardvark: Remove irq_mask_ack() callback for INTx interrupts
>   PCI: aardvark: Don't mask irq when mapping
> 
>  drivers/pci/controller/pci-aardvark.c | 428 +++++++++++++++++++-------
>  drivers/pci/pci-bridge-emul.c         |  49 ++-
>  2 files changed, 371 insertions(+), 106 deletions(-)
> 
> -- 
> 2.35.1
> 

All now queued up, thanks.

greg k-h
