Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11859371469
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 13:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhECLkB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 3 May 2021 07:40:01 -0400
Received: from srv6.fidu.org ([159.69.62.71]:37158 "EHLO srv6.fidu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhECLkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 07:40:01 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id A3260C800BC;
        Mon,  3 May 2021 13:39:06 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id ZxvWVMT4vCPl; Mon,  3 May 2021 13:39:06 +0200 (CEST)
Received: from [IPv6:2003:e3:7f39:8600:1a8b:79e0:b24c:b29d] (p200300e37f3986001a8B79E0b24cB29d.dip0.t-ipconnect.de [IPv6:2003:e3:7f39:8600:1a8b:79e0:b24c:b29d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPSA id C5EAFC800BB;
        Mon,  3 May 2021 13:39:05 +0200 (CEST)
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     airlied@linux.ie, daniel@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210429120553.7823-1-wse@tuxedocomputers.com>
 <YIw2q/aibOplo7b+@intel.com>
From:   Werner Sembach <wse@tuxedocomputers.com>
Subject: Re: [PATCH] drm/i915/display Try YCbCr420 color when RGB fails
Message-ID: <c68865ea-a968-a0b2-e534-a97c51a42d16@tuxedocomputers.com>
Date:   Mon, 3 May 2021 13:39:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YIw2q/aibOplo7b+@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for the feedback. I got some questions below.
> On Thu, Apr 29, 2021 at 02:05:53PM +0200, Werner Sembach wrote:
>> When encoder validation of a display mode fails, retry with less bandwidth
>> heavy YCbCr420 color mode, if available. This enables some HDMI 1.4 setups
>> to support 4k60Hz output, which previously failed silently.
>>
>> AMDGPU had nearly the exact same issue. This problem description is
>> therefore copied from my commit message of the AMDGPU patch.
>>
>> On some setups, while the monitor and the gpu support display modes with
>> pixel clocks of up to 600MHz, the link encoder might not. This prevents
>> YCbCr444 and RGB encoding for 4k60Hz, but YCbCr420 encoding might still be
>> possible. However, which color mode is used is decided before the link
>> encoder capabilities are checked. This patch fixes the problem by retrying
>> to find a display mode with YCbCr420 enforced and using it, if it is
>> valid.
>>
>> I'm not entierly sure if the second
>> "if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv))" check in
>> intel_hdmi_compute_config(...) after forcing ycbcr420 is necessary. I
>> included it to better be safe then sorry.
>>
>> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>> Rebased from 5.12 to drm-tip and resend to resolve merge conflict.
>>
>> >From 876c1c8d970ff2a411ee8d08651bd4edbe9ecb3d Mon Sep 17 00:00:00 2001
>> From: Werner Sembach <wse@tuxedocomputers.com>
>> Date: Thu, 29 Apr 2021 13:59:30 +0200
>> Subject: [PATCH] Retry using YCbCr420 encoding if clock setup for RGB fails
>>
>> ---
>>  drivers/gpu/drm/i915/display/intel_hdmi.c | 80 +++++++++++++++++------
>>  1 file changed, 60 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/display/intel_hdmi.c b/drivers/gpu/drm/i915/display/intel_hdmi.c
>> index 46de56af33db..c9b5a7d7f9c6 100644
>> --- a/drivers/gpu/drm/i915/display/intel_hdmi.c
>> +++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
>> @@ -1861,6 +1861,30 @@ static int intel_hdmi_port_clock(int clock, int bpc)
>>  	return clock * bpc / 8;
>>  }
>>  
>> +static enum drm_mode_status
>> +intel_hdmi_check_bpc(struct intel_hdmi *hdmi, int clock, bool has_hdmi_sink, struct drm_i915_private *dev_priv)
> Don't pass dev_priv. It can be extracted from the intel_hdmi.
>
> The name of the function isn't really sitting super well with me.
> I guess I'd just call it something like intel_hdmi_mode_clock_valid().
>
> We should also split this big patch up into smaller parts. Just this
> mechanical extraction of this function without any functional changes
> could be a nice first patch in the series.
>
>> +{
>> +	enum drm_mode_status status;
>> +
>> +	/* check if we can do 8bpc */
>> +	status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 8),
>> +				       true, has_hdmi_sink);
>> +
>> +	if (has_hdmi_sink) {
>> +		/* if we can't do 8bpc we may still be able to do 12bpc */
>> +		if (status != MODE_OK && !HAS_GMCH(dev_priv))
>> +			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 12),
>> +						       true, has_hdmi_sink);
>> +
>> +		/* if we can't do 8,12bpc we may still be able to do 10bpc */
>> +		if (status != MODE_OK && DISPLAY_VER(dev_priv) >= 11)
>> +			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 10),
>> +						       true, has_hdmi_sink);
>> +	}
>> +
>> +	return status;
>> +}
>> +
>>  static enum drm_mode_status
>>  intel_hdmi_mode_valid(struct drm_connector *connector,
>>  		      struct drm_display_mode *mode)
>> @@ -1891,23 +1915,18 @@ intel_hdmi_mode_valid(struct drm_connector *connector,
>>  	if (drm_mode_is_420_only(&connector->display_info, mode))
>>  		clock /= 2;
>>  
>> -	/* check if we can do 8bpc */
>> -	status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 8),
>> -				       true, has_hdmi_sink);
>> +	status = intel_hdmi_check_bpc(hdmi, clock, has_hdmi_sink, dev_priv);
>>  
>> -	if (has_hdmi_sink) {
>> -		/* if we can't do 8bpc we may still be able to do 12bpc */
>> -		if (status != MODE_OK && !HAS_GMCH(dev_priv))
>> -			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 12),
>> -						       true, has_hdmi_sink);
>> +	if (status != MODE_OK) {
>> +		if (drm_mode_is_420_also(&connector->display_info, mode)) {
> We also need a connector->ycbcr_420_allowed check here.
>
>> +			/* if we can't do full color resolution we may still be able to do reduced color resolution */
>> +			clock /= 2;
>>  
>> -		/* if we can't do 8,12bpc we may still be able to do 10bpc */
>> -		if (status != MODE_OK && DISPLAY_VER(dev_priv) >= 11)
>> -			status = hdmi_port_clock_valid(hdmi, intel_hdmi_port_clock(clock, 10),
>> -						       true, has_hdmi_sink);
>> +			status = intel_hdmi_check_bpc(hdmi, clock, has_hdmi_sink, dev_priv);
>> +		}
>> +		if (status != MODE_OK)
>> +			return status;
>>  	}
>> -	if (status != MODE_OK)
>> -		return status;
>>  
>>  	return intel_mode_valid_max_plane_size(dev_priv, mode, false);
>>  }
>> @@ -1990,14 +2009,17 @@ static bool hdmi_deep_color_possible(const struct intel_crtc_state *crtc_state,
>>  
>>  static int
>>  intel_hdmi_ycbcr420_config(struct intel_crtc_state *crtc_state,
>> -			   const struct drm_connector_state *conn_state)
>> +			   const struct drm_connector_state *conn_state,
>> +			   const bool force_ycbcr420)
>>  {
>>  	struct drm_connector *connector = conn_state->connector;
>>  	struct drm_i915_private *i915 = to_i915(connector->dev);
>>  	const struct drm_display_mode *adjusted_mode =
>>  		&crtc_state->hw.adjusted_mode;
>>  
>> -	if (!drm_mode_is_420_only(&connector->display_info, adjusted_mode))
>> +	if (!(drm_mode_is_420_only(&connector->display_info, adjusted_mode) ||
>> +			(force_ycbcr420 &&
>> +			drm_mode_is_420_also(&connector->display_info, adjusted_mode))))
>>  		return 0;
>>  
> This function I think we just want to throw out and roll something
> a bit better.
>
> Something like this I believe should work nicely:
>
> intel_hdmi_compute_output_format()
> {
> 	if (drm_mode_is_420_only())
> 		crtc_state->output_format = INTEL_OUTPUT_FORMAT_YCBCR420;
> 	else
> 		crtc_state->output_format = INTEL_OUTPUT_FORMAT_RGB;
>
> 	ret = intel_hdmi_compute_clock();
> 	if (ret) {
> 		if (crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR420)
> 			return ret;
>
> 		crtc_state->output_format = INTEL_OUTPUT_FORMAT_YCBCR420;
>
> 		ret = intel_hdmi_compute_clock()
> 		if (ret)
> 			return ret;
> 	}
>
> 	return 0;
> }

Can you give clarification on the 3 checks coming in between intel_hdmi_ycbcr420_config and intel_hdmi_compute_clock?

I guess this can be done before:

pipe_config->has_audio =
        intel_hdmi_has_audio(encoder, pipe_config, conn_state);

This one behaves differently whether or not RGB or YCbCr is used, but I guess does not change the required clock speed? I'm unsure about this however. If it has no effect on the clock I would call it after intel_hdmi_compute_clock:

pipe_config->limited_color_range =
        intel_hdmi_limited_color_range(pipe_config, conn_state);

I don't know what this actually does, but it doesn't seem to have to do something with color encoding so, like the has_audio check, it can be done before deciding on RGB or YCbCr420? Correct me if I'm wrong:

if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv))
        pipe_config->has_pch_encoder = true;

