Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5182553BFFE
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 22:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbiFBUmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 16:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237619AbiFBUmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 16:42:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D3339B;
        Thu,  2 Jun 2022 13:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654202528; x=1685738528;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Sok3m5diANN7wooonIOw/1EsMvSV7BlM/zWiPdcGKEg=;
  b=FqDNb9xaRKNP5v8k/PK81gpwvvqck16TYWih0EqXMeFlIU3sJaoFY6Wy
   frn+8/hdWNk7tdXKse2MhXLGM0mW9qnHFcV4UkTHXXxQk7cn+5S3CLY0I
   yCHLLFH8VSSs8ipUIo5zO4NFdjxS9ljRh3BYoHqICJkLIqI2ziftBVTWH
   juxNMg0Pu8RMI/9/VMEjXyaBeURSQFKVE6UHZmlGTtXiyq4fAK9zVdrL/
   ldtL+uvJ0ojuGuDI2IccZZTAHbh5+Oy1lV6MMlm8YolMgQtATZ/ueIC5h
   5hg6l8GGcULP/kPZtIslrPHejn15u5Qe4AGgflNSR1rQDcwRdwA/TrHra
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10366"; a="339122134"
X-IronPort-AV: E=Sophos;i="5.91,272,1647327600"; 
   d="scan'208";a="339122134"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 13:42:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,272,1647327600"; 
   d="scan'208";a="607038074"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.163])
  by orsmga008.jf.intel.com with SMTP; 02 Jun 2022 13:42:03 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 02 Jun 2022 23:42:02 +0300
Date:   Thu, 2 Jun 2022 23:42:02 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Imran Khan <imran.f.khan@oracle.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] drm/display/dp_mst: Fix
 drm_atomic_get_mst_topology_state()
Message-ID: <YpkgmvBeX6L7Bs5y@intel.com>
References: <20220602201757.30431-1-lyude@redhat.com>
 <20220602201757.30431-3-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220602201757.30431-3-lyude@redhat.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 02, 2022 at 04:17:56PM -0400, Lyude Paul wrote:
> I noticed a rather surprising issue here while working on removing all of
> the non-atomic MST code: drm_atomic_get_mst_topology_state() doesn't check
> the return value of drm_atomic_get_private_obj_state() and instead just
> passes it directly to to_dp_mst_topology_state(). This means that if we
> hit a deadlock or something else which would return an error code pointer,
> we'll likely segfault the kernel.
> 
> This is definitely another one of those fixes where I'm astonished we
> somehow managed never to discover this issue until now…

It has been discussed before.

struct drm_dp_mst_topology_state {
	struct drm_private_state base;
	...
}

so offsetof(base)==0.

> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: a4370c777406 ("drm/atomic: Make private objs proper objects")
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v4.14+
> ---
>  drivers/gpu/drm/display/drm_dp_mst_topology.c | 2 +-
>  include/drm/display/drm_dp_mst_helper.h       | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> index d84673b3294b..d6e595b95f07 100644
> --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> @@ -5468,7 +5468,7 @@ EXPORT_SYMBOL(drm_dp_mst_topology_state_funcs);
>  struct drm_dp_mst_topology_state *drm_atomic_get_mst_topology_state(struct drm_atomic_state *state,
>  								    struct drm_dp_mst_topology_mgr *mgr)
>  {
> -	return to_dp_mst_topology_state(drm_atomic_get_private_obj_state(state, &mgr->base));
> +	return to_dp_mst_topology_state_safe(drm_atomic_get_private_obj_state(state, &mgr->base));
>  }
>  EXPORT_SYMBOL(drm_atomic_get_mst_topology_state);
>  
> diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
> index 10adec068b7f..fe7577e7f305 100644
> --- a/include/drm/display/drm_dp_mst_helper.h
> +++ b/include/drm/display/drm_dp_mst_helper.h
> @@ -541,6 +541,8 @@ struct drm_dp_payload {
>  };
>  
>  #define to_dp_mst_topology_state(x) container_of(x, struct drm_dp_mst_topology_state, base)
> +#define to_dp_mst_topology_state_safe(x) \
> +	container_of_safe(x, struct drm_dp_mst_topology_state, base)

Wasn't aware of container_of_safe(). I suppose no real harm 
in using it. Not sure why we'd even keep the non-safe version
around?

Though the use of container_of_safe() everywhere won't help
when "casting" the other way (&foo->base, when foo==NULL/errptr).
In order to make that work for non-zero offsets we'd have to
introduce a casting macro for that direction as well.

>  
>  struct drm_dp_vcpi_allocation {
>  	struct drm_dp_mst_port *port;
> -- 
> 2.35.3

-- 
Ville Syrjälä
Intel
