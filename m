Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2192E6E609B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjDRMHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjDRMGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:06:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F72CCC0B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 04:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681819130; x=1713355130;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=sbRKIWy0GnJpNVvWh6yMP4GlCOmxyz+sNtBNIXt/lZM=;
  b=e8e+UOMjNk6bMSS7MwVYj9vjW5iKt4QZ4aAd0632+vo6Sh9vO46XE20g
   3Wu7fFYNf/NuWDD0x6WuYJfjiC0Xh9KCHomBsCHrnv2AOS57VUq37Qd9z
   UuWo66/ZB22IoiCskQEqkYfQ/Fi1qQvY4L5U81R/n8exp4Q4MPkS4Vlfa
   M+PHPhBK06lmQmjd0JkMQB6EfPkX+gtQ1beNOsWeeltiUcNuLs/30Q4HJ
   xuaDGqLAiXU3hjV1wSzJ3LshwE9imzTg651xstahZInORTSWm36EcT9l7
   1HjjUHVfXkMp8ierjKoz5wUnRrC78KAkzzCcT5o6rI+T2L/qHczIny1lM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="333952076"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="333952076"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 04:58:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="815179434"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="815179434"
Received: from amrabet-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.119])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 04:58:46 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
Cc:     "lyude@redhat.com" <lyude@redhat.com>,
        "imre.deak@intel.com" <imre.deak@intel.com>,
        "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new message
In-Reply-To: <CO6PR12MB5489C9667D84E0207BD6C14DFC9D9@CO6PR12MB5489.namprd12.prod.outlook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230418060905.4078976-1-Wayne.Lin@amd.com>
 <87mt351sin.fsf@intel.com>
 <CO6PR12MB5489C9667D84E0207BD6C14DFC9D9@CO6PR12MB5489.namprd12.prod.outlook.com>
Date:   Tue, 18 Apr 2023 14:58:42 +0300
Message-ID: <87edoh1jwt.fsf@intel.com>
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