> assuming we make intel_hdmi_compute_clock() check whether 420 output
> is actually supported.

Currently it's check ycbcr420 then set. This would turn this around. Check first is more logical for my brain however.

what about something like this?

intel_hdmi_compute_output_format()
{
    if (drm_mode_is_420_only())
        crtc_state->output_format = INTEL_OUTPUT_FORMAT_YCBCR420;
    else
        crtc_state->output_format = INTEL_OUTPUT_FORMAT_RGB;

    ret = intel_hdmi_compute_clock();
    if (ret) {
        if (crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR420 ||
                !drm_mode_is_420_also() ||
                !connector->ycbcr_420_allowed)
            return ret;

        crtc_state->output_format = INTEL_OUTPUT_FORMAT_YCBCR420;

        ret = intel_hdmi_compute_clock()
        if (ret)
            return ret;
    }

    return 0;
}

> Could roll a small helper for that. Something along these lines perhaps:
> static bool intel_hdmi_ycbcr_420_supported()
> {
> 	return connector->ycbcr_420_allowed &&
> 	       (drm_mode_is_420_only() || drm_mode_is_420_also());
> }
>
> The intel_pch_panel_fitting() call should probably just be hoisted
> into intel_hdmi_compute_config() after we've called the new
> intel_hdmi_compute_output_format().
>
> I think a three patch series is probably what we want for this:
> patch 1: extract intel_hdmi_mode_clock_valid() without 420_also handling
> patch 2: introduce intel_hdmi_compute_output_format() without 420_also handling
> patch 3: drop in the 420_also handling everywhere
>
> That way if there's any regression due to the 420_also stuff at least
> we won't have to revert the whole thing, and can then more easily work
> on fixing whatever needs fixing.
>
>>  	if (!connector->ycbcr_420_allowed) {
>> @@ -2126,7 +2148,7 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
>>  	struct drm_display_mode *adjusted_mode = &pipe_config->hw.adjusted_mode;
>>  	struct drm_connector *connector = conn_state->connector;
>>  	struct drm_scdc *scdc = &connector->display_info.hdmi.scdc;
>> -	int ret;
>> +	int ret, ret_saved;
>>  
>>  	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLSCAN)
>>  		return -EINVAL;
>> @@ -2141,7 +2163,7 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
>>  	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLCLK)
>>  		pipe_config->pixel_multiplier = 2;
>>  
>> -	ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state);
>> +	ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state, false);
>>  	if (ret)
>>  		return ret;
>>  
>> @@ -2155,8 +2177,26 @@ int intel_hdmi_compute_config(struct intel_encoder *encoder,
>>  		intel_hdmi_has_audio(encoder, pipe_config, conn_state);
>>  
>>  	ret = intel_hdmi_compute_clock(encoder, pipe_config);
>> -	if (ret)
>> -		return ret;
>> +	if (ret) {
>> +		ret_saved = ret;
>> +
>> +		ret = intel_hdmi_ycbcr420_config(pipe_config, conn_state, true);
>> +		if (ret)
>> +			return ret;
>> +
>> +		if (pipe_config->output_format != INTEL_OUTPUT_FORMAT_YCBCR420)
>> +			return ret_saved;
>> +
>> +		pipe_config->limited_color_range =
>> +			intel_hdmi_limited_color_range(pipe_config, conn_state);
>> +
>> +		if (HAS_PCH_SPLIT(dev_priv) && !HAS_DDI(dev_priv))
>> +			pipe_config->has_pch_encoder = true;
>> +
>> +		ret = intel_hdmi_compute_clock(encoder, pipe_config);
>> +		if (ret)
>> +			return ret;
>> +	}
>>  
>>  	if (conn_state->picture_aspect_ratio)
>>  		adjusted_mode->picture_aspect_ratio =
>> -- 
>> 2.25.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel

