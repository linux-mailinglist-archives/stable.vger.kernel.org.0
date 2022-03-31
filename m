Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48E24EDF31
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240331AbiCaQ72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiCaQ72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D84232128;
        Thu, 31 Mar 2022 09:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B41F26130D;
        Thu, 31 Mar 2022 16:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCB4C340ED;
        Thu, 31 Mar 2022 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648745860;
        bh=igvAvAQeyELaJZGiURaidLDfiJ9bucjWU0/u3Bx78+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p3O0Yr20Zzryj9CMPn8goSqUTEYcrdwH6a6P5RDADVxSPMC98mi/YN7wftGRziKly
         O9K34sVHKNIzfHOAD1dmmTA/HfiWHaLEg8rXwFrtNwpa2JELbHmfSBxdCmDGUzkmoA
         AP90rl1S+qDeytxkanfeH5ahB2Wy23kxqLW8kX1Y=
Date:   Thu, 31 Mar 2022 18:57:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benson Leung <bleung@google.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Won Chung <wonchung@google.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] misc/mei: Add NULL check to component match callback
 functions
Message-ID: <YkXdgQH1GWCitf0A@kroah.com>
References: <20220331084918.2592699-1-wonchung@google.com>
 <YkVtvhC0n9B994/A@kroah.com>
 <YkV1KK8joyDAgf50@kuha.fi.intel.com>
 <YkWSmvrEevLsyDH5@kroah.com>
 <YkXRKyfoWTXqLi1L@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkXRKyfoWTXqLi1L@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 09:04:59AM -0700, Benson Leung wrote:
> Hi Greg,
> 
> On Thu, Mar 31, 2022 at 01:38:02PM +0200, Greg KH wrote:
> > > > >  		return 0;
> > > > >  
> > > > > diff --git a/drivers/misc/mei/pxp/mei_pxp.c b/drivers/misc/mei/pxp/mei_pxp.c
> > > > > index f7380d387bab..e32a81da8af6 100644
> > > > > --- a/drivers/misc/mei/pxp/mei_pxp.c
> > > > > +++ b/drivers/misc/mei/pxp/mei_pxp.c
> > > > > @@ -131,7 +131,7 @@ static int mei_pxp_component_match(struct device *dev, int subcomponent,
> > > > >  {
> > > > >  	struct device *base = data;
> > > > >  
> > > > > -	if (strcmp(dev->driver->name, "i915") ||
> > > > > +	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||
> > > > 
> > > > Same here, shouldn't this be caught by the driver core or bus and match
> > > > should not be called?
> > > > 
> > > > Why not fix this in the component/driver core instead?
> > > 
> > > A component is just a device that is declared to be a "component", and
> > > the code that declares it as component does not have to be the driver
> > > of that device. You simply can't assume that it's bind to a driver
> > > like this function does.
> > > 
> > > In our case the "components" are USB ports, so devices that are never
> > > bind to drivers.
> > 
> > And going off of the driver name is sane?  That feels ripe for bugs and
> > problems in the future, but hey, I don't understand the need for this
> > driver to care about another driver at all.
> 
> I think the component framework is meant to be this loose confederation of
> devices, so going into component match, you don't know what the other device
> is yet.
> 
> The USB drivers and the i915 drivers 100% don't care about each other,
> but the framework doesn't know that yet until all the drivers try to match.
> 
> > 
> > And why is a USB device being passed to something that it thinks is a
> > PCI device?  That too feels really wrong and ripe for problems.
> > 
> 
> The problematic device that's being passed through here is actually the
> usb4_port, not a usb device. My guess would be that's why it's getting past any
> checks for whether it's a PCI device.

a usb4 port should not be a pci device.

So fix up the checks, don't do a random "is this the driver name?"
check, look for the real driver pointer or something like that that you
KNOW is the correct match.

> The component framework currently being used by (hdac_i915, mei_hdcp, mei_pxp)
> to connect those three devices together, and completely separately, the
> component framework is being used by the typec connector class's port mapper.
> 
> These two clusters of devices are using the same component framework, but are
> not supposed to interact with each other. When we attempted to add the usb4_port
> and its retimer in order to link tbt/usb4 to the typec connector, we discovered
> this interaction because we happened to build the usb4_port built-in in our
> configs, so it does its component_add earlier.
> 
> I agree, by the way. This is all a bit ugly.

Something is wrong with the component code here if this is happening, as
that's not a solid interface that can actually work at all.

Perhaps do not use this framework until it is fixed?

And again, is this something that you see today on an unmodified 5.17.1
release?  If not, why all of the stable backport requests?

confused,

greg k-h
