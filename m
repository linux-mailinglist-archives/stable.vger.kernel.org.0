Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB92222EB4D
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 13:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgG0Lhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 07:37:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:40154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgG0Lhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 07:37:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 748D5ADB5;
        Mon, 27 Jul 2020 11:37:53 +0000 (UTC)
Subject: Re: [PATCH 2/3] drm/ast: Store image size in HW cursor info
To:     daniel@ffwll.ch
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, emil.l.velikov@gmail.com,
        dri-devel@lists.freedesktop.org, kraxel@redhat.com,
        airlied@redhat.com, stable@vger.kernel.org, sam@ravnborg.org
References: <20200727073707.21097-1-tzimmermann@suse.de>
 <20200727073707.21097-3-tzimmermann@suse.de>
 <20200727104250.GV6419@phenom.ffwll.local>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <8c92a1c5-59b8-6b36-5c45-20783b5435eb@suse.de>
Date:   Mon, 27 Jul 2020 13:37:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727104250.GV6419@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CmuSZk7dK7cCWP7ppEw3yAZs6wc1aPuGD"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CmuSZk7dK7cCWP7ppEw3yAZs6wc1aPuGD
Content-Type: multipart/mixed; boundary="moSum8Rl9rGkQ40nN1I6ufdPQr9ySwFxF";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: daniel@ffwll.ch
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, emil.l.velikov@gmail.com,
 dri-devel@lists.freedesktop.org, kraxel@redhat.com, airlied@redhat.com,
 stable@vger.kernel.org, sam@ravnborg.org
Message-ID: <8c92a1c5-59b8-6b36-5c45-20783b5435eb@suse.de>
Subject: Re: [PATCH 2/3] drm/ast: Store image size in HW cursor info
References: <20200727073707.21097-1-tzimmermann@suse.de>
 <20200727073707.21097-3-tzimmermann@suse.de>
 <20200727104250.GV6419@phenom.ffwll.local>
In-Reply-To: <20200727104250.GV6419@phenom.ffwll.local>

--moSum8Rl9rGkQ40nN1I6ufdPQr9ySwFxF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 27.07.20 um 12:42 schrieb daniel@ffwll.ch:
> On Mon, Jul 27, 2020 at 09:37:06AM +0200, Thomas Zimmermann wrote:
>> Store the image size as part of the HW cursor info, so that the
>> cursor show function doesn't require the information from the
>> caller. No functional changes.
>=20
> Uh just pass the state structure and done? All these "store random stuf=
f
> in private structures" (they're not even atomic state structures, it's =
the
> driver private thing even!) is very non-atomic. And I see zero reasons =
why
> you have to do this, the cursor stays around.

It's not random stuff. Ast cannot use ARGB8888 for cursors. Anything in
ast_private.cursor represents cursor hardware state (not DRM state);
duplicated for double buffering.

 * gbo: two perma-pinned GEM objects at the end of VRAM. It's the HW
cursor buffer in ARGB4444 format. The userspace's cursor image is
converted to ARGB4444 and copied into the current backbuffer.

 * vaddr: A mapping of the gbo's into kernel address space. We don't
want to map the gbo on each update, so they are mapped once and the
kernel address is stored in vaddr.

 * size: the size of each HW buffer. We could use the value in the fb,
but storing this as well makes the cursor code self-contained.

Best regards
Thomas

