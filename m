Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01C030E4CB
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 22:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhBCVP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 16:15:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:19696 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhBCVP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 16:15:56 -0500
IronPort-SDR: upwcxqDRPBPvYtDO6UlbfvW4dc7AkJ6Kmn35sK+SWgGD25RLbq8kPv4Rk1waBvwZoS7OH/8XsS
 Sayx6kA18Qbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="180346764"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="180346764"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 13:15:15 -0800
IronPort-SDR: 73OLoKlVIQ9idFotB583rxlu4y8+B/3Dy0UVHEkyzOwwNF3IlSufmgdnHFyuac8DEA3R9Km0DK
 HkM9pC72Ruyg==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="371687075"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 13:15:13 -0800
Date:   Wed, 3 Feb 2021 23:15:09 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     dri-devel@lists.freedesktop.org, Lyude Paul <lyude@redhat.com>,
        Thiago Macieira <gitlab@gitlab.freedesktop.org>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Wayne Lin <Wayne.Lin@amd.com>
Subject: Re: [Intel-gfx] [PATCH 1/4] drm/dp_mst: Don't report ports connected
 if nothing is attached to them
Message-ID: <20210203211509.GA601130@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210201120145.350258-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201120145.350258-1-imre.deak@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 02:01:42PM +0200, Imre Deak wrote:
> Reporting a port as connected if nothing is attached to them leads to
> any i2c transactions on this port trying to use an uninitialized i2c
> adapter, fix this.
> 
> Let's account for this case even if branch devices have no good reason
> to report a port as unplugged with their peer device type set to 'none'.
> 
> Fixes: db1a07956968 ("drm/dp_mst: Handle SST-only branch device case")
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/2987
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/1963
> Cc: Wayne Lin <Wayne.Lin@amd.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: <stable@vger.kernel.org> # v5.5+
> Cc: intel-gfx@lists.freedesktop.org
> Signed-off-by: Imre Deak <imre.deak@intel.com>

Thanks for the report and review, I pushed this one patch to
drm-misc-fixes.

I fixed a typo in the commit message.

> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
> index e82b596d646c..deb7995f42fa 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -4224,6 +4224,7 @@ drm_dp_mst_detect_port(struct drm_connector *connector,
>  
>  	switch (port->pdt) {
>  	case DP_PEER_DEVICE_NONE:
> +		break;
>  	case DP_PEER_DEVICE_MST_BRANCHING:
>  		if (!port->mcs)
>  			ret = connector_status_connected;
> -- 
> 2.25.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
