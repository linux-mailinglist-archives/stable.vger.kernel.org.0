Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE1259D1C8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 09:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiHWHL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 03:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240880AbiHWHLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 03:11:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0862361D59;
        Tue, 23 Aug 2022 00:11:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F627B801C0;
        Tue, 23 Aug 2022 07:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA25C433D6;
        Tue, 23 Aug 2022 07:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661238675;
        bh=vMiL6tXO64IX78O0F1aZDGjmvXqzBiRZfMNOvY56/yc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sAXFQaKxAKlCaC7NX2XtYskIX7HQAcGV2PhFFxMovv9H01hIZnB8HG2j3roNk9mn9
         0Qh1nhXLd9lFMfUaEw+6kXC3Q3qdnWkXtkBOMxILre+GO8H2gJsMsCEylYnxdg7BNT
         aW0K0lA5C0AzHIztQaBAlSxyc88eSbIQthX8qP7Y=
Date:   Tue, 23 Aug 2022 09:11:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean V Kelley <sean.v.kelley@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-pci@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Hinko Kocevar <hinko.kocevar@ess.eu>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kuppuswamy, Sathyanarayanan" <sathyanarayanan.kuppuswamy@intel.com>
Subject: Re: [PATCH 5.10 480/545] PCI/ERR: Add pci_walk_bridge() to
 pcie_do_recovery()
Message-ID: <YwR9kFH3UqhkV4d0@kroah.com>
References: <20220819153850.911668266@linuxfoundation.org>
 <YwL/brvUP1aiwo93@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwL/brvUP1aiwo93@atmark-techno.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 01:00:46PM +0900, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Fri, Aug 19, 2022 at 05:44:10PM +0200:
> > From: Sean V Kelley <sean.v.kelley@intel.com>
> > 
> > [ Upstream commit 05e9ae19ab83881a0f33025bd1288e41e552a34b ]
> > 
> > Consolidate subordinate bus checks with pci_walk_bus() into
> > pci_walk_bridge() for walking below potentially AER affected bridges.
> > 
> > Link: https://lore.kernel.org/r/20201121001036.8560-10-sean.v.kelley@intel.com
> > Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # non-native/no RCEC
> > Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/pci/pcie/err.c | 30 +++++++++++++++++++++++-------
> >  1 file changed, 23 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
> > index 931e75f2549d..8b53aecdb43d 100644
> > --- a/drivers/pci/pcie/err.c
> > +++ b/drivers/pci/pcie/err.c
> > [...]
> > @@ -165,23 +182,22 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
> >  	else
> >  		bridge = pci_upstream_bridge(dev);
> >  
> > -	bus = bridge->subordinate;
> >  	pci_dbg(bridge, "broadcast error_detected message\n");
> >  	if (state == pci_channel_io_frozen) {
> > -		pci_walk_bus(bus, report_frozen_detected, &status);
> > +		pci_walk_bridge(bridge, report_frozen_detected, &status);
> >  		status = reset_subordinates(bridge);
> >  		if (status != PCI_ERS_RESULT_RECOVERED) {
> >  			pci_warn(bridge, "subordinate device reset failed\n");
> >  			goto failed;
> >  		}
> 
> A local conflict merging this made me notice a later commit:
> -----
> commit 387c72cdd7fb6bef650fb078d0f6ae9682abf631
> Author: Keith Busch <kbusch@kernel.org>
> Date:   Mon Jan 4 15:02:58 2021 -0800
> 
> PCI/ERR: Retain status from error notification
> 
> Overwriting the frozen detected status with the result of the link reset
> loses the NEED_RESET result that drivers are depending on for error
> handling to report the .slot_reset() callback. Retain this status so
> that subsequent error handling has the correct flow.
> 
> Link: https://lore.kernel.org/r/20210104230300.1277180-4-kbusch@kernel.org
> Reported-by: Hinko Kocevar <hinko.kocevar@ess.eu>
> Tested-by: Hedi Berriche <hedi.berriche@hpe.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Sean V Kelley <sean.v.kelley@intel.com>
> Acked-by: Hedi Berriche <hedi.berriche@hpe.com>
> 
> diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
> index a84f0bf4c1e2..b576aa890c76 100644
> --- a/drivers/pci/pcie/err.c
> +++ b/drivers/pci/pcie/err.c
> @@ -198,8 +198,7 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
>  	pci_dbg(bridge, "broadcast error_detected message\n");
>  	if (state == pci_channel_io_frozen) {
>  		pci_walk_bridge(bridge, report_frozen_detected, &status);
> -		status = reset_subordinates(bridge);
> -		if (status != PCI_ERS_RESULT_RECOVERED) {
> +		if (reset_subordinates(bridge) != PCI_ERS_RESULT_RECOVERED) {
>  			pci_warn(bridge, "subordinate device reset failed\n");
>  			goto failed;
>  		}
> -----
> 
> Since this (commit I reply to) has been picked up, I think it'd make
> sense to also include this (commit I just listed) in a later 5.10 tag.
> It cherry-picks without error but would you like me to resend?
> (I have added in Cc all involved people to this mail)
> 
> Digging through the mails the patch came with seem to imply approval for
> stable merges; but it didn't make sense until pci_walk_bridge() had been
> added just now. Now it's here we probably want both:
> https://lore.kernel.org/all/d9ee4151-b28d-a52a-b5be-190a75e0e49b@intel.com/
> 
> 
> (I noticed because the NXP kernel we are provided includes a different
> "fix" for what I believe to be the same issue, previously discussed here:
> https://lore.kernel.org/linux-pci/12115.1588207324@famine/
> 
> I haven't actually encountered any of the problems discribed, so this is
> purely theorical for me; it just looks a bit weird.)

I've queued up the commit you referenced above now, thanks!

greg k-h
