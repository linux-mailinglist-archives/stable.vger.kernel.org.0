Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E069E672073
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 16:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjARPCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 10:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjARPCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 10:02:32 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43793D93D
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 07:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674054047; x=1705590047;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=68c325VjfL8aCYRg864MJ9CmsN2DN/rfduIGADfQYIk=;
  b=jFJYSePtamA8WF9boDAvxxjRYBu+HCGe8M/bPEuTCxBbZn9WA/I6x01/
   rMFpC9/1q8+qa3jQ3wlDXLDxiiNslhRcsUHp1srPSugfzMjtjRG4tJt6r
   EvMh2YGi8218OQ7TJvBNlBCCih6rP8joGI2elkflSbejE35Wp+VGvYoBR
   UnE3KoBBV8Qndeq5OZt/6kS5oBK7dSosGzV3H2LF+z7uv8KQvJ4cn+5Qs
   ZMbcq6G4cPKCMNXBGd60hGaOQfppjtvG80XC20DRu2QKCuHWTDX3tjprE
   /MIv2L0ttSaj5YOqEbhLe68fiKVmqVQMtocbs07Mq39KuvW/gx+2LLDOz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="326264753"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="326264753"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 07:00:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="833606590"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="833606590"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.55])
  by orsmga005.jf.intel.com with SMTP; 18 Jan 2023 07:00:28 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 18 Jan 2023 17:00:27 +0200
Date:   Wed, 18 Jan 2023 17:00:27 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 02/22] drm/edid: fix parsing of 3D modes from HDMI VSDB
Message-ID: <Y8gJi2tNyP20fHO9@intel.com>
References: <cover.1672826282.git.jani.nikula@intel.com>
 <cf159b8816191ed595a3cb954acaf189c4528cc7.1672826282.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf159b8816191ed595a3cb954acaf189c4528cc7.1672826282.git.jani.nikula@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 12:05:17PM +0200, Jani Nikula wrote:
> Commit 537d9ed2f6c1 ("drm/edid: convert add_cea_modes() to use cea db
> iter") inadvertently moved the do_hdmi_vsdb_modes() call within the db
> iteration loop, always passing NULL as the CTA VDB to
> do_hdmi_vsdb_modes(), skipping a lot of stereo modes.
> 
> Move the call back outside of the loop.
> 
> This does mean only one CTA VDB and HDMI VSDB combination will be
> handled, but it's an unlikely scenario to have more than one of either
> block, and it was not accounted for before the regression either.
> 
> Fixes: 537d9ed2f6c1 ("drm/edid: convert add_cea_modes() to use cea db iter")
> Cc: <stable@vger.kernel.org> # v6.0+
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  drivers/gpu/drm/drm_edid.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 23f7146e6a9b..b94adb9bbefb 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -5249,13 +5249,12 @@ static int add_cea_modes(struct drm_connector *connector,
>  {
>  	const struct cea_db *db;
>  	struct cea_db_iter iter;
> +	const u8 *hdmi = NULL, *video = NULL;
> +	u8 hdmi_len = 0, video_len = 0;
>  	int modes = 0;
>  
>  	cea_db_iter_edid_begin(drm_edid, &iter);
>  	cea_db_iter_for_each(db, &iter) {
> -		const u8 *hdmi = NULL, *video = NULL;
> -		u8 hdmi_len = 0, video_len = 0;
> -
>  		if (cea_db_tag(db) == CTA_DB_VIDEO) {
>  			video = cea_db_data(db);
>  			video_len = cea_db_payload_len(db);
> @@ -5271,18 +5270,17 @@ static int add_cea_modes(struct drm_connector *connector,
>  			modes += do_y420vdb_modes(connector, vdb420,
>  						  cea_db_payload_len(db) - 1);
>  		}
> -
> -		/*
> -		 * We parse the HDMI VSDB after having added the cea modes as we
> -		 * will be patching their flags when the sink supports stereo
> -		 * 3D.
> -		 */
> -		if (hdmi)
> -			modes += do_hdmi_vsdb_modes(connector, hdmi, hdmi_len,
> -						    video, video_len);
>  	}
>  	cea_db_iter_end(&iter);
>  
> +	/*
> +	 * We parse the HDMI VSDB after having added the cea modes as we will be
> +	 * patching their flags when the sink supports stereo 3D.
> +	 */
> +	if (hdmi)
> +		modes += do_hdmi_vsdb_modes(connector, hdmi, hdmi_len,
> +					    video, video_len);

I wonder if there are any EDIDs with multiple copies
of either data block... But the original code couldn't
deal with that either so not really a concern for this
patch.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> +
>  	return modes;
>  }
>  
> -- 
> 2.34.1

-- 
Ville Syrjälä
Intel
