Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955B530CEF1
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhBBWb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233761AbhBBWaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:30:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 128BE64F84;
        Tue,  2 Feb 2021 22:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612304981;
        bh=vT2E0ya2XxLWSACOrxDzeo4wc0yndhTkeK2S5SvzZLY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AqoQq1ANJHNfJ5ABpt9fHlRhbclm5PFNAfr1DNDvTJp4N9AVK+n21W3qNPV7nvS/+
         rDWfBFJbQS+6GE9tZMrfrMq8mSUoK7S3ZHasx987oNpRYLdGG2wo/pWQvq293F0Hx+
         g8xvtys4vSxW4CZPz5+Q32WiR21gpoMgEzjCTxlWmKAAVUJNA2P6hjc+rfDhN5SVBb
         xCSgTgqs5EPAj/IQkmIxH/OipU4UZrPG0hUz1YRLJXvsAiV9btLiw8XzihPaIC6uSx
         tZzHPQP8orb12DoSWv2LYxeUGaecdgQ8iB9H1niHCqDWPsDczbKUO+Mw9bkMbR3jUI
         cFr03wqJlgRZQ==
Date:   Wed, 3 Feb 2021 00:29:34 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        linux-integrity@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Wang Hai <wanghai38@huawei.com>
Subject: Re: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
Message-ID: <YBnSThFkcPLU2Rki@kernel.org>
References: <20210202153317.57749-1-jarkko@kernel.org>
 <20210202172651.GA2821@mail.hallyn.com>
 <1d661a6bdf2d7a9a31b3357ef4170a1309cf2aa4.camel@HansenPartnership.com>
 <YBnR2YLitNJzvNBk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBnR2YLitNJzvNBk@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 12:27:40AM +0200, Jarkko Sakkinen wrote:
> On Tue, Feb 02, 2021 at 09:58:24AM -0800, James Bottomley wrote:
> > On Tue, 2021-02-02 at 11:26 -0600, Serge E. Hallyn wrote:
> > > On Tue, Feb 02, 2021 at 05:33:17PM +0200, jarkko@kernel.org wrote:
> > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > 
> > > > An unexpected status from TPM chip is not irrecovable failure of
> > > > the
> > > > kernel. It's only undesirable situation. Thus, change the WARN_ONCE
> > > > instance inside tpm_tis_status() to pr_warn_once().
> > > > 
> > > > In addition: print the status in the log message because it is
> > > > actually
> > > > useful information lacking from the existing log message.
> > > > 
> > > > Suggested-by:  Guenter Roeck <linux@roeck-us.net>
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 6f4f57f0b909 ("tpm: ibmvtpm: fix error return code in
> > > > tpm_ibmvtpm_probe()")
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > ---
> > > >  drivers/char/tpm/tpm_tis_core.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/char/tpm/tpm_tis_core.c
> > > > b/drivers/char/tpm/tpm_tis_core.c
> > > > index 431919d5f48a..21f67c6366cb 100644
> > > > --- a/drivers/char/tpm/tpm_tis_core.c
> > > > +++ b/drivers/char/tpm/tpm_tis_core.c
> > > > @@ -202,7 +202,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
> > > >  		 * acquired.  Usually because tpm_try_get_ops() hasn't
> > > >  		 * been called before doing a TPM operation.
> > > >  		 */
> > > > -		WARN_ONCE(1, "TPM returned invalid status\n");
> > > > +		pr_warn_once("TPM returned invalid status: 0x%x\n",
> > > > status);
> > > >  		return 0;
> > > >  	}
> > > 
> > > Actually in this case I don't understand why _once, especially based
> > > on the comment.  Would ratelimited not be better?  So we can see if
> > > it happens repeatedly?  Even better would be if we could see when it
> > > next gave a valid status after an invalid one.
> > 
> > The reason was that we're trying to catch and kill paths to the status
> > where the locality is incorrect.  If you do some operation that finds
> > an incorrect path the likelihood is you'll exercise it more than once,
> > but all we need to identify it is the call trace from a single access. 
> > The symptom the user space process sees is a TPM timeout, but we still
> > have the in-kernel trace to tell us why.
> 
> I don't agree with this reasoning. This warn could spun off also from chip
> not following TCG spec. The patch does provide the status code, which is
> always useful information.

I.e. WARN() implies usually that there is something wrong in the kernel
state risking its stability which *is not* case here. Thus, it's best to
make the status code visible, not the stack trace, and make rest of the
conclusions from that.

/Jarkko
