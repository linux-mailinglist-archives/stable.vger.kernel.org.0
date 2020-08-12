Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2232426B0
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHLIZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 04:25:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:51510 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgHLIZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 04:25:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8DFF8AC82;
        Wed, 12 Aug 2020 08:25:50 +0000 (UTC)
Subject: Re: [PATCH v1 4/4] drm/ast: Disable planes while switching display
 modes
To:     daniel@ffwll.ch
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, emil.l.velikov@gmail.com,
        dri-devel@lists.freedesktop.org, kraxel@redhat.com,
        airlied@redhat.com, stable@vger.kernel.org, sam@ravnborg.org
References: <20200805105428.2590-1-tzimmermann@suse.de>
 <20200805105428.2590-5-tzimmermann@suse.de>
 <20200807085000.GO6419@phenom.ffwll.local>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <890d87c0-195a-8d99-8132-417f2892eb8c@suse.de>
Date:   Wed, 12 Aug 2020 10:25:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200807085000.GO6419@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NPwxnoXLmt9GgPkGomnSwO58kDd9W7RpA"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NPwxnoXLmt9GgPkGomnSwO58kDd9W7RpA
Content-Type: multipart/mixed; boundary="odFEuavhCWfmgVN8VQ8k4xZsFUZmua3kU";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: daniel@ffwll.ch
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, emil.l.velikov@gmail.com,
 dri-devel@lists.freedesktop.org, kraxel@redhat.com, airlied@redhat.com,
 stable@vger.kernel.org, sam@ravnborg.org
Message-ID: <890d87c0-195a-8d99-8132-417f2892eb8c@suse.de>
Subject: Re: [PATCH v1 4/4] drm/ast: Disable planes while switching display
 modes
References: <20200805105428.2590-1-tzimmermann@suse.de>
 <20200805105428.2590-5-tzimmermann@suse.de>
 <20200807085000.GO6419@phenom.ffwll.local>
In-Reply-To: <20200807085000.GO6419@phenom.ffwll.local>

