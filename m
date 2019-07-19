Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A376E1BA
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 09:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfGSHcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 03:32:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:58441 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfGSHcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 03:32:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 00:32:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="asc'?scan'208";a="343619970"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by orsmga005.jf.intel.com with ESMTP; 19 Jul 2019 00:32:11 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     fei.yang@intel.com, john.stultz@linaro.org,
        andrzej.p@collabora.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] usb: dwc3: gadget: trb_dequeue is not updated properly
In-Reply-To: <1563497183-7114-1-git-send-email-fei.yang@intel.com>
References: <1563497183-7114-1-git-send-email-fei.yang@intel.com>
Date:   Fri, 19 Jul 2019 10:32:07 +0300
Message-ID: <87k1cescnc.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

fei.yang@intel.com writes:
> From: Fei Yang <fei.yang@intel.com>
>
> If scatter-gather operation is allowed, a large USB request is split into
> multiple TRBs. These TRBs are chained up by setting DWC3_TRB_CTRL_CHN bit
> except the last one which has DWC3_TRB_CTRL_IOC bit set instead.
> Since only the last TRB has IOC set for the whole USB request, the
> dwc3_gadget_ep_reclaim_trb_sg() gets called only once after the last TRB
> completes and all the TRBs allocated for this request are supposed to be
> reclaimed. However that is not what the current code does.
>
> dwc3_gadget_ep_reclaim_trb_sg() is trying to reclaim all the TRBs in the
> following for-loop,
> 	for_each_sg(sg, s, pending, i) {
> 		trb =3D &dep->trb_pool[dep->trb_dequeue];
>
>                 if (trb->ctrl & DWC3_TRB_CTRL_HWO)
>                         break;
>
>                 req->sg =3D sg_next(s);
>                 req->num_pending_sgs--;
>
>                 ret =3D dwc3_gadget_ep_reclaim_completed_trb(dep, req,
>                                 trb, event, status, chain);
>                 if (ret)
>                         break;
>         }
> but since the interrupt comes only after the last TRB completes, the
> event->status has DEPEVT_STATUS_IOC bit set, so that the for-loop ends for
> the first TRB due to dwc3_gadget_ep_reclaim_completed_trb() returns 1.
> 	if (event->status & DEPEVT_STATUS_IOC)
> 		return 1;
>
> This patch addresses the issue by checking each TRB in function
> dwc3_gadget_ep_reclaim_trb_sg() and maing sure the chained ones are prope=
rly
> reclaimed. dwc3_gadget_ep_reclaim_completed_trb() will return 1 Only for =
the
> last TRB.
>
> Signed-off-by: Fei Yang <fei.yang@intel.com>
> Cc: stable <stable@vger.kernel.org>
> ---
> v2: Better solution is to reclaim chained TRBs in dwc3_gadget_ep_reclaim_=
trb_sg()
>     and leave the last TRB to the dwc3_gadget_ep_reclaim_completed_trb().
> v3: Checking DWC3_TRB_CTRL_CHN bit for each TRB instead, and making sure =
that
>     dwc3_gadget_ep_reclaim_completed_trb() returns 1 only for the last TR=
B.
> ---
>  drivers/usb/dwc3/gadget.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 173f532..88eed49 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2394,7 +2394,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(str=
uct dwc3_ep *dep,
>  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
>  		return 1;
>=20=20
> -	if (event->status & DEPEVT_STATUS_IOC)
> +	if (event->status & DEPEVT_STATUS_IOC && !chain)
>  		return 1;

This will break the situation when we have more SGs than available
TRBs. In that case we set IOC before the last so we have time to update
transfer to append more TRBs.

Please, send me tracepoints

> @@ -2404,11 +2404,12 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct d=
wc3_ep *dep,
>  		struct dwc3_request *req, const struct dwc3_event_depevt *event,
>  		int status)
>  {
> -	struct dwc3_trb *trb =3D &dep->trb_pool[dep->trb_dequeue];
> +	struct dwc3_trb *trb;

should be part of another patch. This is a cleanup that has nothing to
do with this fix.

>  	struct scatterlist *sg =3D req->sg;
>  	struct scatterlist *s;
>  	unsigned int pending =3D req->num_pending_sgs;
>  	unsigned int i;
> +	int chain =3D false;

this could be defined inside for_each_sg() loop like this:

	int chain =3D trb->ctrl & DWC3_TRB_CTRL_CHN;

> @@ -2419,9 +2420,13 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dw=
c3_ep *dep,
>=20=20
>  		req->sg =3D sg_next(s);
>  		req->num_pending_sgs--;
> +		if (trb->ctrl & DWC3_TRB_CTRL_CHN)
> +			chain =3D true;
> +		else
> +			chain =3D false;
>=20=20
>  		ret =3D dwc3_gadget_ep_reclaim_completed_trb(dep, req,
> -				trb, event, status, true);
> +				trb, event, status, chain);

this is definitely a valid fix :-) I'm not convinced about that IOC &&
!chain above, however. Also, if "chain" is always trb->ctrl &
DWC3_TRB_CTRL_CHN, we can get rid of that argument altogether and have
the callee handle it internally, but that's something else, subject to
another patch.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl0xcfcACgkQzL64meEa
mQa6hBAAop4hAPq3S8lrAAbH7E6SxCiOg6QGUr0B4mWmj1gXXGZJhw5Ag2WAMD2C
LuZBvbGvnKWT+lwgz5G6xmNw1ZPSrHivovQ2fG6Cc77EpEwCJULwSRlzfJgdL0bb
AXDKGKOq57TZGkftniv8uAgNfHSwCCHC2iWzCfqjd79RPwo06gnf1JmoqpU1oroa
gvY0KP0DXieOm4HHesKeo3Wu6kK6BdulpAd3v7v5fCZaIY7rpaFwawHJQ/KeCgfF
s+SMO9wJiZmrOIZFfTM6JQYEAKTAERwSuK3eCSt0FRzPbiMmNVD0nWHmHaNS+dR5
xnyx59zLT1+Lstx94tUz5aGMN8rTK6JmtkdZTple5NRkKIx97wQqG/7mjVTMc8Wd
Qz2AMYFT/0Wg6Suz4NBNvoC3Ny8dIR9GhqSu3+YDRr/9fWqCkikaopG1vqLdvCPi
thXi6gLGsPKVZ8yfQMe7lM3Xrrdp72R6QgY8DFLPiLa+rLZmwomCjduV2l4cc0wN
bniH7CX93giYjIYxHos+LoL/zEAdt1Zr/WRw3Y6KJSdefJNJwuklYhe3gcKAjEyj
bCU8Q2thd5YHlRCd05MtPQ9PrlS+3ZM/wexVn4wB/diPSgb14Cs+Ng3l+dtQc/AH
JTPvOVJ8BReIB9DmoZ9RwcLDEt4KE9QShCnEtyDuGBfLXqv70m0=
=kb6q
-----END PGP SIGNATURE-----
--=-=-=--
