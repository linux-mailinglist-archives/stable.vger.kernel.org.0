Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E862AFB1B3
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 14:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKMNti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 08:49:38 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:47544 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfKMNti (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 08:49:38 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 68EB71C1250; Wed, 13 Nov 2019 14:49:36 +0100 (CET)
Date:   Wed, 13 Nov 2019 14:49:36 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 093/125] usb: gadget: configfs: fix concurrent issue
 between composite APIs
Message-ID: <20191113134935.GA20980@duo.ucw.cz>
References: <20191111181438.945353076@linuxfoundation.org>
 <20191111181452.322265396@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20191111181452.322265396@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-11-11 19:28:52, Greg Kroah-Hartman wrote:
> From: Peter Chen <peter.chen@nxp.com>
>=20
> [ Upstream commit 1a1c851bbd706ea9f3a9756c2d3db28523506d3b ]
>=20
> We meet several NULL pointer issues if configfs_composite_unbind
> and composite_setup (or composite_disconnect) are running together.
> These issues occur when do the function switch stress test, the
> configfs_compsoite_unbind is called from user mode by
> echo "" to /sys/../UDC entry, and meanwhile, the setup interrupt
> or disconnect interrupt occurs by hardware. The composite_setup

> +++ b/drivers/usb/gadget/configfs.c
> @@ -61,6 +61,8 @@ struct gadget_info {
>  	bool use_os_desc;
>  	char b_vendor_code;
>  	char qw_sign[OS_STRING_QW_SIGN_LEN];
> +	spinlock_t spinlock;
> +	bool unbind;
>  };
> =20
>  static inline struct gadget_info *to_gadget_info(struct config_item *ite=
m)
> @@ -1244,6 +1246,7 @@ static int configfs_composite_bind(struct usb_gadge=
t *gadget,
>  	int				ret;
> =20
>  	/* the gi->lock is hold by the caller */
> +	gi->unbind =3D 0;
>  	cdev->gadget =3D gadget;

Since variable is bool, I'd expect "=3D false" here?

> +	unsigned long flags;
> =20
>  	/* the gi->lock is hold by the caller */

"is held".

>  	cdev =3D get_gadget_data(gadget);
>  	gi =3D container_of(cdev, struct gadget_info, cdev);
> +	spin_lock_irqsave(&gi->spinlock, flags);
> +	gi->unbind =3D 1;

=3D true;

> +static int configfs_composite_setup(struct usb_gadget *gadget,
> +		const struct usb_ctrlrequest *ctrl)
> +{
> +	struct usb_composite_dev *cdev;
> +	struct gadget_info *gi;
> +	unsigned long flags;
> +	int ret;
> +
> +	cdev =3D get_gadget_data(gadget);
> +	if (!cdev)
> +		return 0;
> +
> +	gi =3D container_of(cdev, struct gadget_info, cdev);
> +	spin_lock_irqsave(&gi->spinlock, flags);
> +	cdev =3D get_gadget_data(gadget);

cdev already contains required value, why get it second time? (If it
needs to be done under lock, comment might be useful...)


Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXcwJ7wAKCRAw5/Bqldv6
8hTcAKCkZ8+lOfe0KoaldFtnuuwaU+hcAgCfUtdgELdKe9XSVUlkKviX4Tmx90Y=
=M6Kj
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
