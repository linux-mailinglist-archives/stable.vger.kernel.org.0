Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ADD417062
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 12:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbhIXKhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 06:37:08 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36808 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIXKhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 06:37:08 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 60D5D1C0BA3; Fri, 24 Sep 2021 12:35:34 +0200 (CEST)
Date:   Fri, 24 Sep 2021 12:35:33 +0200
From:   Pavel Machek <pavel@denx.de>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, konishi.ryusuke@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com, torvalds@linux-foundation.org
Subject: Re: [patch 136/147] nilfs2: use refcount_dec_and_lock() to fix
 potential UAF
Message-ID: <20210924103533.GA22717@duo.ucw.cz>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908030026.2dLZCmkE4%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20210908030026.2dLZCmkE4%akpm@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Zhen Lei <thunder.leizhen@huawei.com>
> Subject: nilfs2: use refcount_dec_and_lock() to fix potential UAF
>=20
> When the refcount is decreased to 0, the resource reclamation branch is
> entered.  Before CPU0 reaches the race point (1), CPU1 may obtain the
> spinlock and traverse the rbtree to find 'root', see nilfs_lookup_root().=
=20
> Although CPU1 will call refcount_inc() to increase the refcount, it is
> obviously too late.  CPU0 will release 'root' directly, CPU1 then accesses
> 'root' and triggers UAF.
>=20
> Use refcount_dec_and_lock() to ensure that both the operations of decrease
> refcount to 0 and link deletion are lock protected eliminates this risk.
>=20
>      CPU0                      CPU1
> nilfs_put_root():
> 			    <-------- (1)
> spin_lock(&nilfs->ns_cptree_lock);
> rb_erase(&root->rb_node, &nilfs->ns_cptree);
> spin_unlock(&nilfs->ns_cptree_lock);
>=20
> kfree(root);
> 			    <-------- use-after-free

> There is no reproduction program, and the above is only theoretical
> analysis.

Ok, so we have a theoretical bug, and fix already on its way to
stable. But ... is it correct?

> +++ a/fs/nilfs2/the_nilfs.c
> @@ -792,14 +792,13 @@ nilfs_find_or_create_root(struct the_nil
> =20
>  void nilfs_put_root(struct nilfs_root *root)
>  {
> -	if (refcount_dec_and_test(&root->count)) {
> -		struct the_nilfs *nilfs =3D root->nilfs;
> +	struct the_nilfs *nilfs =3D root->nilfs;
> =20
> -		nilfs_sysfs_delete_snapshot_group(root);
> -
> -		spin_lock(&nilfs->ns_cptree_lock);
> +	if (refcount_dec_and_lock(&root->count, &nilfs->ns_cptree_lock)) {
>  		rb_erase(&root->rb_node, &nilfs->ns_cptree);
>  		spin_unlock(&nilfs->ns_cptree_lock);
> +
> +		nilfs_sysfs_delete_snapshot_group(root);
>  		iput(root->ifile);
> =20
>  		kfree(root);

spin_lock() is deleted, but spin_unlock() is not affected. This means
unbalanced locking, right?

Best regards,
								Pavel
--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYU2p9QAKCRAw5/Bqldv6
8pEQAKDA9jl6m9R1pd/xcPllBCkOXDjUsQCfUaxkmFaw26oeFa3dtCAQPMQfQtg=
=ui/9
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
