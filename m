Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BAD183E1E
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgCMBA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 21:00:57 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37323 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCMBA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 21:00:57 -0400
Received: by mail-pj1-f67.google.com with SMTP id ca13so3402229pjb.2;
        Thu, 12 Mar 2020 18:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mSSMF1jNwzM5mCMZ+YsKqVM0aKz6yFStwmw3P4+Q8vU=;
        b=kbFOHePx3T0JAyzD1+Ya4v49kWhv+8dhrRKySJef8DrKVbTSaLmcWPgTPzsFIDxHV1
         kS6cS9PdBmL4LH1siHHerL6ZWFet3jvViE73DtTpnkO3ZGtkktujx9qXVIpUP2Xswlc2
         qPkruRRyTkfzxaDPs2K0CJsdprkKBO8EJ000h5BDmqhT4APIuno5QkbZLaCO2wrfSkeT
         os6lE/xdkhW/G3yARp8W6tu5E6DuMp7M/dbMllz8MTEIsipFonp6hys/WhwjVfgPzTly
         5369gekgVlXUUJOk7yPp+5EVjQsuxlEXdM43GB8fqA7KFusLvGzYgmUTYdV1dp5hcwc5
         tEuQ==
X-Gm-Message-State: ANhLgQ1ZpKdPpzAvVN8EDftgLjmeZVura5QxtKif2e/zRe6lgMEIgNzg
        n/IygfkilwE6JJEvtw+XtRkS23oJTdY=
X-Google-Smtp-Source: ADFU+vvrg/s9T1HRu+K3Vt6HiLeYWGGkc7NxSQEjLlLhNFDkBNzm9yVkvypxj4o4BxIX63xKjqkkcQ==
X-Received: by 2002:a17:902:694c:: with SMTP id k12mr10589884plt.329.1584061256321;
        Thu, 12 Mar 2020 18:00:56 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g69sm7121370pje.34.2020.03.12.18.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 18:00:54 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id E0BD84028E; Fri, 13 Mar 2020 01:00:53 +0000 (UTC)
Date:   Fri, 13 Mar 2020 01:00:53 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     NeilBrown <neilb@suse.de>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>, NeilBrown <neilb@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] fs/filesystems.c: downgrade user-reachable
 WARN_ONCE() to pr_warn_once()
Message-ID: <20200313010053.GS11244@42.do-not-panic.com>
References: <20200312202552.241885-1-ebiggers@kernel.org>
 <20200312202552.241885-3-ebiggers@kernel.org>
 <87imj9teh5.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <87imj9teh5.fsf@notabene.neil.brown.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2020 at 09:06:46AM +1100, NeilBrown wrote:
> On Thu, Mar 12 2020, Eric Biggers wrote:
>=20
> > From: Eric Biggers <ebiggers@google.com>
> >
> > After request_module(), nothing is stopping the module from being
> > unloaded until someone takes a reference to it via try_get_module().
> >
> > The WARN_ONCE() in get_fs_type() is thus user-reachable, via userspace
> > running 'rmmod' concurrently.
> >
> > Since WARN_ONCE() is for kernel bugs only, not for user-reachable
> > situations, downgrade this warning to pr_warn_once().
> >
> > Cc: stable@vger.kernel.org
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Jeff Vander Stoep <jeffv@google.com>
> > Cc: Jessica Yu <jeyu@kernel.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Luis Chamberlain <mcgrof@kernel.org>
> > Cc: NeilBrown <neilb@suse.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  fs/filesystems.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/filesystems.c b/fs/filesystems.c
> > index 77bf5f95362da..90b8d879fbaf3 100644
> > --- a/fs/filesystems.c
> > +++ b/fs/filesystems.c
> > @@ -272,7 +272,9 @@ struct file_system_type *get_fs_type(const char *na=
me)
> >  	fs =3D __get_fs_type(name, len);
> >  	if (!fs && (request_module("fs-%.*s", len, name) =3D=3D 0)) {
> >  		fs =3D __get_fs_type(name, len);
> > -		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n=
", len, name);
> > +		if (!fs)
> > +			pr_warn_once("request_module fs-%.*s succeeded, but still no fs?\n",
> > +				     len, name);
>=20
> I strongly support the replacement of "WARN" by "pr_warn".
> I wonder if we really want the "once" now.  Possibly using rate_limited
> would be justified, but I think that in general we should see a warning
> every time this event happens.

Since the usefulness of the print is at boot, I think pr_warn_once() is
good right now but just because I cannot think of a case where multiple
prints are currently desirable, or where this should be possible
post-boot. Can you?

  Luis

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEENnNq2KuOejlQLZofziMdCjCSiKcFAl5q20EACgkQziMdCjCS
iKfnAg//YO6054oZ2BeLdkU7iF2nNMAvYEsJb8/1UxyS+6T/oJ7tB6qkkURs5oky
sJtxPgUtlqS+PA1K7x+VE62/FLFAeMxX6nHx6aSUWUvD2lm4cDSegjSDW2ChUrF1
GiHt0EmSjYuzNkHfTfnsLO2sUY8ZnaLqfLoDOPiFlf7KCskTqtE7JR5UfXflNe+B
snXXpxQY7zvljIjw6ylB3I6dSHX4b7NML/74P+NlQH/hGadPQ6oGi5xG9T/cwEJ3
57aaHndOtS2XIvR8ilueemewZuxnRwWxNJYwPF4XUKO8gqFTzqQMLtaPfvzcpoj9
KqfNj24/XGyYxluCL/OS5YE9Y6/aStM9eppN4Ycy9c5RxdIWCNer7aGPyqvU9Hya
Mt20u7x25eOMORti72qQEQaDCDCdAq8cB1glqJpF8HyixRUaAJcCeDyK0PbJHoDz
IbQ2P0nR8evgx/H2SaETdRpaGDU9zZ7/HOYiAg5OuF3pBiTHiIFrMqHc19eAo8Oy
tnsowlCCAAx16D7CIYHuF4dGKaiPja/78UPyx1lVZVaqWObuZaFBM5sO1HRFGAPv
wEsCL4038eqNrAkdxFIeZPEyr8C+JC32OmptqlGQIG1XY1dWIiGtlNARvvFG/tVg
gOIoSdRk9QQVfjEK7NUvfw6pxYFoGt/GGssIY75Me5AfqBW/5fc=
=dx47
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
