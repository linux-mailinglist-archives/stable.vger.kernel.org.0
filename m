Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34AA4ED70B
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 11:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiCaJgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 05:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbiCaJgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 05:36:32 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5111AA94CC;
        Thu, 31 Mar 2022 02:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648719284; x=1680255284;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=accBRYHMBah+nI3IJi8qJ4uZB9q5SYI8c2Q9UFYLYpM=;
  b=FusmpTAnv2tpVOI6CLesc9XUYI2qpOfiEntKFji0LQvUwc6GVZsiCOi/
   sO8YdaM8r1Kn2zb0BHlAfPC/x6Aq4HPJB+EA+Fby6H9Lg2wpSLMg3wEbr
   CJUqXktOWIArnXDoGYolpBxmCUuqiy/vbSSR7VJNaX+uhaXMIfw8yd0f5
   4m2PNTwEHc17jVso327ylRPznOARGW+k5jiS6l4STwLLmI7KiVwrckUB+
   idiZpaPIqaQk3JpKljBUSwDoGdQlcoJT//xEWZ5YaPAwhmUZg/5x34ZAN
   zTSO5UaREhJDW6QIy72va64nvGaG72FsTuIe8U6EdjDIYiHDfWGUNOEOe
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="247279389"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="247279389"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 02:34:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="695424720"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 31 Mar 2022 02:34:39 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 31 Mar 2022 12:34:38 +0300
Date:   Thu, 31 Mar 2022 12:34:38 +0300
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
Message-ID: <YkV1rsq1SeTNd8Ud@kuha.fi.intel.com>
References: <20220330211913.2068108-1-wonchung@google.com>
 <s5hzgl6eg48.wl-tiwai@suse.de>
 <CAOvb9yiO_n48JPZ3f0+y-fQ_YoOmuWF5c692Jt5_SKbxdA4yAw@mail.gmail.com>
 <s5hr16ieb8o.wl-tiwai@suse.de>
 <YkVzl4NEzwDAp/Zq@kuha.fi.intel.com>
 <s5hmth6eaiz.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmth6eaiz.wl-tiwai@suse.de>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 11:28:20AM +0200, Takashi Iwai wrote:
> On Thu, 31 Mar 2022 11:25:43 +0200,
> Heikki Krogerus wrote:
> > 
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
> OK, that's what I wanted to know.  It'd be helpful if it's more
> clearly mentioned in the commit log.

Agree.

> BTW, the same problem must be seen in MEI drivers, too.

Wasn't there a patch for those too? I lost track...

thanks,

-- 
heikki
