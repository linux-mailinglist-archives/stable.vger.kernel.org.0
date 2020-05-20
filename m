Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7405A1DA6BB
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 02:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgETAoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 20:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgETAo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 20:44:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF49C061A0E
        for <stable@vger.kernel.org>; Tue, 19 May 2020 17:44:29 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z26so718042pfk.12
        for <stable@vger.kernel.org>; Tue, 19 May 2020 17:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=s430EJB7RmoBPjOWD4EaCDtzUs1PkOuIqbnqhKXMVW0=;
        b=bedIwYFX9+2cHiNogs4Geq4ODkF4AmzYWVZlqlh271uYjw9lZhHMjqVXSDrzCc/6T/
         7mWrscT1901ZkbeOAObLowazD1IJJtyIMIY1bwBM7sGu/8Kp5e742X08hOaYs86BPSmn
         Sr5z67z6xFhx42Nag0h601jRc9Datz6gtKUuvk+TmaspRS8SPSGTojjCNGmSn4VudTlx
         jHPk2iYOBLe9Li5Cr8dVvmTnq2pm3BBRgOvdRI2HMwB92tTzYYMI319+3GuRpboIeH5V
         7SnJy9h5l8ie8OISM+5h6ug1GhO22gFwzZS6RYxlwC2wwWJ07yGwkSdy2+jJa49b0mYD
         w3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=s430EJB7RmoBPjOWD4EaCDtzUs1PkOuIqbnqhKXMVW0=;
        b=uOvfsGf9In1XtHIzNVB3IzSY07xHteXSRSgWZS0P0T6ImW10Qpspw9ksYOZ4m/bYwk
         uts3qiKCOQV1KKfh781xc6XHrXPRMMk1e7Yx7L3mn/o5b6Vr3RjOkrDRYUkXZYsS0Fdv
         BFM28ka5F19HjofICTN9NaUkKIR1geidKNKvEzq9Ucp4wMFd6IouHggiwtGGt+CkaB8l
         1tmp23RIuik/UWmFrDvQjPFHzCu0XTF6fgTjbwtjnwyGT9/8x0u8LiAdHOHhposq9nRL
         4FDX5LDn/UYhPRbxRpndfHS/9vx5VXOy7YydGxzCfagLY3jYvH7zauWQ9vLOMJGvJDjF
         p/Rw==
X-Gm-Message-State: AOAM5327DsojDifAp1EP0MN+BC+4FgihVqnWkLY9S3hr1Q9dNQoOzLsG
        kNKXj0ekWnXfVbHLDFjYNFoiOdPPtXtuiQ==
X-Google-Smtp-Source: ABdhPJxeximIo3SU1JWO3Fymu331fgRKoVSKm/KPjIWeblowxUhzTB7dC0flzYAjG+QLDpsx85FZlQ==
X-Received: by 2002:a63:1e5f:: with SMTP id p31mr1596630pgm.19.1589935468995;
        Tue, 19 May 2020 17:44:28 -0700 (PDT)
