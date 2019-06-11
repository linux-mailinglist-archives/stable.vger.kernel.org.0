Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4090E3C5E5
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 10:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404650AbfFKI1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 04:27:08 -0400
Received: from smtp.bonedaddy.net ([45.33.94.42]:50278 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403996AbfFKI1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 04:27:08 -0400
Received: from chianamo (n58-108-67-123.per1.wa.optusnet.com.au [58.108.67.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id 956FB180041;
        Tue, 11 Jun 2019 04:27:03 -0400 (EDT)
Message-ID: <08ffd10ecac7e684503ce55b0f929ac856b9b76b.camel@bonedaddy.net>
Subject: Re: [PATCH v2] drm: add fallback override/firmware EDID modes
 workaround
From:   Paul Wise <pabs3@bonedaddy.net>
To:     Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@cs.helsinki.fi>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Harish Chegondi <harish.chegondi@intel.com>
In-Reply-To: <20190610093054.28445-1-jani.nikula@intel.com>
References: <20190607110513.12072-2-jani.nikula@intel.com>
         <20190610093054.28445-1-jani.nikula@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-9hW4Nd8WB8C0i0szl6Tm"
Date:   Tue, 11 Jun 2019 16:27:00 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.30.5-1.1 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-9hW4Nd8WB8C0i0szl6Tm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-06-10 at 12:30 +0300, Jani Nikula wrote:
> We've moved the override and firmware EDID (simply "override EDID" from
> now on) handling to the low level drm_do_get_edid() function in order to
> transparently use the override throughout the stack. The idea is that
> you get the override EDID via the ->get_modes() hook.
>=20
> Unfortunately, there are scenarios where the DDC probe in drm_get_edid()
> called via ->get_modes() fails, although the preceding ->detect()
> succeeds.
>=20
> In the case reported by Paul Wise, the ->detect() hook,
> intel_crt_detect(), relies on hotplug detect, bypassing the DDC. In the
> case reported by Ilpo J=C3=A4rvinen, there is no ->detect() hook, which i=
s
> interpreted as connected. The subsequent DDC probe reached via
> ->get_modes() fails, and we don't even look at the override EDID,
> resulting in no modes being added.
>=20
> Because drm_get_edid() is used via ->detect() all over the place, we
> can't trivially remove the DDC probe, as it leads to override EDID
> effectively meaning connector forcing. The goal is that connector
> forcing and override EDID remain orthogonal.
>=20
> Generally, the underlying problem here is the conflation of ->detect()
> and ->get_modes() via drm_get_edid(). The former should just detect, and
> the latter should just get the modes, typically via reading the EDID. As
> long as drm_get_edid() is used in ->detect(), it needs to retain the DDC
> probe. Or such users need to have a separate DDC probe step first.
>=20
> The EDID caching between ->detect() and ->get_modes() done by some
> drivers is a further complication that prevents us from making
> drm_do_get_edid() adapt to the two cases.
>=20
> Work around the regression by falling back to a separate attempt at
> getting the override EDID at drm_helper_probe_single_connector_modes()
> level. With a working DDC and override EDID, it'll never be called; the
> override EDID will come via ->get_modes(). There will still be a failing
> DDC probe attempt in the cases that require the fallback.
>=20
> v2:
> - Call drm_connector_update_edid_property (Paul)
> - Update commit message about EDID caching (Daniel)
>=20
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D107583
> Reported-by: Paul Wise <pabs3@bonedaddy.net>
> Cc: Paul Wise <pabs3@bonedaddy.net>
> References: http://mid.mail-archive.com/alpine.DEB.2.20.1905262211270.243=
90@whs-18.cs.helsinki.fi
> Reported-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> Cc: Ilpo J=C3=A4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> References: 15f080f08d48 ("drm/edid: respect connector force for drm_get_=
edid ddc probe")
> Fixes: 53fd40a90f3c ("drm: handle override and firmware EDID at drm_do_ge=
t_edid() level")
> Cc: <stable@vger.kernel.org> # v4.15+
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Cc: Harish Chegondi <harish.chegondi@intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  drivers/gpu/drm/drm_edid.c         | 30 ++++++++++++++++++++++++++++++
>  drivers/gpu/drm/drm_probe_helper.c |  7 +++++++
>  include/drm/drm_edid.h             |  1 +
>  3 files changed, 38 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index c59a1e8c5ada..9d8f2b952004 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -1587,6 +1587,36 @@ static struct edid *drm_get_override_edid(struct d=
rm_connector *connector)
>  	return IS_ERR(override) ? NULL : override;
>  }
> =20
> +/**
> + * drm_add_override_edid_modes - add modes from override/firmware EDID
> + * @connector: connector we're probing
> + *
> + * Add modes from the override/firmware EDID, if available. Only to be u=
sed from
> + * drm_helper_probe_single_connector_modes() as a fallback for when DDC =
probe
> + * failed during drm_get_edid() and caused the override/firmware EDID to=
 be
> + * skipped.
> + *
> + * Return: The number of modes added or 0 if we couldn't find any.
> + */
> +int drm_add_override_edid_modes(struct drm_connector *connector)
> +{
> +	struct edid *override;
> +	int num_modes =3D 0;
> +
> +	override =3D drm_get_override_edid(connector);
> +	if (override) {
> +		drm_connector_update_edid_property(connector, override);
> +		num_modes =3D drm_add_edid_modes(connector, override);
> +		kfree(override);
> +
> +		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] adding %d modes via fallback override=
/firmware EDID\n",
> +			      connector->base.id, connector->name, num_modes);
> +	}
> +
> +	return num_modes;
> +}
> +EXPORT_SYMBOL(drm_add_override_edid_modes);
> +
>  /**
>   * drm_do_get_edid - get EDID data using a custom EDID block read functi=
on
>   * @connector: connector we're probing
> diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_pro=
be_helper.c
> index 01e243f1ea94..ef2c468205a2 100644
> --- a/drivers/gpu/drm/drm_probe_helper.c
> +++ b/drivers/gpu/drm/drm_probe_helper.c
> @@ -480,6 +480,13 @@ int drm_helper_probe_single_connector_modes(struct d=
rm_connector *connector,
> =20
>  	count =3D (*connector_funcs->get_modes)(connector);
> =20
> +	/*
> +	 * Fallback for when DDC probe failed in drm_get_edid() and thus skippe=
d
> +	 * override/firmware EDID.
> +	 */
> +	if (count =3D=3D 0 && connector->status =3D=3D connector_status_connect=
ed)
> +		count =3D drm_add_override_edid_modes(connector);
> +
>  	if (count =3D=3D 0 && connector->status =3D=3D connector_status_connect=
ed)
>  		count =3D drm_add_modes_noedid(connector, 1024, 768);
>  	count +=3D drm_helper_probe_add_cmdline_mode(connector);
> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
> index 88b63801f9db..b9719418c3d2 100644
> --- a/include/drm/drm_edid.h
> +++ b/include/drm/drm_edid.h
> @@ -478,6 +478,7 @@ struct edid *drm_get_edid_switcheroo(struct drm_conne=
ctor *connector,
>  				     struct i2c_adapter *adapter);
>  struct edid *drm_edid_duplicate(const struct edid *edid);
>  int drm_add_edid_modes(struct drm_connector *connector, struct edid *edi=
d);
> +int drm_add_override_edid_modes(struct drm_connector *connector);
> =20
>  u8 drm_match_cea_mode(const struct drm_display_mode *to_match);
>  enum hdmi_picture_aspect drm_get_cea_aspect_ratio(const u8 video_code);

Tested-by: Paul Wise <pabs3@bonedaddy.net>

This version looks good to me.

Both the EDID override data and the resolution are fixed.

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-9hW4Nd8WB8C0i0szl6Tm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAlz/ZdAACgkQMRa6Xp/6
aaMQ5Q/9F/MwBs2IOnXgGF4i86yn6S47bFjfJC17xXsD0vqDd+VzXCTm5kykSSwk
umFaIWlH2/6gFYOd4wP6S0BOU/jzUbNM/JASTepAla+RDCyJ24twaqRx2vNMHehB
WflUP/4CwFvA/oLgk2+Cz7Qu07RJ5iYJUCwIYXukqkfnTV0ooTUfgzlYRJMGKLt9
wmqy+JApuqz/7Nef7Txlha51m3HL0PG+gQEpZ8DwRTazVC1yfqhkKguKZJOcx1pp
0kfo69zA6OXghyr1JuqG4upJiXtTrc9lIHb7XzScCO4hDPdnFL/DTk09ku8a4T1M
l+ZZUX0W3lXYp0Yo9ikVEoyt5d15u9qdg5Dem/6EwlBnd4tD2jFU37PvX2Rsht7r
9OmlltcjVesZK46jVVaOTFfNXzXTFqLtTzOgZ3PwLiKeUwMn12kSncALQRqNDyDW
zaVIYM0Z8NPBt9FtD1i6O4IxHzkXD2aSnvpNgtD3M+XhodfGsQPoZGoCfBTQvWD0
v6DjFzHDa5hJ4zO8fcdNPcH9JGvoBI7hf3CMwmf1fmlTN7vkQGd3hp5Z/uyksT0e
0smRbnOl8Cpp3ApxyE+Yv3YFYqpIP9IdDTe3lStMGu47/QdrgsNC+N4RaYe0nNCR
V9Set1zHTj9M0L3Ffr6FGT9LVTbdQ7LyW5RKIiOfHJw94gBJHBI=
=RCQ7
-----END PGP SIGNATURE-----

--=-9hW4Nd8WB8C0i0szl6Tm--

