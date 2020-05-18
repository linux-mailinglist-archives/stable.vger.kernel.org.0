Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D340F1D89D3
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 23:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgERVNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 17:13:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39506 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERVNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 17:13:33 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8B42D1C025E; Mon, 18 May 2020 23:13:31 +0200 (CEST)
Date:   Mon, 18 May 2020 23:13:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c8a8197c8852f566b9d9@syzkaller.appspotmail.com,
        syzbot+40b71e145e73f78f81ad@syzkaller.appspotmail.com,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 02/80] shmem: fix possible deadlocks on
 shmlock_user_lock
Message-ID: <20200518211330.GA25576@amd>
References: <20200518173450.097837707@linuxfoundation.org>
 <20200518173450.633393924@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20200518173450.633393924@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This may not risk an actual deadlock, since shmem inodes do not take
> part in writeback accounting, but there are several easy ways to avoid
> it.

=2E..

> Take info->lock out of the chain and the possibility of deadlock or
> lockdep warning goes away.

It is unclear to me if actual possibility of deadlock exists or not,
but anyway:

>  	int retval =3D -ENOMEM;
> =20
> -	spin_lock_irq(&info->lock);
> +	/*
> +	 * What serializes the accesses to info->flags?
> +	 * ipc_lock_object() when called from shmctl_do_lock(),
> +	 * no serialization needed when called from shm_destroy().
> +	 */
>  	if (lock && !(info->flags & VM_LOCKED)) {
>  		if (!user_shm_lock(inode->i_size, user))
>  			goto out_nomem;

Should we have READ_ONCE() here? If it is okay, are concurency
sanitizers smart enough to realize that it is okay? Replacing warning
with different one would not be exactly a win...

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7C+noACgkQMOfwapXb+vIp4QCeOHGsBJ1v5LOYIQ5B6hvE0DCT
6KEAn02mxYUIBMKxf6gx/Zb4s1ygGl9Z
=HaBo
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