--odFEuavhCWfmgVN8VQ8k4xZsFUZmua3kU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 07.08.20 um 10:50 schrieb daniel@ffwll.ch:
> On Wed, Aug 05, 2020 at 12:54:28PM +0200, Thomas Zimmermann wrote:
>> The ast HW cursor requires the primary plane and CRTC to display at
>> a valid mode and format. This is not the case while switching
>> display modes, which can lead to the screen turing permanently dark.
>>
>> As a workaround, the ast driver now disables active planes while the
>> mode or format switch takes place. It also synchronizes with the verti=
cal
>> refresh to give CRTC and planes some time to catch up on each other.
>> The active planes planes (primary or cursor) will be re-enabled by
>> each plane's atomic_update() function.
>>
>> v2:
>> 	* move the logic into the commit-tail function
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Fixes: 4961eb60f145 ("drm/ast: Enable atomic modesetting")
>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>> Cc: Gerd Hoffmann <kraxel@redhat.com>
>> Cc: Dave Airlie <airlied@redhat.com>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: Emil Velikov <emil.l.velikov@gmail.com>
>> Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
>> Cc: <stable@vger.kernel.org> # v5.6+
>> ---
>>  drivers/gpu/drm/ast/ast_drv.h  |  2 +
>>  drivers/gpu/drm/ast/ast_mode.c | 68 ++++++++++++++++++++++++++++++++-=
-
>>  2 files changed, 66 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_d=
rv.h
>> index c1af6b725933..467049ca8430 100644
>> --- a/drivers/gpu/drm/ast/ast_drv.h
>> +++ b/drivers/gpu/drm/ast/ast_drv.h
>> @@ -177,6 +177,8 @@ struct ast_private *ast_device_create(struct drm_d=
river *drv,
>> =20
>>  #define AST_IO_MM_OFFSET		(0x380)
>> =20
>> +#define AST_IO_VGAIR1_VREFRESH		BIT(3)
>> +
>>  #define __ast_read(x) \
>>  static inline u##x ast_read##x(struct ast_private *ast, u32 reg) { \
>>  u##x val =3D 0;\
>> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_=
mode.c
>> index ae5cb0a333f7..a379d51f3543 100644
>> --- a/drivers/gpu/drm/ast/ast_mode.c
>> +++ b/drivers/gpu/drm/ast/ast_mode.c
>> @@ -514,6 +514,17 @@ static void ast_set_start_address_crt1(struct ast=
_private *ast,
>> =20
>>  }
>> =20
>> +static void ast_wait_for_vretrace(struct ast_private *ast)
>> +{
>> +	unsigned long timeout =3D jiffies + HZ;
>> +	u8 vgair1;
>> +
>> +	do {
>> +		vgair1 =3D ast_io_read8(ast, AST_IO_INPUT_STATUS1_READ);
>> +	} while (!(vgair1 & AST_IO_VGAIR1_VREFRESH) &&
>> +		 time_before(jiffies, timeout));
>> +}
>> +
>>  /*
>>   * Primary plane
>>   */
>> @@ -1043,23 +1054,72 @@ static int ast_connector_init(struct drm_devic=
e *dev)
>>   * Mode config
>>   */
>> =20
>> +static bool
>> +ast_crtc_needs_planes_disabled(struct drm_crtc_state *old_crtc_state,=

>> +			       struct drm_crtc_state *new_crtc_state)
>> +{
>> +	struct ast_crtc_state *old_ast_crtc_state, *new_ast_crtc_state;
>> +
>> +	if (drm_atomic_crtc_needs_modeset(new_crtc_state))
>> +		return true;
>> +
>> +	old_ast_crtc_state =3D to_ast_crtc_state(old_crtc_state);
>> +	new_ast_crtc_state =3D to_ast_crtc_state(new_crtc_state);
>> +
>> +	if (old_ast_crtc_state->format !=3D new_ast_crtc_state->format)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>  static void
>>  ast_mode_config_helper_commit_tail(struct drm_atomic_state *old_state=
)
>>  {
>>  	struct drm_device *dev =3D old_state->dev;
>> +	struct ast_private *ast =3D to_ast_private(dev);
>> +	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
>> +	struct drm_crtc *crtc;
>> +	int i;
>> +	bool wait_for_vretrace =3D false;
>> =20
>>  	drm_atomic_helper_commit_modeset_disables(dev, old_state);
>> =20
>> -	drm_atomic_helper_commit_planes(dev, old_state, 0);
>> +	/*
>> +	 * HW cursors require the underlying primary plane and CRTC to
>> +	 * display a valid mode and image. This is not the case during
>> +	 * full modeset operations. So we temporarily disable any active
>> +	 * plane, including the HW cursor. Each plane's atomic_update()
>> +	 * helper will re-enable it if necessary.
>> +	 *
>> +	 * We only do this during *full* modesets. It does not affect
>> +	 * simple pageflips on the planes.
>> +	 */
>> +	for_each_oldnew_crtc_in_state(old_state, crtc,
>> +				      old_crtc_state,
>> +				      new_crtc_state, i) {
>> +		if (!ast_crtc_needs_planes_disabled(old_crtc_state,
>> +						    new_crtc_state))
>> +			continue;
>> +		drm_atomic_helper_disable_planes_on_crtc(old_crtc_state,
>> +							 false);
>> +		wait_for_vretrace =3D true;
>> +	}
>=20
> Hm this still feels like you're fighting the framework more than using =
it.
> Comment here, but it's kinda review comments on the entire series.
>=20
> - ast_crtc_needs_planes_disabled feels a bit strange, the usual way to
>   handle this kind of stuff is to set crtc_state->needs_modeset from yo=
ur
>   plane's atomic_check function. You might need your own atomic_check
>   implementation for that, so that after the plane checks you run the
>   modeset checks again.
>=20
> - with that you can put your call here to disable all planes into the c=
rtc
>   ->atomic_disable callback. You can then also put the
>   ast_wait_for_retrace in there, at the end.

The CRTC's atomic_disable/enable only run if needs_modeset() is true.

I brought back support for fast format changes of the primary plane.
Moving that code into atomic_disable/enable would require to set
needs_modeset in atomic_check() for format changes. And later figure out
in atomic_disable/enable if it's really a modeset or just a change of
the format. That's not good either.

Best regards
Thomas

>=20
>> +
>> +	/*
>> +	 * Ensure that no scanout takes place before reprogramming mode
>> +	 * and format registers.
>> +	 */
>> +	if (wait_for_vretrace)
>> +		ast_wait_for_vretrace(ast);
>> +
>> +	drm_atomic_helper_commit_planes(dev, old_state,
>> +					DRM_PLANE_COMMIT_ACTIVE_ONLY);
>=20
> This order also feels a bit strange, especially with the first 2 patche=
s
> where you put the crtc modeset code into atomic_begin. It feels a bit l=
ike
> if you do the plane commit _after_ modeset enables, then you could move=

> the crtc code into the crtc ->atomic_enable hook, and then let the plan=
e
> update stuff roll through all in commit_planes. Moving the modset code
> into atomic_begin at least suggests you want modeset enables before pla=
ne
> commit, and lots of drivers have that sequence in their commit_tail. It=
's
> even a default implementation with drm_atomic_helper_commit_tail_rpm.
>=20
> Sorry this is all dragging around so much, figuring out the best atomic=

> flow is occasionally a bit an endeavour :-/
>=20
> Cheers, Daniel
>=20
>> =20
>>  	drm_atomic_helper_commit_modeset_enables(dev, old_state);
>> =20
>>  	drm_atomic_helper_fake_vblank(old_state);
>> -
>>  	drm_atomic_helper_commit_hw_done(old_state);
>> -
>>  	drm_atomic_helper_wait_for_vblanks(dev, old_state);
>> -
>>  	drm_atomic_helper_cleanup_planes(dev, old_state);
>>  }
>> =20
>> --=20
>> 2.28.0
>>
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--odFEuavhCWfmgVN8VQ8k4xZsFUZmua3kU--

--NPwxnoXLmt9GgPkGomnSwO58kDd9W7RpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFIBAEBCAAyFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl8zp3UUHHR6aW1tZXJt
YW5uQHN1c2UuZGUACgkQaA3BHVMLeiNM9wf+PA/UuQL//X1F6koRVechnnXZY62i
Dgver71sH1VX6EJEzFDbslk2eYZuwi60UWrfr0nATxViaIcfTBYjTNlEet1XjjSa
Ep0y9u1DZ9XV+dme2aC7zITKat3IDAJzJfgdntBieuGgl/ydQAHU22cto84112Ph
NN1i4xJkwSjXtwHPbtbgn6MSx/HyGY5uLqZ81tlLTfvOQrHdLhAsvVEtkXTLNpK3
j6Phv5ncSFNsq3xMHNyiy01cqyoO2oG6WTQLjUMx0lvOG4VLQNCivAZLyCnD8Hqd
KmHvbEOHlYmlqjLvQLgSpDiUwkm88mKOaJ6hkFuUTfNCjKatX8MIh9BQ9A==
=2BYN
-----END PGP SIGNATURE-----

--NPwxnoXLmt9GgPkGomnSwO58kDd9W7RpA--
