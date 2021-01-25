Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E51304A64
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbhAZFFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731866AbhAYT1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 14:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611602702;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J5t4uyfj8TRdwZ/fvPQWIaQpBADUpE7PNoniasbl9zM=;
        b=WkZwE04zYfCqVX4N+hnaHwp+n1LDxo9hkBGoeHdmjpvEEdGGAbzE5peW0kSn+MSJpFIBH5
        EqxKCf+3KZ6sF5xJmGZHgEilpX9ey779+Lr5RzuNTs6eSnrVWISaEiyPj+5VzhnGJr6Nbn
        w1clwS/KYSo6s/nXEuiiW9xTntrf9b0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-9Vz3sFN3MSmcp_fjSZNN3Q-1; Mon, 25 Jan 2021 14:25:00 -0500
X-MC-Unique: 9Vz3sFN3MSmcp_fjSZNN3Q-1
Received: by mail-qv1-f70.google.com with SMTP id h13so9940547qvo.18
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 11:25:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=J5t4uyfj8TRdwZ/fvPQWIaQpBADUpE7PNoniasbl9zM=;
        b=QEI52cQODCoosru8keCaaAl7p3XaNssd+7Y24FvFuP25CsIzpJ52DkY13/nr3UE84g
         qLV6zRQ876Mr6PqXQB0X8Jp4x08fmunxcPXH5HN1y5PRjzcVUrrdyTKlRm8iBaByA4nT
         tJrQ/EXZBaHizaoeZCxazMGezbXxl2b7VIM7FqtY84SUcu1ZJIjwH4ceL5+3v7J9kmFB
         Xvu38Avj4A5zwTDjHOxy1qODFWh9a3V7GXrE/0dDSTG+eW69pcs4WxBqmEWaWQuMMCe5
         H7szU97WjzI93Gi938fBgdqLEls+hqwG0aSdITWVak3jGOkuIbp/k8h1PuFFezyGFSCa
         MR2g==
X-Gm-Message-State: AOAM533k63hGDaTyca0tXPpj8fug/xUE2yXPW2NHkxMCxWjPKeZvjMWK
        YxN+JkQCC59SaFL5/Bxe0E1ftY+0owdfyInaPF38yizjipWH6liOFguSd3gCBbUoKhwjj1iM9WW
        HRRkARsT02xlozOFK
X-Received: by 2002:aed:2644:: with SMTP id z62mr2042621qtc.146.1611602699592;
        Mon, 25 Jan 2021 11:24:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlzXb5NfGvxXaKrFngavT+wZnmDoNR8XnISdzmJkXRsuy549Wm1lkxFgmTOMYDlFr1qjW4kg==
X-Received: by 2002:aed:2644:: with SMTP id z62mr2042606qtc.146.1611602699424;
        Mon, 25 Jan 2021 11:24:59 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id g128sm12446097qkd.91.2021.01.25.11.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 11:24:58 -0800 (PST)
Message-ID: <2be72160accef04bf2ed7341b3619befc2121330.camel@redhat.com>
Subject: Re: [PATCH 2/2] drm/i915: Fix the MST PBN divider calculation
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org
Cc:     Ville Syrjala <ville.syrjala@intel.com>, stable@vger.kernel.org
Date:   Mon, 25 Jan 2021 14:24:58 -0500
In-Reply-To: <20210125173636.1733812-2-imre.deak@intel.com>
References: <20210125173636.1733812-1-imre.deak@intel.com>
         <20210125173636.1733812-2-imre.deak@intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-01-25 at 19:36 +0200, Imre Deak wrote:
> Atm the driver will calculate a wrong MST timeslots/MTP (aka time unit)
> value for MST streams if the link parameters (link rate or lane count)
> are limited in a way independent of the sink capabilities (reported by
> DPCD).
> 
> One example of such a limitation is when a MUX between the sink and
> source connects only a limited number of lanes to the display and
> connects the rest of the lanes to other peripherals (USB).
> 
> Another issue is that atm MST core calculates the divider based on the
> backwards compatible DPCD (at address 0x0000) vs. the extended
> capability info (at address 0x2200). This can result in leaving some
> part of the MST BW unused (For instance in case of the WD19TB dock).
> 
> Fix the above two issues by calculating the PBN divider value based on
> the rate and lane count link parameters that the driver uses for all
> other computation.
> 
> Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/2977
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Ville Syrjala <ville.syrjala@intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_dp_mst.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> index d6a1b961a0e8..b4621ed0127e 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -68,7 +68,9 @@ static int intel_dp_mst_compute_link_config(struct
> intel_encoder *encoder,
>  
>                 slots = drm_dp_atomic_find_vcpi_slots(state, &intel_dp-
> >mst_mgr,
>                                                       connector->port,
> -                                                     crtc_state->pbn, 0);
> +                                                     crtc_state->pbn,
> +                                                    
> drm_dp_get_vc_payload_bw(crtc_state->port_clock,
> +                                                                      

This patch looks fine, however you should take care to also update the
documentation for drm_dp_atomic_find_vcpi_slots() so that it mentiones that
pbn_div should be DSC aware but also is not exclusive to systems supporting DSC
over MST (see the docs for the @pbn_div parameter)

Thank you for doing this! I've been meaning to fix the WD19 issues for a while
now but have been too bogged down by other stuff to spend any time on MST
recently.

>         crtc_state->lane_count));
>                 if (slots == -EDEADLK)
>                         return slots;
>                 if (slots >= 0)

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!

