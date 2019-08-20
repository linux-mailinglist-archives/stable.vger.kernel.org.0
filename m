Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A9696C9C
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 01:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfHTXCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 19:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfHTXCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 19:02:04 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C0A1B7BDAB
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 23:02:03 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id y188so153975qke.18
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 16:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=KJoqObo66CUzJ9UoiBDeSGBnzUEbDV63YL1UyIMcJRI=;
        b=c2n/BMSx1SpDKmP2N0PRVrgq5QxkZPkTDLS76PDtbiz72HcQbm+VyKec5CNceL04zD
         qoC4ujxDqalCChTM3fuLQR1wjjSBN1Qfz8Di8Dze5MD5DJ6R9maoDMeb1eRn50Yk7MOE
         2Vr69CJTL+bdd8y3i0sGEiiLVmMblgz7PvkBIO9wkqsyHUKNDqDUs+85vnFPw1N4xhRx
         xaBYJzRKdEoL0qDo8SxcyE2AbP7B6qqBsVGGx1PhZplG6DKzolaffJgNGmkijn25Sm1X
         g/IM2rrolBwNeT88zzYecIZIlLD5owrlb7/qfRhpEtbPXi4H60FyuS0Errn6XksuTMRb
         3+DA==
X-Gm-Message-State: APjAAAUyM3vlVjTOv94e5jhEHqDIrxMmcIpErM5XLedRvdVxyRdZYsbA
        8ck/KFeomW/rcuUkjN1oPAS/E/qWQ7JWud7otQIeoYRcV9F5dx/99cTDBQj+SCnqQ43a4rzh4E1
        fxLrRddBNh4robnOB
X-Received: by 2002:a37:d2c2:: with SMTP id f185mr29192053qkj.173.1566342122419;
        Tue, 20 Aug 2019 16:02:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwm8rGZCptIyLSmmy+1EZgF2A2+z2L8uBIeAjHH0L0wrGt5pzaMzJ5BOujyu5YLYyARMVM5Ow==
X-Received: by 2002:a37:d2c2:: with SMTP id f185mr29192031qkj.173.1566342122174;
        Tue, 20 Aug 2019 16:02:02 -0700 (PDT)
Received: from dhcp-10-20-1-11.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id v23sm8737178qtq.40.2019.08.20.16.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 16:02:01 -0700 (PDT)
Message-ID: <af6925a36948b12b8e3490f27cd2c08d80d5c50f.camel@redhat.com>
Subject: Re: [PATCH] drm/i915: Do not create a new max_bpc prop for MST
 connectors
From:   Lyude Paul <lyude@redhat.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, sunpeng.li@amd.com,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>
Date:   Tue, 20 Aug 2019 19:01:59 -0400
In-Reply-To: <20190820161657.9658-1-ville.syrjala@linux.intel.com>
References: <20190820161657.9658-1-ville.syrjala@linux.intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Tue, 2019-08-20 at 19:16 +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> We're not allowed to create new properties after device registration
> so for MST connectors we need to either create the max_bpc property
> earlier, or we reuse one we already have. Let's do the latter apporach
> since the corresponding SST connector already has the prop and its
> min/max are correct also for the MST connector.
> 
> The problem was highlighted by commit 4f5368b5541a ("drm/kms:
> Catch mode_object lifetime errors") which results in the following
> spew:
> [ 1330.878941] WARNING: CPU: 2 PID: 1554 at
> drivers/gpu/drm/drm_mode_object.c:45 __drm_mode_object_add+0xa0/0xb0 [drm]
> ...
> [ 1330.879008] Call Trace:
> [ 1330.879023]  drm_property_create+0xba/0x180 [drm]
> [ 1330.879036]  drm_property_create_range+0x15/0x30 [drm]
> [ 1330.879048]  drm_connector_attach_max_bpc_property+0x62/0x80 [drm]
> [ 1330.879086]  intel_dp_add_mst_connector+0x11f/0x140 [i915]
> [ 1330.879094]  drm_dp_add_port.isra.20+0x20b/0x440 [drm_kms_helper]
> ...
> 
> Cc: stable@vger.kernel.org
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: sunpeng.li@amd.com
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sean Paul <sean@poorly.run>
> Fixes: 5ca0ef8a56b8 ("drm/i915: Add max_bpc property for DP MST")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_dp_mst.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> index 83faa246e361..9748581c1d62 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -536,7 +536,15 @@ static struct drm_connector
> *intel_dp_add_mst_connector(struct drm_dp_mst_topolo
>  
>  	intel_attach_force_audio_property(connector);
>  	intel_attach_broadcast_rgb_property(connector);
> -	drm_connector_attach_max_bpc_property(connector, 6, 12);
> +
> +	/*
> +	 * Reuse the prop from the SST connector because we're
> +	 * not allowed to create new props after device registration.
> +	 */
> +	connector->max_bpc_property =
> +		intel_dp->attached_connector->base.max_bpc_property;
> +	if (connector->max_bpc_property)
> +		drm_connector_attach_max_bpc_property(connector, 6, 12);
>  
>  	return connector;
>  
-- 
Cheers,
	Lyude Paul

