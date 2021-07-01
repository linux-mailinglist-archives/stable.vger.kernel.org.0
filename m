Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90213B9065
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 12:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhGAKSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 06:18:17 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52018 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbhGAKSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 06:18:17 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0799A1C0B77; Thu,  1 Jul 2021 12:15:46 +0200 (CEST)
Date:   Thu, 1 Jul 2021 12:15:45 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>
Subject: Re: [PATCH 5.10 016/101] drm/vc4: hdmi: Make sure the controller is
 powered in detect
Message-ID: <20210701101545.GA2423@amd>
References: <20210628142607.32218-1-sashal@kernel.org>
 <20210628142607.32218-17-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20210628142607.32218-17-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 9984d6664ce9dcbbc713962539eaf7636ea246c2 ]
>=20
> If the HPD GPIO is not available and drm_probe_ddc fails, we end up
> reading the HDMI_HOTPLUG register, but the controller might be powered
> off resulting in a CPU hang. Make sure we have the power domain and the
> HSM clock powered during the detect cycle to prevent the hang from
> happening.

If the WARN_ON ever triggers, we'll get unbalance on pm usage
counts. This should use pm_runtime_get_sync().

Plus, we don't really need to duplicate code at function exit.

Signed-off-by: Pavel Machek <pavel@denx.de>

> +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
> @@ -146,6 +146,8 @@ vc4_hdmi_connector_detect(struct drm_connector *conne=
ctor, bool force)
>  	struct vc4_hdmi *vc4_hdmi =3D connector_to_vc4_hdmi(connector);
>  	bool connected =3D false;
> =20
> +	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
> +
>  	if (vc4_hdmi->hpd_gpio) {
>  		if (gpio_get_value_cansleep(vc4_hdmi->hpd_gpio) ^
>  		    vc4_hdmi->hpd_active_low)
> @@ -167,10 +169,12 @@ vc4_hdmi_connector_detect(struct drm_connector *con=
nector, bool force)
>  			}
>  		}
> =20
> +		pm_runtime_put(&vc4_hdmi->pdev->dev);
>  		return connector_status_connected;
>  	}
> =20
>  	cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
> +	pm_runtime_put(&vc4_hdmi->pdev->dev);
>  	return connector_status_disconnected;
>  }
> =20

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 88a8cb840cd5..3b145f9f6c87 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -146,7 +146,7 @@ vc4_hdmi_connector_detect(struct drm_connector *connect=
or, bool force)
 	struct vc4_hdmi *vc4_hdmi =3D connector_to_vc4_hdmi(connector);
 	bool connected =3D false;
=20
-	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
+	WARN_ON(pm_runtime_get_sync(&vc4_hdmi->pdev->dev));
=20
 	if (vc4_hdmi->hpd_gpio) {
 		if (gpio_get_value_cansleep(vc4_hdmi->hpd_gpio) ^
@@ -168,12 +168,9 @@ vc4_hdmi_connector_detect(struct drm_connector *connec=
tor, bool force)
 				kfree(edid);
 			}
 		}
+	} else
+		cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
=20
-		pm_runtime_put(&vc4_hdmi->pdev->dev);
-		return connector_status_connected;
-	}
-
-	cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
 	pm_runtime_put(&vc4_hdmi->pdev->dev);
 	return connector_status_disconnected;
 }

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDdldEACgkQMOfwapXb+vIb9QCfUP/sNuiKsPVgcDxuC12gwWlu
+WYAoIkNG4hIPlFRo7RZH+jpQ/g2LyDN
=3ydh
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
