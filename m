Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B4560B7A0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiJXT2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiJXT1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:27:47 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [IPv6:2a00:da80:fff0:2::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E646275DD;
        Mon, 24 Oct 2022 10:59:34 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 710AB1C002C; Mon, 24 Oct 2022 19:30:13 +0200 (CEST)
Date:   Mon, 24 Oct 2022 19:30:12 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenqing Liu <wenqingliu0120@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 5.10 052/390] f2fs: fix to do sanity check on summary info
Message-ID: <20221024173012.GA25198@duo.ucw.cz>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113024.853480982@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20221024113024.853480982@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Chao Yu <chao@kernel.org>
>=20
> commit c6ad7fd16657ebd34a87a97d9588195aae87597d upstream.
>=20
> As Wenqing Liu reported in bugzilla:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216456
>=20
> BUG: KASAN: use-after-free in recover_data+0x63ae/0x6ae0 [f2fs]
> Read of size 4 at addr ffff8881464dcd80 by task mount/1013

I believe this is missing put_page on the error path:

> +++ b/fs/f2fs/gc.c
> @@ -1003,6 +1003,14 @@ static bool is_alive(struct f2fs_sb_info
>  		return false;
>  	}
> =20
> +	max_addrs =3D IS_INODE(node_page) ? DEF_ADDRS_PER_INODE :
> +						DEF_ADDRS_PER_BLOCK;
> +	if (ofs_in_node >=3D max_addrs) {
> +		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u,=
 max:%u",
> +			ofs_in_node, dni->ino, dni->nid, max_addrs);
> +		return false;
> +	}
> +
>  	*nofs =3D ofs_of_node(node_page);
>  	source_blkaddr =3D data_blkaddr(NULL, node_page, ofs_in_node);
>  	f2fs_put_page(node_page, 1);

So something like this is needed. (Feel free to test/adapt/apply).

Signed-off-by: Pavel Machek <pavel@denx.de>

Best regards,
								Pavel

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 4546e01b2ee0..dab794225cce 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1110,6 +1110,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct=
 f2fs_summary *sum,
 	if (ofs_in_node >=3D max_addrs) {
 		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, m=
ax:%u",
 			ofs_in_node, dni->ino, dni->nid, max_addrs);
+		f2fs_put_page(node_page, 1);
 		return false;
 	}
=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1bLpAAKCRAw5/Bqldv6
8hmyAKC7ZXIcPf5MpyZ9AMln+rmaOqzJugCgohM0HFz47LHNFd++QYjLSHMYJeU=
=cm9e
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
