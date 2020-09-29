Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D90727BD64
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 08:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbgI2GxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 02:53:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:49006 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgI2GxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 02:53:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C20E5AA55;
        Tue, 29 Sep 2020 06:53:10 +0000 (UTC)
Subject: Re: [PATCH v1 1/2] drm/rockchip: fix build due to undefined
 drm_gem_cma_vm_ops
To:     Sam Ravnborg <sam@ravnborg.org>, dri-devel@lists.freedesktop.org,
        Heiko Stuebner <heiko@sntech.de>
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, stable@vger.kernel.org
References: <20200925215524.2899527-1-sam@ravnborg.org>
 <20200925215524.2899527-2-sam@ravnborg.org>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <83650213-3b09-aea0-4485-cd20de1d9548@suse.de>
Date:   Tue, 29 Sep 2020 08:53:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925215524.2899527-2-sam@ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6YHHtMbT7KHuJuTcxyCa8HKASYuntrLh1"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6YHHtMbT7KHuJuTcxyCa8HKASYuntrLh1
Content-Type: multipart/mixed; boundary="a4Uvht4Eoz86hwhsz3CYNBhxRUzoaASBQ";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>, dri-devel@lists.freedesktop.org,
 Heiko Stuebner <heiko@sntech.de>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 Sandy Huang <hjc@rock-chips.com>, stable@vger.kernel.org
Message-ID: <83650213-3b09-aea0-4485-cd20de1d9548@suse.de>
Subject: Re: [PATCH v1 1/2] drm/rockchip: fix build due to undefined
 drm_gem_cma_vm_ops
References: <20200925215524.2899527-1-sam@ravnborg.org>
 <20200925215524.2899527-2-sam@ravnborg.org>
In-Reply-To: <20200925215524.2899527-2-sam@ravnborg.org>

--a4Uvht4Eoz86hwhsz3CYNBhxRUzoaASBQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Sam

Am 25.09.20 um 23:55 schrieb Sam Ravnborg:
> Commit 0d590af3140d ("drm/rockchip: Convert to drm_gem_object_funcs")
> introduced the following build error:
>=20
> rockchip_drm_gem.c:304:13: error: =E2=80=98drm_gem_cma_vm_ops=E2=80=99 =
undeclared here
>   304 |  .vm_ops =3D &drm_gem_cma_vm_ops,
>       |             ^~~~~~~~~~~~~~~~~~
>       |             drm_gem_mmap_obj
>=20
> Fixed by adding missing include file.
>=20
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Didn't you review exactly this change yesterday? Anyway, you should add

Fixes: 0d590af3140d ("drm/rockchip: Convert to drm_gem_object_funcs")

and

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

It might happen that I land my patch first, depending on the urgency of
the issue.

Best regards
Thomas

> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Sandy Huang <hjc@rock-chips.com>
> Cc: "Heiko St=C3=BCbner" <heiko@sntech.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-rockchip@lists.infradead.org
> ---
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/=
drm/rockchip/rockchip_drm_gem.c
> index bb3578469b03..6da15faf0192 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
> @@ -10,6 +10,7 @@
> =20
>  #include <drm/drm.h>
>  #include <drm/drm_gem.h>
> +#include <drm/drm_gem_cma_helper.h>
>  #include <drm/drm_prime.h>
>  #include <drm/drm_vma_manager.h>
> =20
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--a4Uvht4Eoz86hwhsz3CYNBhxRUzoaASBQ--

--6YHHtMbT7KHuJuTcxyCa8HKASYuntrLh1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFIBAEBCAAyFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl9y2dUUHHR6aW1tZXJt
YW5uQHN1c2UuZGUACgkQaA3BHVMLeiOlhgf8DYDzFCpHX12ZpZHqFk3OQ9J9L89O
pGoo9DVE8T363kMseRMt4gjR/MqCz6x9iaQj5Eh+9wFomogly/P4dIiZvuWXT4qI
siLNbwiRT9VC3a4BqsI+bU938ftr+0fTV4J9BqVCr/arFBKhKldyofvXYtJK2stm
58BPLvKLF9C7aORDCFA8+YMTgIuIALOtr9k6+W3K9PqcC1oG7QdvK8Yv7cop2hI3
hD+j0qqPtI20sDcqEm2zs3vt6qMLSqvd29n3ax27FMu862XIp3n+d7v6qWhK67L8
EdEoRjJG1gFjZ5fEzhMCs+iH16OrfKAicd6sYApBCgr4rq1obJmkLjlTzA==
=qy3O
-----END PGP SIGNATURE-----

--6YHHtMbT7KHuJuTcxyCa8HKASYuntrLh1--
