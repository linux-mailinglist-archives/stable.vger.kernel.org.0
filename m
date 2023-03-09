Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE696B2B2B
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 17:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCIQuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 11:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjCIQt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 11:49:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEC1FE0B9;
        Thu,  9 Mar 2023 08:39:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A966261C4A;
        Thu,  9 Mar 2023 16:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E9AC433D2;
        Thu,  9 Mar 2023 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678379977;
        bh=lPti0CqiJyrVN8p1peO9ayPP4zvhtBCZaW4gjRkGXz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Hmd9ToL/4LqU26a4rwLzPqQpJBKFO8O+twt93NgBKvVPwnX+l0D9Ol3IV38M5Zao2
         ufqkOsdfBfSub5n5DO0TnGDEYsaiszTiNoGQckU+9qAuwLty8/q+buZ1jR2fbFBv3L
         WofwK2r/iDZKABvCQJzIRRT27sPnR1a4DG8esc4HeA3S185UFVUDcPgop47s+CGpbP
         kipr2ysjLmeFPZ8i0xPt9RfS8OEnhIPOkelIFmJVlBzIKm+c6Jm8yp56gEZb7wbaCd
         O4AIRxiBKLbGlH+9cxeilrw30RONRlR2TICcAaj4O9KoCbVqqZJtPPmOtLhV/cabi5
         BCrXSROYicgGA==
Date:   Thu, 9 Mar 2023 10:39:35 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Janne Grunau <j@jannau.net>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: apple: Set only available ports up
Message-ID: <20230309163935.GA1140101@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307-apple_pcie_disabled_ports-v2-1-c3bd1fd278a4@jannau.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Daire, Conor for apple/microchip use of ECAM .init() method]

On Thu, Mar 09, 2023 at 02:36:24PM +0100, Janne Grunau wrote:
> Fixes following warning inside of_irq_parse_raw() called from the common
> PCI device probe path.
> 
>   /soc/pcie@690000000/pci@1,0 interrupt-map failed, using interrupt-controller
>   WARNING: CPU: 4 PID: 252 at drivers/of/irq.c:279 of_irq_parse_raw+0x5fc/0x724

Based on this commit log, I assume this patch only fixes the warning,
and the system *works* just fine either way.  If that's the case, it's
debatable whether it meets the stable kernel criteria, although the
documented criteria are much stricter than what happens in practice.

>   ...
>   Call trace:
>    of_irq_parse_raw+0x5fc/0x724
>    of_irq_parse_and_map_pci+0x128/0x1d8
>    pci_assign_irq+0xc8/0x140
>    pci_device_probe+0x70/0x188
>    really_probe+0x178/0x418
>    __driver_probe_device+0x120/0x188
>    driver_probe_device+0x48/0x22c
>    __device_attach_driver+0x134/0x1d8
>    bus_for_each_drv+0x8c/0xd8
>    __device_attach+0xdc/0x1d0
>    device_attach+0x20/0x2c
>    pci_bus_add_device+0x5c/0xc0
>    pci_bus_add_devices+0x58/0x88
>    pci_host_probe+0x124/0x178
>    pci_host_common_probe+0x124/0x198 [pci_host_common]
>    apple_pcie_probe+0x108/0x16c [pcie_apple]
>    platform_probe+0xb4/0xdc
> 
> This became apparent after disabling unused PCIe ports in the Apple
> silicon device trees instead of deleting them.
> 
> Use for_each_available_child_of_node instead of for_each_child_of_node
> which takes the "status" property into account.
> 
> Link: https://lore.kernel.org/asahi/20230214-apple_dts_pcie_disable_unused-v1-0-5ea0d3ddcde3@jannau.net/
> Link: https://lore.kernel.org/asahi/1ea2107a-bb86-8c22-0bbc-82c453ab08ce@linaro.org/
> Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
> Cc: stable@vger.kernel.org
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Janne Grunau <j@jannau.net>
> ---
> Changes in v2:
> - rewritten commit message with more details and corrections
> - collected Marc's "Reviewed-by:"
> - Link to v1: https://lore.kernel.org/r/20230307-apple_pcie_disabled_ports-v1-1-b32ef91faf19@jannau.net
> ---
>  drivers/pci/controller/pcie-apple.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
> index 66f37e403a09..f8670a032f7a 100644
> --- a/drivers/pci/controller/pcie-apple.c
> +++ b/drivers/pci/controller/pcie-apple.c
> @@ -783,7 +783,7 @@ static int apple_pcie_init(struct pci_config_window *cfg)
>  	cfg->priv = pcie;
>  	INIT_LIST_HEAD(&pcie->ports);
>  
> -	for_each_child_of_node(dev->of_node, of_port) {
> +	for_each_available_child_of_node(dev->of_node, of_port) {
>  		ret = apple_pcie_setup_port(pcie, of_port);
>  		if (ret) {
>  			dev_err(pcie->dev, "Port %pOF setup fail: %d\n", of_port, ret);

Is this change still needed after 6fffbc7ae137 ("PCI: Honor firmware's
device disabled status")?  This is a generic problem, and it would be
a lot nicer if we had a generic solution.  But I assume it *is* still
needed because Rob gave his Reviewed-by.

Not related to this patch, but this function looks funny to me.  Most
pci_ecam_ops.init functions just set up ECAM-related things.

In addition to ECAM stuff, apple_pcie_init() and mc_platform_init()
also initialize IRQs, clocks, and resets.

Maybe we shoehorn the IRQ, clock, reset setup into pci_ecam_ops.init
because we lack a generic hook for doing those things, but it seems a
little muddy conceptually.

Bjorn
