Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95B4984D2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiAXQaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:30:06 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42284 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243788AbiAXQ3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:29:49 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2Dz-00070f-JJ; Mon, 24 Jan 2022 17:29:47 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2Dy-009z8k-Lu;
        Mon, 24 Jan 2022 17:29:46 +0100
Date:   Mon, 24 Jan 2022 17:29:46 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Michael Wakabayashi <mwakabayashi@vmware.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14] NFSv4: Initialise connection to the server in
 nfs4_alloc_client()
Message-ID: <Ye7T+vLMFpwBFsRW@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="E3flWCMVqAGF9hC4"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--E3flWCMVqAGF9hC4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Trond Myklebust <trond.myklebust@hammerspace.com>

commit dd99e9f98fbf423ff6d365b37a98e8879170f17c upstream.

Set up the connection to the NFSv4 server in nfs4_alloc_client(), before
we've added the struct nfs_client to the net-namespace's nfs_client_list
so that a downed server won't cause other mounts to hang in the trunking
detection code.

Reported-by: Michael Wakabayashi <mwakabayashi@vmware.com>
Fixes: 5c6e5b60aae4 ("NFS: Fix an Oops in the pNFS files and flexfiles conn=
ection setup to the DS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[bwh: Backported to 4.14: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4client.c | 82 +++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 40 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 3c8dfab8e958..02b01b4025f6 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -177,8 +177,11 @@ void nfs40_shutdown_client(struct nfs_client *clp)
=20
 struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_=
init)
 {
-	int err;
+	char buf[INET6_ADDRSTRLEN + 1];
+	const char *ip_addr =3D cl_init->ip_addr;
 	struct nfs_client *clp =3D nfs_alloc_client(cl_init);
+	int err;
+
 	if (IS_ERR(clp))
 		return clp;
=20
@@ -202,6 +205,44 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_=
client_initdata *cl_init)
 #if IS_ENABLED(CONFIG_NFS_V4_1)
 	init_waitqueue_head(&clp->cl_lock_waitq);
 #endif
+
+	if (cl_init->minorversion !=3D 0)
+		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
+	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
+	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
+
+	/*
+	 * Set up the connection to the server before we add add to the
+	 * global list.
+	 */
+	err =3D nfs_create_rpc_client(clp, cl_init, RPC_AUTH_GSS_KRB5I);
+	if (err =3D=3D -EINVAL)
+		err =3D nfs_create_rpc_client(clp, cl_init, RPC_AUTH_UNIX);
+	if (err < 0)
+		goto error;
+
+	/* If no clientaddr=3D option was specified, find a usable cb address */
+	if (ip_addr =3D=3D NULL) {
+		struct sockaddr_storage cb_addr;
+		struct sockaddr *sap =3D (struct sockaddr *)&cb_addr;
+
+		err =3D rpc_localaddr(clp->cl_rpcclient, sap, sizeof(cb_addr));
+		if (err < 0)
+			goto error;
+		err =3D rpc_ntop(sap, buf, sizeof(buf));
+		if (err < 0)
+			goto error;
+		ip_addr =3D (const char *)buf;
+	}
+	strlcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
+
+	err =3D nfs_idmap_new(clp);
+	if (err < 0) {
+		dprintk("%s: failed to create idmapper. Error =3D %d\n",
+			__func__, err);
+		goto error;
+	}
+	__set_bit(NFS_CS_IDMAP, &clp->cl_res_state);
 	return clp;
=20
 error:
@@ -354,8 +395,6 @@ static int nfs4_init_client_minor_version(struct nfs_cl=
ient *clp)
 struct nfs_client *nfs4_init_client(struct nfs_client *clp,
 				    const struct nfs_client_initdata *cl_init)
 {
-	char buf[INET6_ADDRSTRLEN + 1];
-	const char *ip_addr =3D cl_init->ip_addr;
 	struct nfs_client *old;
 	int error;
=20
@@ -363,43 +402,6 @@ struct nfs_client *nfs4_init_client(struct nfs_client =
*clp,
 		/* the client is initialised already */
 		return clp;
=20
-	/* Check NFS protocol revision and initialize RPC op vector */
-	clp->rpc_ops =3D &nfs_v4_clientops;
-
-	if (clp->cl_minorversion !=3D 0)
-		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
-	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
-	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
-
-	error =3D nfs_create_rpc_client(clp, cl_init, RPC_AUTH_GSS_KRB5I);
-	if (error =3D=3D -EINVAL)
-		error =3D nfs_create_rpc_client(clp, cl_init, RPC_AUTH_UNIX);
-	if (error < 0)
-		goto error;
-
-	/* If no clientaddr=3D option was specified, find a usable cb address */
-	if (ip_addr =3D=3D NULL) {
-		struct sockaddr_storage cb_addr;
-		struct sockaddr *sap =3D (struct sockaddr *)&cb_addr;
-
-		error =3D rpc_localaddr(clp->cl_rpcclient, sap, sizeof(cb_addr));
-		if (error < 0)
-			goto error;
-		error =3D rpc_ntop(sap, buf, sizeof(buf));
-		if (error < 0)
-			goto error;
-		ip_addr =3D (const char *)buf;
-	}
-	strlcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
-
-	error =3D nfs_idmap_new(clp);
-	if (error < 0) {
-		dprintk("%s: failed to create idmapper. Error =3D %d\n",
-			__func__, error);
-		goto error;
-	}
-	__set_bit(NFS_CS_IDMAP, &clp->cl_res_state);
-
 	error =3D nfs4_init_client_minor_version(clp);
 	if (error < 0)
 		goto error;

--E3flWCMVqAGF9hC4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu0/EACgkQ57/I7JWG
EQlS2w//aod9fqPkor9InXhpSw4Exa2SIn7d3YZxPnWvckZye3xVZAJDDI3zG8Ln
c+Vqi2oDLLqW56lGtq60uxQE7ARf2QD8mmUeJOAunTzlcCkxD32G2HSEXcoTZhxV
zWt80rmzRrY97L4B5uozV8dMcYmE/EIkixQG4qQWs7la7lWxw5v0O1R27DH3H7vD
ebsY4yDSHpc16vscxUjZbx3noaH87pb6S6LHRz3WSt9QCuqO8pHmuZTAGzumPknK
42mZHIXIhssu88bpnncTwN/lRdLwJFKHTjv8XC8qWukqzkaOoi+5v/x0uxMgz16j
bCzZYoQjSQE8d7ChMXYcsaaxyrxrirf9uY2yQi1VPsfdIA0g2m0HXlak3G9PGsC2
zMi8OBScoA4t391+7WfxPnwHuSfft9dCtcLIRE5xWhlgJKgeQOjrF2YN9xeZHJmS
lS8GAsQk/0aC+BTUWFV+uIiie8/PwyiCicm+LIklGF6c7OO9IhOHO32pQRbpvd+5
a7eUtfWZMh0ZXFBT0sBeP4Xk3W8A1Ns5aLq4rtyjZ4todr2AZd86RqNDqrdbbZ1F
GNpguOU24VJ6bxB7x9VxiTm7L2gb38jnWGUhMMMANGrr+2KVGRtSpgY2LQxyMwXI
/8Ds/eBoJCqwL5ctMpPGrsQA8tJtVbA7CY1plxZLOL4N4ILbOOQ=
=DeMb
-----END PGP SIGNATURE-----

--E3flWCMVqAGF9hC4--
