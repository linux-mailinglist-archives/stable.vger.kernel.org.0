Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD746602841
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJRJZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJRJZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:25:09 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A506138448
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666085099; x=1697621099;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=UMCO5mJkxdgXG8Vg18aqKASsvHeMgG5yqkmJ96uzOXg=;
  b=EJZhXAlsGmLmg3CVfzqPko+rPHMmjjvi0aC/J1Daaz3YzKs1vc0jpXPb
   HOqVy/XXmOnNnlVmuipyIQfaxxoeiZXorCsAwL+MAWm1jmKwB+smRV4co
   kkNYDSVestiB6OvhCEem6JE1oJXNWjiQlUKeNvEVxu7KcINuaUv5PJk7Z
   DM6zNvM/dV2CoN57RbCynJseyNhvkbf8s3wGFVh00ucltC6vHvF0dXarE
   eqLXa9VjmaRH0yQ17juH3ziyC0SLb9sgoOvVyXsmlVg5vCTpsQdojslmb
   SDT+Ge3V5AFOV8ym7O/7JPLuK937wqZZCnjZoMHx8E+0CxB9MkT3Jcgxq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="303663486"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="303663486"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 02:24:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="771119489"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="771119489"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga001.fm.intel.com with SMTP; 18 Oct 2022 02:24:54 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 18 Oct 2022 12:24:53 +0300
Date:   Tue, 18 Oct 2022 12:24:53 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Simon Ser <contact@emersion.fr>
Cc:     dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jonas =?iso-8859-1?Q?=C5dahl?= <jadahl@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/connector: send hotplug uevent on connector
 cleanup
Message-ID: <Y05w5U0CAbrdA10S@intel.com>
References: <20221017153150.60675-1-contact@emersion.fr>
 <20221017153150.60675-2-contact@emersion.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221017153150.60675-2-contact@emersion.fr>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 03:32:01PM +0000, Simon Ser wrote:
> A typical DP-MST unplug removes a KMS connector. However care must
> be taken to properly synchronize with user-space. The expected
> sequence of events is the following:
> 
> 1. The kernel notices that the DP-MST port is gone.
> 2. The kernel marks the connector as disconnected, then sends a
>    uevent to make user-space re-scan the connector list.
> 3. User-space notices the connector goes from connected to disconnected,
>    disables it.
> 4. Kernel handles the the IOCTL disabling the connector. On success,
>    the very last reference to the struct drm_connector is dropped and
>    drm_connector_cleanup() is called.
> 5. The connector is removed from the list, and a uevent is sent to tell
>    user-space that the connector disappeared.
> 
> The very last step was missing. As a result, user-space thought the
> connector still existed and could try to disable it again. Since the
> kernel no longer knows about the connector, that would end up with
> EINVAL and confused user-space.

So is the uevent sent by the mst delayed destroy work
useless now, or what is going on there?

> 
> Fix this by sending a hotplug uevent from drm_connector_cleanup().
> 
> Signed-off-by: Simon Ser <contact@emersion.fr>
> Cc: stable@vger.kernel.org
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Jonas Ådahl <jadahl@redhat.com>
> ---
>  drivers/gpu/drm/drm_connector.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
> index e3142c8142b3..90dad87e9ad0 100644
> --- a/drivers/gpu/drm/drm_connector.c
> +++ b/drivers/gpu/drm/drm_connector.c
> @@ -582,6 +582,9 @@ void drm_connector_cleanup(struct drm_connector *connector)
>  	mutex_destroy(&connector->mutex);
>  
>  	memset(connector, 0, sizeof(*connector));
> +
> +	if (dev->registered)
> +		drm_sysfs_hotplug_event(dev);
>  }
>  EXPORT_SYMBOL(drm_connector_cleanup);
>  
> -- 
> 2.38.0
> 

-- 
Ville Syrjälä
Intel
