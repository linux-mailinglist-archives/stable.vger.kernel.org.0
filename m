Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287E422B51A
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 19:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgGWRoK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 Jul 2020 13:44:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:47764 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgGWRoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 13:44:09 -0400
IronPort-SDR: 9iMua7AYLBX7MRkrUeqcPvJdRkhyTaWETbjFpmFO1GPRzh9Zu+EgoBuizONe+KMOLjGArPzK8w
 9ysSPfu09vKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="150574565"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="150574565"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 10:44:09 -0700
IronPort-SDR: qoDZPp8xaBOFuq8BdYHacEb11LDbs/vj66/URjxsNfr5myN8nr/LqL2N4HUSA2SvLpJwgXlG9N
 21tyO8bxADPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="328639284"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 10:44:09 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 10:44:09 -0700
Received: from orsmsx163.amr.corp.intel.com ([169.254.9.101]) by
 ORSMSX121.amr.corp.intel.com ([169.254.10.71]) with mapi id 14.03.0439.000;
 Thu, 23 Jul 2020 10:44:09 -0700
From:   "Tang, CQ" <cq.tang@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Vetter, Daniel" <daniel.vetter@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 2/3] drm/i915/gem: Move context decoupling from
 postclose to preclose
Thread-Topic: [PATCH 2/3] drm/i915/gem: Move context decoupling from
 postclose to preclose
Thread-Index: AQHWYRW0ju6h2xQdSEex8T/aQszD5akVbtQQ
Date:   Thu, 23 Jul 2020 17:44:08 +0000
Message-ID: <1D440B9B88E22A4ABEF89F9F1F81BC290117BC5431@ORSMSX163.amr.corp.intel.com>
References: <20200723172119.17649-1-chris@chris-wilson.co.uk>
 <20200723172119.17649-2-chris@chris-wilson.co.uk>
In-Reply-To: <20200723172119.17649-2-chris@chris-wilson.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Sent: Thursday, July 23, 2020 10:21 AM
> To: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org; Chris Wilson <chris@chris-wilson.co.uk>;
> Tang, CQ <cq.tang@intel.com>; Vetter, Daniel <daniel.vetter@intel.com>;
> stable@vger.kernel.org
> Subject: [PATCH 2/3] drm/i915/gem: Move context decoupling from
> postclose to preclose
> 
> Since the GEM contexts refer to other GEM state, we need to nerf those
> pointers before that state is freed during drm_gem_release(). We need to
> move i915_gem_context_close() from the postclose callback to the preclose.
> 
> In particular, debugfs likes to peek into the GEM contexts, and from there
> peek at the drm core objects. If the context is closed during the peeking, we
> may attempt to dereference a stale core object.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: CQ Tang <cq.tang@intel.com>
> Cc: Daniel Vetter <daniel.vetter@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/i915_drv.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.c
> b/drivers/gpu/drm/i915/i915_drv.c index 5fd5af4bc855..15242a8c70f7 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -1114,11 +1114,15 @@ static void i915_driver_lastclose(struct
> drm_device *dev)
>  	vga_switcheroo_process_delayed_switch();
>  }
> 
> +static void i915_driver_preclose(struct drm_device *dev, struct
> +drm_file *file) {
> +	i915_gem_context_close(file);
> +}
> +
>  static void i915_driver_postclose(struct drm_device *dev, struct drm_file
> *file)  {
>  	struct drm_i915_file_private *file_priv = file->driver_priv;
> 
> -	i915_gem_context_close(file);
>  	i915_gem_release(dev, file);

Now we separate i915_gem_context_close() from i915_gem_release() and other freeing code in postclose(), is there any side effect to allow code to run in between?
Can we move all postclose() code into preclose()?

--CQ

> 
>  	kfree_rcu(file_priv, rcu);
> @@ -1850,6 +1854,7 @@ static struct drm_driver driver = {
>  	.release = i915_driver_release,
>  	.open = i915_driver_open,
>  	.lastclose = i915_driver_lastclose,
> +	.preclose  = i915_driver_preclose,
>  	.postclose = i915_driver_postclose,
> 
>  	.gem_close_object = i915_gem_close_object,
> --
> 2.20.1

