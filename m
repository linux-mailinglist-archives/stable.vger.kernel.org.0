Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B342D64EF35
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 17:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLPQeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 11:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiLPQdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 11:33:47 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBCFE2D
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 08:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671208426; x=1702744426;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=3omOzoexz7b2rPBIg3en969awPF/T7AOgbuk5SQGxBk=;
  b=hTmYRduNoQY4Ax7jXp2zwsWRs2ZE6zQq/39tKRbHOXVQXuFCKuRwf35m
   HpZkWtlEd6qGbUN1/smZpNIseeq9fZJeanoSQ2aQv28nsLk7X8ijOicPv
   6cWDvs6osQB8ezB1ii4rSNAW1i0M5bXvEU5Rzo1yTVX+6zlY/iceE9nsh
   8HeEHKrs/wey6yzS8AvzqSdtN8VMM9m3uLSbxDK1MwuezTVI1Go/ADQ/G
   X7WqaK+MrgFBC0AKwPVFAZ6HTw3fO0xj2gISWyv5P0wtaFJXHmUYb73WX
   tUlaHw/G5yDfjxJEro3dU7vS45HIUnywJ8UpKYL3gyxvF0CHnCFs19eNU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="405258208"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="405258208"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 08:33:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="643323420"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="643323420"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 08:33:44 -0800
Date:   Fri, 16 Dec 2022 18:33:40 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Lyude Paul <lyude@redhat.com>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/display/dp_mst: Fix down/up message
 handling after sink disconnect
Message-ID: <Y5yd5PvWb2fl66/s@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20221214184258.2869417-1-imre.deak@intel.com>
 <1ade43347769118c82f1b68bd8b51172a1012a37.camel@redhat.com>
 <Y5yKXXBUycSHov5g@ideak-desk.fi.intel.com>
 <875yebuy68.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yebuy68.fsf@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 16, 2022 at 06:10:39PM +0200, Jani Nikula wrote:
> On Fri, 16 Dec 2022, Imre Deak <imre.deak@intel.com> wrote:
> > On Wed, Dec 14, 2022 at 04:41:42PM -0500, Lyude Paul wrote:
> >> For the whole series:
> >> 
> >> Reviewed-by: Lyude Paul <lyude@redhat.com>
> >
> > Thanks for the review, pushed it to drm-misc-next.
> 
> Hmm, with the drm-misc *not* cherry-picking patches from drm-misc-next
> to drm-misc-fixes, these will only get backported to stable kernels
> after they hit Linus' tree in the next (as opposed to current) merge
> window after a full development cycle. Wonder if they should be
> expedited.

Ok, it should've been pushed to -fixes then, will do that next time.
Yes, I think sending them already before the next merge window would be
good.

> 
> BR,
> Jani.
> 
> >
> >> Thanks!
> >> 
> >> On Wed, 2022-12-14 at 20:42 +0200, Imre Deak wrote:
> >> > If the sink gets disconnected during receiving a multi-packet DP MST AUX
> >> > down-reply/up-request sideband message, the state keeping track of which
> >> > packets have been received already is not reset. This results in a failed
> >> > sanity check for the subsequent message packet received after a sink is
> >> > reconnected (due to the pending message not yet completed with an
> >> > end-of-message-transfer packet), indicated by the
> >> > 
> >> > "sideband msg set header failed"
> >> > 
> >> > error.
> >> > 
> >> > Fix the above by resetting the up/down message reception state after a
> >> > disconnect event.
> >> > 
> >> > Cc: Lyude Paul <lyude@redhat.com>
> >> > Cc: <stable@vger.kernel.org> # v3.17+
> >> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> >> > ---
> >> >  drivers/gpu/drm/display/drm_dp_mst_topology.c | 3 +++
> >> >  1 file changed, 3 insertions(+)
> >> > 
> >> > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> >> > index 51a46689cda70..90819fff2c9ba 100644
> >> > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> >> > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> >> > @@ -3641,6 +3641,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
> >> >  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
> >> >  		ret = 0;
> >> >  		mgr->payload_id_table_cleared = false;
> >> > +
> >> > +		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
> >> > +		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
> >> >  	}
> >> >  
> >> >  out_unlock:
> >> 
> >> -- 
> >> Cheers,
> >>  Lyude Paul (she/her)
> >>  Software Engineer at Red Hat
> >> 
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center
