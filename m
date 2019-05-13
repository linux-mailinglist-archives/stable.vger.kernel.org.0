Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0062B1AEF4
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 04:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfEMChF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 May 2019 22:37:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:32636 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbfEMChE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 May 2019 22:37:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 May 2019 19:37:04 -0700
X-ExtLoop1: 1
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by fmsmga008.fm.intel.com with ESMTP; 12 May 2019 19:37:03 -0700
Date:   Mon, 13 May 2019 10:36:21 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Weinan <weinan.z.li@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915/gvt: emit init breadcrumb for gvt request
Message-ID: <20190513023621.GX12913@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190510075720.8206-1-weinan.z.li@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="D5HQcwfjqNcvOcn2"
Content-Disposition: inline
In-Reply-To: <20190510075720.8206-1-weinan.z.li@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--D5HQcwfjqNcvOcn2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.05.10 15:57:20 +0800, Weinan wrote:
> "To track whether a request has started on HW, we can emit a breadcrumb at
> the beginning of the request and check its timeline's HWSP to see if the
> breadcrumb has advanced past the start of this request." It means all the
> request which timeline's has_init_breadcrumb is true, then the
> emit_init_breadcrumb process must have before emitting the real commands,
> otherwise, the scheduler might get a wrong state of this request during
> reset. If the request is exactly the guilty one, the scheduler won't
> terminate it with the wrong state. To avoid this, do emit_init_breadcrumb
> for all the requests from gvt.
>=20
> v2: cc to stable kernel
>=20
> Fixes: 8547444137ec ("drm/i915: Identify active requests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Weinan <weinan.z.li@intel.com>

Thanks for the fix!

Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gvt/scheduler.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/=
gvt/scheduler.c
> index 7c99bbc3e2b8..ccd71152c9bc 100644
> --- a/drivers/gpu/drm/i915/gvt/scheduler.c
> +++ b/drivers/gpu/drm/i915/gvt/scheduler.c
> @@ -298,12 +298,31 @@ static int copy_workload_to_ring_buffer(struct inte=
l_vgpu_workload *workload)
>  	struct i915_request *req =3D workload->req;
>  	void *shadow_ring_buffer_va;
>  	u32 *cs;
> +	int err;
> =20
>  	if ((IS_KABYLAKE(req->i915) || IS_BROXTON(req->i915)
>  		|| IS_COFFEELAKE(req->i915))
>  		&& is_inhibit_context(req->hw_context))
>  		intel_vgpu_restore_inhibit_context(vgpu, req);
> =20
> +	/*
> +	 * To track whether a request has started on HW, we can emit a
> +	 * breadcrumb at the beginning of the request and check its
> +	 * timeline's HWSP to see if the breadcrumb has advanced past the
> +	 * start of this request. Actually, the request must have the
> +	 * init_breadcrumb if its timeline set has_init_bread_crumb, or the
> +	 * scheduler might get a wrong state of it during reset. Since the
> +	 * requests from gvt always set the has_init_breadcrumb flag, here
> +	 * need to do the emit_init_breadcrumb for all the requests.
> +	 */
> +	if (req->engine->emit_init_breadcrumb) {
> +		err =3D req->engine->emit_init_breadcrumb(req);
> +		if (err) {
> +			gvt_vgpu_err("fail to emit init breadcrumb\n");
> +			return err;
> +		}
> +	}
> +
>  	/* allocate shadow ring buffer */
>  	cs =3D intel_ring_begin(workload->req, workload->rb_len / sizeof(u32));
>  	if (IS_ERR(cs)) {
> --=20
> 2.17.1
>=20
> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--D5HQcwfjqNcvOcn2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXNjYJQAKCRCxBBozTXgY
J60KAJ9EV+AbFJvit0OUETLPhP6OpaJ24QCdHnyL9X9/4LwMZn4I5YcECtyqsKM=
=ORf2
-----END PGP SIGNATURE-----

--D5HQcwfjqNcvOcn2--
