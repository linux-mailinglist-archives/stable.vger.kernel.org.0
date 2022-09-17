Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1EF5BBAC0
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 23:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiIQVwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 17:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQVwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 17:52:00 -0400
X-Greylist: delayed 42278 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 17 Sep 2022 14:51:58 PDT
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E4E52229E;
        Sat, 17 Sep 2022 14:51:58 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 3BAB592009C; Sat, 17 Sep 2022 23:51:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 2C9FF92009B;
        Sat, 17 Sep 2022 22:51:56 +0100 (BST)
Date:   Sat, 17 Sep 2022 22:51:56 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Bjorn Helgaas <helgaas@kernel.org>
cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] PCI: Sanitise firmware BAR assignments behind
 a PCI-PCI bridge
In-Reply-To: <20220419225008.GA1241595@bhelgaas>
Message-ID: <alpine.DEB.2.21.2209171611420.56231@angie.orcam.me.uk>
References: <20220419225008.GA1241595@bhelgaas>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Apr 2022, Bjorn Helgaas wrote:

> > linux-pci-setup-res-fw-address-nobridge.diff
> > Index: linux-macro/drivers/pci/setup-res.c
> > ===================================================================
> > --- linux-macro.orig/drivers/pci/setup-res.c
> > +++ linux-macro/drivers/pci/setup-res.c
> > @@ -212,9 +212,19 @@ static int pci_revert_fw_address(struct
> >  	res->end = res->start + size - 1;
> >  	res->flags &= ~IORESOURCE_UNSET;
> >  
> > +	/*
> > +	 * If we're behind a P2P or CardBus bridge, make sure we're
> > +	 * inside the relevant forwarding window, or otherwise the
> > +	 * assignment must have been bogus and accesses intended for
> > +	 * the range assigned would not reach the device anyway.
> > +	 * On the root bus accept anything under the assumption the
> > +	 * host bridge will let it through.
> > +	 */
> >  	root = pci_find_parent_resource(dev, res);
> >  	if (!root) {
> > -		if (res->flags & IORESOURCE_IO)
> > +		if (dev->bus->parent)
> > +			return -ENXIO;
> > +		else if (res->flags & IORESOURCE_IO)
> >  			root = &ioport_resource;
> >  		else
> >  			root = &iomem_resource;
> 
> Is there value in the ioport_resource and iomem_resource lines here?  
> They've been there since 58c84eda0756, when we didn't look for a
> parent resource.

 My understanding is this is the whole point of this code and said commit.  
If you look at PR16263 and e.g. comment #12, then you'll see that the case 
was that we have a PCI-to-PCI bridge device on the root bus (00:04.0) that 
decodes outside the root bus resource for the purpose of forwarding to its 
secondary bus and it works.  It is fine presumably because the host bridge 
does additional decoding outside the root bus resource and doesn't tell us 
about it.  However when we try to squeeze device 00:04.0 into space within 
the root bus resource as we know it, we overrun it and fail the 
assignment.

 So the fallback is to revert to what the firmware has left in the BARs, 
which is outside any PCI resource, causing `pci_find_parent_resource' to 
fail.  But to do such an assignment within our infrastructure, we need to 
allow assigning outside the root bus resource, which the reference to 
either `ioport_resource' or `iomem_resource' serves as required.

 Now that only works for devices on the root bus and not ones behind 
PCI-to-PCI bridges, where we do have to respect the parent's resource, 
because a PCI-to-PCI bridge is not allowed to randomly decode ranges 
beyond ones programmed in standard bridge BARs.

> 351fc6d1a517 ("PCI: Fix starting basis for resource requests") added
> the pci_find_parent_resource() call, and I think that *should* find
> the root bus resources if the device is on the root bus.  And the root
> bus resources should already include ioport_resource and
> iomem_resource if we don't have anything better.

 Now the description of this commit doesn't really explain (to me anyway) 
why it is needed or what scenario it addresses that commit 58c84eda0756 
didn't by itself handle correctly.

 My understanding is `pci_find_parent_resource' is expected to always fail 
in this path as otherwise there shouldn't have been the need to revert to 
firmware settings and this function wouldn't have been called in the first 
place.  This is because if there indeed is a parent resource the original 
firmware settings are supposed to fit, then our resource allocator would 
have found them and used them (or similar ones) rather than failing.

 So I really do not understand what case this commit is supposed to 
address.  So much for terse change descriptions without actual details of 
the case addressed!  If you are able to infer more or track down an actual 
discussion with extra information around this commit, then I'm all ears.

> So I wonder if we should just always return failure when we don't find
> a parent resource?

 IIUC it would defeat the purpose of commit 58c84eda0756 and is therefore 
a no-no AFAICT.

 If you agree with my interpretation, then I'll trim down the change 
description as you requested (but please bear in mind then it's better to 
have a little too much information rather than not enough or someone else 
may end up scratching their head over this change ten years from now just 
as I do over commit 351fc6d1a517 here) and repost the patch with the code 
update proper unchanged.  Let me know if you have any further questions or 
comments.

 Thank you for your review.

  Maciej