> -Daniel
>=20
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
>>  drivers/gpu/drm/ast/ast_cursor.c | 13 +++++++++++--
>>  drivers/gpu/drm/ast/ast_drv.h    |  7 +++++--
>>  drivers/gpu/drm/ast/ast_mode.c   |  8 +-------
>>  3 files changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/ast/ast_cursor.c b/drivers/gpu/drm/ast/as=
t_cursor.c
>> index acf0d23514e8..8642a0ce9da6 100644
>> --- a/drivers/gpu/drm/ast/ast_cursor.c
>> +++ b/drivers/gpu/drm/ast/ast_cursor.c
>> @@ -87,6 +87,8 @@ int ast_cursor_init(struct ast_private *ast)
>> =20
>>  		ast->cursor.gbo[i] =3D gbo;
>>  		ast->cursor.vaddr[i] =3D vaddr;
>> +		ast->cursor.size[i].width =3D 0;
>> +		ast->cursor.size[i].height =3D 0;
>>  	}
>> =20
>>  	return drmm_add_action_or_reset(dev, ast_cursor_release, NULL);
>> @@ -194,6 +196,9 @@ int ast_cursor_blit(struct ast_private *ast, struc=
t drm_framebuffer *fb)
>>  	/* do data transfer to cursor BO */
>>  	update_cursor_image(dst, src, fb->width, fb->height);
>> =20
>> +	ast->cursor.size[ast->cursor.next_index].width =3D fb->width;
>> +	ast->cursor.size[ast->cursor.next_index].height =3D fb->height;
>> +
>>  	drm_gem_vram_vunmap(gbo, src);
>>  	drm_gem_vram_unpin(gbo);
>> =20
>> @@ -249,14 +254,18 @@ static void ast_cursor_set_location(struct ast_p=
rivate *ast, u16 x, u16 y,
>>  	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xc7, y1);
>>  }
>> =20
>> -void ast_cursor_show(struct ast_private *ast, int x, int y,
>> -		     unsigned int offset_x, unsigned int offset_y)
>> +void ast_cursor_show(struct ast_private *ast, int x, int y)
>>  {
>> +	unsigned int offset_x, offset_y;
>>  	u8 x_offset, y_offset;
>>  	u8 __iomem *dst, __iomem *sig;
>>  	u8 jreg;
>> =20
>>  	dst =3D ast->cursor.vaddr[ast->cursor.next_index];
>> +	offset_x =3D AST_MAX_HWC_WIDTH -
>> +		   ast->cursor.size[ast->cursor.next_index].width;
>> +	offset_y =3D AST_MAX_HWC_HEIGHT -
>> +		   ast->cursor.size[ast->cursor.next_index].height;
>> =20
>>  	sig =3D dst + AST_HWC_SIZE;
>>  	writel(x, sig + AST_HWC_SIGNATURE_X);
>> diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_d=
rv.h
>> index e3a264ac7ee2..57414b429db3 100644
>> --- a/drivers/gpu/drm/ast/ast_drv.h
>> +++ b/drivers/gpu/drm/ast/ast_drv.h
>> @@ -116,6 +116,10 @@ struct ast_private {
>>  	struct {
>>  		struct drm_gem_vram_object *gbo[AST_DEFAULT_HWC_NUM];
>>  		void __iomem *vaddr[AST_DEFAULT_HWC_NUM];
>> +		struct {
>> +			unsigned int width;
>> +			unsigned int height;
>> +		} size[AST_DEFAULT_HWC_NUM];
>>  		unsigned int next_index;
>>  	} cursor;
>> =20
>> @@ -311,8 +315,7 @@ void ast_release_firmware(struct drm_device *dev);=

>>  int ast_cursor_init(struct ast_private *ast);
>>  int ast_cursor_blit(struct ast_private *ast, struct drm_framebuffer *=
fb);
>>  void ast_cursor_page_flip(struct ast_private *ast);
>> -void ast_cursor_show(struct ast_private *ast, int x, int y,
>> -		     unsigned int offset_x, unsigned int offset_y);
>> +void ast_cursor_show(struct ast_private *ast, int x, int y);
>>  void ast_cursor_hide(struct ast_private *ast);
>> =20
>>  #endif
>> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_=
mode.c
>> index 3680a000b812..5b2b39c93033 100644
>> --- a/drivers/gpu/drm/ast/ast_mode.c
>> +++ b/drivers/gpu/drm/ast/ast_mode.c
>> @@ -671,20 +671,14 @@ ast_cursor_plane_helper_atomic_update(struct drm=
_plane *plane,
>>  				      struct drm_plane_state *old_state)
>>  {
>>  	struct drm_plane_state *state =3D plane->state;
>> -	struct drm_framebuffer *fb =3D state->fb;
>>  	struct ast_private *ast =3D plane->dev->dev_private;
>> -	unsigned int offset_x, offset_y;
>> -
>> -	offset_x =3D AST_MAX_HWC_WIDTH - fb->width;
>> -	offset_y =3D AST_MAX_HWC_WIDTH - fb->height;
>> =20
>>  	if (state->fb !=3D old_state->fb) {
>>  		/* A new cursor image was installed. */
>>  		ast_cursor_page_flip(ast);
>>  	}
>> =20
>> -	ast_cursor_show(ast, state->crtc_x, state->crtc_y,
>> -			offset_x, offset_y);
>> +	ast_cursor_show(ast, state->crtc_x, state->crtc_y);
>>  }
>> =20
>>  static void
>> --=20
>> 2.27.0
>>
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--moSum8Rl9rGkQ40nN1I6ufdPQr9ySwFxF--

--CmuSZk7dK7cCWP7ppEw3yAZs6wc1aPuGD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFIBAEBCAAyFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl8evIMUHHR6aW1tZXJt
YW5uQHN1c2UuZGUACgkQaA3BHVMLeiOaewf/Td1IsttQNF4KERc+23/KgYJuRF6A
jZeW2ilwy1wROmTGi3mCDMMt/puu1MYJU7tP3RErO/n6y7HK2UVDkoX/g55JThdt
fopg2FZYmqXMNzEQAdgMHPrhv3fwSGtwhp+yp1Kcp2Hecu72Fkzqzmj/2d9Uz00x
VimEC7GsmAFkQwdlI+X+RuHaHHugXctFVwQBH8TZuxdPRVRsLuaQkTc/AXX9nH3j
Wf56Ce5dBzcTWfdJhBmZjFAkFsEnOTj11rAgzhzEJhSbG3A0TW/s1c0dbi0ga31o
MN0i5/m74tIXFaGn5N6ftwOUsgz1jy8IYjsYJdZWcMLbbupJJJt5sUFhzw==
=IeIN
-----END PGP SIGNATURE-----

--CmuSZk7dK7cCWP7ppEw3yAZs6wc1aPuGD--
