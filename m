Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA904EE8B6
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 09:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244808AbiDAHEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 03:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbiDAHEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 03:04:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C509321DF22;
        Fri,  1 Apr 2022 00:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648796552; x=1680332552;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nNoodzSci328///pz5PHrckfWv0oUcZ0OAexwl63MVM=;
  b=eOqWuqRyMBb9dbXNteW6+M0VA442DXXYoQhGJISHG9P9uWIQ9HKB2Cxj
   ++WTPfiehdmSuSgIYIhqyvRfb6+nfy9UKncUCaiK5N4RrebdW+hKC+PNt
   wBXpTPVT30Gsb8xbZi8I4uOUBpj7+qlzJvJLMdaZNkH/PccyGKdwCvnBI
   2nnBWlhbiOxBFmzAvlOesWEJyp+qrco1IJZswr6oi+0E7gw8hrM8Wfjs6
   b+DWJ2l7xCdZrIasivxwAho/ppkCHJPxhQceluN2FXIcFmDYQCXkqc2cI
   +KRJLc7M+Dfg2gUMYAJJzKl6H5rVHp3jYiKDabwb2jTTtxqu6Si9I3ACh
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="259763359"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="259763359"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 00:02:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="695791642"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 01 Apr 2022 00:02:28 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Fri, 01 Apr 2022 10:02:27 +0300
Date:   Fri, 1 Apr 2022 10:02:27 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Won Chung <wonchung@google.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] sound/hda: Add NULL check to component match callback
 function
Message-ID: <Ykajg7LP7dn6+b6H@kuha.fi.intel.com>
References: <20220330211913.2068108-1-wonchung@google.com>
 <s5hzgl6eg48.wl-tiwai@suse.de>
 <CAOvb9yiO_n48JPZ3f0+y-fQ_YoOmuWF5c692Jt5_SKbxdA4yAw@mail.gmail.com>
 <s5hr16ieb8o.wl-tiwai@suse.de>
 <YkVzl4NEzwDAp/Zq@kuha.fi.intel.com>
 <s5hmth6eaiz.wl-tiwai@suse.de>
 <YkV1rsq1SeTNd8Ud@kuha.fi.intel.com>
 <s5hk0cae9pw.wl-tiwai@suse.de>
 <s5h7d8adzdl.wl-tiwai@suse.de>
 <s5hzgl6ciho.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzgl6ciho.wl-tiwai@suse.de>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Takashi,

On Thu, Mar 31, 2022 at 04:19:15PM +0200, Takashi Iwai wrote:
> On Thu, 31 Mar 2022 15:29:10 +0200,
> Takashi Iwai wrote:
> > 
> > On Thu, 31 Mar 2022 11:45:47 +0200,
> > Takashi Iwai wrote:
> > > 
> > > On Thu, 31 Mar 2022 11:34:38 +0200,
> > > Heikki Krogerus wrote:
> > > > 
> > > > On Thu, Mar 31, 2022 at 11:28:20AM +0200, Takashi Iwai wrote:
> > > > > On Thu, 31 Mar 2022 11:25:43 +0200,
> > > > > Heikki Krogerus wrote:
> > > > > > 
> > > > > > On Thu, Mar 31, 2022 at 11:12:55AM +0200, Takashi Iwai wrote:
> > > > > > > > > > -     if (!strcmp(dev->driver->name, "i915") &&
> > > > > > > > > > +     if (dev->driver && !strcmp(dev->driver->name, "i915") &&
> > > > > > > > >
> > > > > > > > > Can NULL dev->driver be really seen?  I thought the components are
> > > > > > > > > added by the drivers, hence they ought to have the driver field set.
> > > > > > > > > But there can be corner cases I overlooked.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > thanks,
> > > > > > > > >
> > > > > > > > > Takashi
> > > > > > > > 
> > > > > > > > Hi Takashi,
> > > > > > > > 
> > > > > > > > When I try using component_add in a different driver (usb4 in my
> > > > > > > > case), I think dev->driver here is NULL because the i915 drivers do
> > > > > > > > not have their component master fully bound when this new component is
> > > > > > > > registered. When I test it, it seems to be causing a crash.
> > > > > > > 
> > > > > > > Hm, from where component_add*() is called?  Basically dev->driver must
> > > > > > > be already set before the corresponding driver gets bound at
> > > > > > > __driver_probe_deviec().  So, if the device is added to component from
> > > > > > > the corresponding driver's probe, dev->driver must be non-NULL.
> > > > > > 
> > > > > > The code that declares a device as component does not have to be the
> > > > > > driver of that device.
> > > > > > 
> > > > > > In our case the components are USB ports, and they are devices that
> > > > > > are actually never bind to any drivers: drivers/usb/core/port.c
> > > > > 
> > > > > OK, that's what I wanted to know.  It'd be helpful if it's more
> > > > > clearly mentioned in the commit log.
> > > > 
> > > > Agree.
> > > > 
> > > > > BTW, the same problem must be seen in MEI drivers, too.
> > > > 
> > > > Wasn't there a patch for those too? I lost track...
> > > 
> > > I don't know, I just checked the latest Linus tree.
> > > 
> > > And, looking at the HD-audio code, I still wonder how NULL dev->driver
> > > can reach there.  Is there any PCI device that is added to component
> > > without binding to a driver?  We have dev_is_pci() check at the
> > > beginning, so non-PCI devices should bail out there...
> > 
> > Further reading on, I'm really confused.  How data=NULL can be passed
> > to this function?  The data argument is the value passed from the
> > component_match_add_typed() call in HD-audio driver, hence it must be
> > always the snd_hdac_bus object.
> > 
> > And, I guess the i915 string check can be omitted completely, at
> > least, for HD-audio driver.  It already have a check of the parent of
> > the device and that should be enough.
> 
> That said, something like below (supposing data NULL check being
> superfluous), instead.

I don't think data can be NULL. There is no need for that check like
you said.

> --- a/sound/hda/hdac_i915.c
> +++ b/sound/hda/hdac_i915.c
> @@ -102,18 +102,13 @@ static int i915_component_master_match(struct device *dev, int subcomponent,
>  	struct pci_dev *hdac_pci, *i915_pci;
>  	struct hdac_bus *bus = data;
>  
> -	if (!dev_is_pci(dev))
> +	if (subcomponent != I915_COMPONENT_AUDIO || !dev_is_pci(dev))
>  		return 0;
>  
>  	hdac_pci = to_pci_dev(bus->dev);
>  	i915_pci = to_pci_dev(dev);
>  
> -	if (!strcmp(dev->driver->name, "i915") &&
> -	    subcomponent == I915_COMPONENT_AUDIO &&
> -	    connectivity_check(i915_pci, hdac_pci))
> -		return 1;
> -
> -	return 0;
> +	return connectivity_check(i915_pci, hdac_pci);
>  }
>  
>  /* check whether intel graphics is present */

That looks really nice to me!

thanks,

-- 
heikki
