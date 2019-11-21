Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3D6105D69
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 00:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKUXwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 18:52:20 -0500
Received: from mga04.intel.com ([192.55.52.120]:11589 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfKUXwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 18:52:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 15:52:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,227,1571727600"; 
   d="asc'?scan'208";a="197434268"
Received: from lmhaganx-mobl.amr.corp.intel.com ([10.251.138.123])
  by orsmga007.jf.intel.com with ESMTP; 21 Nov 2019 15:52:18 -0800
Message-ID: <e5273fa943335bbc1300360d7944c66d57ea5e27.camel@intel.com>
Subject: Re: [PATCH 4.19 063/422] ice: Prevent control queue operations
 during reset
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Thu, 21 Nov 2019 15:52:18 -0800
In-Reply-To: <20191120214848.GA13271@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
         <20191119051403.783565468@linuxfoundation.org>
         <20191120214848.GA13271@duo.ucw.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-2ZlOwiajNpxv6Imgsesg"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-2ZlOwiajNpxv6Imgsesg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-20 at 22:48 +0100, Pavel Machek wrote:
> Hi!
> > [ Upstream commit fd2a981777d911b2e94cdec50779c85c58a0dec9 ]
> >=20
> > Once reset is issued, the driver loses all control queue interfaces.
> > Exercising control queue operations during reset is incorrect and
> > may result in long timeouts.
> >=20
> > This patch introduces a new field 'reset_ongoing' in the hw structure.
> > This is set to 1 by the core driver when it receives a reset interrupt.
> > ice_sq_send_cmd checks reset_ongoing before actually issuing the
> > control
> > queue operation. If a reset is in progress, it returns a soft error
> > code
> > (ICE_ERR_RESET_PENDING) to the caller. The caller may or may not have
> > to
> > take any action based on this return. Once the driver knows that the
> > reset is done, it has to set reset_ongoing back to 0. This will allow
> > control queue operations to be posted to the hardware again.
> >=20
> > This "bail out" logic was specifically added to ice_sq_send_cmd (which
> > is pretty low level function) so that we have one solution in one place
> > that applies to all types of control queues.
>=20
> I don't think this is suitable for stable. Would driver maintainers
> comment?

Actually this change is fine for stable.

>=20
> > +			 *
> > +			 * As this is the start of the reset/rebuild cycle,
> > set
> > +			 * both to indicate that.
> > +			 */
> > +			hw->reset_ongoing =3D true;
> >  		}
> >  	}
>=20
> This should be =3D 1, since variable is u8...

This variable is treated as a bool, and since bools vary depending on
architecture, Linus has stated that using a u8 would be more consistent
across the vary architectures.  So we have used u8's for variables treated
as bools.

In addition, there has been no issue assigning "true" or "false" to a u8.

>=20
> Best regards,
> 									Pav
> el     	      =20
>=20
> > +++ b/drivers/net/ethernet/intel/ice/ice_type.h
> > @@ -293,6 +293,7 @@ struct ice_hw {
> >  	u8 sw_entry_point_layer;
> > =20
> >  	u8 evb_veb;		/* true for VEB, false for VEPA */
> > +	u8 reset_ongoing;	/* true if hw is in reset, false otherwise */
> >  	struct ice_bus_info bus;
> >  	struct ice_nvm_info nvm;
> >  	struct ice_hw_dev_caps dev_caps;	/* device capabilities */
> > --=20


--=-2ZlOwiajNpxv6Imgsesg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3XIzIACgkQ5W/vlVpL
7c6pMA/+LBAQ7x99yucQ9+nNxAkaE2uLli0g0MRBmLb9G3Jphymle2pRNfQ1lL+o
iQMo9BnFm7K5cOVBp3/sNG6BuyKv7Oa0TR5mQKHDo9pyRH5wFaKE8JsxErBYaRgr
9qIrrh33V1CqEwNB9hA/gWRUhFcVymdkozojvyjvtYICLahMIEMw94mbJqkhXYps
BEERDn+w+E94bKTcTdkxs9o3zv0bPCYEwDcwnm9sYRRqcxQeOqmDTRLxqk3IzztH
inFFKkTrcpTf/4dhv3gZytjooFPD5zyBRdrtZv57dWVzqNcOhXl3xOABLZl/Xskx
2v3kfcvudSio52RZzSNzrTQEngRz37kyDFVsiSLHibvt4vLnlMeBiluBB6gJQOeb
yjH+laB/W5d/2VCT/w5ps8vFw0TZs20IUGvdG4R5Se88IqyMF9JF4rX81hNS3+mz
Mv1JadysPakfMVKQ5tipFRRykuGiUfJKjKraMDHoLPD37QhOkG0RHdb5CtzycZE9
w1bABOiBh2PEZnDUvJQ1RCNSjU5hptc3NYsmMMeX/PnFNmZegBUkp+vGxMglM4Dn
mk+w7Htj2YdOTsGizcZE4vXIEwTwwdxcS0Cc04ygc+NBu528RUQLC3H00KeR0FsB
KiZPh5DgHI/CmwLmFSGeaavvK8urPyw7d+No4r+LMhYpeL1ie8g=
=qE4m
-----END PGP SIGNATURE-----

--=-2ZlOwiajNpxv6Imgsesg--

