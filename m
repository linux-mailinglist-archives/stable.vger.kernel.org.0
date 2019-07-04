Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502EE5F40C
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 09:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfGDHqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 03:46:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:42702 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbfGDHqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 03:46:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 00:46:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="asc'?scan'208";a="191299870"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jul 2019 00:46:29 -0700
Date:   Thu, 4 Jul 2019 15:43:51 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Colin Xu <colin.xu@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915/gvt: Adding ppgtt to GVT GEM context after
 pin.
Message-ID: <20190704074351.GV9684@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190704070613.31609-1-colin.xu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YtYWfCPO8ILWk+jM"
Content-Disposition: inline
In-Reply-To: <20190704070613.31609-1-colin.xu@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YtYWfCPO8ILWk+jM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.07.04 15:06:13 +0800, Colin Xu wrote:
> Windows guest can't run after force-TDR with host log:
> ...
> gvt: vgpu 1: workload shadow ppgtt isn't ready
> gvt: vgpu 1: fail to dispatch workload, skip
> ...
>=20
> The error is raised by set_context_ppgtt_from_shadow(), when it checks
> and found the shadow_mm isn't marked as shadowed.
>=20
> In work thread before each submission, a shadow_mm is set to shadowed in:
> shadow_ppgtt_mm()
> <-intel_vgpu_pin_mm()
> <-prepare_workload()
> <-dispatch_workload()
> <-workload_thread()
> However checking whether or not shadow_mm is shadowed is prior to it:
> set_context_ppgtt_from_shadow()
> <-dispatch_workload()
> <-workload_thread()
>=20
> In normal case, create workload will check the existence of shadow_mm,
> if not it will create a new one and marked as shadowed. If already exist
> it will reuse the old one. Since shadow_mm is reused, checking of shadowed
> in set_context_ppgtt_from_shadow() actually always see the state set in
> creation, but not the state set in intel_vgpu_pin_mm().
>=20
> When force-TDR, all engines are reset, since it's not dmlr level, all
> ppgtt_mm are invalidated but not destroyed. Invalidation will mark all
> reused shadow_mm as not shadowed but still keeps in ppgtt_mm_list_head.
> If workload submission phase those shadow_mm are reused with shadowed
> not set, then set_context_ppgtt_from_shadow() will report error.
>=20
> Fixes: 4f15665ccbba (drm/i915: Add ppgtt to GVT GEM context)
>=20
> v2:
> Move set_context_ppgtt_from_shadow() after prepare_workload(). (zhenyu)
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Colin Xu <colin.xu@intel.com>
> ---
>  drivers/gpu/drm/i915/gvt/scheduler.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/=
gvt/scheduler.c
> index 196b4155a309..100040209188 100644
> --- a/drivers/gpu/drm/i915/gvt/scheduler.c
> +++ b/drivers/gpu/drm/i915/gvt/scheduler.c
> @@ -685,13 +685,6 @@ static int dispatch_workload(struct intel_vgpu_workl=
oad *workload)
>  	mutex_lock(&vgpu->vgpu_lock);
>  	mutex_lock(&dev_priv->drm.struct_mutex);
> =20
> -	ret =3D set_context_ppgtt_from_shadow(workload,
> -					    s->shadow[ring_id]->gem_context);
> -	if (ret < 0) {
> -		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
> -		goto err_req;
> -	}
> -
>  	ret =3D intel_gvt_workload_req_alloc(workload);
>  	if (ret)
>  		goto err_req;
> @@ -707,6 +700,13 @@ static int dispatch_workload(struct intel_vgpu_workl=
oad *workload)
>  	}
> =20
>  	ret =3D prepare_workload(workload);
> +	if (ret)
> +		goto out;
> +
> +	ret =3D set_context_ppgtt_from_shadow(workload,
> +					    s->shadow[ring_id]->gem_context);
> +	if (ret)
> +		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");

As workload's shadow_mm should always be for ppgtt, so we don't need return
for set_context_ppgtt_from_shadow, can just be void. Then how about do that
in prepare_workload after we settle down shadow pdp?

>  out:
>  	if (ret) {
>  		/* We might still need to add request with
> --=20
> 2.22.0
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--YtYWfCPO8ILWk+jM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXR2uNgAKCRCxBBozTXgY
JzznAKCNlpcuWmr68bARFGCHfO3XNV+7XwCeLzBZctiBxA8M1FtthyBDwbmfeCs=
=coQO
-----END PGP SIGNATURE-----

--YtYWfCPO8ILWk+jM--
