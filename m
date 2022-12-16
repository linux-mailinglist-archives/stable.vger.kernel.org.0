Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AEE64EFBF
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 17:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiLPQvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 11:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiLPQus (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 11:50:48 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881476F4B7
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 08:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671209400; x=1702745400;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=icRczXlqHzD+ae5wgkamu3FNINHiBF4DVSht/FvMcyA=;
  b=OTZFtswUibzDFEIqE4a+sKfZ8U6M9gHd/4Me2yFuRrI+K2DV3XEJzfa6
   6ua+//qb0xswg3TiGa7xt90HMKR6FWbJ/Ev6agw6/btY1d0orLH8eMcLG
   11OvzH5Jd+yYVnOdEX60Saw77jp0B07cUpHIt2SOSpHcahLQIVNkUS0MF
   fBz/N/esC5iQ4uygExSp/Jh/6cLxSuwE2JaFJYSlkZlpxekc+JMsZ3Q2Q
   AWPOiDIqI6hjl+DgZE2fStYodYEPO0o/W7PUaKQVg1JnT6VGk/YTbSS3h
   jkEILtyIYuhCrZesNcNcMfIsxHF8sPq1YW16us21c44glIMARXcn9l3iM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="320178310"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="320178310"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 08:50:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="895294387"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="895294387"
Received: from fbielich-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.62.38])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 08:49:57 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     imre.deak@intel.com
Cc:     Lyude Paul <lyude@redhat.com>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/display/dp_mst: Fix down/up message
 handling after sink disconnect
In-Reply-To: <Y5yd5PvWb2fl66/s@ideak-desk.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221214184258.2869417-1-imre.deak@intel.com>
 <1ade43347769118c82f1b68bd8b51172a1012a37.camel@redhat.com>
 <Y5yKXXBUycSHov5g@ideak-desk.fi.intel.com> <875yebuy68.fsf@intel.com>
 <Y5yd5PvWb2fl66/s@ideak-desk.fi.intel.com>
Date:   Fri, 16 Dec 2022 18:49:54 +0200
Message-ID: <87zgbnthsd.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Dec 2022, Imre Deak <imre.deak@intel.com> wrote:
> On Fri, Dec 16, 2022 at 06:10:39PM +0200, Jani Nikula wrote:
>> On Fri, 16 Dec 2022, Imre Deak <imre.deak@intel.com> wrote:
>> > On Wed, Dec 14, 2022 at 04:41:42PM -0500, Lyude Paul wrote:
>> >> For the whole series:
>> >> 
>> >> Reviewed-by: Lyude Paul <lyude@redhat.com>
>> >
>> > Thanks for the review, pushed it to drm-misc-next.
>> 
>> Hmm, with the drm-misc *not* cherry-picking patches from drm-misc-next
>> to drm-misc-fixes, these will only get backported to stable kernels
>> after they hit Linus' tree in the next (as opposed to current) merge
>> window after a full development cycle. Wonder if they should be
>> expedited.
>
> Ok, it should've been pushed to -fixes then, will do that next time.
> Yes, I think sending them already before the next merge window would be
> good.

Cc: drm-misc maintainers, I think this is for you to figure out.

BR,
Jani.


>
>> 
>> BR,
>> Jani.
>> 
>> >
>> >> Thanks!
>> >> 
>> >> On Wed, 2022-12-14 at 20:42 +0200, Imre Deak wrote:
>> >> > If the sink gets disconnected during receiving a multi-packet DP MST AUX
>> >> > down-reply/up-request sideband message, the state keeping track of which
>> >> > packets have been received already is not reset. This results in a failed
>> >> > sanity check for the subsequent message packet received after a sink is
>> >> > reconnected (due to the pending message not yet completed with an
>> >> > end-of-message-transfer packet), indicated by the
>> >> > 
>> >> > "sideband msg set header failed"
>> >> > 
>> >> > error.
>> >> > 
>> >> > Fix the above by resetting the up/down message reception state after a
>> >> > disconnect event.
>> >> > 
>> >> > Cc: Lyude Paul <lyude@redhat.com>
>> >> > Cc: <stable@vger.kernel.org> # v3.17+
>> >> > Signed-off-by: Imre Deak <imre.deak@intel.com>
>> >> > ---
>> >> >  drivers/gpu/drm/display/drm_dp_mst_topology.c | 3 +++
>> >> >  1 file changed, 3 insertions(+)
>> >> > 
>> >> > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> >> > index 51a46689cda70..90819fff2c9ba 100644
>> >> > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> >> > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
>> >> > @@ -3641,6 +3641,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
>> >> >  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
>> >> >  		ret = 0;
>> >> >  		mgr->payload_id_table_cleared = false;
>> >> > +
>> >> > +		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
>> >> > +		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
>> >> >  	}
>> >> >  
>> >> >  out_unlock:
>> >> 
>> >> -- 
>> >> Cheers,
>> >>  Lyude Paul (she/her)
>> >>  Software Engineer at Red Hat
>> >> 
>> 
>> -- 
>> Jani Nikula, Intel Open Source Graphics Center

-- 
Jani Nikula, Intel Open Source Graphics Center
