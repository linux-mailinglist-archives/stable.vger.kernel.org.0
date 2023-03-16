Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915DF6BCD1F
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 11:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjCPKr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 06:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCPKrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 06:47:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99B7B53EB;
        Thu, 16 Mar 2023 03:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC764B820F1;
        Thu, 16 Mar 2023 10:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA71C433D2;
        Thu, 16 Mar 2023 10:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678963638;
        bh=oVJKXXmyFemiia076cROVBxSR0hcwYomgygILOaiuhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=STJX+/4MELf1XFf3XtEMCdDHYG4U1N5l+NIK58bK8/DoopMvH1mDx2l44s0smoKTt
         1inb1y/H0vpPXsRJU/oept6d7jc/yot9fg/sbKfjjq1CPN5OnLc/6xiKnsj/er64aB
         tif80s7q2HhNyW3jfDTfNbdTy6BlvRPYJGoWjJ7q5ieU1ZQUgsblnRuItuLa9+CE2f
         Ah3/nh1j1HAQSlCHD1MdhTM4uiWKZHZp99ioSjMDmdhiIEkA3v3X0puzAxD3huLd1j
         qNddr70dq8SErG5Kk+q9bp140tX4r0/eUPdX76rjZ3UORdPlOvoLIU50ljJOoKIicH
         OwGkX+oUJQk1w==
Date:   Thu, 16 Mar 2023 11:47:11 +0100
From:   Lorenzo Pieralisi <lpieralisi@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, Janne Grunau <j@jannau.net>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        asahi@lists.linux.dev, linux-kernel@vger.kernel.org,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: apple: Set only available ports up
Message-ID: <ZBLzr1MZ2whtvusL@lpieralisi>
References: <20230307-apple_pcie_disabled_ports-v2-1-c3bd1fd278a4@jannau.net>
 <20230309163935.GA1140101@bhelgaas>
 <86a60dxcr0.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a60dxcr0.wl-maz@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 09:32:35AM +0000, Marc Zyngier wrote:
> On Thu, 09 Mar 2023 16:39:35 +0000,
> Bjorn Helgaas <helgaas@kernel.org> wrote:
> > 
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
> > 
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
> I'm not sure this is addressing the same issue. The way I read it, the
> patch you mention here allows a PCI device to be disabled in firmware,
> even if it could otherwise be probed.
> 
> What this patch does is to prevent root ports that exist in the HW but
> that have been disabled from being probed. Same concept, only at a
> different level.

A root port is a PCI device though and that's what's causing the warning
AFAIK (? it is triggered on the root port PCI device pci_assign_irq()
call), I am not sure the root port DT node is associated with the root
port PCI device correctly, which might explain why, even after
6fffbc7ae137, the PCI enumeration code is adding the root port PCI
device to the PCI tree.

Is the dts available anywhere ? How are root ports described in it ?

Lorenzo
