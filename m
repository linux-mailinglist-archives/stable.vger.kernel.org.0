Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3A6B059D
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 12:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjCHLPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 06:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjCHLPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 06:15:36 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1851C93112;
        Wed,  8 Mar 2023 03:15:34 -0800 (PST)
Received: by soltyk.jannau.net (Postfix, from userid 1000)
        id 6462726F897; Wed,  8 Mar 2023 12:15:32 +0100 (CET)
Date:   Wed, 8 Mar 2023 12:15:32 +0100
From:   Janne Grunau <j@jannau.net>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: apple: Set only available ports up
Message-ID: <20230308111532.GG24656@jannau.net>
References: <20230307-apple_pcie_disabled_ports-v1-1-b32ef91faf19@jannau.net>
 <20230308002018.GA913897@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308002018.GA913897@bhelgaas>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-03-07 18:20:18 -0600, Bjorn Helgaas wrote:
> Thanks for your patch.
> 
> On Tue, Mar 07, 2023 at 11:59:50PM +0100, Janne Grunau wrote:
> > Fixes "interrupt-map" parsing in of_irq_parse_raw() which takes the
> > node's availability into account.
> 
> I don't really know what this means.  The patch looks like a fix to
> apple_pcie_init(), not to of_irq_parse_raw().  I assume maybe this is
> to do with the irq_of_parse_and_map() in apple_pcie_port_setup_irq()?

no, it happens inside the pci_host_common_probe() call but the root 
cause of the problem is that pcie-apple inits disabled ports. It would 
have been clearer if I pasted the warning, see below:

| /soc/pcie@690000000/pci@1,0 interrupt-map failed, using 
interrupt-controller
| WARNING: CPU: 4 PID: 252 at drivers/of/irq.c:279 
of_irq_parse_raw+0x5fc/0x724
| ...
| Call trace:
|  of_irq_parse_raw+0x5fc/0x724
|  of_irq_parse_and_map_pci+0x128/0x1d8
|  pci_assign_irq+0xc8/0x140
|  pci_device_probe+0x70/0x188
|  really_probe+0x178/0x418
|  __driver_probe_device+0x120/0x188
|  driver_probe_device+0x48/0x22c
|  __device_attach_driver+0x134/0x1d8
|  bus_for_each_drv+0x8c/0xd8
|  __device_attach+0xdc/0x1d0
|  device_attach+0x20/0x2c
|  pci_bus_add_device+0x5c/0xc0
|  pci_bus_add_devices+0x58/0x88
|  pci_host_probe+0x124/0x178
|  pci_host_common_probe+0x124/0x198 [pci_host_common]
|  apple_pcie_probe+0x108/0x16c [pcie_apple]
|  platform_probe+0xb4/0xdc

> > This became apparent after disabling unused PCIe ports in the Apple
> > silicon device trees instead of disabling them.
> 
> "... disabling unused PCIe ports ... instead of disabling them"
> doesn't read quite right.  Maybe it should read "instead of *deleting*
> them"?  Not sure because I don't know the background here.

err, yes I ment, "instead of deleting them".
 
> > Link: https://lore.kernel.org/asahi/20230214-apple_dts_pcie_disable_unused-v1-0-5ea0d3ddcde3@jannau.net/
> > Link: https://lore.kernel.org/asahi/1ea2107a-bb86-8c22-0bbc-82c453ab08ce@linaro.org/
> > Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Janne Grunau <j@jannau.net>
> > ---
> >  drivers/pci/controller/pcie-apple.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
> > index 66f37e403a09..f8670a032f7a 100644
> > --- a/drivers/pci/controller/pcie-apple.c
> > +++ b/drivers/pci/controller/pcie-apple.c
> > @@ -783,7 +783,7 @@ static int apple_pcie_init(struct pci_config_window *cfg)
> >  	cfg->priv = pcie;
> >  	INIT_LIST_HEAD(&pcie->ports);
> >  
> > -	for_each_child_of_node(dev->of_node, of_port) {
> > +	for_each_available_child_of_node(dev->of_node, of_port) {
> >  		ret = apple_pcie_setup_port(pcie, of_port);
> >  		if (ret) {
> >  			dev_err(pcie->dev, "Port %pOF setup fail: %d\n", of_port, ret);
> > 
> > ---
> > base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
> > change-id: 20230307-apple_pcie_disabled_ports-0c17fb7a4738
> > 

Janne
