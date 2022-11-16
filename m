Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E128562B7B3
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 11:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbiKPKVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 05:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238254AbiKPKVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 05:21:06 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A386D2253B
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 02:20:38 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5EFD11C09F7; Wed, 16 Nov 2022 11:20:37 +0100 (CET)
Date:   Wed, 16 Nov 2022 11:20:36 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+45d6ce7b7ad7ef455d03@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.0 134/190] nilfs2: fix deadlock in
 nilfs_count_free_blocks()
Message-ID: <Y3S5dFSZnPKXsvWZ@duo.ucw.cz>
References: <20221114124458.806324402@linuxfoundation.org>
 <20221114124504.652482817@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yeuuGazEakkzllCW"
Content-Disposition: inline
In-Reply-To: <20221114124504.652482817@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yeuuGazEakkzllCW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
>=20
> commit 8ac932a4921a96ca52f61935dbba64ea87bbd5dc upstream.
=2E..
> However, there is actually no need to take rwsem A in
> nilfs_count_free_blocks() because it, within the lock section, only reads
> a single integer data on a shared struct with
> nilfs_sufile_get_ncleansegs().  This has been the case after commit
> aa474a220180 ("nilfs2: add local variable to cache the number of clean
> segments"), that is, even before this bug was introduced.

Ok, but these days we have checkers that don't like reading variables
unlocked, and compiler theoretically could do something funny.

So this should have READ/WRITE_ONCE annotations... this is incomplete,
but should illustrate what is needed. Likely some helper for updating
ncleansegs should be introduced.

Best regards,
								Pavel

diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 63722475e17e..58dddc0b1d88 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -122,7 +122,7 @@ static void nilfs_sufile_mod_counter(struct buffer_head=
 *header_bh,
  */
 unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile)
 {
-	return NILFS_SUI(sufile)->ncleansegs;
+	return READ_ONCE(NILFS_SUI(sufile)->ncleansegs);
 }
=20
 /**
@@ -418,7 +418,9 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, =
__u64 segnum,
 	kunmap_atomic(kaddr);
=20
 	nilfs_sufile_mod_counter(header_bh, -1, 1);
-	NILFS_SUI(sufile)->ncleansegs--;
+	/* nilfs_sufile_get_ncleansegs() leads this without taking lock */
+	WRITE_ONCE(NILFS_SUI(sufile)->ncleansegs,
+		   READ_ONCE(NILFS_SUI(sufile)->ncleansegs) - 1);
=20
 	mark_buffer_dirty(su_bh);
 	nilfs_mdt_mark_dirty(sufile);

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yeuuGazEakkzllCW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S5dAAKCRAw5/Bqldv6
8qwqAKCg9Pr7u0jsNSiROsNWDANK8ix62ACdEc8J7LbTneILBlrZaR9AaKObRus=
=6J+9
-----END PGP SIGNATURE-----

--yeuuGazEakkzllCW--
