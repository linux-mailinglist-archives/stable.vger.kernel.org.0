Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600C364ED9C
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 16:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiLPPKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 10:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiLPPKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 10:10:34 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949EFE6
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 07:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671203432; x=1702739432;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=emGcT4Xnk63cWO9TnSa5/SLFBAjCaEY6T+Xm7GwkSSw=;
  b=jrsog9Tw0OBPS8VqgwZ2g1s+E/ihYyO4a4FmxVrJQKyz81HGvv0iE1WB
   9MT9f7h5TOLUkICLXaGFnzm/vn3KLGA1Brv6T9vjpU8gZnx4CD7rqT63v
   VdOveBEM+Qq0YBwcEabT7FLW7D4ED+Lk8heMO2ueSApXAFWzXHkrerU6u
   EYpCc3jaQoA3zH0MaSqRwJEYp9JtTaSXpnrTh/qgeRFiPfByDUoBh2yxT
   9izd1lIf4FEyXcH2KLJbe9NlvqYk79ZaQvzixfFXZSlQzxgVcVAmdMXvu
   r4TcMKqjHFaHVgEpk2L486HtlZ5fm/AHNoVWd0sLUatdgCKHE085ZIQXw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="381204850"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="381204850"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 07:10:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="713278668"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="713278668"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 07:10:24 -0800
Date:   Fri, 16 Dec 2022 17:10:21 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] drm/display/dp_mst: Fix down/up message handling
 after sink disconnect
Message-ID: <Y5yKXXBUycSHov5g@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20221214184258.2869417-1-imre.deak@intel.com>
 <1ade43347769118c82f1b68bd8b51172a1012a37.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ade43347769118c82f1b68bd8b51172a1012a37.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 14, 2022 at 04:41:42PM -0500, Lyude Paul wrote:
> For the whole series:
> 
> Reviewed-by: Lyude Paul <lyude@redhat.com>

Thanks for the review, pushed it to drm-misc-next.

> Thanks!
> 
> On Wed, 2022-12-14 at 20:42 +0200, Imre Deak wrote:
> > If the sink gets disconnected during receiving a multi-packet DP MST AUX
> > down-reply/up-request sideband message, the state keeping track of which
> > packets have been received already is not reset. This results in a failed
> > sanity check for the subsequent message packet received after a sink is
> > reconnected (due to the pending message not yet completed with an
> > end-of-message-transfer packet), indicated by the
> > 
> > "sideband msg set header failed"
> > 
> > error.
> > 
> > Fix the above by resetting the up/down message reception state after a
> > disconnect event.
> > 
> > Cc: Lyude Paul <lyude@redhat.com>
> > Cc: <stable@vger.kernel.org> # v3.17+
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  drivers/gpu/drm/display/drm_dp_mst_topology.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > index 51a46689cda70..90819fff2c9ba 100644
> > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > @@ -3641,6 +3641,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
> >  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
> >  		ret = 0;
> >  		mgr->payload_id_table_cleared = false;
> > +
> > +		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
> > +		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
> >  	}
> >  
> >  out_unlock:
> 
> -- 
> Cheers,
>  Lyude Paul (she/her)
>  Software Engineer at Red Hat
> 
