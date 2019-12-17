Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03354121FB5
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfLQA1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:27:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34352 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726734AbfLQA1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:27:34 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih0hy-00025Z-Ta; Tue, 17 Dec 2019 00:27:26 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih0hy-00021y-I0; Tue, 17 Dec 2019 00:27:26 +0000
Message-ID: <ff051a95512a6463dc0588e285557f79ee98c8f0.camel@decadent.org.uk>
Subject: Re: [PATCH for linux 4.4.y/3.16.y] fs/dcache: move
 security_d_instantiate() behind attaching dentry to inode
From:   Ben Hutchings <ben@decadent.org.uk>
To:     "zhangyi (F)" <yi.zhang@huawei.com>, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date:   Tue, 17 Dec 2019 00:27:22 +0000
In-Reply-To: <20191106094352.9665-1-yi.zhang@huawei.com>
References: <20191106094352.9665-1-yi.zhang@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-UCJX5BCuOL81e29pynaB"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-UCJX5BCuOL81e29pynaB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-06 at 17:43 +0800, zhangyi (F) wrote:
> During backport 1e2e547a93a "do d_instantiate/unlock_new_inode
> combinations safely", there was a error instantiating sequence of
> attaching dentry to inode and calling security_d_instantiate().
>=20
> Before commit ce23e640133 "->getxattr(): pass dentry and inode as
> separate arguments" and b96809173e9 "security_d_instantiate(): move to
> the point prior to attaching dentry to inode", security_d_instantiate()
> should be called beind __d_instantiate(), otherwise it will trigger
> below problem when CONFIG_SECURITY_SMACK on ext4 was enabled because
> d_inode(dentry) used by ->getxattr() is NULL before __d_instantiate()
> instantiate inode.

Thanks, I've queued this up for 3.16.

Ben.

> [   31.858026] BUG: unable to handle kernel paging request at fffffffffff=
fff70
> ...
> [   31.882024] Call Trace:
> [   31.882378]  [<ffffffffa347f75c>] ext4_xattr_get+0x8c/0x3e0
> [   31.883195]  [<ffffffffa3489454>] ext4_xattr_security_get+0x24/0x40
> [   31.884086]  [<ffffffffa336a56b>] generic_getxattr+0x5b/0x90
> [   31.884907]  [<ffffffffa3700514>] smk_fetch+0xb4/0x150
> [   31.885634]  [<ffffffffa3700772>] smack_d_instantiate+0x1c2/0x550
> [   31.886508]  [<ffffffffa36f9a5a>] security_d_instantiate+0x3a/0x80
> [   31.887389]  [<ffffffffa3353b26>] d_instantiate_new+0x36/0x130
> [   31.888223]  [<ffffffffa342b1ef>] ext4_mkdir+0x4af/0x6a0
> [   31.888928]  [<ffffffffa3343470>] vfs_mkdir+0x100/0x280
> [   31.889536]  [<ffffffffa334b086>] SyS_mkdir+0xb6/0x170
> [   31.890255]  [<ffffffffa307c855>] ? trace_do_page_fault+0x95/0x2b0
> [   31.891134]  [<ffffffffa3c5e078>] entry_SYSCALL_64_fastpath+0x18/0x73
>=20
> Cc: <stable@vger.kernel.org> # 3.16, 4.4
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/dcache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 5a1c36dc5d65..baa00718d8d1 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1900,7 +1900,6 @@ void d_instantiate_new(struct dentry *entry, struct=
 inode *inode)
>  	BUG_ON(!hlist_unhashed(&entry->d_u.d_alias));
>  	BUG_ON(!inode);
>  	lockdep_annotate_inode_mutex_key(inode);
> -	security_d_instantiate(entry, inode);
>  	spin_lock(&inode->i_lock);
>  	__d_instantiate(entry, inode);
>  	WARN_ON(!(inode->i_state & I_NEW));
> @@ -1908,6 +1907,7 @@ void d_instantiate_new(struct dentry *entry, struct=
 inode *inode)
>  	smp_mb();
>  	wake_up_bit(&inode->i_state, __I_NEW);
>  	spin_unlock(&inode->i_lock);
> +	security_d_instantiate(entry, inode);
>  }
>  EXPORT_SYMBOL(d_instantiate_new);
> =20
--=20
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.



--=-UCJX5BCuOL81e29pynaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl34IOoACgkQ57/I7JWG
EQlpSRAAixDpQg8VyBz4aI52VPCIkKWbx72PNLPoKOOUQUX5HP0EbXOdUxhUP5HU
3Hc9+rVSyyy9IqStFb4Eaf0wlgLqwT0vYm5tzF6u0zOA7qdyLpOAEOywNaX92Tig
flhCd3M2l0hMWUaVBPuBfGFE64jpP8lnLaLB5mT0THa8SzqJdDJUmQ3r564l+0kY
l6HoWschaq6vFcfVzZZX5vb+rhbU8tBYWOlTW5+mb+TaJtp9NqGWUnw87/YUh+PD
dhQkL2CSwpcahs4BMhvjZo3gVNJe3Af3MousIloUoJ0qZLwQ78rm0zp7Vy4+b3tf
jM4uyU+KMa6kisa2XpbIMbC+TnA5U7n5xpR/g53PbjFtZ51EJwOLas3zW49vBpMQ
P9aTa5GLKHRoQ9OhvoSnulfW7BVnS0CxLVZP9xh6mQOF/0AYs0hMzeGDOs/zlEH8
lM/vp+0lrm0wpDWTKquNwqGyIejPAGJxwY63uuatrPBYjcJ9psstCppPoEpC+sAw
AcNyyTXJc6VfC/pAdRmhPA/fJYgYwTk4ImIwYK+rM7jb4qZ5Pj1lUvuz0/feuyPl
CN7K3JjMOyEwWS1ehMjTO27HliP02zVC/r1ZOksWnvs9rJ9bQFeTsADD3+svwTWc
VaTLm2nHwldIl6cNlETuLuUssrQ6/Vg93abbL4DWdV9DVBBfvoE=
=cS8o
-----END PGP SIGNATURE-----

--=-UCJX5BCuOL81e29pynaB--
