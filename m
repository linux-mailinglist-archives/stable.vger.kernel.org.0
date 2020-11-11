Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B382AF116
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 13:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgKKMox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 07:44:53 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45496 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgKKMow (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 07:44:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6B73B1C0B88; Wed, 11 Nov 2020 13:44:50 +0100 (CET)
Date:   Wed, 11 Nov 2020 13:44:49 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: Re: [PATCH 4.19 19/71] btrfs: extent_io: add proper error handling
 to lock_extent_buffer_for_io()
Message-ID: <20201111124448.GA26508@amd>
References: <20201109125019.906191744@linuxfoundation.org>
 <20201109125020.811120362@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20201109125020.811120362@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Thankfully it's handled by the only caller, btree_write_cache_pages(),
> as later write_one_eb() call will trigger submit_one_bio().  So there
> shouldn't be any problem.

This explains there should not be any problem in _the
mainline_. AFAICT this talks about this code. Mainline version is:

 prev_eb =3D eb;
 ret =3D lock_extent_buffer_for_io(eb, &epd);
 if (!ret) {
 	free_extent_buffer(eb);
 	continue;
 } else if (ret < 0) {
 	done =3D 1;
 	free_extent_buffer(eb);
 	break;
 }

But 4.19 has:

 ret =3D lock_extent_buffer_for_io(eb, fs_info, &epd);
 if (!ret) {
  	free_extent_buffer(eb);
 	continue;
 }

IOW missing the code mentioned in the changelog. Is 0607eb1d452d4
prerequisite for this patch?

Best regards,
								Pavel

> +/*
> + * Lock eb pages and flush the bio if we can't the locks
> + *
> + * Return  0 if nothing went wrong
> + * Return >0 is same as 0, except bio is not submitted
> + * Return <0 if something went wrong, no page is locked
> + */

--=20
http://www.livejournal.com/~pavelmachek

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+r3MAACgkQMOfwapXb+vIomgCgiSNvx3YV/LxEpSOq9MFYm+YI
dyQAniLtaZliGW/D+WeWdLm4saWyLlPR
=o2X7
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
