Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B8212FDFB
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 21:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgACUfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 15:35:19 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24281 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727400AbgACUfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 15:35:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578083718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5P6pC9bB+XM8/Xw1EneHQrwc3b3SXf3nT5GAbtbko10=;
        b=TGifn/lOWLXWsBZCUYxHMMHc4AsElZ2SBJZP5/85loVvVRuaoufwczIv2SHHwVpnaTt1Gb
        1huFdbnQ3NtiMwsNaqpEGRk0ZQyawDRjGt2OImJ+KVxmB6IMNSahwblDC4gexJw4v+/UJu
        jGdAUaUqSpNPzcPl7EQpukQhoKymIWQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-sA7sExubNwCa2Fjn0ugKcg-1; Fri, 03 Jan 2020 15:35:15 -0500
X-MC-Unique: sA7sExubNwCa2Fjn0ugKcg-1
Received: by mail-qt1-f198.google.com with SMTP id l1so29921396qtp.21
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 12:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=5P6pC9bB+XM8/Xw1EneHQrwc3b3SXf3nT5GAbtbko10=;
        b=r0eHihr1dEAIkpTJQUbMJIKDBi3wUkL/aigmJRg5sLOwQfZZtPMAAGDJ5cpSpaDpWj
         fyqwBqeai3ScFpVAPGAiGxgcPUq0i+ZOonQqEiceArB5CuBGquruDFj268jMrriS8XMS
         myOG9N+p4NmIT4TinEDsr++umDRWzj/UNYO2LL5SLB4kgOZPK+W8gFvd2VwKO/QI4js9
         IsRqfYgGRTzbpDXHpUdFJ9Q0guJZ2Kw2hjLOU/13DLfooE9Ihypda3m87llv8pnA+fEr
         stZ9zDUucvGnCpLUs7YfcoG73pAZUoc6+/WCToyAENq2hVsXS+v+jZaib+GT4m6CaL//
         IjPg==
X-Gm-Message-State: APjAAAUTxlqyto6vp0jz0V7mmdZ/sn9lWb5hslLPFPwR1rfEpDtj+jwz
        L9X8278nEZ5jubLXeCoFJyRhaGWhTX36BpTep2BW/4xjM9i7qGiYgA5tRKv5+YuDGA3ihdultNP
        lPCd3hhE8dh4ujCh4
X-Received: by 2002:ad4:5421:: with SMTP id g1mr68023149qvt.57.1578083714758;
        Fri, 03 Jan 2020 12:35:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgi68keBLcjfBEz4zN/KMDnPfwz3LFg1QJoD7HQRJG4uxuW/u3P8yGx/4EeO57ZnsZsWnpOw==
X-Received: by 2002:ad4:5421:: with SMTP id g1mr68023134qvt.57.1578083714480;
        Fri, 03 Jan 2020 12:35:14 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id h28sm16911014qkk.48.2020.01.03.12.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 12:35:13 -0800 (PST)
Message-ID: <cfb5d28df84df7d3ce20656ca40be65713d5bdb0.camel@redhat.com>
Subject: Re: [PATCH] drm/dp_mst: Avoid NULL pointer dereference
From:   Lyude Paul <lyude@redhat.com>
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     Nicholas.Kazlauskas@amd.com, harry.wentland@amd.com,
        mikita.lipski@amd.com, jerry.zuo@amd.com, stable@vger.kernel.org
Date:   Fri, 03 Jan 2020 15:35:12 -0500
In-Reply-To: <20191226023151.5448-1-Wayne.Lin@amd.com>
References: <20191226023151.5448-1-Wayne.Lin@amd.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Back from the holidays!

Reviewed-by: Lyude Paul <lyude@redhat.com>

Do you need me to push this to drm-misc?

On Thu, 2019-12-26 at 10:31 +0800, Wayne Lin wrote:
> [Why]
> Found kernel NULL pointer dereference under the below situation:
> 
> 	src — HDMI_Monitor   src — HDMI_Monitor
> e.g.:	    \            =>
> 	     MSTB — MSTB     (unplug) MSTB — MSTB
> 
> When display 1 HDMI and 2 DP daisy chain monitors, unplugging the dp
> cable connected to source causes kernel NULL pointer dereference at
> drm_dp_mst_atomic_check_bw_limit(). When calculating pbn_limit, if
> branch is null, accessing "&branch->ports" causes the problem.
> 
> [How]
> Judge branch is null or not at the beginning. If it is null, return 0.
> 
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 7d2d31eaf003..a6473e3ab448 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -4707,6 +4707,9 @@ int drm_dp_mst_atomic_check_bw_limit(struct
> drm_dp_mst_branch *branch,
>  	struct drm_dp_vcpi_allocation *vcpi;
>  	int pbn_limit = 0, pbn_used = 0;
>  
> +	if (!branch)
> +		return 0;
> +
>  	list_for_each_entry(port, &branch->ports, next) {
>  		if (port->mstb)
>  			if (drm_dp_mst_atomic_check_bw_limit(port->mstb,
> mst_state))
-- 
Cheers,
	Lyude Paul

