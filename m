Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0083268CB
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 21:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhBZUd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 15:33:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42752 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhBZUd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 15:33:57 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 29B5B1C0B8A; Fri, 26 Feb 2021 21:33:13 +0100 (CET)
Date:   Fri, 26 Feb 2021 21:33:12 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, stern@rowland.harvard.edu,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH v5] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <20210226203312.GA3379@duo.ucw.cz>
References: <20210226092648.4584-1-tzimmermann@suse.de>
 <YDkBuu0AhZy+C/Y/@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <YDkBuu0AhZy+C/Y/@phenom.ffwll.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> > +	struct device *dmadev;
> > +	struct drm_gem_object *obj;
> > +
> > +	if (!dev_is_usb(dev->dev))
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	dmadev =3D usb_intf_get_dma_device(to_usb_interface(dev->dev));
> > +	if (drm_WARN_ONCE(dev, !dmadev, "buffer sharing not supported"))
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	obj =3D drm_gem_prime_import_dev(dev, dma_buf, dmadev);
> > +
> > +	put_device(dmadev);
>=20
> Just realized there's another can of worms here because dma_buf_attach
> does not refcount the struct device. But the dma_buf can easily outlive
> the underlying device, at least right now.
>=20
> We should probably require that devices get rid of all their mappings in
> their hotunplug code.
>=20
> Ofc now that we pick some random other device struct this gets kinda
> worse.
>=20
> Anyway, also just another pre-existing condition that we should worry
> about here. It's all still a very bad hack.

This is actually regression fix if I understand this correctly. Bug
means udl is unusable, so that's kind of bad.

Should we revert the original commit causing this while this get
sorted out?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDlbCAAKCRAw5/Bqldv6
8j4pAJ4pMO1Nkx0d7xHie+0D2+0Scx6kHgCeOO4KKjPOZuK7ZRg1nTfB7wz7+Rc=
=n8h1
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
