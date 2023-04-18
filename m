Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF35F6E5C8F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 10:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjDRIxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 04:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjDRIw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 04:52:58 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758DD49D7
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 01:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681807975; x=1713343975;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=+r5HNnhbzxitDBNyCdAhtAQgLrE9Ump8tBCjEV3p1JI=;
  b=SYRIJbToH/jWbuqv82QFTrSwE7qGkdFyLHQGujHFzPUs5uCVjjeenbQ0
   /gzFjOryl93FOucr8Yn/TKhO2QLDFo0FmJFWc84OjhYqFzjG9Jcdprf8Q
   89yzv41Y3gTaAgJ+K9xT+c+wKVxpMUJbbbQAlV4kWEjnIIlutgtXsLz4P
   RRshWIPHKss/sc3pBhC193asqCyFlnEKEbFL9ZTW/Yvxrj4iF6wZvhXLW
   chC2nKlMC55727O5G/DGZbo7E9Q2lwOK0CWTuRB1rEEIELuBMno5fOKMf
   ftPFtN/AmbdWfk4QOq1zLo/J9k6wxuSX2ghAb9k7vhYPuqIWxX4DeSQAV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="346961863"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="346961863"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 01:52:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="668436390"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="668436390"
Received: from unknown (HELO localhost) ([10.237.66.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 01:52:51 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     lyude@redhat.com, imre.deak@intel.com,
        ville.syrjala@linux.intel.com, harry.wentland@amd.com,
        jerry.zuo@amd.com, Wayne Lin <Wayne.Lin@amd.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new message
In-Reply-To: <20230418060905.4078976-1-Wayne.Lin@amd.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230418060905.4078976-1-Wayne.Lin@amd.com>
Date:   Tue, 18 Apr 2023 11:52:48 +0300
Message-ID: <87mt351sin.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023, Wayne Lin <Wayne.Lin@amd.com> wrote:
> [Why & How]
> The sequence for collecting down_reply/up_request from source
> perspective should be:
>
> Request_n->repeat (get partial reply of Request_n->clear message ready
> flag to ack DPRX that the message is received) till all partial
> replies for Request_n are received->new Request_n+1.
>
> While assembling partial reply packets, reading out DPCD DOWN_REP
> Sideband MSG buffer + clearing DOWN_REP_MSG_RDY flag should be
> wrapped up as a complete operation for reading out a reply packet.
> Kicking off a new request before clearing DOWN_REP_MSG_RDY flag might
> be risky. e.g. If the reply of the new request has overwritten the
> DPRX DOWN_REP Sideband MSG buffer before source writing ack to clear
> DOWN_REP_MSG_RDY flag, source then unintentionally flushes the reply
> for the new request. Should handle the up request in the same way.
>
> In drm_dp_mst_hpd_irq(), we don't clear MSG_RDY flag before caliing
> drm_dp_mst_kick_tx(). Fix that.
>
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 ++
>  drivers/gpu/drm/display/drm_dp_mst_topology.c | 22 +++++++++++++++++++
>  drivers/gpu/drm/i915/display/intel_dp.c       |  3 +++
>  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 ++
>  4 files changed, 29 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 77277d90b6e2..5313a5656598 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -3166,6 +3166,8 @@ static void dm_handle_mst_sideband_msg(struct amdgpu_dm_connector *aconnector)
>  			for (retry = 0; retry < 3; retry++) {
>  				uint8_t wret;
>  
> +				/* MSG_RDY ack is done in drm*/
> +				esi[1] &= ~(DP_DOWN_REP_MSG_RDY | DP_UP_REQ_MSG_RDY);

Why do the masking within the retry loop?

>  				wret = drm_dp_dpcd_write(
>  					&aconnector->dm_dp_aux.aux,
>  					dpcd_addr + 1,
> diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> index 51a46689cda7..02aad713c67c 100644
> --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> @@ -4054,6 +4054,9 @@ int drm_dp_mst_hpd_irq(struct drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl
>  {
>  	int ret = 0;
>  	int sc;
> +	const int tosend = 1;
> +	int retries = 0;
> +	u8 buf = 0;

All of these should be in tighter scope.

>  	*handled = false;
>  	sc = DP_GET_SINK_COUNT(esi[0]);
>  
> @@ -4072,6 +4075,25 @@ int drm_dp_mst_hpd_irq(struct drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl
>  		*handled = true;
>  	}
>  
> +	if (*handled) {

That should check for DP_DOWN_REP_MSG_RDY and DP_UP_REQ_MSG_RDY only,
right? If those are not set, we didn't do anything with them, and should
not ack.

> +		buf = esi[1] & (DP_DOWN_REP_MSG_RDY | DP_UP_REQ_MSG_RDY);
> +		do {
> +			ret = drm_dp_dpcd_write(mgr->aux,
> +						DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0,
> +						&buf,
> +						tosend);

We should probably have a helper function to do the acking, similar to
intel_dp_ack_sink_irq_esi(), which could be used both by this function
and the drivers.

> +
> +			if (ret == tosend)
> +				break;
> +
> +			retries++;
> +		} while (retries < 5);

Please don't use a do-while when a for loop is sufficient.

	for (tries = 0; tries < 5; tries++)

and it's obvious at a glance how many times at most this runs. Not so
with a do-while where you count *re-tries*. Again, would be nice to
abstract this away in a helper function.

> +
> +		if (ret != tosend)
> +			drm_dbg_kms(mgr->dev, "failed to write dpcd 0x%x\n",
> +				    DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0);
> +	}
> +
>  	drm_dp_mst_kick_tx(mgr);
>  	return ret;
>  }
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index bf80f296a8fd..abec3de38b66 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -3939,6 +3939,9 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
>  		if (!memchr_inv(ack, 0, sizeof(ack)))
>  			break;
>  
> +		/* MSG_RDY ack is done in drm*/
> +		ack[1] &= ~(DP_DOWN_REP_MSG_RDY | DP_UP_REQ_MSG_RDY);

Above we check if there's anything to ack and bail out, and now this
clears the bits but writes them anyway.

I think the handled parameter was problematic before, but now it's even
more convoluted. What does it indicate? It used to mean you need to ack
if it's set, but now it's something different. This function is getting
very difficult to use correctly.

BR,
Jani.



> +
>  		if (!intel_dp_ack_sink_irq_esi(intel_dp, ack))
>  			drm_dbg_kms(&i915->drm, "Failed to ack ESI\n");
>  	}
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> index edcb2529b402..e905987104ed 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -1336,6 +1336,8 @@ nv50_mstm_service(struct nouveau_drm *drm,
>  		if (!handled)
>  			break;
>  
> +		/* MSG_RDY ack is done in drm*/
> +		esi[1] &= ~(DP_DOWN_REP_MSG_RDY | DP_UP_REQ_MSG_RDY);
>  		rc = drm_dp_dpcd_write(aux, DP_SINK_COUNT_ESI + 1, &esi[1],
>  				       3);

Same here, this acks even if it's already been acked.

>  		if (rc != 3) {

-- 
Jani Nikula, Intel Open Source Graphics Center
