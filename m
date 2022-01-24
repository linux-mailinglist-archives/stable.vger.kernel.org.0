Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E98498363
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238694AbiAXPSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:18:30 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42128 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiAXPSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:18:30 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC16z-0006e6-1O; Mon, 24 Jan 2022 16:18:29 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC16y-009sGO-Ee;
        Mon, 24 Jan 2022 16:18:28 +0100
Date:   Mon, 24 Jan 2022 16:18:28 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14,4.19 2/2] fuse: fix live lock in fuse_iget()
Message-ID: <Ye7DRM+jxoaske8/@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qckN/X/CQYA8P9Tt"
Content-Disposition: inline
In-Reply-To: <Ye7C/r2HAXqKeg/7@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qckN/X/CQYA8P9Tt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Amir Goldstein <amir73il@gmail.com>

commit 775c5033a0d164622d9d10dd0f0a5531639ed3ed upstream.

Commit 5d069dbe8aaf ("fuse: fix bad inode") replaced make_bad_inode()
in fuse_iget() with a private implementation fuse_make_bad().

The private implementation fails to remove the bad inode from inode
cache, so the retry loop with iget5_locked() finds the same bad inode
and marks it bad forever.

kmsg snip:

[ ] rcu: INFO: rcu_sched self-detected stall on CPU
=2E..
[ ]  ? bit_wait_io+0x50/0x50
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ? find_inode.isra.32+0x60/0xb0
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ilookup5_nowait+0x65/0x90
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ilookup5.part.36+0x2e/0x80
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ? fuse_inode_eq+0x20/0x20
[ ]  iget5_locked+0x21/0x80
[ ]  ? fuse_inode_eq+0x20/0x20
[ ]  fuse_iget+0x96/0x1b0

Fixes: 5d069dbe8aaf ("fuse: fix bad inode")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/fuse_i.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 220960c9b96d..fac1f08dd32e 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -691,6 +691,7 @@ static inline u64 get_node_id(struct inode *inode)
=20
 static inline void fuse_make_bad(struct inode *inode)
 {
+	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
=20

--qckN/X/CQYA8P9Tt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHuw0QACgkQ57/I7JWG
EQlE/BAAyVZ5g0R/R4UYDcyWgNu5Z6Ss5jRl6X/A1P7f+AnjfvOCa7WuOFmway/p
68mJgL9LYxRhXp+szPeeXj6N+iRF0t8Yk7XaIirMSaovHXllsfSWCqTiuNJqTzEC
AXXLcZwhPkb4nkTwMIr39Jv6ROvHEdvpkXK1TwIPlYhyvSu5zoaipqVa8nsUACCZ
486JSXEJ0Y4RQue6thN2ou3wAith/AZet2fC4hF4GgNzuB7F6MPnVvCI3jMKcFre
SQd00NEYx4fZo+cojUuB0wThRlnUVrXwiQMiKpUfTWWbCZEEMmHGoxbGwj1W2uyz
SS4H8s02A0U18zjHq8TSVVilGgt6ZP2b5NSOASbTjo2q2jATlAD1g+DlOYnf9OWe
ZNuTKl7fSzNKidaItZwQVxk7gGxwaNF1UYBElMMCxsvYQEYWXoK/+ww63bclOrBJ
gP+Zy0Y8IDpwWyr/R6Umi1jA/3YupSTkVIymWLD8sh9wEXzPBGLidWeM34FRlzh5
zc6ip3pti9zf7uGug8627mUS+WsQFTawG/PECYoiffEGgwJHNi9n5VMzIdSOYrCM
saQ9q+2m5jxVX2qA3YL+vYSwR0xQFSyuCNCqq+iBw4YyIR3XXbwoD3humZQJsH81
rznY7XpDpKuTZf4P2N67HRDJUpvB7w2DNjGl+etv+MgCMX84C98=
=IRls
-----END PGP SIGNATURE-----

--qckN/X/CQYA8P9Tt--
