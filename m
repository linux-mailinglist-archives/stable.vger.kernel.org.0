Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B432AF24E
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 14:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgKKNi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 08:38:59 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52620 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgKKNiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 08:38:23 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3D9B21C0B7C; Wed, 11 Nov 2020 14:38:22 +0100 (CET)
Date:   Wed, 11 Nov 2020 14:38:21 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: Re: [PATCH 4.19 29/71] btrfs: tree-checker: Verify inode item
Message-ID: <20201111133820.GA29099@amd>
References: <20201109125019.906191744@linuxfoundation.org>
 <20201109125021.272942487@linuxfoundation.org>
 <20201111131340.GA28106@amd>
 <0a9548c8-1866-fa2e-59a1-54be518c3fc0@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <0a9548c8-1866-fa2e-59a1-54be518c3fc0@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> From: Qu Wenruo <wqu@suse.com>
> >>
> >> commit 496245cac57e26d8b738d85c7a29cf9a47610f3f upstream.
> >>
> >> There is a report in kernel bugzilla about mismatch file type in dir
> >> item and inode item.
> >>
> >> This inspires us to check inode mode in inode item.
> >>
> >> This patch will check the following members:
> >=20
> >> +	/* Here we use super block generation + 1 to handle log tree */
> >> +	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
> >> +		inode_item_err(fs_info, leaf, slot,
> >> +			"invalid inode generation: has %llu expect (0, %llu]",
> >> +			       btrfs_inode_generation(leaf, iitem),
> >> +			       super_gen + 1);
> >> +		return -EUCLEAN;
> >> +	}
> >=20
> > Printk suggests btrfs_inode_generation() may not be zero, but the
> > condition does not actually check that. Should that be added?
>=20
> Sorry, btrfs_inode_generation() here is exactly what we're checking
> here, so what's wrong?

Quoted message says "(0, ...]", while message below says "[0, ...]". I
assume that means that btrfs_inode_generation() may not be zero in the
first case, but may be zero in the second case. But the code does not
test for zero here.

Best regards,
								Pavel

> >> +	/* Note for ROOT_TREE_DIR_ITEM, mkfs could set its transid 0 */
> >> +	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
> >> +		inode_item_err(fs_info, leaf, slot,
> >> +			"invalid inode generation: has %llu expect [0, %llu]",
> >> +			       btrfs_inode_transid(leaf, iitem), super_gen + 1);
> >> +		return -EUCLEAN;
> >> +	}

--=20
http://www.livejournal.com/~pavelmachek

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+r6UwACgkQMOfwapXb+vIv3QCghUOdR+o4MmIHJ/xmEOH0y2VO
6GIAnjVSeYuxAadg8AX0aesSDFCag7QY
=m21L
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
