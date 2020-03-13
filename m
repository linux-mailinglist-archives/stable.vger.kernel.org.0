Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C9E18476F
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 14:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgCMNGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 09:06:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23439 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726479AbgCMNGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 09:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584104804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1UcD6SvRQdQ67CEbuSkOopYlp5LyOHtadTTVCjBN5DQ=;
        b=auHv9EX/r8p94497cTXVepYRg06v8oXhjaQgQHf+ewK9S/BSrdDbbxGvlEHxjtjB4s6kft
        MQNuiOCrRnD6AMfdgG3t4KtNeIEOpLb3OVFSNSNkL6RZsr5wYfF7qYjjT7c8pIW7qCqoAi
        rfMwDBDtUNdwA8JD2JaZ9QUptgJK2RE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-w0ujB9D1MISbTMZ9YA7J0w-1; Fri, 13 Mar 2020 09:06:38 -0400
X-MC-Unique: w0ujB9D1MISbTMZ9YA7J0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8799B1088380;
        Fri, 13 Mar 2020 13:06:36 +0000 (UTC)
Received: from localhost (ovpn-121-102.rdu2.redhat.com [10.10.121.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBBF08B570;
        Fri, 13 Mar 2020 13:06:34 +0000 (UTC)
Date:   Fri, 13 Mar 2020 10:06:34 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "sergey.senozhatsky@gmail.com" <sergey.senozhatsky@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Message-ID: <20200313130634.GJ13406@glitch>
References: <20200313003533.2203429-1-bmeneg@redhat.com>
 <20200313073425.GA219881@google.com>
 <20200313110229.GI13406@glitch>
 <b9427c068f3f4af9bf2bd290d88f84b9@AcuMS.aculab.com>
MIME-Version: 1.0
In-Reply-To: <b9427c068f3f4af9bf2bd290d88f84b9@AcuMS.aculab.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCKy2vjPBX+S/5dE"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--FCKy2vjPBX+S/5dE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2020 at 11:06:42AM +0000, David Laight wrote:
> From: Bruno Meneguele
> > Sent: 13 March 2020 11:02
> > On Fri, Mar 13, 2020 at 04:34:25PM +0900, Sergey Senozhatsky wrote:
> > > On (20/03/12 21:35), Bruno Meneguele wrote:
> > > >
> > > > Userspace libraries, e.g. glibc's dprintf(), expect the default ret=
urn value
> > > > for invalid seek situations: -ESPIPE, but when the IO was over /dev=
/kmsg the
> > > > current state of kernel code was returning the generic case of an -=
EINVAL.
> > > > Hence, userspace programs were not behaving as expected or document=
ed.
> > > >
> > >
> > > Hmm. I don't think I see ESPIPE in documentation [0], [1], [2]
> > >
> > > [0] https://pubs.opengroup.org/onlinepubs/9699919799/functions/fprint=
f.html
> > > [1] http://man7.org/linux/man-pages/man3/dprintf.3p.html
> > > [2] http://man7.org/linux/man-pages/man3/fprintf.3p.html
> > >
> > > =09-ss
> > >
> >=20
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
>=20
> Someone explain why it is doing an explicit seek to the current position?
> The only reason to do that is to get the current offset.
>=20
> =09David
>=20

dprintf gets a fd as input and convert it to a FILE structure, with that
it can't garantuee the previous state of that fd: was it already
manipulated? Thus they check the current position to make sure it's not
junk.

But that's me guessing things about a code from 1996 :).

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--FCKy2vjPBX+S/5dE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl5rhVkACgkQYdRkFR+R
okPciQf/aHCBcLzuwwtWOV0265ILqVZ/Oq9rjX1HxAgz3sMWEdov7F9qg1fyNfye
1iqo0sRROWcxzBQ4/Dvn841x4w1jLOxSRzEfZEqvzj7ybd9U1fMmZ7rGd0KosvPj
agNO/lV89KHw5FX4PNcuX/CFjGDYXlWNxd1jIbtweob8QhbwsAiaWrGXiNm0oaBb
CDRFqVwY1rX9LgmDugO5f8Qmwn0EHSZKgX8L2JvxdC2Nrw9bwfuufpiXVt+66cuF
iHKczLsVtDcBinWIe9CWUX+k+oc2yvRdbAxFJwI7o3qCyyl0CzqJeS42BsDr28+D
hgryRL1UvP3s2MmGiIfXcQA9u1OlfA==
=TMYJ
-----END PGP SIGNATURE-----

--FCKy2vjPBX+S/5dE--

