Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F23649814F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiAXNoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:44:37 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:41942 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiAXNoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:44:37 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jan 2022 08:44:36 EST
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nBze7-00050A-MV; Mon, 24 Jan 2022 14:44:35 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nBze7-009hqO-1o;
        Mon, 24 Jan 2022 14:44:35 +0100
Date:   Mon, 24 Jan 2022 14:44:35 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.9 2/2] fuse: fix live lock in fuse_iget()
Message-ID: <Ye6tQ6i83vth4BAQ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dh47kNqNJ6zMI4+J"
Content-Disposition: inline
In-Reply-To: <Ye6s90hqJXcsvslQ@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dh47kNqNJ6zMI4+J
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
index bd82c09b053d..7e4b0e298bc7 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -692,6 +692,7 @@ static inline u64 get_node_id(struct inode *inode)
=20
 static inline void fuse_make_bad(struct inode *inode)
 {
+	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
=20

--dh47kNqNJ6zMI4+J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHurToACgkQ57/I7JWG
EQmFyhAAy7Sdj6U3Qg0rbNldv91dH4EQcNAl6NdikR1KfaAM7aed6FMiLyWL/aVY
qV6+RfOWUyXiutJrMZnQw8wfxopQlizYNVq6BCUyh66R45t2AKz2jiw6BzeWxB53
nhvfow9pZSi9YrpFbLYv8vjZFpUE6tdRJYi2+bh6a6R18pi2pnn+Z/2tHJvZX2pL
gM1Z/Drk4FjSnoGBPYY+Z4r0CWozG2nZz15a8t67b1fRrZbxctKnQNqPakt7PMc+
a4WzX8ZS/IfiSAiTz/Enl6oU3SR0wPS35KAyJJb6Y4loDmfQEiNppk0bK1r1LTSC
nBjE8ZOOPY3nFUDLbmbSTy9MeN4H1xJp+svxwFkO/ZClMwqmIwrQrQ401UBFM201
xI+cUc36E3VxgB0Lqyl33vacU8HaL4dOpzK7+oaOf8CIatwjxKrDXAkjm87MUj+D
9p8m2Flrx4D/Ztxx7zP0pGMZGTb35LIJkHieD11xIJFqBqeEIIcvBeWaUg3ArX8n
jQXSorCiNhKUbAPUx0Hm7zNCEs+5V8TXu+8k1CmXgzyuq8+GLzvtp2Nsl2VjLVLe
YFbUU+K5+8EVBOqn8GMRAb12COUYgedP1ajIHLypUMXY+eUqgYglk1xqhzmkuiFe
iaws3vdtLefpRhjufxb5nKOak5Ji4363yr3/n3kM6HI6bhmEdtE=
=QXvz
-----END PGP SIGNATURE-----

--dh47kNqNJ6zMI4+J--
