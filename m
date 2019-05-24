Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1F229A55
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 16:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403917AbfEXOtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 10:49:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52890 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403888AbfEXOtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 10:49:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id y3so9706049wmm.2
        for <stable@vger.kernel.org>; Fri, 24 May 2019 07:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M1OVfqkksdeurBVUMPNqtFo9e47tslxfnlj6Q1FVC7s=;
        b=ZyZuLCCOfnLuJDG+di693ODAQcbcFxRZJ2yIMa13F9uYcRZf6aUELBjsBMdIRkTSc6
         3FhWbO6WkOoLeZNoNDDpet3MvzBqfT5bneB8hSs+N/SfiTiYRLplpdkkSFdPkeV8IhkS
         0NMsD/yvhqQKlq2HTBZxih1wIgi6+TWJ9ZPVniBIn7XXF9Yuob+AwJ73IyTTA/UttW38
         MjKfi0+ZZ0JBQWGZzevFnR+/jhC+/F9bXQjh4IngviflszqBJPbpR8+Rlw2lYpFipfi5
         xbHHMw2hXBEAplkmWjviAOSKQMS3hCYnjln2cHmLbrfDs2hSRVmrbhftS5m2QtSY6QBl
         evcQ==
X-Gm-Message-State: APjAAAUf1hB8myHF1rGmG9jio7591jrLc+FKw5oN5PRFt958daX9FR4q
        mS0zAebSewvLq+nq60oyREBfQs4z3TE=
X-Google-Smtp-Source: APXvYqxYJ1yQsTD5Dm2L9ePvKHSZvu8av4zCv2xTmS5i9JL+H8Cen0n+w4WLmVz0CdD8t0e2ooexWw==
X-Received: by 2002:a1c:1bc5:: with SMTP id b188mr144055wmb.174.1558709353426;
        Fri, 24 May 2019 07:49:13 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:1c0c:6c86:46e0:a7ad:5246:f04d])
        by smtp.gmail.com with ESMTPSA id z4sm2558108wru.69.2019.05.24.07.49.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 07:49:12 -0700 (PDT)
Subject: Re: [PATCH] drm/i915/dsi: Use a fuzzy check for burst mode clock
 check
To:     Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20190524130607.4021-1-hdegoede@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <2c8453e4-286b-2a05-4481-ac7f4b1843d9@redhat.com>
Date:   Fri, 24 May 2019 16:49:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524130607.4021-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 5/24/19 3:06 PM, Hans de Goede wrote:
> Prior to this commit we fail to init the DSI panel on the GPD MicroPC:
> https://www.indiegogo.com/projects/gpd-micropc-6-inch-handheld-industry-laptop#/
> 
> The problem is intel_dsi_vbt_init() failing with the following error:
> *ERROR* Burst mode freq is less than computed
> 
> The pclk in the VBT panel modeline is 70000, together with 24 bpp and
> 4 lines this results in a bitrate value of 70000 * 24 / 4 = 420000.
> But the target_burst_mode_freq in the VBT is 418000.
> 
> This commit works around this problem by adding an intel_fuzzy_clock_check
> when target_burst_mode_freq < bitrate and setting target_burst_mode_freq to
> bitrate when that checks succeeds, fixing the panel not working.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

I just realized that this patch depends on a patch from another series of
mine which exports intel_fuzzy_clock_check, I will resend this as a series
with the patch doing the exporting as first patch, so that the CI can test
this.

Regards,

Hans


> ---
>   drivers/gpu/drm/i915/intel_dsi_vbt.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dsi_vbt.c b/drivers/gpu/drm/i915/intel_dsi_vbt.c
> index 022bf59418df..a2a9b9d0eeaa 100644
> --- a/drivers/gpu/drm/i915/intel_dsi_vbt.c
> +++ b/drivers/gpu/drm/i915/intel_dsi_vbt.c
> @@ -895,6 +895,17 @@ bool intel_dsi_vbt_init(struct intel_dsi *intel_dsi, u16 panel_id)
>   		if (mipi_config->target_burst_mode_freq) {
>   			u32 bitrate = intel_dsi_bitrate(intel_dsi);
>   
> +			/*
> +			 * Sometimes the VBT contains a slightly lower clock,
> +			 * then the bitrate we have calculated, in this case
> +			 * just replace it with the calculated bitrate.
> +			 */
> +			if (mipi_config->target_burst_mode_freq < bitrate &&
> +			    intel_fuzzy_clock_check(
> +					mipi_config->target_burst_mode_freq,
> +					bitrate))
> +				mipi_config->target_burst_mode_freq = bitrate;
> +
>   			if (mipi_config->target_burst_mode_freq < bitrate) {
>   				DRM_ERROR("Burst mode freq is less than computed\n");
>   				return false;
> 
