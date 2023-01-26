Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF9467D667
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 21:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjAZU2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 15:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjAZU2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 15:28:18 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE70241EA
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 12:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674764896; x=1706300896;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=/pvcG2BnTUdUdPvGkurmDGk6N0a1zJT0BaRf56t8Zeo=;
  b=iG2NBN15khGM7ECFiWjd0Kexs1zWNBcvEHiMZTwaQ11kLUGQNdh9PmdW
   5Bj36FhGk2EjhgAYnhVwj2D8tfJWqnuQ+a8vTpJUdZypJP9j5Kyt178+Q
   4tHh7G0UB7TXsBjm9SXDOpEqwPV5ZKYgwO1StgSvluowUDC4Zi7+8ODxZ
   0K4PLJ7eq68TW2z8B35P+zs5HIXu9cDpHi31uHhOY1VB807+0a7Bi75vx
   ppKUb0hecReu8Pf6wINdi7/M6QZE9XXH921mz0Aqk0Eixxpl+WBzNs7PT
   CcEtXPqLF++YP1tjpq4Omw7a/vJtDLkbWs4PGqhIj+GthXeuyojJCjcLA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="307284684"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="307284684"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 12:28:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="771289036"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="771289036"
Received: from ideak-desk.fi.intel.com ([10.237.72.58])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 12:28:12 -0800
Date:   Thu, 26 Jan 2023 22:28:09 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/9] drm/display/dp_mst: Add
 drm_atomic_get_old_mst_topology_state()
Message-ID: <Y9LiWf0pj5IcNm2p@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20230125114852.748337-1-imre.deak@intel.com>
 <20230125114852.748337-4-imre.deak@intel.com>
 <Y9LIJE85qySKUODU@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9LIJE85qySKUODU@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 08:36:20PM +0200, Ville Syrjälä wrote:
> On Wed, Jan 25, 2023 at 01:48:46PM +0200, Imre Deak wrote:
> > Add a function to get the old MST topology state, required by a
> > follow-up i915 patch.
> > 
> > While at it clarify the code comment of
> > drm_atomic_get_new_mst_topology_state().
> > 
> > Cc: Lyude Paul <lyude@redhat.com>
> > Cc: stable@vger.kernel.org # 6.1
> > Cc: dri-devel@lists.freedesktop.org
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  drivers/gpu/drm/display/drm_dp_mst_topology.c | 29 +++++++++++++++++--
> >  include/drm/display/drm_dp_mst_helper.h       |  3 ++
> >  2 files changed, 30 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > index ebf6e31e156e0..81cc0c3b1e000 100644
> > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > @@ -5362,18 +5362,43 @@ struct drm_dp_mst_topology_state *drm_atomic_get_mst_topology_state(struct drm_a
> >  }
> >  EXPORT_SYMBOL(drm_atomic_get_mst_topology_state);
> >  
> > +/**
> > + * drm_atomic_get_old_mst_topology_state: get old MST topology state in atomic state, if any
> > + * @state: global atomic state
> > + * @mgr: MST topology manager, also the private object in this case
> > + *
> > + * This function wraps drm_atomic_get_old_private_obj_state() passing in the MST atomic
> > + * state vtable so that the private object state returned is that of a MST
> > + * topology object.
> > + *
> > + * Returns:
> > + *
> > + * The old MST topology state, or NULL if there's no topology state for this MST mgr
> > + * in the global atomic state
> > + */
> > +struct drm_dp_mst_topology_state *
> > +drm_atomic_get_old_mst_topology_state(struct drm_atomic_state *state,
> > +				      struct drm_dp_mst_topology_mgr *mgr)
> > +{
> > +	struct drm_private_state *priv_state =
> 
> I would include 'old_' in the variable name to remind the reader what it
> is.

Ok, will change it.

> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> > +		drm_atomic_get_old_private_obj_state(state, &mgr->base);
> > +
> > +	return priv_state ? to_dp_mst_topology_state(priv_state) : NULL;
> > +}
> > +EXPORT_SYMBOL(drm_atomic_get_old_mst_topology_state);
> > +
> >  /**
> >   * drm_atomic_get_new_mst_topology_state: get new MST topology state in atomic state, if any
> >   * @state: global atomic state
> >   * @mgr: MST topology manager, also the private object in this case
> >   *
> > - * This function wraps drm_atomic_get_priv_obj_state() passing in the MST atomic
> > + * This function wraps drm_atomic_get_new_private_obj_state() passing in the MST atomic
> >   * state vtable so that the private object state returned is that of a MST
> >   * topology object.
> >   *
> >   * Returns:
> >   *
> > - * The MST topology state, or NULL if there's no topology state for this MST mgr
> > + * The new MST topology state, or NULL if there's no topology state for this MST mgr
> >   * in the global atomic state
> >   */
> >  struct drm_dp_mst_topology_state *
> > diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
> > index f5eb9aa152b14..32c764fb9cb56 100644
> > --- a/include/drm/display/drm_dp_mst_helper.h
> > +++ b/include/drm/display/drm_dp_mst_helper.h
> > @@ -868,6 +868,9 @@ struct drm_dp_mst_topology_state *
> >  drm_atomic_get_mst_topology_state(struct drm_atomic_state *state,
> >  				  struct drm_dp_mst_topology_mgr *mgr);
> >  struct drm_dp_mst_topology_state *
> > +drm_atomic_get_old_mst_topology_state(struct drm_atomic_state *state,
> > +				      struct drm_dp_mst_topology_mgr *mgr);
> > +struct drm_dp_mst_topology_state *
> >  drm_atomic_get_new_mst_topology_state(struct drm_atomic_state *state,
> >  				      struct drm_dp_mst_topology_mgr *mgr);
> >  struct drm_dp_mst_atomic_payload *
> > -- 
> > 2.37.1
> 
> -- 
> Ville Syrjälä
> Intel
