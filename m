Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA8F187B94
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 09:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgCQIyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 04:54:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:36243 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgCQIyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 04:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584435246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TNEcRgJYG2FHvRPL0to6kfT0Q5dHg4uObpbCvKN7dtE=;
        b=J4eDu3Csp29Qu1QFjFOMuXBXMkOyXPHi6N0fs3dQqXikG9dqImYk9AFDQZS1wwC2zAbxM2
        rQcqdeAG1Lz0gFm0ylpLkVG4eDQphqI2DPdPwoWbKE1aOl0EwIF3ZXxEiqxeLQ9hiHGhlB
        QYHbyudv2UwHHZzwHV2t2Po4YjEYZbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-K6SU7qjLP4-cYPg-Wrh8ng-1; Tue, 17 Mar 2020 04:54:02 -0400
X-MC-Unique: K6SU7qjLP4-cYPg-Wrh8ng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A194566F;
        Tue, 17 Mar 2020 08:54:00 +0000 (UTC)
Received: from localhost (ovpn-113-80.rdu2.redhat.com [10.10.113.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F077E90811;
        Tue, 17 Mar 2020 08:53:59 +0000 (UTC)
Date:   Tue, 17 Mar 2020 05:53:58 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        pmladek@suse.com, sergey.senozhatsky@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Message-ID: <20200317085358.GE11152@glitch>
References: <20200313003533.2203429-1-bmeneg@redhat.com>
 <20200313073425.GA219881@google.com>
 <20200313110229.GI13406@glitch>
 <20200317020326.GC219881@google.com>
MIME-Version: 1.0
In-Reply-To: <20200317020326.GC219881@google.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KlAEzMkarCnErv5Q"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--KlAEzMkarCnErv5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2020 at 11:03:26AM +0900, Sergey Senozhatsky wrote:
> On (20/03/13 08:02), Bruno Meneguele wrote:
> > Ok, I poorly expressed the notion of "documentantion". The userspace
> > doesn't tell about returning -ESPIPE, but to the functions work properl=
y
> > they watch for -ESPIPE returning from the syscall. For instance, gblic
> > dprintf() implementation:
> >=20
> > dprintf:
> >   __vdprintf_internal:
> >     _IO_new_file_attach:
> >=20
> >   if (_IO_SEEKOFF (fp, (off64_t)0, _IO_seek_cur, _IOS_INPUT|_IOS_OUTPUT=
)
> >       =3D=3D _IO_pos_BAD && errno !=3D ESPIPE)
> >     return NULL;
> >=20
> > With that, if the seek fails, but return anything other than ESPIPE the
> > dprintf() will also fail returning -EINVAL to dprintf() caller. While i=
f
> > ESPIPE is returned, it's "ignored" and the call still works. The way we
> > have today make kmsg an exception case among the rest of the system
> > files where you can open with dprintf.
> >=20
> > One of the things I could agree with is removing the SEEK call from
> > dprintf, since fprintf basically follows the same steps, but doesn't
> > seek anything.  But at the same time, IMO it makes sense to make kmsg
> > interface complaint with the errno return values.
>=20
> The code in questions is very old. So let's add the missing bit to the
> kernel. At the same time, we probably can have a slightly more detailed
> documentation / code comment.
>=20
> =09-ss
>=20

Sure thing.

I'm going to send a v2 of this patch with more details still today or
tomorrow.

Thanks!

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--KlAEzMkarCnErv5Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl5wkCYACgkQYdRkFR+R
okOt6wgAs3dyaz7bUjahq+okFkTiDc6plFTMf+OgYLwsF7b1FCDcFwuzdUptfAXR
muOlZ4t0hcTfTOYb6uCWITVdOwKR76RVMieoEfaSYY+g8RpT5e+xfHmxB268Ud3b
/9Tz1J86cnN8jjoj/B6exMg3ZzwrQXgmPhF+B8NAoPnEkscmr5sDWXVoSchXy8mZ
7iezmGVaaLthlqIrsQU9CUXpDYMhXlaUiLi/U/euzxLTl8Es14UdEAw3xKP5Accs
2KTctmiyTr2VGaZ6B04DIU0SFGAEstgk4IUvn2bkrjnkyoLhz5mQBVk4vRC3Lu3Z
pd7KCXg8F8GOdiZ7dwYQ5CtQNEkxlg==
=MnH8
-----END PGP SIGNATURE-----

--KlAEzMkarCnErv5Q--

