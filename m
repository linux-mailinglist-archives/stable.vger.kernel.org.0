Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046656BE510
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 10:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCQJMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 05:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjCQJMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 05:12:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696631A482;
        Fri, 17 Mar 2023 02:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1DDD62243;
        Fri, 17 Mar 2023 09:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52552C433EF;
        Fri, 17 Mar 2023 09:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679044335;
        bh=yIBWbJIYgG7lzu3cPwnPr24tCM1jWhNKwE63jEH40XI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DLDuqfOWe2nJQQWCu6USvWskzisA+FW5J/GUjoTAR9FP6Gv/gsUyPsyS7T/K++rWf
         zJ+dY0xI4DDP+pTn7SQWsJoeC9yIvYkCLGTZhnexu94dqdBsNTuy0wGxOnwo4Q/zMM
         VNkcTnRfKVp1tkrY3q1vkDMARN4ZLBREsg3MB5n/d7bzj23YH8qFVbj1MQsppxLzyy
         b8hZkl6PXb4E+KP66CoT2GT8Z4AQFmYvYQ46+PP5zGiGX5+dnmBCmOmgMh5OMQtrTb
         +M2OsoOOsx0G2SCXaZtplTxYyOgBbE/Bl4UXmlRZMFlpJSvOdhqfCzS1po+ji40vZ1
         c77C5wm7qegdA==
Date:   Fri, 17 Mar 2023 10:12:08 +0100
From:   Lorenzo Pieralisi <lpieralisi@kernel.org>
To:     Janne Grunau <j@jannau.net>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Marc Zyngier <maz@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: apple: Set only available ports up
Message-ID: <ZBQu6PBvNVO1ps/A@lpieralisi>
References: <20230307-apple_pcie_disabled_ports-v2-1-c3bd1fd278a4@jannau.net>
 <20230309163935.GA1140101@bhelgaas>
 <20230316212217.GI24656@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316212217.GI24656@jannau.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 10:22:17PM +0100, Janne Grunau wrote:
> On 2023-03-09 10:39:35 -0600, Bjorn Helgaas wrote:
> > [+cc Daire, Conor for apple/microchip use of ECAM .init() method]
> > 
> > On Thu, Mar 09, 2023 at 02:36:24PM +0100, Janne Grunau wrote:
> > > Fixes following warning inside of_irq_parse_raw() called from the common
> > > PCI device probe path.
> > > 
> > >   /soc/pcie@690000000/pci@1,0 interrupt-map failed, using interrupt-controller
> > >   WARNING: CPU: 4 PID: 252 at drivers/of/irq.c:279 of_irq_parse_raw+0x5fc/0x724
> > 
> > Based on this commit log, I assume this patch only fixes the warning,
> > and the system *works* just fine either way.  If that's the case, it's
> > debatable whether it meets the stable kernel criteria, although the
> > documented criteria are much stricter than what happens in practice.
> 
> Yes, it fixes only the warning and hides devices. The present devices 
> still work. I confused myself with the submitted M2 devicetree. It 
> missed information in the dt node of an disabled PCIe port breaking 
> probing of the pcie controller.
>  
> I agree that the Cc: stable is not necessary. Please drop it or tell me 
> to resend the change.

I think this change is not needed as it stands. If the goal is
to disable *probing* some root ports for power efficiency, we
need a different commit log altogether, see below.

> > >   ...
> > >   Call trace:
> > >    of_irq_parse_raw+0x5fc/0x724
> > >    of_irq_parse_and_map_pci+0x128/0x1d8
> > >    pci_assign_irq+0xc8/0x140
> > >    pci_device_probe+0x70/0x188
> > >    really_probe+0x178/0x418
> > >    __driver_probe_device+0x120/0x188
> > >    driver_probe_device+0x48/0x22c
> > >    __device_attach_driver+0x134/0x1d8
> > >    bus_for_each_drv+0x8c/0xd8
> > >    __device_attach+0xdc/0x1d0
> > >    device_attach+0x20/0x2c
> > >    pci_bus_add_device+0x5c/0xc0
> > >    pci_bus_add_devices+0x58/0x88
> > >    pci_host_probe+0x124/0x178
> > >    pci_host_common_probe+0x124/0x198 [pci_host_common]
> > >    apple_pcie_probe+0x108/0x16c [pcie_apple]
> > >    platform_probe+0xb4/0xdc
> > > 
> > > This became apparent after disabling unused PCIe ports in the Apple
> > > silicon device trees instead of deleting them.
> > > 
> > > Use for_each_available_child_of_node instead of for_each_child_of_node
> > > which takes the "status" property into account.
> > > 
> > > Link: https://lore.kernel.org/asahi/20230214-apple_dts_pcie_disable_unused-v1-0-5ea0d3ddcde3@jannau.net/
> > > Link: https://lore.kernel.org/asahi/1ea2107a-bb86-8c22-0bbc-82c453ab08ce@linaro.org/
> > > Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
> > > Cc: stable@vger.kernel.org
> > > Reviewed-by: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Janne Grunau <j@jannau.net>
> > > ---
> > > Changes in v2:
> > > - rewritten commit message with more details and corrections
> > > - collected Marc's "Reviewed-by:"
> > > - Link to v1: https://lore.kernel.org/r/20230307-apple_pcie_disabled_ports-v1-1-b32ef91faf19@jannau.net
> > > ---
> > >  drivers/pci/controller/pcie-apple.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
> > > index 66f37e403a09..f8670a032f7a 100644
> > > --- a/drivers/pci/controller/pcie-apple.c
> > > +++ b/drivers/pci/controller/pcie-apple.c
> > > @@ -783,7 +783,7 @@ static int apple_pcie_init(struct pci_config_window *cfg)
> > >  	cfg->priv = pcie;
> > >  	INIT_LIST_HEAD(&pcie->ports);
> > >  
> > > -	for_each_child_of_node(dev->of_node, of_port) {
> > > +	for_each_available_child_of_node(dev->of_node, of_port) {
> > >  		ret = apple_pcie_setup_port(pcie, of_port);
> > >  		if (ret) {
> > >  			dev_err(pcie->dev, "Port %pOF setup fail: %d\n", of_port, ret);
> > 
> > Is this change still needed after 6fffbc7ae137 ("PCI: Honor firmware's
> > device disabled status")?  This is a generic problem, and it would be
> > a lot nicer if we had a generic solution.  But I assume it *is* still
> > needed because Rob gave his Reviewed-by.
> 
> 6fffbc7ae137 avoids the warning and hides the disabled ports as well. I 
> think we want to keep this change however in the hope that avoiding the 
> port setup of disbled ports saves energy.

That's fine but the commit log must be rewritten, it is a completely
different aim than the one stated in the current commit log and it
is not stable material.

Thanks,
Lorenzo
