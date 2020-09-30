Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F76527E831
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 14:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgI3MGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 08:06:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37613 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI3MGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 08:06:40 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <stefan.bader@canonical.com>)
        id 1kNasX-0004Q9-1y; Wed, 30 Sep 2020 12:06:37 +0000
Subject: Re: [PATCH] xen/events: don't use chip_data for legacy IRQs
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
References: <20200930091614.13660-1-jgross@suse.com>
From:   Stefan Bader <stefan.bader@canonical.com>
Autocrypt: addr=stefan.bader@canonical.com; prefer-encrypt=mutual; keydata=
 mQINBE5mmXEBEADoM0yd6ERIuH2sQjbCGtrt0SFCbpAuOgNy7LSDJw2vZHkZ1bLPtpojdQId
 258o/4V+qLWaWLjbQdadzodnVUsvb+LUKJhFRB1kmzVYNxiu7AtxOnNmUn9dl1oS90IACo1B
 BpaMIunnKu1pp7s3sfzWapsNMwHbYVHXyJeaPFtMqOxd1V7bNEAC9uNjqJ3IG15f5/50+N+w
 LGkd5QJmp6Hs9RgCXQMDn989+qFnJga390C9JPWYye0sLjQeZTuUgdhebP0nvciOlKwaOC8v
 K3UwEIbjt+eL18kBq4VBgrqQiMupmTP9oQNYEgk2FiW3iAQ9BXE8VGiglUOF8KIe/2okVjdO
 nl3VgOHumV+emrE8XFOB2pgVmoklYNvOjaIV7UBesO5/16jbhGVDXskpZkrP/Ip+n9XD/EJM
 ismF8UcvcL4aPwZf9J03fZT4HARXuig/GXdK7nMgCRChKwsAARjw5f8lUx5iR1wZwSa7HhHP
 rAclUzjFNK2819/Ke5kM1UuT1X9aqL+uLYQEDB3QfJmdzVv5vHON3O7GOfaxBICo4Z5OdXSQ
 SRetiJ8YeUhKpWSqP59PSsbJg+nCKvWfkl/XUu5cFO4V/+NfivTttnoFwNhi/4lrBKZDhGVm
 6Oo/VytPpGHXt29npHb8x0NsQOsfZeam9Z5ysmePwH/53Np8NQARAQABtDVTdGVmYW4gQmFk
 ZXIgKENhbm9uaWNhbCkgPHN0ZWZhbi5iYWRlckBjYW5vbmljYWwuY29tPokCVwQTAQoAQQIb
 AwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAIZARYhBNtdfMrzmU4zldpNPuhnXe7L7s6jBQJd
 7mXwBQkRwqX/AAoJEOhnXe7L7s6jwpgQALEz54XvgIhYi8qCwqkopEZXq2fYttMFMEMkW3dA
 7Y/m5fnmPs/QYsfpn7LtQcmDGBz4W9YDL/KD+1YF1W1+vzo8NQTeR02DJksaTx2riyzI+zS9
 YY/c0EvyauOWa8s9YvI9lzN+gWgOKyEK415nybXjU5FEMAF6jAjJ70T+DPeZjGBgkoDPKBRK
 O3DBgOV23rrAiMx9UXqAbcSUU4i1me6PTZaAbSeIiOPOdJfPgJP8ki3QuGF3ct23dLLlPame
 cCCgH4ZBMGb8ZQLhRfLNYao0dbDXcqQ+OSFl2pGToiC19MJj1im1Ca8Dc97JRuzkxOFKRfXA
 9rYsVy7AV//pfVy3x5tT0fJQtz4UFU4Qzhi/08U2wgl9tsJxP2LCtcoXa7D+3ehe92cQNsrQ
 Xo6XKNzvOFoXzDBzoVU9SYTv12Y97zECJG11F+QmDiogudy+ioq+R9aKgMUIugnCh45LuZuR
 yj9quASYn5vf/YywML5vSVKNQ1+0jcO/vkwja4bMU0intA0se8ujjVMV/XXJb80PtghZVVL/
 +xqnApGilIda5+QEbjdPO8XjNlFO8cIhez81+8m68ybnq5svfee/PJOEZ6jlxG5XIyb3B/ky
 gZY6kimPLeLcjxK4FVH5teiSB0IfpEMnQNLrjDzXWgmA/Bk7VNycPYOKvZnYuBNgA7wEuQIN
 BE5mmXEBEADCkRfuS1cAx02yTsk9gyAapcQnpb6EBay40Ch/IPrMF2iG4F0CX6puKubjjVbq
 L6jEKyksqPb57Vu9WAufy4Rlv3OwzaymmWk00CROCVSuEV+3bikBTnF/l+VVCvccNlpHsADM
 LncaATvSOj1iCXeikxNAk2LA3g9H8uz7lQUhjni05ixBZGDGbaxB6Odmh58q8k/iooREHyqf
 leSg1zpuBxYGKVug2daXLSvQI7w59eYO/L1YpLtu1sMzqRyYdSUyCiNcXDO/Ko221o2NfdqQ
 9KET1az8QTsBnZeTsjsk4VnYwjc9ZEYN7LATWrhz8vgI2eP80lXxXm9kx81NubnOPxna5vg9
 DhxZEjo8A+zE4c5bQuSCJ3GTnOalXsAz0Lwk1H1nFwizUqvmPI8eAqZGeZoJ409uDcNi2BrR
 +W7MjXxPM5k4M2zMiNfIvNBjclBLE/m7nrcxNLOk1z/KQiFVZQhtHXoOTUWmINZ+E3GIJT2D
 ToFxUoaEW2GdX0rjqEerbUaoo6SBX7HxmjAzseND9IatGTxgN+EhJUiIWK4UOH343erB7Hga
 98WeEzZTq7W2NvwnqOVAq2ElnPhHrD98nWIBZPOEu6xgiyvVFfXJGmRBMRBR+8hBjfX0643n
 Lq3wYOrZbNfP8dJVQZ4GxI6OLTcwYNgifqp/SIJzE1tgkwARAQABiQI8BBgBCgAmAhsMFiEE
 2118yvOZTjOV2k0+6Gdd7svuzqMFAl3uZkUFCRGHUtQACgkQ6Gdd7svuzqMZ8A/+OOxzg8PT
 7B9o/YvbBuKfnc3WK2xFpYPsiqlRk+7NnV1BXOMpCe9jrKGy1erJg0WBD7BXg7mbQj6KH58o
 MslCZCkb4N1igwD2JiJo/Lf98DFdw6hUR8Ja/DOVhjpNjfbhF5EIIzkkV8K/pIrkRPOL6uld
 i2IPowtMky2yoIJ1cQdtREEUL/WcpRoLrW6ZqITx4RxL2nnUSp0kpr3sdsYmUoGKWAfBSO/W
 TCsypW4Ymd4tWST4NVFYOW2/pkROX8saRdznaCRFnn8QeTSb2WgDmXLLjGKancYmZPNRcdr9
 OsFcWN2R3ljo6+frW58GoR1To4E7Jr2MucDK8wmvkf08NlnhqOzfaRvgdLLK5l5tv6LZOGCH
 17imKDu6cH0qf0EVCCd3Oq8SIosKzcvYJRqwc6CJGJSaz9CNUHCnDUzMZq1Pi+C4FuK2i2jz
 X+xJRAvEX6xZ0BhfuKnum7KtZmBYACeL4V27Bes6r2YGEf4ZQq9kyNVZ6r+pmcyRS495Y+8r
 Vgixzb39xyLAzwOFCBpCcsT6MsdsqIx9ir+Dx3aVpU9kxzFLXmj1JnlqCvDx4g8q1kEU9ffD
 6bmoRYuE45/feIEQGr1QueKac1rpRHhfohCTZNG2Jx1c6VwZCYvBKkOJMWpQwRtyEcShcX1j
 quuXTQgSgLXYhq37J+O42GU0Amw=
