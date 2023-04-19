Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2CC6E7DAF
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 17:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDSPLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 11:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjDSPLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 11:11:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F95448E
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 08:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681917083; x=1713453083;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=1yS80lr2TH8CLnDCNmIWKRIr1v+RwIxSQ/31odSqD/c=;
  b=XmFie0wi8eExHXXvvlUD3sFcKoWvwUYky+axCmaw9LuajwpwwNCNw4IA
   BEgQR9oG19oyrew4PYkMqj1rQ+gog5Z+TmOOdxl0Jk7JZhXakjBMn94Ow
   bBw/kaLA56CKa/KkRSKQvsgm0oFZMWds/vSjz5iNz+7kiFAHB7P7r9hvB
   sZLI+EZ3dc5k0w538Cn3+kUu+yubtKo9kKotvvLbpOTDkfgvTcrcVZZPk
   yW90BvcCs11X+nJB4ixBlLtBl51hD2+Qd/2eW555x39ul3GonqqLxWicY
   C948aO3CwKO6fEWh5Gtjb3dAL42Md5/JaL0B8xOi4XlJdmZRXIowe6nYl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="334286122"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="334286122"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 08:11:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="780883706"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="780883706"
Received: from yedidyal-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.47.37])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 08:11:18 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     Ross Zwisler <zwisler@google.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 01/15] drm/i915: Check pipe source size when
 using skl+ scalers
In-Reply-To: <20230418175528.13117-2-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230418175528.13117-1-ville.syrjala@linux.intel.com>
 <20230418175528.13117-2-ville.syrjala@linux.intel.com>
Date:   Wed, 19 Apr 2023 18:11:16 +0300
Message-ID: <87ildrzz3f.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> The skl+ scalers only sample 12 bits of PIPESRC so we can't
> do any plane scaling at all when the pipe source size is >4k.
>
> Make sure the pipe source size is also below the scaler's src
> size limits. Might not be 100% accurate, but should at least be
> safe. We can refine the limits later if we discover that recent
> hw is less restricted.
>
> Cc: stable@vger.kernel.org
> Tested-by: Ross Zwisler <zwisler@google.com>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8357
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/i915/display/skl_scaler.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/display/skl_scaler.c b/drivers/gpu/drm/=
i915/display/skl_scaler.c
> index 473d53610b92..0e7e014fcc71 100644
> --- a/drivers/gpu/drm/i915/display/skl_scaler.c
> +++ b/drivers/gpu/drm/i915/display/skl_scaler.c
> @@ -111,6 +111,8 @@ skl_update_scaler(struct intel_crtc_state *crtc_state=
, bool force_detach,
>  	struct drm_i915_private *dev_priv =3D to_i915(crtc->base.dev);
>  	const struct drm_display_mode *adjusted_mode =3D
>  		&crtc_state->hw.adjusted_mode;
> +	int pipe_src_w =3D drm_rect_width(&crtc_state->pipe_src);
> +	int pipe_src_h =3D drm_rect_height(&crtc_state->pipe_src);
>  	int min_src_w, min_src_h, min_dst_w, min_dst_h;
>  	int max_src_w, max_src_h, max_dst_w, max_dst_h;
>=20=20
> @@ -207,6 +209,21 @@ skl_update_scaler(struct intel_crtc_state *crtc_stat=
e, bool force_detach,
>  		return -EINVAL;
>  	}
>=20=20
> +	/*
> +	 * The pipe scaler does not use all the bits of PIPESRC, at least
> +	 * on the earlier platforms. So even when we're scaling a plane
> +	 * the *pipe* source size must not be too large. For simplicity
> +	 * we assume the limits match the scaler source size limits. Might
> +	 * not be 100% accurate on all platforms, but good enough for now.
> +	 */
> +	if (pipe_src_w > max_src_w || pipe_src_h > max_src_h) {
> +		drm_dbg_kms(&dev_priv->drm,
> +			    "scaler_user index %u.%u: pipe src size %ux%u "
> +			    "is out of scaler range\n",
> +			    crtc->pipe, scaler_user, pipe_src_w, pipe_src_h);
> +		return -EINVAL;
> +	}
> +
>  	/* mark this plane as a scaler user in crtc_state */
>  	scaler_state->scaler_users |=3D (1 << scaler_user);
>  	drm_dbg_kms(&dev_priv->drm, "scaler_user index %u.%u: "

--=20
Jani Nikula, Intel Open Source Graphics Center