Received: from [192.168.10.160] (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id n205sm541869pfd.50.2020.05.19.17.44.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 17:44:28 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <20AA140E-877B-4240-9BEF-91D24215AF45@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_9BA1F62A-5378-475C-AF76-40175CDC3230";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 2/2] jbd2: Avoid leaking transaction credits when
 unreserving handle
Date:   Tue, 19 May 2020 18:44:25 -0600
In-Reply-To: <20200518092120.10322-3-jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
To:     Jan Kara <jack@suse.cz>
References: <20200518092120.10322-1-jack@suse.cz>
 <20200518092120.10322-3-jack@suse.cz>
X-Mailer: Apple Mail (2.3273)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_9BA1F62A-5378-475C-AF76-40175CDC3230
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 18, 2020, at 3:21 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> When reserved transaction handle is unused, we subtract its reserved
> credits in __jbd2_journal_unreserve_handle() called from
> jbd2_journal_stop(). However this function forgets to remove reserved
> credits from transaction->t_outstanding_credits and thus the =
transaction
> space that was reserved remains effectively leaked. The leaked
> transaction space can be quite significant in some cases and leads to
> unnecessarily small transactions and thus reducing throughput of the
> journalling machinery. E.g. fsmark workload creating lots of 4k files
> was observed to have about 20% lower throughput due to this when ext4 =
is
> mounted with dioread_nolock mount option.
>=20
> Subtract reserved credits from t_outstanding_credits as well.
>=20
> CC: stable@vger.kernel.org
> Fixes: 8f7d89f36829 ("jbd2: transaction reservation support")
> Signed-off-by: Jan Kara <jack@suse.cz>

Patch looks reasonable, with one minor nit below.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/jbd2/transaction.c | 17 +++++++++++++----
> 1 file changed, 13 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 3dccc23cf010..b49a103cff1f 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -541,17 +541,24 @@ handle_t *jbd2_journal_start(journal_t *journal, =
int nblocks)
> }
> EXPORT_SYMBOL(jbd2_journal_start);
>=20
> -static void __jbd2_journal_unreserve_handle(handle_t *handle)
> +static void __jbd2_journal_unreserve_handle(handle_t *handle, =
transaction_t *t)
> {
> 	journal_t *journal =3D handle->h_journal;
>=20
> 	WARN_ON(!handle->h_reserved);
> 	sub_reserved_credits(journal, handle->h_total_credits);
> +	if (t)
> +		atomic_sub(handle->h_total_credits, =
&t->t_outstanding_credits);
> }
>=20
> void jbd2_journal_free_reserved(handle_t *handle)
> {
> -	__jbd2_journal_unreserve_handle(handle);
> +	journal_t *journal =3D handle->h_journal;
> +
> +	/* Get j_state_lock to pin running transaction if it exists */
> +	read_lock(&journal->j_state_lock);
> +	__jbd2_journal_unreserve_handle(handle, =
journal->j_running_transaction);
> +	read_unlock(&journal->j_state_lock);
> 	jbd2_free_handle(handle);
> }
> EXPORT_SYMBOL(jbd2_journal_free_reserved);
> @@ -721,8 +728,10 @@ static void stop_this_handle(handle_t *handle)
> 	}
> 	atomic_sub(handle->h_total_credits,
> 		   &transaction->t_outstanding_credits);
> -	if (handle->h_rsv_handle)
> -		__jbd2_journal_unreserve_handle(handle->h_rsv_handle);
> +	if (handle->h_rsv_handle) {
> +		__jbd2_journal_unreserve_handle(handle->h_rsv_handle,
> +						transaction);
> +	}

There isn't any need for braces {} around this one-line if-block.


Cheers, Andreas






--Apple-Mail=_9BA1F62A-5378-475C-AF76-40175CDC3230
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl7EfWkACgkQcqXauRfM
H+CjDxAAgR72LLDqfiSa0CiTLsjpEG8ZXL+WEXseIQLOJe66IPm9f/VUmCZzncAw
0uPAq87QXoos8rmJidrX71JWRtd3+HC+cIVcNxCADtGi3oSRu3U0G0j0+HEEhtpp
ypGdY1LZ0SQEEa9HPcJqTq+XkybCZJ87MznMx4zacZcIzKw18pUDu+MemzK3KEw8
rBmb4mMHW/jsib/LifaaNOA6HOrk0aYa91bK8QTMimW93nhT/SVUOXFo156rKG8o
IC+k+VzIHtcyirI7r3OfzGTqtY3s9ymvtF1lrsY+I9JCyL9Lh8RoHkPXVuMH2oe9
O8pqWrzctwVre6VTYgXgNglrfpqht/Fq9Q9lmOsS/nohzf0SnTRTE5ZTJJUqLGCQ
4qQDboRWyOzRnbLawrADwWuP/FLhyPW8PAlUTY2djLX/8zPsOFKAu02AfaQJiZeu
xginCZFetyaUj/mSKYVTzR+qenrW9Z0J0oH/WxDUyAuvA3U8w16Kxg0HV7giQ5Wo
IiOUy/3aKvuzL9agECcrWoTWRglD6gydrcX8PEr+2HC/aAsf52S3d6PeRSv8robm
uQ6t06GsZ4e9yfU9NovWPSB+5L648Eld60a1tzt43Nfhsf3Z/6TrBOb7lVj7+e6V
Wz03I+AMnOBQh6y+EH93zOhBn1dwQm1wcb3asuzSvYlcZ17HXq8=
=/5kH
-----END PGP SIGNATURE-----

--Apple-Mail=_9BA1F62A-5378-475C-AF76-40175CDC3230--
