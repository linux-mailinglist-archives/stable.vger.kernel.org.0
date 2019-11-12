Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5844BF99F5
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 20:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKLTmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 14:42:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56004 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726936AbfKLTmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 14:42:51 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUc3r-0001YW-Ay; Tue, 12 Nov 2019 19:42:47 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUc3q-0001he-Pz; Tue, 12 Nov 2019 19:42:46 +0000
Message-ID: <71577c0106fb9bcc28cff3f507e73bf2d3cb3713.camel@decadent.org.uk>
Subject: Re: [PATCH 5.3 134/166] net: qlogic: Fix memory leak in
 ql_alloc_large_buffers
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Date:   Tue, 12 Nov 2019 19:42:36 +0000
In-Reply-To: <20191006171224.456500506@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
         <20191006171224.456500506@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-bVMiIecY0+Bsfzq3/ooD"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-bVMiIecY0+Bsfzq3/ooD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-10-06 at 19:21 +0200, Greg Kroah-Hartman wrote:
> From: Navid Emamdoost <navid.emamdoost@gmail.com>
>=20
> [ Upstream commit 1acb8f2a7a9f10543868ddd737e37424d5c36cf4 ]
>=20
> In ql_alloc_large_buffers, a new skb is allocated via netdev_alloc_skb.
> This skb should be released if pci_dma_mapping_error fails.
>=20
> Fixes: 0f8ab89e825f ("qla3xxx: Check return code from pci_map_single() in=
 ql_release_to_lrg_buf_free_list(), ql_populate_free_queue(), ql_alloc_larg=
e_buffers(), and ql3xxx_send()")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ethernet/qlogic/qla3xxx.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
> @@ -2787,6 +2787,7 @@ static int ql_alloc_large_buffers(struct
>  				netdev_err(qdev->ndev,
>  					   "PCI mapping failed with error: %d\n",
>  					   err);
> +				dev_kfree_skb_irq(skb);
>  				ql_free_large_buffers(qdev);

So far as I can see, ql_free_large_buffers() will free the skb since
qdev->lrg_buf[i].skb already points to it.  So there was no memory
leak, and this change introduced a double-free on the error path.

Am I missing something?

Ben.

>  				return -ENOMEM;
>  			}
>=20
>=20
--=20
Ben Hutchings
I'm not a reverse psychological virus.
Please don't copy me into your signature.


--=-bVMiIecY0+Bsfzq3/ooD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3LCywACgkQ57/I7JWG
EQmdaw/8Dph2qrw/XuROeeFFP8N5VP6zqNVfHFfxcRXB6P+lg2XOWEoCmmT0MTOU
K6c24MMO0DNDCUAnv4oc1vg6Jpj6krUGKfHjrOKsApxzpjQtgzX+z7GmyT92aXQn
GSq2uNbq3VJ9YvXNKG+zNouT9bwNZa+douHahMY/OVR7J6mk0YRIbHWHVCxs8Lyi
6JKheoLtafDtqeH+4sIa1K1kV34/E3h1y/hHcoMTAY0aYM8aZnnZgJz2S530fvjN
wLGzPAYecKix1gmNowLhPRMDHt+8/B8urHpcu4FXa+F7n3hRMHP80IoIHHhXSjOe
/vkJrnJ1YPaaVTTDf/5f5A2t4JgVfVRQ2rfcGGWr94WX9PQf39eC1pM25RAKMv3V
qwnFHgQOQ+d3+rAvdR21F4akNx9sTX7Nzj7JoVSPJ3mFufMouYOEq5r10lbd9/1o
EPlpASegaYFzmgsx3Qt25Hjt+KH9FmdasDmHbSVStk/zZwhdGV4Za6r+1z1Twxr9
KspNs8zyP8YMo5grdzKSAh2HGU8fcHdkDXQY6iPTOLyF96rG2Z+Mt4UAGpr0xkQK
3Mfg5SUhQ/WCp8O3XTF+quzrY/d6QdpMM9wz3WelGB2fCsy78fGMqPl8IfYE8h2w
HZMWBf9LvOPu62v9Fh3FhWF87sjZl7jV8mR2Wi/7lzVdGUPFQ44=
=YbhV
-----END PGP SIGNATURE-----

--=-bVMiIecY0+Bsfzq3/ooD--
