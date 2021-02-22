Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC114321DAA
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 18:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhBVRCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 12:02:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:26472 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhBVRCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 12:02:00 -0500
IronPort-SDR: Msl4G/IjYxSlpIu9CIgyQBdPQHRp6nc/VV7l9tAlT8T1kV5Y3G7yOU4X9xPOXubPDUnV8515PD
 TfdzippMvu8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="172168511"
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="172168511"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 09:00:12 -0800
IronPort-SDR: x9cKnOZhTPwzTl6nRCI0W0rdt0dXfk3MJZJlCvlJ8ubRpu4EYO8XFO/iiM3lnqt13Zd7Ep5r4w
 mJ0g/ci4F//A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="380081397"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga002.jf.intel.com with SMTP; 22 Feb 2021 09:00:08 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 22 Feb 2021 19:00:07 +0200
Date:   Mon, 22 Feb 2021 19:00:07 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Wayne Lin <Wayne.Lin@amd.com>
Cc:     dri-devel@lists.freedesktop.org, eryk.brol@amd.com,
        qingqing.zhuo@amd.com, stable@vger.kernel.org, jerry.zuo@amd.com,
        Nicholas.Kazlauskas@amd.com,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Subject: Re: [PATCH 2/2] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
Message-ID: <YDPjFzPdfZXJqex8@intel.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
 <20210222040027.23505-3-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210222040027.23505-3-Wayne.Lin@amd.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 12:00:27PM +0800, Wayne Lin wrote:
> [Why & How]
> According to DP spec, CLEAR_PAYLOAD_ID_TABLE is a path broadcast request
> message and current implementation is incorrect. Fix it.
> 
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 713ef3b42054..6d73559046e5 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -1072,6 +1072,7 @@ static void build_clear_payload_id_table(struct drm_dp_sideband_msg_tx *msg)
>  
>  	req.req_type = DP_CLEAR_PAYLOAD_ID_TABLE;
>  	drm_dp_encode_sideband_req(&req, msg);
> +	msg->path_msg = true;
>  }
>  
>  static int build_enum_path_resources(struct drm_dp_sideband_msg_tx *msg,
> @@ -2722,7 +2723,8 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sideband_msg_hdr *hdr,
>  
>  	req_type = txmsg->msg[0] & 0x7f;
>  	if (req_type == DP_CONNECTION_STATUS_NOTIFY ||
> -		req_type == DP_RESOURCE_STATUS_NOTIFY)
> +		req_type == DP_RESOURCE_STATUS_NOTIFY ||
> +		req_type == DP_CLEAR_PAYLOAD_ID_TABLE)
>  		hdr->broadcast = 1;

Looks correct.
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Hmm. Looks like we're missing DP_POWER_DOWN_PHY and DP_POWER_UP_PHY
here as well. We do try to send them as path requests, but apparently
forget to mark them as broadcast messages.

>  	else
>  		hdr->broadcast = 0;
> -- 
> 2.17.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel
