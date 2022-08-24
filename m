Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE8959F91A
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiHXMLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiHXMLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:11:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C07065573
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 05:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661343075; x=1692879075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=AM1fboOapzTo46Lk6YYpoPBpuwY0NuTFDojhyL3gXi8=;
  b=EV8YH7UiuSdPJU0d9X419F+tWp5nki+BJoye7P4Y08Nss1hElMTdOhUT
   9bR7tQN/diTCRXauGy4KNkB6d3TVMDHlMpNU9F/t7ZcAuyHEyJgp+LZSy
   Afx3JX4cboZi7Z8qDW/x6vnwVPWkNQ7cT+x7oy+VcxnOi43D9sAhr3cA2
   Nal+y3Mq2EAHTCiOG3RgV/jMabR6iYSfw3xRDdyztnCC6/VB030sXR+Uy
   8NwWKge+UCUonDJAXX/WS1Dqj2mOZg51NSXX4SizsRMM7GgojUEH6KS2q
   4Bkd5QbRV/r66V8/PRDnEG51u5bkh8oS+25mWve1Vwt5jlR5XBRo9qypV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="295227375"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="295227375"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 05:11:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="713016983"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.59])
  by fmsmga002.fm.intel.com with SMTP; 24 Aug 2022 05:11:12 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 24 Aug 2022 15:11:11 +0300
Date:   Wed, 24 Aug 2022 15:11:11 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/edid: Handle EDID 1.4 range descriptor h/vfreq
 offsets
Message-ID: <YwYVX8dUbpv746Zn@intel.com>
References: <20220819092728.14753-1-ville.syrjala@linux.intel.com>
 <87mtbukhiz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mtbukhiz.fsf@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 08:15:48PM +0300, Jani Nikula wrote:
> On Fri, 19 Aug 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >
> > EDID 1.4 introduced some extra flags in the range
> > descriptor to support min/max h/vfreq >= 255. Consult them
> > to correctly parse the vfreq limits.
> >
> > Cc: stable@vger.kernel.org
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6519
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/drm_edid.c | 24 ++++++++++++++++++------
> >  include/drm/drm_edid.h     |  5 +++++
> >  2 files changed, 23 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> > index 90a5e26eafa8..4005dab6147d 100644
> > --- a/drivers/gpu/drm/drm_edid.c
> > +++ b/drivers/gpu/drm/drm_edid.c
> > @@ -6020,12 +6020,14 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
> >  }
> >  
> >  static
> > -void get_monitor_range(const struct detailed_timing *timing,
> > -		       void *info_monitor_range)
> > +void get_monitor_range(const struct detailed_timing *timing, void *c)
> >  {
> > -	struct drm_monitor_range_info *monitor_range = info_monitor_range;
> > +	struct detailed_mode_closure *closure = c;
> > +	struct drm_display_info *info = &closure->connector->display_info;
> > +	struct drm_monitor_range_info *monitor_range = &info->monitor_range;
> >  	const struct detailed_non_pixel *data = &timing->data.other_data;
> >  	const struct detailed_data_monitor_range *range = &data->data.range;
> > +	const struct edid *edid = closure->drm_edid->edid;
> >  
> >  	if (!is_display_descriptor(timing, EDID_DETAIL_MONITOR_RANGE))
> >  		return;
> > @@ -6041,18 +6043,28 @@ void get_monitor_range(const struct detailed_timing *timing,
> >  
> >  	monitor_range->min_vfreq = range->min_vfreq;
> >  	monitor_range->max_vfreq = range->max_vfreq;
> > +
> > +	if (edid->revision >= 4) {
> > +		if (data->pad2 & DRM_EDID_RANGE_OFFSET_MIN_VFREQ)
> > +			monitor_range->min_vfreq += 255;
> > +		if (data->pad2 & DRM_EDID_RANGE_OFFSET_MAX_VFREQ)
> > +			monitor_range->max_vfreq += 255;
> > +	}
> 
> Nitpick, a combo where min vertical range has +255 offset but max
> doesn't shouldn't be okay. But then, what are we going to do in that
> case anyway? I guess the generic check would be min <= max. Also, the
> +255 offset range is 256..510, not 256..(255+255). Again, what to do if
> that's what the EDID has? *shrug*.

Yeah, I figured that writing the code in the most straightforward
way was fine since reserved values aren't going to produce valid
results anyway. Though I guess just ignoring the whole descriptor
in that case might be another option.

> 
> Anyway, what's broken here (and probably impacts the testing in the
> referenced bug) is that the struct drm_monitor_range_info members are u8
> and this overflows.

Derp.

> 
> With that fixed, whether or not you decide to do anything about the
> nitpicks,
>
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>

Thanks.

> 
> 
> Side note, git grep for monitor_range reveals amdgpu are doing their own
> thing for the parsing. *sigh*.
> 
> 
> >  }
> >  
> >  static void drm_get_monitor_range(struct drm_connector *connector,
> >  				  const struct drm_edid *drm_edid)
> >  {
> > -	struct drm_display_info *info = &connector->display_info;
> > +	const struct drm_display_info *info = &connector->display_info;
> > +	struct detailed_mode_closure closure = {
> > +		.connector = connector,
> > +		.drm_edid = drm_edid,
> > +	};
> >  
> >  	if (!version_greater(drm_edid, 1, 1))
> >  		return;
> >  
> > -	drm_for_each_detailed_block(drm_edid, get_monitor_range,
> > -				    &info->monitor_range);
> > +	drm_for_each_detailed_block(drm_edid, get_monitor_range, &closure);
> >  
> >  	DRM_DEBUG_KMS("Supported Monitor Refresh rate range is %d Hz - %d Hz\n",
> >  		      info->monitor_range.min_vfreq,
> > diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
> > index 2181977ae683..d81da97cad6e 100644
> > --- a/include/drm/drm_edid.h
> > +++ b/include/drm/drm_edid.h
> > @@ -92,6 +92,11 @@ struct detailed_data_string {
> >  	u8 str[13];
> >  } __attribute__((packed));
> >  
> > +#define DRM_EDID_RANGE_OFFSET_MIN_VFREQ (1 << 0)
> > +#define DRM_EDID_RANGE_OFFSET_MAX_VFREQ (1 << 1)
> > +#define DRM_EDID_RANGE_OFFSET_MIN_HFREQ (1 << 2)
> > +#define DRM_EDID_RANGE_OFFSET_MAX_HFREQ (1 << 3)
> > +
> >  #define DRM_EDID_DEFAULT_GTF_SUPPORT_FLAG   0x00
> >  #define DRM_EDID_RANGE_LIMITS_ONLY_FLAG     0x01
> >  #define DRM_EDID_SECONDARY_GTF_SUPPORT_FLAG 0x02
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center

-- 
Ville Syrjälä
Intel
