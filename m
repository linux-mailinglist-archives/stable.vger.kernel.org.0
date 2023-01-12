Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FCA667312
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjALNV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjALNVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:21:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751F73AAB7;
        Thu, 12 Jan 2023 05:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673529711; x=1705065711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wGK0Rt5AseVe+djDRhfbBc7Uh6hTvWK9/1qteiv2qfQ=;
  b=eqFaExafH0hIvJbw8+z8fp0s6mwaCoFR36wAYySVQwas8RudsKkwMuKc
   BKUfgRt0rLHof5dPhcw2y2W6SdvOQ4gaOGUZ0EOabh9XrATN7TfWJ3PSW
   G9vNIIj4LeNKfAniFl8jxsYnvRxnED1yqU0C6OtkHdUgzYT1VY4cjGkh5
   mPdAfeh6pC1TCNnT2IMsRr1IcDxb+UxC32NK/bLzt1hHe7Fz4+/GHy83K
   u7rbH6mp1/Rm3FBxYKUqzMSX1mVX8eUQiiIHpxOBMSwRucSIGRvIhOr2l
   uQ3zNXp7MbMfFeBPSopuWThcyrlnY9/s/xaCZRaAaOQeTZY/6yRd0488a
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10587"; a="311525130"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="311525130"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 05:21:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10587"; a="800207610"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="800207610"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 12 Jan 2023 05:21:47 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 12 Jan 2023 15:21:46 +0200
Date:   Thu, 12 Jan 2023 15:21:46 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Ranquet <granquet@baylibre.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>
Subject: Re: [PATCH 1/3] usb: typec: altmodes/displayport: Add pin assignment
 helper
Message-ID: <Y8AJak+munzDqTPK@kuha.fi.intel.com>
References: <20230111020546.3384569-1-pmalani@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111020546.3384569-1-pmalani@chromium.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023 at 02:05:41AM +0000, Prashant Malani wrote:
> The code to extract a peripheral's currently supported Pin Assignments
> is repeated in a couple of locations. Factor it out into a separate
> function.
> 
> This will also make it easier to add fixes (we only need to update 1
> location instead of 2).
> 
> Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles")
> Cc: stable@vger.kernel.org
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Prashant Malani <pmalani@chromium.org>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> 
> While this patch doesn't fix anything, it is required by the actual
> fix (which is Patch 2/3 in this series). So, I've add the "Fixes" tag
> and "Cc stable" tag to ensure that both patches are picked.
> 
> If this is the incorrect approach and there is a better way, my
> apologies, and please let me know the appropriate process.
> 
>  drivers/usb/typec/altmodes/displayport.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
> index 06fb4732f8cd..f9d4a7648bc9 100644
> --- a/drivers/usb/typec/altmodes/displayport.c
> +++ b/drivers/usb/typec/altmodes/displayport.c
> @@ -420,6 +420,18 @@ static const char * const pin_assignments[] = {
>  	[DP_PIN_ASSIGN_F] = "F",
>  };
>  
> +/*
> + * Helper function to extract a peripheral's currently supported
> + * Pin Assignments from its DisplayPort alternate mode state.
> + */
> +static u8 get_current_pin_assignments(struct dp_altmode *dp)
> +{
> +	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
> +		return DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
> +	else
> +		return DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
> +}
> +
>  static ssize_t
>  pin_assignment_store(struct device *dev, struct device_attribute *attr,
>  		     const char *buf, size_t size)
> @@ -446,10 +458,7 @@ pin_assignment_store(struct device *dev, struct device_attribute *attr,
>  		goto out_unlock;
>  	}
>  
> -	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
> -		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
> -	else
> -		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
> +	assignments = get_current_pin_assignments(dp);
>  
>  	if (!(DP_CONF_GET_PIN_ASSIGN(conf) & assignments)) {
>  		ret = -EINVAL;
> @@ -486,10 +495,7 @@ static ssize_t pin_assignment_show(struct device *dev,
>  
>  	cur = get_count_order(DP_CONF_GET_PIN_ASSIGN(dp->data.conf));
>  
> -	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
> -		assignments = DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
> -	else
> -		assignments = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
> +	assignments = get_current_pin_assignments(dp);
>  
>  	for (i = 0; assignments; assignments >>= 1, i++) {
>  		if (assignments & 1) {
> -- 
> 2.39.0.314.g84b9a713c41-goog

-- 
heikki