Message-ID: <1bf20485-3dd2-109f-5c8a-d2c971e1f6d6@canonical.com>
Date:   Wed, 30 Sep 2020 14:06:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930091614.13660-1-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="4ZWfbxMYEuYb9WBQDNT49jdPyGV9G7x6T"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4ZWfbxMYEuYb9WBQDNT49jdPyGV9G7x6T
Content-Type: multipart/mixed; boundary="eo46LUkwhYPCjazyhGffTGoSf3IEADHzU"

--eo46LUkwhYPCjazyhGffTGoSf3IEADHzU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 30.09.20 11:16, Juergen Gross wrote:
> Since commit c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_=
data to store a per interrupt XEN data pointer which contains XEN specifi=
c information.")
> Xen is using the chip_data pointer for storing IRQ specific data. When
> running as a HVM domain this can result in problems for legacy IRQs, as=

> those might use chip_data for their own purposes.
>=20
> Use a local array for this purpose in case of legacy IRQs, avoiding the=

> double use.
>=20
> Cc: stable@vger.kernel.org
> Fixes: c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data t=
o store a per interrupt XEN data pointer which contains XEN specific info=
rmation.")
> Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  drivers/xen/events/events_base.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/even=
ts_base.c
> index 90b8f56fbadb..6f02c18fa65c 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -92,6 +92,8 @@ static bool (*pirq_needs_eoi)(unsigned irq);
>  /* Xen will never allocate port zero for any purpose. */
>  #define VALID_EVTCHN(chn)	((chn) !=3D 0)
> =20
> +static struct irq_info *legacy_info_ptrs[NR_IRQS_LEGACY];
> +
>  static struct irq_chip xen_dynamic_chip;
>  static struct irq_chip xen_percpu_chip;
>  static struct irq_chip xen_pirq_chip;
> @@ -156,7 +158,18 @@ int get_evtchn_to_irq(evtchn_port_t evtchn)
>  /* Get info for IRQ */
>  struct irq_info *info_for_irq(unsigned irq)
>  {
> -	return irq_get_chip_data(irq);
> +	if (irq < nr_legacy_irqs())
> +		return legacy_info_ptrs[irq];
> +	else
> +		return irq_get_chip_data(irq);
> +}
> +
> +static void set_info_for_irq(unsigned int irq, struct irq_info *info)
> +{
> +	if (irq < nr_legacy_irqs())
> +		legacy_info_ptrs[irq] =3D info;
> +	else
> +		irq_set_chip_data(irq, info);
>  }
> =20
>  /* Constructors for packed IRQ information. */
> @@ -377,7 +390,7 @@ static void xen_irq_init(unsigned irq)
>  	info->type =3D IRQT_UNBOUND;
>  	info->refcnt =3D -1;
> =20
> -	irq_set_chip_data(irq, info);
> +	set_info_for_irq(irq, info);
> =20
>  	list_add_tail(&info->list, &xen_irq_list_head);
>  }
> @@ -426,14 +439,14 @@ static int __must_check xen_allocate_irq_gsi(unsi=
gned gsi)
> =20
>  static void xen_free_irq(unsigned irq)
>  {
> -	struct irq_info *info =3D irq_get_chip_data(irq);
> +	struct irq_info *info =3D info_for_irq(irq);
> =20
>  	if (WARN_ON(!info))
>  		return;
> =20
>  	list_del(&info->list);
> =20
> -	irq_set_chip_data(irq, NULL);
> +	set_info_for_irq(irq, NULL);
> =20
>  	WARN_ON(info->refcnt > 0);
> =20
> @@ -603,7 +616,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
>  static void __unbind_from_irq(unsigned int irq)
>  {
>  	evtchn_port_t evtchn =3D evtchn_from_irq(irq);
> -	struct irq_info *info =3D irq_get_chip_data(irq);
> +	struct irq_info *info =3D info_for_irq(irq);
> =20
>  	if (info->refcnt > 0) {
>  		info->refcnt--;
> @@ -1108,7 +1121,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
> =20
>  void unbind_from_irqhandler(unsigned int irq, void *dev_id)
>  {
> -	struct irq_info *info =3D irq_get_chip_data(irq);
> +	struct irq_info *info =3D info_for_irq(irq);
> =20
>  	if (WARN_ON(!info))
>  		return;
> @@ -1142,7 +1155,7 @@ int evtchn_make_refcounted(evtchn_port_t evtchn)
>  	if (irq =3D=3D -1)
>  		return -ENOENT;
> =20
> -	info =3D irq_get_chip_data(irq);
> +	info =3D info_for_irq(irq);
> =20
>  	if (!info)
>  		return -ENOENT;
> @@ -1170,7 +1183,7 @@ int evtchn_get(evtchn_port_t evtchn)
>  	if (irq =3D=3D -1)
>  		goto done;
> =20
> -	info =3D irq_get_chip_data(irq);
> +	info =3D info_for_irq(irq);
> =20
>  	if (!info)
>  		goto done;
>=20



--eo46LUkwhYPCjazyhGffTGoSf3IEADHzU--

--4ZWfbxMYEuYb9WBQDNT49jdPyGV9G7x6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAl90dMwACgkQ6Gdd7svu
zqPQ/A//RDI4BshHv9YGjjm0Nxa2eS5HXqyE3rPLWF+ppy1GjdxTI1X6uPJ5q6Tq
iQxLlb5X+VILKwYN1VK8pz3Jl/rexaQZEsTOvxswLpGs2CaHWLpBf3GVziewCq6u
V/JXLRFmgCRq+DQ0IgWnl7FJk/kkUp4mLbdsVBpZxayrinXmdCnSsiCIhEAnOJIm
ooiiyc7x1OqzmrfJiwFgRchdc3qBGcaXUzZZkJJYT++y/SigfyXY5JUk/fK3VzLi
RjZ7HqRo19h0SKOn2WA46fqKxHVLkpINt5ixOvGXn5eaUkLmq9GUaejhf0ABuk+y
gMwSgUYAA08w5VkWOch9Tc+YR8LxlfjTelQWpoGL6DYYIAiavyyNAso6RJwf/bN1
XcFg+NBYi4XCWAyi77IqPWjIdmMqHMeMzP/PuUe5QOOr2xT0IJbXU1solq9DblqF
/dcvaUkIOKxS9vhD+n+jPGjDzl3KEhyczQv5M7LwtmcLqh1n3DqTMlZzgu1VhwLH
XEmZMZTV0QAYuEIhhUePtsivw1RnKxd84nVYF/lx9tDcdqORtLOy9h9IfdF7tBPv
anROrXIdL2ktJr1k2SjrENmRipmKOeisYE1LOjmaReUi/PiV+SgVmh0132C0Fnih
FTgJYBZYKyuB/kJKDT0Dyf3h5FuAWlKTK1iR5q9jo4FFEHjME7M=
=/vXP
-----END PGP SIGNATURE-----

--4ZWfbxMYEuYb9WBQDNT49jdPyGV9G7x6T--
