Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C92B5F440
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 10:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfGDIF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 04:05:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:34391 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfGDIF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 04:05:59 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 01:05:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="asc'?scan'208";a="315803222"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga004.jf.intel.com with ESMTP; 04 Jul 2019 01:05:57 -0700
Date:   Thu, 4 Jul 2019 16:03:19 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Colin Xu <Colin.Xu@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915/gvt: Adding ppgtt to GVT GEM context after
 pin.
Message-ID: <20190704080318.GW9684@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190704070613.31609-1-colin.xu@intel.com>
 <20190704074351.GV9684@zhen-hp.sh.intel.com>
 <4d2595be-6614-0f33-0cbf-a7341cf94906@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ga6FVKWZzVeX7g0Z"
Content-Disposition: inline
In-Reply-To: <4d2595be-6614-0f33-0cbf-a7341cf94906@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ga6FVKWZzVeX7g0Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.07.04 16:00:55 +0800, Colin Xu wrote:
>=20
> On 2019-07-04 15:43, Zhenyu Wang wrote:
> > On 2019.07.04 15:06:13 +0800, Colin Xu wrote:
> > > Windows guest can't run after force-TDR with host log:
> > > ...
> > > gvt: vgpu 1: workload shadow ppgtt isn't ready
> > > gvt: vgpu 1: fail to dispatch workload, skip
> > > ...
> > >=20
> > > The error is raised by set_context_ppgtt_from_shadow(), when it checks
> > > and found the shadow_mm isn't marked as shadowed.
> > >=20
> > > In work thread before each submission, a shadow_mm is set to shadowed=
 in:
> > > shadow_ppgtt_mm()
> > > <-intel_vgpu_pin_mm()
> > > <-prepare_workload()
> > > <-dispatch_workload()
> > > <-workload_thread()
> > > However checking whether or not shadow_mm is shadowed is prior to it:
> > > set_context_ppgtt_from_shadow()
> > > <-dispatch_workload()
> > > <-workload_thread()
> > >=20
> > > In normal case, create workload will check the existence of shadow_mm,
> > > if not it will create a new one and marked as shadowed. If already ex=
ist
> > > it will reuse the old one. Since shadow_mm is reused, checking of sha=
dowed
> > > in set_context_ppgtt_from_shadow() actually always see the state set =
in
> > > creation, but not the state set in intel_vgpu_pin_mm().
> > >=20
> > > When force-TDR, all engines are reset, since it's not dmlr level, all
> > > ppgtt_mm are invalidated but not destroyed. Invalidation will mark all
> > > reused shadow_mm as not shadowed but still keeps in ppgtt_mm_list_hea=
d.
> > > If workload submission phase those shadow_mm are reused with shadowed
> > > not set, then set_context_ppgtt_from_shadow() will report error.
> > >=20
> > > Fixes: 4f15665ccbba (drm/i915: Add ppgtt to GVT GEM context)
> > >=20
> > > v2:
> > > Move set_context_ppgtt_from_shadow() after prepare_workload(). (zheny=
u)
> > >=20
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Colin Xu <colin.xu@intel.com>
> > > ---
> > >   drivers/gpu/drm/i915/gvt/scheduler.c | 14 +++++++-------
> > >   1 file changed, 7 insertions(+), 7 deletions(-)
> > >=20
> > > diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i=
915/gvt/scheduler.c
> > > index 196b4155a309..100040209188 100644
> > > --- a/drivers/gpu/drm/i915/gvt/scheduler.c
> > > +++ b/drivers/gpu/drm/i915/gvt/scheduler.c
> > > @@ -685,13 +685,6 @@ static int dispatch_workload(struct intel_vgpu_w=
orkload *workload)
> > >   	mutex_lock(&vgpu->vgpu_lock);
> > >   	mutex_lock(&dev_priv->drm.struct_mutex);
> > > -	ret =3D set_context_ppgtt_from_shadow(workload,
> > > -					    s->shadow[ring_id]->gem_context);
> > > -	if (ret < 0) {
> > > -		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
> > > -		goto err_req;
> > > -	}
> > > -
> > >   	ret =3D intel_gvt_workload_req_alloc(workload);
> > >   	if (ret)
> > >   		goto err_req;
> > > @@ -707,6 +700,13 @@ static int dispatch_workload(struct intel_vgpu_w=
orkload *workload)
> > >   	}
> > >   	ret =3D prepare_workload(workload);
> > > +	if (ret)
> > > +		goto out;
> > > +
> > > +	ret =3D set_context_ppgtt_from_shadow(workload,
> > > +					    s->shadow[ring_id]->gem_context);
> > > +	if (ret)
> > > +		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
> > As workload's shadow_mm should always be for ppgtt, so we don't need re=
turn
> > for set_context_ppgtt_from_shadow, can just be void. Then how about do =
that
> > in prepare_workload after we settle down shadow pdp?
> >=20
> If so, is checking mm->type and shadowed flag stil necessary? since intel=
_vgpu_pin_mm()
> in prepare_workload will guaranee that, if intel_vgpu_pin_mm() fails, sha=
dow pdp won't
> get updated and no need to pin. Am I right?
>

yep, I think so.

> > >   out:
> > >   	if (ret) {
> > >   		/* We might still need to add request with
> > > --=20
> > > 2.22.0
> > >=20
> --=20
> Best Regards,
> Colin Xu
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--Ga6FVKWZzVeX7g0Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXR2yxgAKCRCxBBozTXgY
J00NAKCIzLDl55iAqgsnjmrHOVgW1rSXZACghZXsngwid3aYNJQAcdqkC1DHHQ0=
=4WUx
-----END PGP SIGNATURE-----

--Ga6FVKWZzVeX7g0Z--
