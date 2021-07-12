Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C93B3C65CF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 23:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhGLWC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 18:02:29 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46772 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhGLWC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 18:02:28 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6ED781C0B7A; Mon, 12 Jul 2021 23:59:38 +0200 (CEST)
Date:   Mon, 12 Jul 2021 23:59:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH AUTOSEL 4.4 08/31] drm/virtio: Fixes a potential NULL
 pointer dereference on probe failure
Message-ID: <20210712215937.GA9488@amd>
References: <20210706112931.2066397-1-sashal@kernel.org>
 <20210706112931.2066397-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20210706112931.2066397-8-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Xie Yongji <xieyongji@bytedance.com>
>=20
> [ Upstream commit 17f46f488a5d82c5568e6e786cd760bba1c2ee09 ]
>=20
> The dev->dev_private might not be allocated if virtio_gpu_pci_quirk()
> or virtio_gpu_init() failed. In this case, we should avoid the cleanup
> in virtio_gpu_release().

The check is in wrong place at least in 4.4:

> +++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
> @@ -257,6 +257,9 @@ int virtio_gpu_driver_unload(struct drm_device *dev)
>  	flush_work(&vgdev->config_changed_work);
>  	vgdev->vdev->config->del_vqs(vgdev->vdev);
> =20
> +	if (!vgdev)
> +		return;
> +

Pointer is dereferenced before being tested.

Best regards,
								Pavel
--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDsu0kACgkQMOfwapXb+vJjkQCfTnZfEObWPQ0KW+EVB/gjNplI
MTsAoLIl0zT4dRziH65vFg9CK41DHEHK
=xObD
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
