Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063ED6B3CA7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 11:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCJKp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 05:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCJKpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 05:45:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B678CF8E53;
        Fri, 10 Mar 2023 02:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CCDEB82254;
        Fri, 10 Mar 2023 10:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EFDC4339B;
        Fri, 10 Mar 2023 10:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678445140;
        bh=xdOv7uNCigwmUrpXzidKOlMmbXveRlJ+/d2EH0ufkdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jl4DgVXkQgVApUmLK5cswQkRfI3PYbMMw0LpnYUYVELSnyJP1RA2gp8LoJBVfAf7s
         IPNWnET6kchDKrZPHx/DQZapWnZZR/VLhdZv46pU1sAZ8sR0Q3qP6Y2hK2yYdlzXgS
         Mi0RgMVB/PFg7/vTlZ1qQNkj4lDXGjHvirleuJaPVsCsvv6IV9yOKi9dRMmz7/KKMn
         LKWZav7zA3N5KmBqYbBfQYFH2IIVro6GIG1oCGPS85jqOd+jRqpwvl7EbwQ7PEWYX0
         EjLXIGqKjp19IO9P1JE83r53UtwE0fJlcNwRawavcGFyLYvbsLdqxunyCbQHoSoukO
         rSnB8PSiceUJA==
Date:   Fri, 10 Mar 2023 11:45:34 +0100
From:   Lorenzo Pieralisi <lpieralisi@kernel.org>
To:     Xi Ruoyao <xry111@xry111.site>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Xiaowei Song <songxiaowei@huawei.com>, stable@vger.kernel.org
Subject: Re: Ping: [PATCH] PCI: kirin: Select REGMAP_MMIO for PCIE_KIRIN
Message-ID: <ZAsKThAQPbGVUig8@lpieralisi>
References: <20230228043423.19335-1-xry111@xry111.site>
 <8996e9ba32cbdc24b828c9a37793b39f17eb33a8.camel@xry111.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8996e9ba32cbdc24b828c9a37793b39f17eb33a8.camel@xry111.site>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 01:42:01PM +0800, Xi Ruoyao wrote:
> Gentle ping.
> 
> On Tue, 2023-02-28 at 12:34 +0800, Xi Ruoyao wrote:
> > pcie-kirin.c invokes devm_regmap_init_mmio, so it's necessary to
> > select
> > REGMAP_MMIO or vmlinux fails to link with "undefined reference to
> > `__devm_regmap_init_mmio_clk`.
> > 
> > Cc: stable@vger.kernel.org # at least for 6.1 and 6.2

I merged this (with a rewritten commit log, Fixes tag and
CC stable - please have a look and check how this has to
be written for future submissions):

https://lore.kernel.org/linux-pci/167844411812.1209684.12017386820985241641.b4-ty@kernel.org

This patch is dropped.

Thanks,
Lorenzo

> > Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> > ---
> >  drivers/pci/controller/dwc/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/pci/controller/dwc/Kconfig
> > b/drivers/pci/controller/dwc/Kconfig
> > index 434f6a4f4041..d29551261e80 100644
> > --- a/drivers/pci/controller/dwc/Kconfig
> > +++ b/drivers/pci/controller/dwc/Kconfig
> > @@ -307,6 +307,7 @@ config PCIE_KIRIN
> >         tristate "HiSilicon Kirin series SoCs PCIe controllers"
> >         depends on PCI_MSI
> >         select PCIE_DW_HOST
> > +       select REGMAP_MMIO
> >         help
> >           Say Y here if you want PCIe controller support
> >           on HiSilicon Kirin series SoCs.
> 
> -- 
> Xi Ruoyao <xry111@xry111.site>
> School of Aerospace Science and Technology, Xidian University
