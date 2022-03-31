Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2806D4ED6BF
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 11:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiCaJ1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 05:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiCaJ1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 05:27:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466D21FD2E6;
        Thu, 31 Mar 2022 02:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648718748; x=1680254748;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N3PP8ZivePQMvjV4Fur4OQwgO4dspQzwIlKhbnGe298=;
  b=f4RYGwSSr38DhEM0LgOrJaPk+g9p8ahdcXqy99WuQVh/Ju0vkkNeyw8J
   IlTwGf7b4VkhCA95SvAViRJQPJW9DX44+vq7mEeUU6ZKXiYqhujJ7G4CB
   HG9/s+DMicQswI/oC3dWc599br9b8Ceo5rqHrXldQR5t6l7731abmZroJ
   wSWqy+BmNTNtp5nu9Z37SZ5PJa80FkVMnIw2Xzq3cqJYjlAhej8WqKlYQ
   oOtxE4sbOx2yMfTmy1tZ0oRK4aTS1IVMJjuZv5snrsoQB28YEuxl4Svab
   w30wBiMI+jL0Lqs4IN7Gf16glUUqFa3FFM2Dv/YvBDZLuBodB+/OIUW1G
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="258608861"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="258608861"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 02:25:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="695422964"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 31 Mar 2022 02:25:44 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 31 Mar 2022 12:25:43 +0300
Date:   Thu, 31 Mar 2022 12:25:43 +0300
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
Message-ID: <YkVzl4NEzwDAp/Zq@kuha.fi.intel.com>
References: <20220330211913.2068108-1-wonchung@google.com>
 <s5hzgl6eg48.wl-tiwai@suse.de>
 <CAOvb9yiO_n48JPZ3f0+y-fQ_YoOmuWF5c692Jt5_SKbxdA4yAw@mail.gmail.com>
 <s5hr16ieb8o.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hr16ieb8o.wl-tiwai@suse.de>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 11:12:55AM +0200, Takashi Iwai wrote:
> > > > -     if (!strcmp(dev->driver->name, "i915") &&
> > > > +     if (dev->driver && !strcmp(dev->driver->name, "i915") &&
> > >
> > > Can NULL dev->driver be really seen?  I thought the components are
> > > added by the drivers, hence they ought to have the driver field set.
> > > But there can be corner cases I overlooked.
> > >
> > >
> > > thanks,
> > >
> > > Takashi
> > 
> > Hi Takashi,
> > 
> > When I try using component_add in a different driver (usb4 in my
> > case), I think dev->driver here is NULL because the i915 drivers do
> > not have their component master fully bound when this new component is
> > registered. When I test it, it seems to be causing a crash.
> 
> Hm, from where component_add*() is called?  Basically dev->driver must
> be already set before the corresponding driver gets bound at
> __driver_probe_deviec().  So, if the device is added to component from
> the corresponding driver's probe, dev->driver must be non-NULL.

The code that declares a device as component does not have to be the
driver of that device.

In our case the components are USB ports, and they are devices that
are actually never bind to any drivers: drivers/usb/core/port.c

thanks,

-- 
heikki
