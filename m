Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663F72AF1CA
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 14:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgKKNNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 08:13:44 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48324 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgKKNNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 08:13:44 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D4B661C0B7C; Wed, 11 Nov 2020 14:13:41 +0100 (CET)
Date:   Wed, 11 Nov 2020 14:13:40 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: Re: [PATCH 4.19 29/71] btrfs: tree-checker: Verify inode item
Message-ID: <20201111131340.GA28106@amd>
References: <20201109125019.906191744@linuxfoundation.org>
 <20201109125021.272942487@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20201109125021.272942487@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Qu Wenruo <wqu@suse.com>
>=20
> commit 496245cac57e26d8b738d85c7a29cf9a47610f3f upstream.
>=20
> There is a report in kernel bugzilla about mismatch file type in dir
> item and inode item.
>=20
> This inspires us to check inode mode in inode item.
>=20
> This patch will check the following members:

> +	/* Here we use super block generation + 1 to handle log tree */
> +	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid inode generation: has %llu expect (0, %llu]",
> +			       btrfs_inode_generation(leaf, iitem),
> +			       super_gen + 1);
> +		return -EUCLEAN;
> +	}

Printk suggests btrfs_inode_generation() may not be zero, but the
condition does not actually check that. Should that be added?

> +	/* Note for ROOT_TREE_DIR_ITEM, mkfs could set its transid 0 */
> +	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid inode generation: has %llu expect [0, %llu]",
> +			       btrfs_inode_transid(leaf, iitem), super_gen + 1);
> +		return -EUCLEAN;
> +	}

Best regards,
									Pavel

--=20
http://www.livejournal.com/~pavelmachek

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+r44QACgkQMOfwapXb+vLylgCbBST7kDuV3FoezTqcmeJfdDg0
CfEAoJqGvLCGwFfzIekWttxvddwvvmvp
=TwEK
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
