Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EA14ED700
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 11:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiCaJeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 05:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiCaJeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 05:34:15 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4461BD99C;
        Thu, 31 Mar 2022 02:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648719148; x=1680255148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ctf/hX3XkJggP7/+ZH5JrIfbFRaHucv2k5aVIYpgwkA=;
  b=HpkUKfvWAito1y1YpVTscD9KZN5HyjXNV/9dGDXloGZWhLmo5sdnvJXn
   vgBgE34X6lEqscgN8MLvRJt3gKcuoIS+E6pL4mWiFa3KpwTbD4ojS5OIL
   okXg5+an+5ORXtteFDfiwNysToGo8v7b7gp9zQK+GqoAZinYLQLRPXDSx
   olhmoA/xishw5PPOIB0uXeuD0ZUXxqzBFezRyTHTTc/zkJkwWhES6Hovf
   1Id/LfZc57O/wv9edgnIdGY7IMzoJzka+hpgHRIaJao2KIz+TA7ljsX84
   u6J167IiCeJfaHXHX/LuZQeKsMjA/5Koy7xcWEyN2awQbVjGS8AUytMvN
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="259758101"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="259758101"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 02:32:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="695424269"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 31 Mar 2022 02:32:25 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 31 Mar 2022 12:32:24 +0300
Date:   Thu, 31 Mar 2022 12:32:24 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Won Chung <wonchung@google.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] misc/mei: Add NULL check to component match callback
 functions
Message-ID: <YkV1KK8joyDAgf50@kuha.fi.intel.com>
References: <20220331084918.2592699-1-wonchung@google.com>
 <YkVtvhC0n9B994/A@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkVtvhC0n9B994/A@kroah.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 11:00:46AM +0200, Greg KH wrote:
> On Thu, Mar 31, 2022 at 08:49:18AM +0000, Won Chung wrote:
> > Component match callback functions need to check if expected data is
> > passed to them. Without this check, it can cause a NULL pointer
> > dereference when another driver registers a component before i915
> > drivers have their component master fully bind.
> 
> How can that happen in a real system?  Or does this just happen for when
> you are doing development and testing?
> 
> > 
> > Fixes: 1e8d19d9b0dfc ("mei: hdcp: bind only with i915 on the same PCH")
> > Fixes: c2004ce99ed73 ("mei: pxp: export pavp client to me client bus")
> > Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Suggested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Won Chung <wonchung@google.com>
> > Cc: stable@vger.kernel.org
> 
> Why does this need to go to stable?  How can this be triggered in older
> kernels?
> 
> > ---
> > Changes from v2:
> > - Correctly add "Suggested-by" tag
> > - Add "Cc: stable@vger.kernel.org"
> > 
> > Changes from v1:
> > - Add "Fixes" tag
> > - Send to stable@vger.kernel.org
> > 
> >  drivers/misc/mei/hdcp/mei_hdcp.c | 2 +-
> >  drivers/misc/mei/pxp/mei_pxp.c   | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
> > index ec2a4fce8581..843dbc2b21b1 100644
> > --- a/drivers/misc/mei/hdcp/mei_hdcp.c
> > +++ b/drivers/misc/mei/hdcp/mei_hdcp.c
> > @@ -784,7 +784,7 @@ static int mei_hdcp_component_match(struct device *dev, int subcomponent,
> >  {
> >  	struct device *base = data;
> >  
> > -	if (strcmp(dev->driver->name, "i915") ||
> > +	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||
> 
> How can base be NULL?
> 
> 
> >  	    subcomponent != I915_COMPONENT_HDCP)
> >  		return 0;
> >  
> > diff --git a/drivers/misc/mei/pxp/mei_pxp.c b/drivers/misc/mei/pxp/mei_pxp.c
> > index f7380d387bab..e32a81da8af6 100644
> > --- a/drivers/misc/mei/pxp/mei_pxp.c
> > +++ b/drivers/misc/mei/pxp/mei_pxp.c
> > @@ -131,7 +131,7 @@ static int mei_pxp_component_match(struct device *dev, int subcomponent,
> >  {
> >  	struct device *base = data;
> >  
> > -	if (strcmp(dev->driver->name, "i915") ||
> > +	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||
> 
> Same here, shouldn't this be caught by the driver core or bus and match
> should not be called?
> 
> Why not fix this in the component/driver core instead?

A component is just a device that is declared to be a "component", and
the code that declares it as component does not have to be the driver
of that device. You simply can't assume that it's bind to a driver
like this function does.

In our case the "components" are USB ports, so devices that are never
bind to drivers.

thanks,

-- 
heikki
