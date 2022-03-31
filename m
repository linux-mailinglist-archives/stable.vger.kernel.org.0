Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961A64ED898
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 13:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiCaLj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 07:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiCaLjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 07:39:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52B0208247;
        Thu, 31 Mar 2022 04:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8015961534;
        Thu, 31 Mar 2022 11:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A86DC340ED;
        Thu, 31 Mar 2022 11:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648726686;
        bh=/jI8Y2KnjFMiq0vz5kPkp3upN5zf40lZ63WmlzK4JIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QmbXyl3x9opWS5I5HuQOfmYLg/S2gTYFf+btlwjkEb6OYK9x2eOjky/1VGHzeV3Yg
         5Mht1VcgA+iUjho9ZlpOTynkhLoXqf2kWZAGWR1VZkMW4XqbdC9P5yRYlodsLrzAye
         +yGquo1sdj/0AF0xWrDn/7acj7s1L23ljSAYStSM=
Date:   Thu, 31 Mar 2022 13:38:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Won Chung <wonchung@google.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] misc/mei: Add NULL check to component match callback
 functions
Message-ID: <YkWSmvrEevLsyDH5@kroah.com>
References: <20220331084918.2592699-1-wonchung@google.com>
 <YkVtvhC0n9B994/A@kroah.com>
 <YkV1KK8joyDAgf50@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkV1KK8joyDAgf50@kuha.fi.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 12:32:24PM +0300, Heikki Krogerus wrote:
> On Thu, Mar 31, 2022 at 11:00:46AM +0200, Greg KH wrote:
> > On Thu, Mar 31, 2022 at 08:49:18AM +0000, Won Chung wrote:
> > > Component match callback functions need to check if expected data is
> > > passed to them. Without this check, it can cause a NULL pointer
> > > dereference when another driver registers a component before i915
> > > drivers have their component master fully bind.
> > 
> > How can that happen in a real system?  Or does this just happen for when
> > you are doing development and testing?
> > 
> > > 
> > > Fixes: 1e8d19d9b0dfc ("mei: hdcp: bind only with i915 on the same PCH")
> > > Fixes: c2004ce99ed73 ("mei: pxp: export pavp client to me client bus")
> > > Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > > Suggested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Signed-off-by: Won Chung <wonchung@google.com>
> > > Cc: stable@vger.kernel.org
> > 
> > Why does this need to go to stable?  How can this be triggered in older
> > kernels?
> > 
> > > ---
> > > Changes from v2:
> > > - Correctly add "Suggested-by" tag
> > > - Add "Cc: stable@vger.kernel.org"
> > > 
> > > Changes from v1:
> > > - Add "Fixes" tag
> > > - Send to stable@vger.kernel.org
> > > 
> > >  drivers/misc/mei/hdcp/mei_hdcp.c | 2 +-
> > >  drivers/misc/mei/pxp/mei_pxp.c   | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
> > > index ec2a4fce8581..843dbc2b21b1 100644
> > > --- a/drivers/misc/mei/hdcp/mei_hdcp.c
> > > +++ b/drivers/misc/mei/hdcp/mei_hdcp.c
> > > @@ -784,7 +784,7 @@ static int mei_hdcp_component_match(struct device *dev, int subcomponent,
> > >  {
> > >  	struct device *base = data;
> > >  
> > > -	if (strcmp(dev->driver->name, "i915") ||
> > > +	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||
> > 
> > How can base be NULL?
> > 
> > 
> > >  	    subcomponent != I915_COMPONENT_HDCP)
> > >  		return 0;
> > >  
> > > diff --git a/drivers/misc/mei/pxp/mei_pxp.c b/drivers/misc/mei/pxp/mei_pxp.c
> > > index f7380d387bab..e32a81da8af6 100644
> > > --- a/drivers/misc/mei/pxp/mei_pxp.c
> > > +++ b/drivers/misc/mei/pxp/mei_pxp.c
> > > @@ -131,7 +131,7 @@ static int mei_pxp_component_match(struct device *dev, int subcomponent,
> > >  {
> > >  	struct device *base = data;
> > >  
> > > -	if (strcmp(dev->driver->name, "i915") ||
> > > +	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||
> > 
> > Same here, shouldn't this be caught by the driver core or bus and match
> > should not be called?
> > 
> > Why not fix this in the component/driver core instead?
> 
> A component is just a device that is declared to be a "component", and
> the code that declares it as component does not have to be the driver
> of that device. You simply can't assume that it's bind to a driver
> like this function does.
> 
> In our case the "components" are USB ports, so devices that are never
> bind to drivers.

And going off of the driver name is sane?  That feels ripe for bugs and
problems in the future, but hey, I don't understand the need for this
driver to care about another driver at all.

And why is a USB device being passed to something that it thinks is a
PCI device?  That too feels really wrong and ripe for problems.

thanks,

greg k-h
