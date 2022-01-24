Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000BC49A98C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiAYDX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:23:29 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55180 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387209AbiAXUgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1B5011C0B76; Mon, 24 Jan 2022 21:36:38 +0100 (CET)
Date:   Mon, 24 Jan 2022 21:36:37 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 4.19 026/239] f2fs: fix to do sanity check in is_alive()
Message-ID: <20220124203637.GA19321@duo.ucw.cz>
References: <20220124183943.102762895@linuxfoundation.org>
 <20220124183943.957395248@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20220124183943.957395248@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Chao Yu <chao@kernel.org>
>=20
> commit 77900c45ee5cd5da63bd4d818a41dbdf367e81cd upstream.
>=20
> In fuzzed image, SSA table may indicate that a data block belongs to
> invalid node, which node ID is out-of-range (0, 1, 2 or max_nid), in
> order to avoid migrating inconsistent data in such corrupted image,
> let's do sanity check anyway before data block migration.

This may be good idea, but AFAICT this leads to leak of page reference.

> +++ b/fs/f2fs/gc.c
> @@ -589,6 +589,9 @@ static bool is_alive(struct f2fs_sb_info
>  		set_sbi_flag(sbi, SBI_NEED_FSCK);
>  	}
> =20
> +	if (f2fs_check_nid_range(sbi, dni->ino))
> +		return false;
> +
>  	*nofs =3D ofs_of_node(node_page);
>  	source_blkaddr =3D datablock_addr(NULL, node_page, ofs_in_node);
>  	f2fs_put_page(node_page, 1);

AFAICT f2fs_put_page() needs to be done in the error path, too.

(Problem seems to exist in mainline, too).

Something like this?

Signed-off-by: Pavel Machek <pavel@denx.de>

Best regards,
								Pavel

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index ee308a8de432..e020804f7b07 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1038,8 +1038,10 @@ static bool is_alive(struct f2fs_sb_info *sbi, struc=
t f2fs_summary *sum,
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 	}
=20
-	if (f2fs_check_nid_range(sbi, dni->ino))
+	if (f2fs_check_nid_range(sbi, dni->ino)) {
+		f2fs_put_page(node_page, 1);
 		return false;
+	}
=20
 	*nofs =3D ofs_of_node(node_page);
 	source_blkaddr =3D data_blkaddr(NULL, node_page, ofs_in_node);


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYe8N1QAKCRAw5/Bqldv6
8iluAJ4pFchtjQXsPSylkcIofl1xlZpjtACguBTQY+IRb8eImaAncSwdHnIHml8=
=qPFd
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
