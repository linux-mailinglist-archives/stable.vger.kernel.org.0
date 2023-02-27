Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD116A4717
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 17:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjB0Qez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 11:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjB0Qez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 11:34:55 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BC91BFE;
        Mon, 27 Feb 2023 08:34:54 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E5D441C0AB2; Mon, 27 Feb 2023 17:34:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1677515692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ktO3Rbjq63JIQYyF79cKaeyJl8mq0I/C+Gd1rfs+flQ=;
        b=e+K/uL1wgdHsRR2bJkP4h2MgGY5sFBEX+nLO5wIfy8ZaP/bC7gSYAYuWryTUk4z0EiiN25
        sCisIBwansU0ST3n5HSI+K+Y4UP2d1eAry3NwQl1L+Kq3I9C4fkWDznTT4rLyyaQ0ZfFH9
        xz2WqiI2UwqrGptNq3HmbhGy7mScMUw=
Date:   Mon, 27 Feb 2023 17:34:52 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 4/5] fs/super.c: stop calling
 fscrypt_destroy_keyring() from __put_super()
Message-ID: <Y/zbrCJz4SONlZFs@duo.ucw.cz>
References: <20230226034408.774670-1-sashal@kernel.org>
 <20230226034408.774670-4-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ciODApcgPoRi2ROG"
Content-Disposition: inline
In-Reply-To: <20230226034408.774670-4-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ciODApcgPoRi2ROG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Eric Biggers <ebiggers@google.com>
>=20
> [ Upstream commit ec64036e68634231f5891faa2b7a81cdc5dcd001 ]
>=20
> Now that the key associated with the "test_dummy_operation" mount option
> is added on-demand when it's needed, rather than immediately when the
> filesystem is mounted, fscrypt_destroy_keyring() no longer needs to be
> called from __put_super() to avoid a memory leak on mount failure.
>=20
> Remove this call, which was causing confusion because it appeared to be
> a sleep-in-atomic bug (though it wasn't, for a somewhat-subtle
> reason).

Not a bugfix, so should not be in -stable. Plus, have someone verified
that its dependencies are in 5.10?

Best regards,
								Pavel
> +++ b/fs/super.c
> @@ -293,7 +293,6 @@ static void __put_super(struct super_block *s)
>  		WARN_ON(s->s_inode_lru.node);
>  		WARN_ON(!list_empty(&s->s_mounts));
>  		security_sb_free(s);
> -		fscrypt_destroy_keyring(s);
>  		put_user_ns(s->s_user_ns);
>  		kfree(s->s_subtype);
>  		call_rcu(&s->rcu, destroy_super_rcu);

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--ciODApcgPoRi2ROG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY/zbrAAKCRAw5/Bqldv6
8qXxAJ9/dQJ6j0oncg7mDsIO9KEa/UDdBwCeMsXPKOE98RMQxhMpVhGbfWL1hbM=
=AVsw
-----END PGP SIGNATURE-----

--ciODApcgPoRi2ROG--
