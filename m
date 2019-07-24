Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F8473325
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 17:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfGXPxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 11:53:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:60626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726029AbfGXPxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 11:53:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12B20B0BF;
        Wed, 24 Jul 2019 15:53:20 +0000 (UTC)
Message-ID: <01092e95d61f19ac3e373b0dbaf5db8cb551ee8d.camel@suse.de>
Subject: Re: FAILED: patch "[PATCH] xhci: Fix immediate data transfer if
 buffer is already DMA" failed to apply to 5.2-stable tree
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     gregkh@linuxfoundation.org, mathias.nyman@linux.intel.com,
        m.szyprowski@samsung.com
Cc:     stable@vger.kernel.org
Date:   Wed, 24 Jul 2019 17:53:18 +0200
In-Reply-To: <1563983027111159@kroah.com>
References: <1563983027111159@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uRTCncO/Zrk5+koJXCER"
User-Agent: Evolution 3.32.3 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-uRTCncO/Zrk5+koJXCER
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-07-24 at 17:43 +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.2-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>

For the record, just so it doesn't get lost, it is indeed needed.=20
I'll take care of it as long as Matthias doesn't prefer to do it himself.

> ------------------ original commit in Linus's tree ------------------
>=20
> From 13b82b746310b51b064bc855993a1c84bf862726 Mon Sep 17 00:00:00 2001
> From: Mathias Nyman <mathias.nyman@linux.intel.com>
> Date: Wed, 22 May 2019 14:34:00 +0300
> Subject: [PATCH] xhci: Fix immediate data transfer if buffer is already D=
MA
>  mapped
>=20
> xhci immediate data transfer (IDT) support in 5.2-rc1 caused regression
> on various Samsung Exynos boards with ASIX USB 2.0 ethernet dongle.
>=20
> If the transfer buffer in the URB is already DMA mapped then IDT should
> not be used. urb->transfer_dma will already contain a valid dma address,
> and there is no guarantee the data in urb->transfer_buffer is valid.
>=20
> The IDT support patch used urb->transfer_dma as a temporary storage,
> copying data from urb->transfer_buffer into it.
>=20
> Issue was solved by preventing IDT if transfer buffer is already dma
> mapped, and by not using urb->transfer_dma as temporary storage.
>=20
> Fixes: 33e39350ebd2 ("usb: xhci: add Immediate Data Transfer support")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index ef7c8698772e..88392aa65722 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -3432,11 +3432,14 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp=
_t
> mem_flags,
> =20
>  	if (urb->transfer_buffer_length > 0) {
>  		u32 length_field, remainder;
> +		u64 addr;
> =20
>  		if (xhci_urb_suitable_for_idt(urb)) {
> -			memcpy(&urb->transfer_dma, urb->transfer_buffer,
> +			memcpy(&addr, urb->transfer_buffer,
>  			       urb->transfer_buffer_length);
>  			field |=3D TRB_IDT;
> +		} else {
> +			addr =3D (u64) urb->transfer_dma;
>  		}
> =20
>  		remainder =3D xhci_td_remainder(xhci, 0,
> @@ -3449,8 +3452,8 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp_t
> mem_flags,
>  		if (setup->bRequestType & USB_DIR_IN)
>  			field |=3D TRB_DIR_IN;
>  		queue_trb(xhci, ep_ring, true,
> -				lower_32_bits(urb->transfer_dma),
> -				upper_32_bits(urb->transfer_dma),
> +				lower_32_bits(addr),
> +				upper_32_bits(addr),
>  				length_field,
>  				field | ep_ring->cycle_state);
>  	}
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index a450a99e90eb..7f8b950d1a73 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -2160,7 +2160,8 @@ static inline bool xhci_urb_suitable_for_idt(struct=
 urb
> *urb)
>  {
>  	if (!usb_endpoint_xfer_isoc(&urb->ep->desc) && usb_urb_dir_out(urb) &&
>  	    usb_endpoint_maxp(&urb->ep->desc) >=3D TRB_IDT_MAX_SIZE &&
> -	    urb->transfer_buffer_length <=3D TRB_IDT_MAX_SIZE)
> +	    urb->transfer_buffer_length <=3D TRB_IDT_MAX_SIZE &&
> +	    !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP))
>  		return true;
> =20
>  	return false;
>=20


--=-uRTCncO/Zrk5+koJXCER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl04fu4ACgkQlfZmHno8
x/6fsQf9FdYOP8NGejTXpa1s7Fg+hS5Z8EWAt3ETGOKHjhSPW9e6qJpGE77zzCzj
/fO1TxJNu+OZUnjitj1fK8r0rALAKKO7kUXEGvhhVkrPkpgBfgdrx1AQnWP47AyK
j222oZ19a0iPV90D0jbv2Ug7pA3NuII7a7l1nVK/8onvI9LDNDeklQrSnQJiso2x
6UgrHRQFn4uSP9N0yHmE6/VSZ/KFGfKSM6J/3bTrAP6fsMnXBYzhzE77fz0ZwyQC
M6GifEcOhdj4ln4mlnB/xdh6Ejv+wMKW/TAgDsQziiP1rSQNDClGCcr6RBh5GB17
a+TBn2MhKA1AMFqPZ0G0YkDVyRh49Q==
=Wph0
-----END PGP SIGNATURE-----

--=-uRTCncO/Zrk5+koJXCER--

