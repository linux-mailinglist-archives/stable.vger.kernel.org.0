Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E873A1157BA
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 20:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfLFTYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 14:24:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34759 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726317AbfLFTYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 14:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575660255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8lr3mwGxXhI82WmKp3XKXy3xSh21+B3Dvk4LNThQO0=;
        b=gtQRCgt+4arYui1zGEUM/jYJJm0Re94c/gfUZnzmss6hwbJDWHfXyzlHHgwkuAO37C60BX
        qcvG4J/eiLHJP46dojYakSdE6dMEpluvExSogAwxgLMQgHKMIr/xvDGgj+Eobh6W6RZByR
        ofDE7Fl9p8Dpx+JIjRzSTcPaL5l9JQc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-W5mTJxUbP1CI6qjIko698Q-1; Fri, 06 Dec 2019 14:24:14 -0500
Received: by mail-qt1-f200.google.com with SMTP id u9so5732982qte.5
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 11:24:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=S8lr3mwGxXhI82WmKp3XKXy3xSh21+B3Dvk4LNThQO0=;
        b=RS4qTgs/gyKlbD2Eu5HSp414xJDyjQ8SFjM7Pg1b6b9VF/j88H6k02vNaVhq6Orcir
         9OEsME5uqUnMZbUfhGNVgusXmoimuavfCjdXePoohz8pVZppPnOx6y2EdLxiXVJBQsu/
         RG7JKp4+Q7e3kq6iqWNZEq1asboFZN9ODTzk9OdcA4Zm/tnT06RqkoNsEGvLXnkB33zG
         r4b9TXe3O4Oah5ktNbLHTLVfLD3561O8bzA4QyIMw1k3o3xDghvSULIVy+/TrZbFhy/O
         OJfvh9iPM4vgAJKpm8FAYvyQ5hL27wEyijquDzmchAfAuDLnDxZDbVgEIMAxpjhR1P9e
         OIZQ==
X-Gm-Message-State: APjAAAUBYTglVnxPfrxy4XjfazSLVnYxj07G3a4ncsCn0O5eMlAL1JhO
        EpzrB48NmimA35yC8HlvpTrHsthq6xmnnIQh2OSJs6F6xH1rAqDVaDWBw1FXf1yDgUHGBGrSEWE
        P77yo37zaC1Bo15XQ
X-Received: by 2002:ac8:67cb:: with SMTP id r11mr13999616qtp.54.1575660253731;
        Fri, 06 Dec 2019 11:24:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwX3PjTHrOow2vN7EK2A8jxrFjf0XyZzUwkotrX3+LAqSHG3uRAB0KHOmew9nARPynN51H3Ug==
X-Received: by 2002:ac8:67cb:: with SMTP id r11mr13999592qtp.54.1575660253395;
        Fri, 06 Dec 2019 11:24:13 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id 17sm6285222qkk.81.2019.12.06.11.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 11:24:12 -0800 (PST)
Message-ID: <a6c4db964da7e00a6069d40abcb3aa887ef5522b.camel@redhat.com>
Subject: Re: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
From:   Lyude Paul <lyude@redhat.com>
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     Nicholas.Kazlauskas@amd.com, harry.wentland@amd.com,
        jerry.zuo@amd.com, stable@vger.kernel.org
Date:   Fri, 06 Dec 2019 14:24:11 -0500
In-Reply-To: <20191205090043.7580-1-Wayne.Lin@amd.com>
References: <20191205090043.7580-1-Wayne.Lin@amd.com>
Organization: Red Hat
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31)
MIME-Version: 1.0
X-MC-Unique: W5mTJxUbP1CI6qjIko698Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

I'll go ahead and push this to drm-misc-next-fixes right now, thanks!

On Thu, 2019-12-05 at 17:00 +0800, Wayne Lin wrote:
> [Why]
> 
> This patch is trying to address the issue observed when hotplug DP
> daisy chain monitors.
> 
> e.g.
> src-mstb-mstb-sst -> src (unplug) mstb-mstb-sst -> src-mstb-mstb-sst
> (plug in again)
> 
> Once unplug a DP MST capable device, driver will call
> drm_dp_mst_topology_mgr_set_mst() to disable MST. In this function,
> it cleans data of topology manager while disabling mst_state. However,
> it doesn't clean up the proposed_vcpis of topology manager.
> If proposed_vcpi is not reset, once plug in MST daisy chain monitors
> later, code will fail at checking port validation while trying to
> allocate payloads.
> 
> When MST capable device is plugged in again and try to allocate
> payloads by calling drm_dp_update_payload_part1(), this
> function will iterate over all proposed virtual channels to see if
> any proposed VCPI's num_slots is greater than 0. If any proposed
> VCPI's num_slots is greater than 0 and the port which the
> specific virtual channel directed to is not in the topology, code then
> fails at the port validation. Since there are stale VCPI allocations
> from the previous topology enablement in proposed_vcpi[], code will fail
> at port validation and reurn EINVAL.
> 
> [How]
> 
> Clean up the data of stale proposed_vcpi[] and reset mgr->proposed_vcpis
> to NULL while disabling mst in drm_dp_mst_topology_mgr_set_mst().
> 
> Changes since v1:
> *Add on more details in commit message to describe the issue which the 
> patch is trying to fix
> 
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> b/drivers/gpu/drm/drm_dp_mst_topology.c
> index ae5809a1f19a..bf4f745a4edb 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -3386,6 +3386,7 @@ static int drm_dp_get_vc_payload_bw(u8 dp_link_bw,
> u8  dp_link_count)
>  int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr,
> bool mst_state)
>  {
>  	int ret = 0;
> +	int i = 0;
>  	struct drm_dp_mst_branch *mstb = NULL;
>  
>  	mutex_lock(&mgr->lock);
> @@ -3446,10 +3447,21 @@ int drm_dp_mst_topology_mgr_set_mst(struct
> drm_dp_mst_topology_mgr *mgr, bool ms
>  		/* this can fail if the device is gone */
>  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
>  		ret = 0;
> +		mutex_lock(&mgr->payload_lock);
>  		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct
> drm_dp_payload));
>  		mgr->payload_mask = 0;
>  		set_bit(0, &mgr->payload_mask);
> +		for (i = 0; i < mgr->max_payloads; i++) {
> +			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
> +
> +			if (vcpi) {
> +				vcpi->vcpi = 0;
> +				vcpi->num_slots = 0;
> +			}
> +			mgr->proposed_vcpis[i] = NULL;
> +		}
>  		mgr->vcpi_mask = 0;
> +		mutex_unlock(&mgr->payload_lock);
>  	}
>  
>  out_unlock:
-- 
Cheers,
	Lyude Paul

