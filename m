Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DA84E6165
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 10:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346363AbiCXJ7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 05:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239661AbiCXJ7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 05:59:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57408DEE8
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648115884; x=1679651884;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=5pWMXm6/ad8t/vDpGlpaj1ZWbgKQkZ1B50zfHdF/XQw=;
  b=d98JwM5JQeOq3MNpA1yw7Ma8EnUM1RJGJeGiLqvI3tfBnkdp9nNngWwH
   do5cu9xPNJjsI2eAKfqhqrRJLXkxFAoPhNHMpCMpQa88pEEFBS0r2ato7
   0b8pcB2vyxlNRcPoDH4D/2MkI6NQMCRs7k3s6HohnLMEXnatLKyOQQYda
   +yqdJrX4z4zlVyysJyHSMaJfyrG7oV+s3Lw4VjObCC6Lh/mO1eLVC8AdX
   2tD7xjJjp+FYsQjtpMt33gxQtmfQpoT1w3tr+ypwI9mNBA9OqScXFtdQV
   ty/MEBb48Trg+YB+oISK8TQOJlY0Yva8iCMM46tGIrgJb13DC4uofuU56
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="238935812"
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="238935812"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 02:57:39 -0700
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="544577026"
Received: from cnalawad-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.131])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 02:57:37 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Lee Shawn C <shawn.c.lee@intel.com>,
        dri-devel@lists.freedesktop.org
Cc:     Cooper Chiou <cooper.chiou@intel.com>, stable@vger.kernel.org,
        Shawn C Lee <shawn.c.lee@intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: [v3] drm/edid: check basic audio support on CEA extension block
In-Reply-To: <20220324061635.328-1-shawn.c.lee@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220321044330.27723-1-cooper.chiou@intel.com>
 <20220324061635.328-1-shawn.c.lee@intel.com>
Date:   Thu, 24 Mar 2022 11:57:35 +0200
Message-ID: <87y20zhdv4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 24 Mar 2022, Lee Shawn C <shawn.c.lee@intel.com> wrote:
> From: Cooper Chiou <cooper.chiou@intel.com>
>
> Tag code stored in bit7:5 for CTA block byte[3] is not the same as
> CEA extension block definition. Only check CEA block has
> basic audio support.
>
> v3: update commit message.
>
> Cc: stable@vger.kernel.org
> Cc: Jani Nikula <jani.nikula@intel.com>
> Cc: Shawn C Lee <shawn.c.lee@intel.com>
> Cc: intel-gfx <intel-gfx@lists.freedesktop.org>
> Signed-off-by: Cooper Chiou <cooper.chiou@intel.com>
> Signed-off-by: Lee Shawn C <shawn.c.lee@intel.com>
> Fixes: e28ad544f462 ("drm/edid: parse CEA blocks embedded in DisplayID")
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>

Thanks for the patch, pushed to drm-misc-next-fixes.

BR,
Jani.

> ---
>  drivers/gpu/drm/drm_edid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 561f53831e29..f07af6786cec 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -4859,7 +4859,8 @@ bool drm_detect_monitor_audio(struct edid *edid)
>  	if (!edid_ext)
>  		goto end;
>  
> -	has_audio = ((edid_ext[3] & EDID_BASIC_AUDIO) != 0);
> +	has_audio = (edid_ext[0] == CEA_EXT &&
> +		    (edid_ext[3] & EDID_BASIC_AUDIO) != 0);
>  
>  	if (has_audio) {
>  		DRM_DEBUG_KMS("Monitor has basic audio support\n");

-- 
Jani Nikula, Intel Open Source Graphics Center
