Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3279F4859BE
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 21:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243826AbiAEUF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 15:05:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57384 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243804AbiAEUFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 15:05:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00ECE618EE;
        Wed,  5 Jan 2022 20:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB47EC36AE9;
        Wed,  5 Jan 2022 20:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641413124;
        bh=i9ijiSAZhMIkeK5p6Sg4YwWy4SiKzLVwwbjM2KYc+4E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XOFlqv6Mxy9ImL6hQxPISDSoP+fCItTHb8u8BzpErtq7di3nm3Z5vS1KTygbRlxaJ
         8mGFzLLp+/PWyLnspPlJep1/9mEXYxyTV3WbE4PsWDiFiYXUAVs6f4GGNjVLcqoAZI
         sRMw6dfuh4rcmxnHKMl5L3/aYhVNkXGzlw9IDa0jMtmWj/vIrzOGDuBScxVzP5Iayo
         wVUuhTFLwBQoOh+bBYb39GkHM+SrA3rXg6H6Kq1sw6S38Ysu1ucpQzIn8UJfY61wsE
         EBhljGywFKaBS4q1YTZRmKFK+8JOMXasEE0xu0PspD6guWRP0OF54NsMN1Z5B3PQb4
         R5STTLGlc+6WA==
Message-ID: <883e4ac1a10dc192824dff3eb6489d027417d1d4.camel@kernel.org>
Subject: Re: [PATCH v2 1/2] tpm: Fix error handling in async work
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tadeusz Struk <tstruk@gmail.com>, jarkko@kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 05 Jan 2022 22:05:18 +0200
In-Reply-To: <20211229050655.2030-1-tstruk@gmail.com>
References: <20211229050655.2030-1-tstruk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-12-28 at 21:06 -0800, Tadeusz Struk wrote:
> When an invalid (non existing) handle is used in a tpm command,
                                                     ~~~
                                                     TPM

> that uses the resource manager interface (/dev/tpmrm0) the resource
> manager tries to load it from its internal cache, but fails and
> returns an -EINVAL error to the caller. The async handler doesn't
> handle these error cases currently and the condition in the poll
> handler never returns mask with EPOLLIN set.
> The result is that the poll call blocks and the application gets
> stuck
> until the user_read_timer wakes it up after 120 sec.
> Make sure that error conditions also contribute to the poll mask
> so that a correct error code could passed back to the caller.

I'm not sure what "making sure" means.

>=20
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: <linux-integrity@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Fixes: 9e1b74a63f77 ("tpm: add support for nonblocking operation")
> Signed-off-by: Tadeusz Struk <tstruk@gmail.com>
> ---
> Changes in v2:
> - Updated commit message with better problem description.
> - Fixed typeos.
> ---
> =C2=A0drivers/char/tpm/tpm-dev-common.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/char/tpm/tpm-dev-common.c
> b/drivers/char/tpm/tpm-dev-common.c
> index c08cbb306636..fe2679f84cb6 100644
> --- a/drivers/char/tpm/tpm-dev-common.c
> +++ b/drivers/char/tpm/tpm-dev-common.c
> @@ -69,7 +69,7 @@ static void tpm_dev_async_work(struct work_struct
> *work)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D tpm_dev_transmit(=
priv->chip, priv->space, priv-
> >data_buffer,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(priv->data_buffer));
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tpm_put_ops(priv->chip);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret > 0) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret !=3D 0) {

What if ret < 0?

You should explain this change in the commit message. Also, consider
adding an inline comment.

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0priv->response_length =3D ret;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0mod_timer(&priv->user_read_timer, jiffies + (120 *
> HZ));
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}

BR,
Jarkko
