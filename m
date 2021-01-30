Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723B230987E
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 22:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhA3V3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 16:29:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231617AbhA3V3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 16:29:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1D1864E28;
        Sat, 30 Jan 2021 21:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612042124;
        bh=IEdMkWfaMTpe+aItAOx3xlsZs03km5O75suvzry/28w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=buPG/morYZRoEr5mAEcHCiEwlkSM9fk+PxXS3rmbfofrBO44kYEyTni17cXza0z8w
         deQ3WJOYkq0uCpCZutyiaIsMK96P+/kNjTA5xkBzTio3TEIRO/wG/V512FLPgaprAG
         Y+pECB4Ishpy43Yt/mnKIVPT+hb55iZW/iYquNtvptHxJZPhcTcSXLEC6kIugsevXk
         qkQaReJojFMtA2WR1mQ7DJHFjRBWVNM9I9VWO8zk7J9m97UwUx5KBctrXCYWHy9Xnj
         ndZXJpvhUln50WadzubAQycvdGohyvMPWjI/0jG+lK5f+O3wl3dpP5y1NH3Dlijtry
         CjtdnZjs2F/RQ==
Message-ID: <fe83527d3745b5f071b2807d724f27f7632ed8cb.camel@kernel.org>
Subject: Re: [PATCH v5 3/3] KEYS: trusted: Reserve TPM for seal and unseal
 operations
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date:   Sat, 30 Jan 2021 23:28:39 +0200
In-Reply-To: <6459b955f8cb05dae7d15a233f26ff9c9501b839.camel@linux.ibm.com>
References: <20210128235621.127925-1-jarkko@kernel.org>
         <20210128235621.127925-4-jarkko@kernel.org>
         <6459b955f8cb05dae7d15a233f26ff9c9501b839.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-01-29 at 08:58 -0500, Mimi Zohar wrote:
> On Fri, 2021-01-29 at 01:56 +0200, jarkko@kernel.org=C2=A0wrote:
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
>=20
> Tested-by: Mimi Zohar <zohar@linux.ibm.com> (on TPM 1.2 & PTT, discrete
> TPM 2.0)

Thanks, is it OK to apply the whole series?

/Jarkko

