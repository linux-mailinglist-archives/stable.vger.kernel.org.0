Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2234C667315
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjALNXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjALNXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:23:24 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E7139FA6;
        Thu, 12 Jan 2023 05:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673529803; x=1705065803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1PTv1lDpHp6a2TJ4NRR5GKeQ0sdk0umVwo/CpE1OPbU=;
  b=LWsChcUu7MDZAAW8lR9I1/p+WKhpD/P5Eq7wW1T8LLMrAa0XN3oBd+vA
   k/SjHoFPVXJFWDoMc/jGtZqo6i5JhwfgYZsgqTDiO/SoIs5BHUgCgeD7L
   2HgZg4J0bmBwMi1EwP0XvLrF77XKvSDaTTmY8tchcvWpWwZsf2XDrqDG3
   fi2SoBRjWtA0PUoh+alaaxfSBnWMjw9U2qX5Vjpu+KlemPvVLEpaUw5ie
   ozCjyGCpkYr5zvKFZHpCt2+xIPWQinttdTjEETbyov1eGvb+ifH6AlEWY
   rRwmBOu9J8oEbuyXNe4DRBdopvr0f18XeZX+YS8lbokiqJD952Ju8bUPY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10587"; a="311525496"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="311525496"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 05:23:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10587"; a="800208195"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="800208195"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 12 Jan 2023 05:23:18 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 12 Jan 2023 15:23:18 +0200
Date:   Thu, 12 Jan 2023 15:23:18 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Ranquet <granquet@baylibre.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>
Subject: Re: [PATCH 2/3] usb: typec: altmodes/displayport: Fix pin assignment
 calculation
Message-ID: <Y8AJxswZzE6MaUFQ@kuha.fi.intel.com>
References: <20230111020546.3384569-1-pmalani@chromium.org>
 <20230111020546.3384569-2-pmalani@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111020546.3384569-2-pmalani@chromium.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023 at 02:05:42AM +0000, Prashant Malani wrote:
> Commit c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin
> assignment for UFP receptacles") fixed the pin assignment calculation
> to take into account whether the peripheral was a plug or a receptacle.
> 
> But the "pin_assignments" sysfs logic was not updated. Address this by
> using the macros introduced in the aforementioned commit in the sysfs
> logic too.
> 
> Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles")
> Cc: stable@vger.kernel.org
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Prashant Malani <pmalani@chromium.org>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/altmodes/displayport.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
> index f9d4a7648bc9..c0d65c93cefe 100644
> --- a/drivers/usb/typec/altmodes/displayport.c
> +++ b/drivers/usb/typec/altmodes/displayport.c
> @@ -427,9 +427,9 @@ static const char * const pin_assignments[] = {
>  static u8 get_current_pin_assignments(struct dp_altmode *dp)
>  {
>  	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
> -		return DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
> +		return DP_CAP_PIN_ASSIGN_DFP_D(dp->alt->vdo);
>  	else
> -		return DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
> +		return DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo);
>  }
>  
>  static ssize_t
> -- 
> 2.39.0.314.g84b9a713c41-goog

-- 
heikki
