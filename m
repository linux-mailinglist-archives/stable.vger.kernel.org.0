Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19653183BE8
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 23:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCLWG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 18:06:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:53628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgCLWG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 18:06:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C11B2AC44;
        Thu, 12 Mar 2020 22:06:54 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Date:   Fri, 13 Mar 2020 09:06:46 +1100
Cc:     linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        NeilBrown <neilb@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()
In-Reply-To: <20200312202552.241885-3-ebiggers@kernel.org>
References: <20200312202552.241885-1-ebiggers@kernel.org> <20200312202552.241885-3-ebiggers@kernel.org>
Message-ID: <87imj9teh5.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12 2020, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
>
> After request_module(), nothing is stopping the module from being
> unloaded until someone takes a reference to it via try_get_module().
>
> The WARN_ONCE() in get_fs_type() is thus user-reachable, via userspace
> running 'rmmod' concurrently.
>
> Since WARN_ONCE() is for kernel bugs only, not for user-reachable
> situations, downgrade this warning to pr_warn_once().
>
> Cc: stable@vger.kernel.org
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jeff Vander Stoep <jeffv@google.com>
> Cc: Jessica Yu <jeyu@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/filesystems.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/filesystems.c b/fs/filesystems.c
> index 77bf5f95362da..90b8d879fbaf3 100644
> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -272,7 +272,9 @@ struct file_system_type *get_fs_type(const char *name)
>  	fs =3D __get_fs_type(name, len);
>  	if (!fs && (request_module("fs-%.*s", len, name) =3D=3D 0)) {
>  		fs =3D __get_fs_type(name, len);
> -		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n",=
 len, name);
> +		if (!fs)
> +			pr_warn_once("request_module fs-%.*s succeeded, but still no fs?\n",
> +				     len, name);

I strongly support the replacement of "WARN" by "pr_warn".
I wonder if we really want the "once" now.  Possibly using rate_limited
would be justified, but I think that in general we should see a warning
every time this event happens.

Thanks,
NeilBrown


>  	}
>=20=20
>  	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
> --=20
> 2.25.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl5qsnYACgkQOeye3VZi
gbl3oBAAuV3LZM5xUEigsaeRtvVM9jGCrTQ5m9xsUxqV7SJ+fQfKx2sgHAZL5fD7
RfCoUBsYaOaeXL6XsSAb/ztSXlPAsADvhZxvNiz1DCdl+fkULVrG1k91iLKgNJuu
jiByqqs+vZxeHp8BjOMDPts3VimUxKSoVIOX5wui7xC4ZWsYxY3Ca0g0E0VSj54f
lRCs+80C0mkaQ+VwtHtamSgEFlIkqElqTTmnCVF98LrTI9X1GNSIN0jQz9fVjChS
n/pyrFnJ8Py9FdbC7gZ2xNJe/01va8uKeCvE7Lqyfp3bHfTFJlNXul60rmoAWnM2
QSLuMqXHOLh4kdT52FHplr4ejmp6i+0uYzJbIPSMwY/KhWn2Z4b33rCchaxATU7P
MhfIIhjAOOU+72iL93Xm5DMpHrHQAdsQH/hV4kpizhoqDL5kRS6apYmqJ0HGdfGf
g7kqx+zrnNrkO2QdqJ2PDXJJCn4pZa6htMEESsdWkhltTPaQQ8c3BgjD5sywEFJP
lkI5wQBSjzyiZRI6n94WB4PuHJzZLk1fQcRGjt22w+6U0p4dNvtIDo40L7kZK8dk
uqSyat6aSpriad0xtXc8BTPhfctDRmiNyy5vRPfmac9lim3YQjYFECTUTNd5tTYx
+Vzy+DNAA2tFWlVjV9xlwLVzPS9dMHDbTO41NE4GA0UQb9qXpYg=
=siGd
-----END PGP SIGNATURE-----
--=-=-=--
