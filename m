Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C6A691A72
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 09:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjBJI5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 03:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjBJI5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 03:57:10 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E06121285;
        Fri, 10 Feb 2023 00:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676019428; x=1707555428;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tc+hIX0ul8Y+LFWF/oVDFRS5E1dOUD0QDPlgBJRGPck=;
  b=PIRW9oRJhsl6L1shzAm1uZgJwnFTlJ+hqhf8N7M2zA3cBD18Q9NklE0F
   uCuag7zUBe+Nxt+lZO9F+3CNmy1zwh74YEJa4QDIQvy5obPL9ijYvBlX1
   eosH0ip5FkWvbdtczOHZ9leJuI1L90A68CAJZl6Jt6XmPmMSebgBGZwzM
   6wtof4c5ctQaNVZl98g8FWCUdGoyzi/h9WeEkqvCcWD14s9INFmUZnGJL
   5hTP1jhlUIit+UgU1BoHgNbijxpoKlrqPGJ9dsjIJIGPqKRh7KhtYzJh+
   tKcISoeQ3pq6rz5GjHCWTVHWuKWfn3/FAkE5VQ12Abmz0+YI6Vvu/KNNR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="314017159"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="314017159"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 00:57:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="810750098"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="810750098"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 10 Feb 2023 00:56:57 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Fri, 10 Feb 2023 10:56:56 +0200
Date:   Fri, 10 Feb 2023 10:56:56 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org,
        Diana Zigterman <dzigterman@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Ranquet <granquet@baylibre.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>
Subject: Re: [PATCH] usb: typec: altmodes/displayport: Fix probe pin assign
 check
Message-ID: <Y+YG2DIHy/vg0vxY@kuha.fi.intel.com>
References: <20230208205318.131385-1-pmalani@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208205318.131385-1-pmalani@chromium.org>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 08, 2023 at 08:53:19PM +0000, Prashant Malani wrote:
> While checking Pin Assignments of the port and partner during probe, we
> don't take into account whether the peripheral is a plug or receptacle.
> 
> This manifests itself in a mode entry failure on certain docks and
> dongles with captive cables. For instance, the Startech.com Type-C to DP
> dongle (Model #CDP2DP) advertises its DP VDO as 0x405. This would fail
> the Pin Assignment compatibility check, despite it supporting
> Pin Assignment C as a UFP.
> 
> Update the check to use the correct DP Pin Assign macros that
> take the peripheral's receptacle bit into account.
> 
> Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles")
> Cc: stable@vger.kernel.org
> Reported-by: Diana Zigterman <dzigterman@chromium.org>
> Signed-off-by: Prashant Malani <pmalani@chromium.org>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> 
> I realize this is a bit late in the release cycle, but figured since it
> is a fix it might still be considered. Please let me know if it's too
> late and I can re-send this after the 6.3-rc1 is released. Thanks!
> 
>  drivers/usb/typec/altmodes/displayport.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
> index 20db51471c98..662cd043b50e 100644
> --- a/drivers/usb/typec/altmodes/displayport.c
> +++ b/drivers/usb/typec/altmodes/displayport.c
> @@ -547,10 +547,10 @@ int dp_altmode_probe(struct typec_altmode *alt)
>  	/* FIXME: Port can only be DFP_U. */
>  
>  	/* Make sure we have compatiple pin configurations */
> -	if (!(DP_CAP_DFP_D_PIN_ASSIGN(port->vdo) &
> -	      DP_CAP_UFP_D_PIN_ASSIGN(alt->vdo)) &&
> -	    !(DP_CAP_UFP_D_PIN_ASSIGN(port->vdo) &
> -	      DP_CAP_DFP_D_PIN_ASSIGN(alt->vdo)))
> +	if (!(DP_CAP_PIN_ASSIGN_DFP_D(port->vdo) &
> +	      DP_CAP_PIN_ASSIGN_UFP_D(alt->vdo)) &&
> +	    !(DP_CAP_PIN_ASSIGN_UFP_D(port->vdo) &
> +	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
>  		return -ENODEV;
>  
>  	ret = sysfs_create_group(&alt->dev.kobj, &dp_altmode_group);
> -- 
> 2.39.1.519.gcb327c4b5f-goog

thanks,

-- 
heikki
