Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBCB6AFAFC
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 01:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCHAUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 19:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCHAUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 19:20:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A43E96096;
        Tue,  7 Mar 2023 16:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24534B815E6;
        Wed,  8 Mar 2023 00:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CA5C433D2;
        Wed,  8 Mar 2023 00:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678234819;
        bh=/1KG94RNtNfOwyEyvtWapeQN+ftz3LtLGEnFKj/PSwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DMOdH9lXNsxr7PqWBQwjns1cp7mftqZy9Nul7jq9dtoy6QnA5SMKVSTz9povKo+W3
         u+XjL/yINkdzgx1ceqJaLCHQJ8z90esmhYfk3xZtU/sAcsCepNeLBedP0AG64rEwEy
         peS2jQ+wNem/Y992dqlTf7GbTWzSRwLgKZbXlbO7dAKZz0+SXhGA32M5EypGMWseUJ
         hVDsBuC7Le+JL2I3/HtnU1YujYAy7lDPDjFzF431fWIdN26ygGfQZzhiZgY0OwlsdA
         ie640X8pg3cTb5FRcPKBQztQzQ3PIqwTxkv1r8iuGBcgRxYqLN/9AYXyJIJdGiNVxU
         s1rQiSN1Ycb1A==
Date:   Tue, 7 Mar 2023 18:20:18 -0600
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
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: apple: Set only available ports up
Message-ID: <20230308002018.GA913897@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307-apple_pcie_disabled_ports-v1-1-b32ef91faf19@jannau.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for your patch.

On Tue, Mar 07, 2023 at 11:59:50PM +0100, Janne Grunau wrote:
> Fixes "interrupt-map" parsing in of_irq_parse_raw() which takes the
> node's availability into account.

I don't really know what this means.  The patch looks like a fix to
apple_pcie_init(), not to of_irq_parse_raw().  I assume maybe this is
to do with the irq_of_parse_and_map() in apple_pcie_port_setup_irq()?

> This became apparent after disabling unused PCIe ports in the Apple
> silicon device trees instead of disabling them.

"... disabling unused PCIe ports ... instead of disabling them"
doesn't read quite right.  Maybe it should read "instead of *deleting*
them"?  Not sure because I don't know the background here.

> Link: https://lore.kernel.org/asahi/20230214-apple_dts_pcie_disable_unused-v1-0-5ea0d3ddcde3@jannau.net/
> Link: https://lore.kernel.org/asahi/1ea2107a-bb86-8c22-0bbc-82c453ab08ce@linaro.org/
> Fixes: 1e33888fbe44 ("PCI: apple: Add initial hardware bring-up")
> Cc: stable@vger.kernel.org
> Signed-off-by: Janne Grunau <j@jannau.net>
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
> 
> ---
> base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
> change-id: 20230307-apple_pcie_disabled_ports-0c17fb7a4738
> 
> Best regards,
> -- 
> Janne Grunau <j@jannau.net>
> 