On Tue, 18 Apr 2023, "Lin, Wayne" <Wayne.Lin@amd.com> wrote:
> [Public]
>
> Hi Jani Nikula,
>
> Appreciate your time and feedback! Will adjust the patch.
> Some comments inline.
>
>> -----Original Message-----
>> From: Jani Nikula <jani.nikula@intel.com>
>> Sent: Tuesday, April 18, 2023 4:53 PM
>> To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org;
>> amd-gfx@lists.freedesktop.org
>> Cc: lyude@redhat.com; imre.deak@intel.com; ville.syrjala@linux.intel.com;
>> Wentland, Harry <Harry.Wentland@amd.com>; Zuo, Jerry
>> <Jerry.Zuo@amd.com>; Lin, Wayne <Wayne.Lin@amd.com>;
>> stable@vger.kernel.org
>> Subject: Re: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new
>> message
>> 
>> On Tue, 18 Apr 2023, Wayne Lin <Wayne.Lin@amd.com> wrote:
>> > [Why & How]
>> > The sequence for collecting down_reply/up_request from source
>> > perspective should be:
>> >
>> > Request_n->repeat (get partial reply of Request_n->clear message ready
>> > flag to ack DPRX that the message is received) till all partial
>> > replies for Request_n are received->new Request_n+1.
>> >
>> > While assembling partial reply packets, reading out DPCD DOWN_REP
>> > Sideband MSG buffer + clearing DOWN_REP_MSG_RDY flag should be
>> wrapped
>> > up as a complete operation for reading out a reply packet.
>> > Kicking off a new request before clearing DOWN_REP_MSG_RDY flag might
>> > be risky. e.g. If the reply of the new request has overwritten the
>> > DPRX DOWN_REP Sideband MSG buffer before source writing ack to clear
>> > DOWN_REP_MSG_RDY flag, source then unintentionally flushes the reply
>> > for the new request. Should handle the up request in the same way.
>> >
>> > In drm_dp_mst_hpd_irq(), we don't clear MSG_RDY flag before caliing
>> > drm_dp_mst_kick_tx(). Fix that.
>> >
>> > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
>> > Cc: stable@vger.kernel.org
>> > ---
>> >  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 ++
>> > drivers/gpu/drm/display/drm_dp_mst_topology.c | 22
>> +++++++++++++++++++
>> >  drivers/gpu/drm/i915/display/intel_dp.c       |  3 +++
>> >  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 ++
>> >  4 files changed, 29 insertions(+)
>> >
>> > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> > b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> > index 77277d90b6e2..5313a5656598 100644
>> > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> > @@ -3166,6 +3166,8 @@ static void dm_handle_mst_sideband_msg(struct
>> amdgpu_dm_connector *aconnector)
>> >  			for (retry = 0; retry < 3; retry++) {
>> >  				uint8_t wret;
>> >
>> > +				/* MSG_RDY ack is done in drm*/
>> > +				esi[1] &= ~(DP_DOWN_REP_MSG_RDY |
>> DP_UP_REQ_MSG_RDY);
>> 
>> Why do the masking within the retry loop?
>> 
>> >  				wret = drm_dp_dpcd_write(
>> >  					&aconnector->dm_dp_aux.aux,
>> >  					dpcd_addr + 1,
>> > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> > b/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> > index 51a46689cda7..02aad713c67c 100644
>> > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> > @@ -4054,6 +4054,9 @@ int drm_dp_mst_hpd_irq(struct
>> > drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl  {
>> >  	int ret = 0;
>> >  	int sc;
>> > +	const int tosend = 1;
>> > +	int retries = 0;
>> > +	u8 buf = 0;
>> 
>> All of these should be in tighter scope.
>> 
>> >  	*handled = false;
>> >  	sc = DP_GET_SINK_COUNT(esi[0]);
>> >
>> > @@ -4072,6 +4075,25 @@ int drm_dp_mst_hpd_irq(struct
>> drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl
>> >  		*handled = true;
>> >  	}
>> >
>> > +	if (*handled) {
>> 
>> That should check for DP_DOWN_REP_MSG_RDY and
>> DP_UP_REQ_MSG_RDY only, right? If those are not set, we didn't do
>> anything with them, and should not ack.
>
> Right. I was thinking the sink count change will accompany the CSN
> up request message. I'll change it to be more clear. Thanks.
>> 
>> > +		buf = esi[1] & (DP_DOWN_REP_MSG_RDY |
>> DP_UP_REQ_MSG_RDY);
>> > +		do {
>> > +			ret = drm_dp_dpcd_write(mgr->aux,
>> > +
>> 	DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0,
>> > +						&buf,
>> > +						tosend);
>> 
>> We should probably have a helper function to do the acking, similar to
>> intel_dp_ack_sink_irq_esi(), which could be used both by this function and
>> the drivers.
>> 
>> > +
>> > +			if (ret == tosend)
>> > +				break;
>> > +
>> > +			retries++;
>> > +		} while (retries < 5);
>> 
>> Please don't use a do-while when a for loop is sufficient.
>> 
>> 	for (tries = 0; tries < 5; tries++)
>> 
>> and it's obvious at a glance how many times at most this runs. Not so with a
>> do-while where you count *re-tries*. Again, would be nice to abstract this
>> away in a helper function.
>> 
>> > +
>> > +		if (ret != tosend)
>> > +			drm_dbg_kms(mgr->dev, "failed to write dpcd
>> 0x%x\n",
>> > +				    DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0);
>> > +	}
>> > +
>> >  	drm_dp_mst_kick_tx(mgr);
>> >  	return ret;
>> >  }
>> > diff --git a/drivers/gpu/drm/i915/display/intel_dp.c
>> > b/drivers/gpu/drm/i915/display/intel_dp.c
>> > index bf80f296a8fd..abec3de38b66 100644
>> > --- a/drivers/gpu/drm/i915/display/intel_dp.c
>> > +++ b/drivers/gpu/drm/i915/display/intel_dp.c
>> > @@ -3939,6 +3939,9 @@ intel_dp_check_mst_status(struct intel_dp
>> *intel_dp)
>> >  		if (!memchr_inv(ack, 0, sizeof(ack)))
>> >  			break;
>> >
>> > +		/* MSG_RDY ack is done in drm*/
>> > +		ack[1] &= ~(DP_DOWN_REP_MSG_RDY |
>> DP_UP_REQ_MSG_RDY);
>> 
>> Above we check if there's anything to ack and bail out, and now this clears
>> the bits but writes them anyway.
>> 
>> I think the handled parameter was problematic before, but now it's even
>> more convoluted. What does it indicate? It used to mean you need to ack if
>> it's set, but now it's something different. This function is getting very difficult
>> to use correctly.
>
> My plan was to ack message events within drm_dp_mst_hpd_irq() since the
> events are handled there. There are still CP_IRQ and LINK_STATUS_CHANGED
> events above get handled in intel_dp_check_mst_status(), so I intended to
> mask DP_DOWN_REP_MSG_RDY/DP_UP_REQ_MSG_RDY, and ack
> CP_IRQ/LINK_STATUS_CHANGED here.

I get it, but if DP_DOWN_REP_MSG_RDY or DP_UP_REQ_MSG_RDY were the only
events to ack, and they were already acked in drm_dp_mst_hpd_irq(), we
should not do an extra "nop" ack.

The caller of drm_dp_mst_hpd_irq() needs to be able to conveniently
figure out what to ack, and what to not ack. And without duplicating the
logic within drm_dp_mst_hpd_irq().

BR,
Jani.



>> 
>> BR,
>> Jani.
>> 
>> 
>> 
>> > +
>> >  		if (!intel_dp_ack_sink_irq_esi(intel_dp, ack))
>> >  			drm_dbg_kms(&i915->drm, "Failed to ack ESI\n");
>> >  	}
>> > diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c
>> > b/drivers/gpu/drm/nouveau/dispnv50/disp.c
>> > index edcb2529b402..e905987104ed 100644
>> > --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
>> > +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
>> > @@ -1336,6 +1336,8 @@ nv50_mstm_service(struct nouveau_drm *drm,
>> >  		if (!handled)
>> >  			break;
>> >
>> > +		/* MSG_RDY ack is done in drm*/
>> > +		esi[1] &= ~(DP_DOWN_REP_MSG_RDY |
>> DP_UP_REQ_MSG_RDY);
>> >  		rc = drm_dp_dpcd_write(aux, DP_SINK_COUNT_ESI + 1,
>> &esi[1],
>> >  				       3);
>> 
>> Same here, this acks even if it's already been acked.
>> 
>> >  		if (rc != 3) {
>> 
>> --
>> Jani Nikula, Intel Open Source Graphics Center
>
> --
> Regards,
> Wayne Lin

-- 
Jani Nikula, Intel Open Source Graphics Center
