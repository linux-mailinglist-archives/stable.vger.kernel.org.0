Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFB330987C
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 22:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhA3V2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 16:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231970AbhA3V2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 16:28:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD36464E15;
        Sat, 30 Jan 2021 21:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612042083;
        bh=LWAUUOMJxMF/jjGGiyOe5lWXDEo2fMBk8QuQVYWzdnQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V6l+T18uJAOQ2eB2aiMhcq6mfHLzuTLqwX8MprZnYP7pbqcikBThmFt1byoTIwQHM
         Z7YMRldjCyXI1yu7/0QX+YQ5O/ou1PXQ3xm0CzToWNWUR8mbXDZ62gMhBeD/LwWiKX
         eyPOPg0mRh4FpYhEstc/GruLmRJy9TXLz4zVM/HELNjTTGerNAA9VgqvwHKwxA+Em+
         rsPK6iaP9O2QVE9h677ZbtaBr/Lb3g3T6oahffFJSmA18xe2e5n0qi/PQi8AoahRHN
         gdovgP63ckDq388sSoNDJZq3hhA5pNWT7rI1CdsjVeFvPitnDjih9ZLXAtfYRPHiLm
         8ykeRgX9ns3EQ==
Message-ID: <1a2bb90a6468093aa128940a52ad8e38ea9538ab.camel@kernel.org>
Subject: Re: [PATCH v5 3/3] KEYS: trusted: Reserve TPM for seal and unseal
 operations
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-integrity@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        stable <stable@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date:   Sat, 30 Jan 2021 23:27:58 +0200
In-Reply-To: <CAFA6WYOAbHV=sOxuUdJq91sZbKDMbo6D5KXcSp9ix0PWLpSdaA@mail.gmail.com>
References: <20210128235621.127925-1-jarkko@kernel.org>
         <20210128235621.127925-4-jarkko@kernel.org>
         <CAFA6WYOAbHV=sOxuUdJq91sZbKDMbo6D5KXcSp9ix0PWLpSdaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-01-29 at 14:44 +0530, Sumit Garg wrote:
> On Fri, 29 Jan 2021 at 05:26, <jarkko@kernel.org> wrote:
> >=20
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> >=20
> > When TPM 2.0 trusted keys code was moved to the trusted keys subsystem,
> > the operations were unwrapped from tpm_try_get_ops() and tpm_put_ops(),
> > which are used to take temporarily the ownership of the TPM chip. The
> > ownership is only taken inside tpm_send(), but this is not sufficient,
> > as in the key load TPM2_CC_LOAD, TPM2_CC_UNSEAL and TPM2_FLUSH_CONTEXT
> > need to be done as a one single atom.
> >=20
> > Take the TPM chip ownership before sending anything with
> > tpm_try_get_ops() and tpm_put_ops(), and use tpm_transmit_cmd() to send
> > TPM commands instead of tpm_send(), reverting back to the old behaviour=
.
> >=20
> > Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
> > Reported-by: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.=
com>
> > Cc: stable@vger.kernel.org
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Mimi Zohar <zohar@linux.ibm.com>
> > Cc: Sumit Garg <sumit.garg@linaro.org>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > =C2=A0drivers/char/tpm/tpm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 4 ----
> > =C2=A0include/linux/tpm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 5 ++++-
> > =C2=A0security/keys/trusted-keys/trusted_tpm2.c | 24 ++++++++++++++++++=
-----
> > =C2=A03 files changed, 23 insertions(+), 10 deletions(-)
> >=20
>=20
> Acked-by: Sumit Garg <sumit.garg@linaro.org>

Thanks.

/Jarkko
