Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701B82FBC03
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 17:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391216AbhASQKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 11:10:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:36115 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730806AbhASPwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 10:52:46 -0500
IronPort-SDR: bEcqN7VMan0nEMhTFsjnIgDhSgu5Wn+dDCs52jyf0Diorn00Il29nkBC5QZ+CQ8sMf82idwPkY
 mzHhMNou8kpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="166037214"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="166037214"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 07:50:47 -0800
IronPort-SDR: QcFo4LTPse8p65jCI8icg2cawYnEk2WuYQDw7YoWRjgZBd2Vxl0ZkS2skRF+nxz19/qEY1j5X1
 hbUSo2wp7itw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="383982855"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga008.jf.intel.com with SMTP; 19 Jan 2021 07:50:43 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 19 Jan 2021 17:50:42 +0200
Date:   Tue, 19 Jan 2021 17:50:42 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     nouveau@lists.freedesktop.org,
        "open list:DRM DRIVER FOR NVIDIA GEFORCE/QUADRO GPUS" 
        <dri-devel@lists.freedesktop.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        James Jones <jajones@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.aiemd@gmail.com>
Subject: Re: [PATCH 1/3] drivers/nouveau/kms/nv50-: Reject format modifiers
 for cursor planes
Message-ID: <YAb/0urUmEg5kd3C@intel.com>
References: <20210119015415.2511028-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210119015415.2511028-1-lyude@redhat.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 08:54:12PM -0500, Lyude Paul wrote:
> Nvidia hardware doesn't actually support using tiling formats with the
> cursor plane, only linear is allowed. In the future, we should write a
> testcase for this.

There are a couple of old modifier/format sanity tests here:
https://patchwork.freedesktop.org/series/46876/

Couple of things missing that now came to my mind:
- test setplane/etc. rejects unsupported formats/modifiers even if
  addfb allowed them, exactly for the case where only a subset of
  planes support something
- validate the IN_FORMATS blob harder, eg. make sure each modifier
  listed there supports at least one format. IIRC this was busted on
  a few drivers last year, dunno if they got fixed or not. Hmm,
  actually since this is now using the pre-parsed stuff I guess we
  should just stick an assert into igt_fill_plane_format_mod() where
  the blob gets parsed

> 
> Fixes: c586f30bf74c ("drm/nouveau/kms: Add format mod prop to base/ovly/nvdisp")
> Cc: James Jones <jajones@nvidia.com>
> Cc: Martin Peres <martin.peres@free.fr>
> Cc: Jeremy Cline <jcline@redhat.com>
> Cc: Simon Ser <contact@emersion.fr>
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/dispnv50/wndw.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/wndw.c b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
> index ce451242f79e..271de3a63f21 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
> @@ -702,6 +702,11 @@ nv50_wndw_init(struct nv50_wndw *wndw)
>  	nvif_notify_get(&wndw->notify);
>  }
>  
> +static const u64 nv50_cursor_format_modifiers[] = {
> +	DRM_FORMAT_MOD_LINEAR,
> +	DRM_FORMAT_MOD_INVALID,
> +};
> +
>  int
>  nv50_wndw_new_(const struct nv50_wndw_func *func, struct drm_device *dev,
>  	       enum drm_plane_type type, const char *name, int index,
> @@ -713,6 +718,7 @@ nv50_wndw_new_(const struct nv50_wndw_func *func, struct drm_device *dev,
>  	struct nvif_mmu *mmu = &drm->client.mmu;
>  	struct nv50_disp *disp = nv50_disp(dev);
>  	struct nv50_wndw *wndw;
> +	const u64 *format_modifiers;
>  	int nformat;
>  	int ret;
>  
> @@ -728,10 +734,13 @@ nv50_wndw_new_(const struct nv50_wndw_func *func, struct drm_device *dev,
>  
>  	for (nformat = 0; format[nformat]; nformat++);
>  
> -	ret = drm_universal_plane_init(dev, &wndw->plane, heads, &nv50_wndw,
> -				       format, nformat,
> -				       nouveau_display(dev)->format_modifiers,
> -				       type, "%s-%d", name, index);
> +	if (type == DRM_PLANE_TYPE_CURSOR)
> +		format_modifiers = nv50_cursor_format_modifiers;
> +	else
> +		format_modifiers = nouveau_display(dev)->format_modifiers;
> +
> +	ret = drm_universal_plane_init(dev, &wndw->plane, heads, &nv50_wndw, format, nformat,
> +				       format_modifiers, type, "%s-%d", name, index);
>  	if (ret) {
>  		kfree(*pwndw);
>  		*pwndw = NULL;
> -- 
> 2.29.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel
