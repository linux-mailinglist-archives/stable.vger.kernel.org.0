Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C76D18B185
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 11:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgCSKdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 06:33:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:30107 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgCSKdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 06:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584613997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/F29gYvjLAvqi6zhZjXwmumeqKrqEdvY9gjbDSGuDU4=;
        b=VdOxR3VlBvs2+JL4TkeicysCORXPEtqiuW8d2p0GOEY0DJaTlw0Qf4RLy4Cwl3n7LXurdw
        7aH5WAGVuCa8+tGrisSE4h1niWJKtzQ1uCYY9A1BznmJ4MdupanwXpm7uAfEKfVk7OKfQk
        3+cOmP939saUchPkw5ykc1ZcFirTwcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-EEqVd_4jORKIT_O_G4LS8A-1; Thu, 19 Mar 2020 06:33:13 -0400
X-MC-Unique: EEqVd_4jORKIT_O_G4LS8A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3153B801E74;
        Thu, 19 Mar 2020 10:33:12 +0000 (UTC)
Received: from localhost (ovpn-113-150.rdu2.redhat.com [10.10.113.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8DBDCFC0;
        Thu, 19 Mar 2020 10:33:11 +0000 (UTC)
Date:   Thu, 19 Mar 2020 07:33:10 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        pmladek@suse.com, sergey.senozhatsky@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Message-ID: <20200319103310.GE3448@glitch>
References: <20200313003533.2203429-1-bmeneg@redhat.com>
 <20200313073425.GA219881@google.com>
 <20200313110229.GI13406@glitch>
 <20200317020326.GC219881@google.com>
 <20200317085358.GE11152@glitch>
MIME-Version: 1.0
In-Reply-To: <20200317085358.GE11152@glitch>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2hMgfIw2X+zgXrFs"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 17, 2020 at 05:54:00AM -0300, Bruno Meneguele wrote:
> On Tue, Mar 17, 2020 at 11:03:26AM +0900, Sergey Senozhatsky wrote:
> > On (20/03/13 08:02), Bruno Meneguele wrote:
> > > Ok, I poorly expressed the notion of "documentantion". The userspace
> > > doesn't tell about returning -ESPIPE, but to the functions work prope=
rly
> > > they watch for -ESPIPE returning from the syscall. For instance, gbli=
c
> > > dprintf() implementation:
> > >=20
> > > dprintf:
> > >   __vdprintf_internal:
> > >     _IO_new_file_attach:
> > >=20
> > >   if (_IO_SEEKOFF (fp, (off64_t)0, _IO_seek_cur, _IOS_INPUT|_IOS_OUTP=
UT)
> > >       =3D=3D _IO_pos_BAD && errno !=3D ESPIPE)
> > >     return NULL;
> > >=20
> > > With that, if the seek fails, but return anything other than ESPIPE t=
he
> > > dprintf() will also fail returning -EINVAL to dprintf() caller. While=
 if
> > > ESPIPE is returned, it's "ignored" and the call still works. The way =
we
> > > have today make kmsg an exception case among the rest of the system
> > > files where you can open with dprintf.
> > >=20
> > > One of the things I could agree with is removing the SEEK call from
> > > dprintf, since fprintf basically follows the same steps, but doesn't
> > > seek anything.  But at the same time, IMO it makes sense to make kmsg
> > > interface complaint with the errno return values.
> >=20
> > The code in questions is very old. So let's add the missing bit to the
> > kernel. At the same time, we probably can have a slightly more detailed
> > documentation / code comment.
> >=20
> > =09-ss
> >=20
>=20
> Sure thing.
>=20
> I'm going to send a v2 of this patch with more details still today or
> tomorrow.
>=20
> Thanks!
>=20

Just fyi, v2 was posted:
https://lkml.org/lkml/2020/3/17/321

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--2hMgfIw2X+zgXrFs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl5zSmYACgkQYdRkFR+R
okNopAf/SzeggTq1W6Ar2E6wVg+LYaVb7FNwyRr5qxxdJccZO7YljjwZ9QcESjAm
RwevCCV7TbIOqY9oAyRJGzMmfMk1xmA9HJ58n7cyDoSgV/NW/7mlo2T6Vm00mqwV
+iwo1NuKrmn34AApfwHhhp+More5cVWoB+w5nL4AF5L8s/dz7lGYESTpF8PsWCNd
WUTXe5UNTA91tKZ6mcldv27CHLINY8MqWYLd9gxMN9iOM2dbMyn3lBRMqXMdQiSp
Ep8ouXIjH296yGRRPybMGVCBj4wrFgNumB0eplXh0P+QmRZw5fcTeddPQZ9v0cnH
VlIsPjXfUpJdIYVIVPQxDcZNbwagPw==
=1aFS
-----END PGP SIGNATURE-----

--2hMgfIw2X+zgXrFs--

