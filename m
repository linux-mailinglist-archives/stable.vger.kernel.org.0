Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D06D59EB76
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 20:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiHWSwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 14:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiHWSwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 14:52:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D8E5D103
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 10:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661274987; x=1692810987;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=oiAV1RwepXSe9Io6bX6GBUzq1NIILs2Gga9AQHIcC4I=;
  b=i7DlZlmFxRn/JJTtQUpYtvMzum0Nt/pOitSmlofPy4ZDJVeJHmae9Ve0
   VMFUZyv1paKEo9LwqIwks/sgZlhaP/YoEJQRFDIejEW4MhOHXb0O8Pw7R
   B/J34VrthsGKG51utKBgGf0aw9mbTwCKEqH4JmVeJ64ORjqEKM3ggsX06
   82aFMLxXz0IP8Ohnme8Ga9cInsqC/HbY7EGRJ6FI8T3OnIw5/2vRC4mRH
   no6sea/hOAWr9CxmawFB8diC84BBhuUP68XNwOCtUe4ZM+dD3LJOao0r7
   TI6u+6cE98oQ3B8ZGCI+dwl7xDaScaB4QBz5KDMDr8zvZmCpO3cRlxzA3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="291309170"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="291309170"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:15:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="670124517"
Received: from obeltran-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.51.100])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:15:51 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/edid: Handle EDID 1.4 range descriptor h/vfreq offsets
In-Reply-To: <20220819092728.14753-1-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220819092728.14753-1-ville.syrjala@linux.intel.com>
Date:   Tue, 23 Aug 2022 20:15:48 +0300
Message-ID: <87mtbukhiz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Aug 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> EDID 1.4 introduced some extra flags in the range
> descriptor to support min/max h/vfreq >=3D 255. Consult them
> to correctly parse the vfreq limits.
>
> Cc: stable@vger.kernel.org
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6519
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/drm_edid.c | 24 ++++++++++++++++++------
>  include/drm/drm_edid.h     |  5 +++++
>  2 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 90a5e26eafa8..4005dab6147d 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -6020,12 +6020,14 @@ static void drm_parse_cea_ext(struct drm_connecto=
r *connector,
>  }
>=20=20
>  static
> -void get_monitor_range(const struct detailed_timing *timing,
> -		       void *info_monitor_range)
> +void get_monitor_range(const struct detailed_timing *timing, void *c)
>  {
> -	struct drm_monitor_range_info *monitor_range =3D info_monitor_range;
> +	struct detailed_mode_closure *closure =3D c;
> +	struct drm_display_info *info =3D &closure->connector->display_info;
> +	struct drm_monitor_range_info *monitor_range =3D &info->monitor_range;
>  	const struct detailed_non_pixel *data =3D &timing->data.other_data;
>  	const struct detailed_data_monitor_range *range =3D &data->data.range;
> +	const struct edid *edid =3D closure->drm_edid->edid;
>=20=20
>  	if (!is_display_descriptor(timing, EDID_DETAIL_MONITOR_RANGE))
>  		return;
> @@ -6041,18 +6043,28 @@ void get_monitor_range(const struct detailed_timi=
ng *timing,
>=20=20
>  	monitor_range->min_vfreq =3D range->min_vfreq;
>  	monitor_range->max_vfreq =3D range->max_vfreq;
> +
> +	if (edid->revision >=3D 4) {
> +		if (data->pad2 & DRM_EDID_RANGE_OFFSET_MIN_VFREQ)
> +			monitor_range->min_vfreq +=3D 255;
> +		if (data->pad2 & DRM_EDID_RANGE_OFFSET_MAX_VFREQ)
> +			monitor_range->max_vfreq +=3D 255;
> +	}

Nitpick, a combo where min vertical range has +255 offset but max
doesn't shouldn't be okay. But then, what are we going to do in that
case anyway? I guess the generic check would be min <=3D max. Also, the
+255 offset range is 256..510, not 256..(255+255). Again, what to do if
that's what the EDID has? *shrug*.

Anyway, what's broken here (and probably impacts the testing in the
referenced bug) is that the struct drm_monitor_range_info members are u8
and this overflows.

With that fixed, whether or not you decide to do anything about the
nitpicks,

Reviewed-by: Jani Nikula <jani.nikula@intel.com>


Side note, git grep for monitor_range reveals amdgpu are doing their own
thing for the parsing. *sigh*.


>  }
>=20=20
>  static void drm_get_monitor_range(struct drm_connector *connector,
>  				  const struct drm_edid *drm_edid)
>  {
> -	struct drm_display_info *info =3D &connector->display_info;
> +	const struct drm_display_info *info =3D &connector->display_info;
> +	struct detailed_mode_closure closure =3D {
> +		.connector =3D connector,
> +		.drm_edid =3D drm_edid,
> +	};
>=20=20
>  	if (!version_greater(drm_edid, 1, 1))
>  		return;
>=20=20
> -	drm_for_each_detailed_block(drm_edid, get_monitor_range,
> -				    &info->monitor_range);
> +	drm_for_each_detailed_block(drm_edid, get_monitor_range, &closure);
>=20=20
>  	DRM_DEBUG_KMS("Supported Monitor Refresh rate range is %d Hz - %d Hz\n",
>  		      info->monitor_range.min_vfreq,
> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
> index 2181977ae683..d81da97cad6e 100644
> --- a/include/drm/drm_edid.h
> +++ b/include/drm/drm_edid.h
> @@ -92,6 +92,11 @@ struct detailed_data_string {
>  	u8 str[13];
>  } __attribute__((packed));
>=20=20
> +#define DRM_EDID_RANGE_OFFSET_MIN_VFREQ (1 << 0)
> +#define DRM_EDID_RANGE_OFFSET_MAX_VFREQ (1 << 1)
> +#define DRM_EDID_RANGE_OFFSET_MIN_HFREQ (1 << 2)
> +#define DRM_EDID_RANGE_OFFSET_MAX_HFREQ (1 << 3)
> +
>  #define DRM_EDID_DEFAULT_GTF_SUPPORT_FLAG   0x00
>  #define DRM_EDID_RANGE_LIMITS_ONLY_FLAG     0x01
>  #define DRM_EDID_SECONDARY_GTF_SUPPORT_FLAG 0x02

--=20
Jani Nikula, Intel Open Source Graphics Center
