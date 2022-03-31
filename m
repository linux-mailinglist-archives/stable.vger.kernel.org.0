Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45ED4ED9E3
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiCaMyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 08:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiCaMyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 08:54:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A56B527CA;
        Thu, 31 Mar 2022 05:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648731150; x=1680267150;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K9FkXpKnPJFCdzt73/Eq1ltSIhF+ecIDKBRNSMWrnqU=;
  b=kVCMLCeh+U+oFVN1o3U7SZSQQc2MeFRqL8D9+FqtWeOdty5nQHn0VXYY
   LQCRecdC8ENl6vzOKPWgCsXQ+2x03UH49V9h/pG2Lia+33lH7sMskFLwS
   BLkdngMNtmsN077Ue6o21cJUDPYBNxJVcQpc8SHiB+sGW9Bc2l5VJ0LMn
   glR1yzpV4KbOuxidH8s/a9R0DaoEyMjRO9cn0bXRfbMzWZsQ73KE3FP5Y
   1xsZ8Zg6Jf6U3pXm61miMgKHx7zPdoI1WutnzCZLfBuscsAYtoyGi+0Xt
   dkM1USuxSgwX3ypTKOWz487BIIU6z320mZ9eBP8Awy9X7b/AiSRfU2pwP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="284746907"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="284746907"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 05:52:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="695481304"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 31 Mar 2022 05:52:14 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 31 Mar 2022 15:52:14 +0300
Date:   Thu, 31 Mar 2022 15:52:14 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Takashi Iwai <tiwai@suse.de>, Won Chung <wonchung@google.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] sound/hda: Add NULL check to component match callback
 function
Message-ID: <YkWj/vmjohNo0r2c@kuha.fi.intel.com>
References: <20220330211913.2068108-1-wonchung@google.com>
 <s5hzgl6eg48.wl-tiwai@suse.de>
 <CAOvb9yiO_n48JPZ3f0+y-fQ_YoOmuWF5c692Jt5_SKbxdA4yAw@mail.gmail.com>
 <s5hr16ieb8o.wl-tiwai@suse.de>
 <YkVzl4NEzwDAp/Zq@kuha.fi.intel.com>
 <YkWTBwAB1HrxcUR3@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkWTBwAB1HrxcUR3@kroah.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Mar 31, 2022 at 01:39:51PM +0200, Greg KH wrote:
> On Thu, Mar 31, 2022 at 12:25:43PM +0300, Heikki Krogerus wrote:
> > On Thu, Mar 31, 2022 at 11:12:55AM +0200, Takashi Iwai wrote:
> > > > > > -     if (!strcmp(dev->driver->name, "i915") &&
> > > > > > +     if (dev->driver && !strcmp(dev->driver->name, "i915") &&
> > > > >
> > > > > Can NULL dev->driver be really seen?  I thought the components are
> > > > > added by the drivers, hence they ought to have the driver field set.
> > > > > But there can be corner cases I overlooked.
> > > > >
> > > > >
> > > > > thanks,
> > > > >
> > > > > Takashi
> > > > 
> > > > Hi Takashi,
> > > > 
> > > > When I try using component_add in a different driver (usb4 in my
> > > > case), I think dev->driver here is NULL because the i915 drivers do
> > > > not have their component master fully bound when this new component is
> > > > registered. When I test it, it seems to be causing a crash.
> > > 
> > > Hm, from where component_add*() is called?  Basically dev->driver must
> > > be already set before the corresponding driver gets bound at
> > > __driver_probe_deviec().  So, if the device is added to component from
> > > the corresponding driver's probe, dev->driver must be non-NULL.
> > 
> > The code that declares a device as component does not have to be the
> > driver of that device.
> > 
> > In our case the components are USB ports, and they are devices that
> > are actually never bind to any drivers: drivers/usb/core/port.c
> 
> Why is a USB device being passed to this code that assumes it is looking
> for a PCI device with a specific driver name?  As I mentioned on the
> mei patch, triggering off of a name is really a bad idea, as is assuming
> the device type without any assurance it is such a device (there's a
> reason we didn't provide device type identification in the driver core,
> don't abuse that please...)

I totally agree. This driver is making a whole bunch of assumptions
when it should not make any assumptions. And yes, one of those
assumptions is that the driver of the device has a specific name, and
that is totally crazy. So why is it making those assumptions? I have
no idea, but is does, and they are now causing the first problem -
NULL pointer dereference.

This patch (and that other) is only proposing a simple way to solve
that NULL pointer dereference issue by adding some sanity checks. If
that's no OK, and the whole driver should be refactored instead, then
that is perfectly OK by me, but that has to be done by somebody who
understands what exactly is the driver and the device it's controlling
doing (and for).

thanks,

-- 
heikki
