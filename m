Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40CC184569
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 12:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgCMLCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 07:02:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20450 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726365AbgCMLCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 07:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584097359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tfub7WJ366iIWPYFGkBjzwdHOoRbkxCwrjycNLUZ/PI=;
        b=FZMhb5Hvfe+ZvxrPS7TcKE5T3iTXrGq7lgWpKYSNMxwxAMCijNJBzWCh3bHI3pL/ytAwpI
        NmklXHS1lf3ZRhGhorg8L14lnqaR3nv3Jh041vaAq9uN+aSzNuLTOJR04mgkmmdQ+krjCx
        fOJ+KdKzNXeS9MeNMUHoRQzZijQfQsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-UwMOmhpxPC2gvyIP_3s6Eg-1; Fri, 13 Mar 2020 07:02:32 -0400
X-MC-Unique: UwMOmhpxPC2gvyIP_3s6Eg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C66E4192D786;
        Fri, 13 Mar 2020 11:02:30 +0000 (UTC)
Received: from localhost (ovpn-121-102.rdu2.redhat.com [10.10.121.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FDBB92965;
        Fri, 13 Mar 2020 11:02:30 +0000 (UTC)
Date:   Fri, 13 Mar 2020 08:02:29 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        pmladek@suse.com, sergey.senozhatsky@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Message-ID: <20200313110229.GI13406@glitch>
References: <20200313003533.2203429-1-bmeneg@redhat.com>
 <20200313073425.GA219881@google.com>
MIME-Version: 1.0
In-Reply-To: <20200313073425.GA219881@google.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KrHCbChajFcK0yQE"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--KrHCbChajFcK0yQE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2020 at 04:34:25PM +0900, Sergey Senozhatsky wrote:
> On (20/03/12 21:35), Bruno Meneguele wrote:
> >=20
> > Userspace libraries, e.g. glibc's dprintf(), expect the default return =
value
> > for invalid seek situations: -ESPIPE, but when the IO was over /dev/kms=
g the
> > current state of kernel code was returning the generic case of an -EINV=
AL.
> > Hence, userspace programs were not behaving as expected or documented.
> >=20
>=20
> Hmm. I don't think I see ESPIPE in documentation [0], [1], [2]
>=20
> [0] https://pubs.opengroup.org/onlinepubs/9699919799/functions/fprintf.ht=
ml
> [1] http://man7.org/linux/man-pages/man3/dprintf.3p.html
> [2] http://man7.org/linux/man-pages/man3/fprintf.3p.html
>=20
> =09-ss
>=20

Ok, I poorly expressed the notion of "documentantion". The userspace
doesn't tell about returning -ESPIPE, but to the functions work properly
they watch for -ESPIPE returning from the syscall. For instance, gblic
dprintf() implementation:

dprintf:
  __vdprintf_internal:
    _IO_new_file_attach:

  if (_IO_SEEKOFF (fp, (off64_t)0, _IO_seek_cur, _IOS_INPUT|_IOS_OUTPUT)
      =3D=3D _IO_pos_BAD && errno !=3D ESPIPE)
    return NULL;

With that, if the seek fails, but return anything other than ESPIPE the
dprintf() will also fail returning -EINVAL to dprintf() caller. While if
ESPIPE is returned, it's "ignored" and the call still works. The way we
have today make kmsg an exception case among the rest of the system
files where you can open with dprintf.

One of the things I could agree with is removing the SEEK call from
dprintf, since fprintf basically follows the same steps, but doesn't
seek anything.  But at the same time, IMO it makes sense to make kmsg
interface complaint with the errno return values.

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--KrHCbChajFcK0yQE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl5raEUACgkQYdRkFR+R
okPnQAgAoEVvkr9xuWNi7/5UFSFUCzBWggHS62VeY1aVd+yBi04vKD0eeHERUsCV
0z4B/Bz9/6QvmuEMm1+xsOfzimrnhrvdJaf3i8o/4GPEZOiDfv7I/FRMd3eIFUtC
/BWcuRAd53x8zPDbqRrtfc/oHysW6ClTHu+DjIeidwDJ67W75u2hwRDaNf0sonu4
VA0+SyaLTtnFC+gYAh2vFpleQJ8feEEraFjFIhZLK0hP/5UTvCDv76GWG3WXaL1B
2nXGBf16LEe546UbPcSBhaRc+w9aaynfZUgj9GYbP5Mg29egSdhF6AEJ+Kq044pO
G3ZYD4XRaVtbvPTlCQD7yHUiKcSLfg==
=+ptV
-----END PGP SIGNATURE-----

--KrHCbChajFcK0yQE--

