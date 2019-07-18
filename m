Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447CA6C5B7
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390892AbfGRDIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:08:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:38778 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389899AbfGRDIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 20:08:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="asc'?scan'208";a="343232767"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga005.jf.intel.com with ESMTP; 17 Jul 2019 20:08:51 -0700
Date:   Thu, 18 Jul 2019 11:05:41 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Xiaolin Zhang <xiaolin.zhang@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gvt: fix incorrect cache entry for guest page
 mapping
Message-ID: <20190718030541.GC16681@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <1563383424-23315-1-git-send-email-xiaolin.zhang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p11K2BJEgMZL61bg"
Content-Disposition: inline
In-Reply-To: <1563383424-23315-1-git-send-email-xiaolin.zhang@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--p11K2BJEgMZL61bg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.07.18 01:10:24 +0800, Xiaolin Zhang wrote:
> GPU hang observed during the guest OCL conformance test which is caused
> by THP GTT feature used durning the test.
>=20
> It was observed the same GFN with different size (4K and 2M) requested
> from the guest in GVT. So during the guest page dma map stage, it is
> required to unmap first with orginal size and then remap again with
> requested size.
>=20
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---

Applied, thanks!

>  drivers/gpu/drm/i915/gvt/kvmgt.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/=
kvmgt.c
> index a68addf..4a7cf86 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1911,6 +1911,18 @@ static int kvmgt_dma_map_guest_page(unsigned long =
handle, unsigned long gfn,
>  		ret =3D __gvt_cache_add(info->vgpu, gfn, *dma_addr, size);
>  		if (ret)
>  			goto err_unmap;
> +	} else if (entry->size !=3D size) {
> +		/* the same gfn with different size: unmap and re-map */
> +		gvt_dma_unmap_page(vgpu, gfn, entry->dma_addr, entry->size);
> +		__gvt_cache_remove_entry(vgpu, entry);
> +
> +		ret =3D gvt_dma_map_page(vgpu, gfn, dma_addr, size);
> +		if (ret)
> +			goto err_unlock;
> +
> +		ret =3D __gvt_cache_add(info->vgpu, gfn, *dma_addr, size);
> +		if (ret)
> +			goto err_unmap;
>  	} else {
>  		kref_get(&entry->ref);
>  		*dma_addr =3D entry->dma_addr;
> --=20
> 1.8.3.1
>=20
> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--p11K2BJEgMZL61bg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXS/iBQAKCRCxBBozTXgY
J8AZAJ994iBkcLjTJOZSs5VsyDpn7kn+RQCdEyVtanjb3XVy00Ve6A12JZpZaMw=
=jkcs
-----END PGP SIGNATURE-----

--p11K2BJEgMZL61bg--
