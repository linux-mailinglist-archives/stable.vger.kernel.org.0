Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0339230C8CE
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237984AbhBBSAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238107AbhBBR7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 12:59:07 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3996C06174A;
        Tue,  2 Feb 2021 09:58:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id A10091280937;
        Tue,  2 Feb 2021 09:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612288705;
        bh=dK/nfEvcp1DZ2YDpk8Iwhpvh9P38HcxpmJGB3AEtAeg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Xze+8Q1KzzaF8OCwoc9aZL2ZaMPSb5DkcI8/tfAshH2SbHo3HnZL0XF3egk06omgw
         5cqce8ld9y6JeO7G4MZl1YyVPjSsjYJIKYf1wXTnWvyZcMHhxxr9j6hdp9rBIFv216
         DL3u/E6JG5gUq9a1C+ITH1LnMV3wb/3R+Fqchm1s=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XeuJiCPzkeTs; Tue,  2 Feb 2021 09:58:25 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 17DB41280936;
        Tue,  2 Feb 2021 09:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612288705;
        bh=dK/nfEvcp1DZ2YDpk8Iwhpvh9P38HcxpmJGB3AEtAeg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Xze+8Q1KzzaF8OCwoc9aZL2ZaMPSb5DkcI8/tfAshH2SbHo3HnZL0XF3egk06omgw
         5cqce8ld9y6JeO7G4MZl1YyVPjSsjYJIKYf1wXTnWvyZcMHhxxr9j6hdp9rBIFv216
         DL3u/E6JG5gUq9a1C+ITH1LnMV3wb/3R+Fqchm1s=
Message-ID: <1d661a6bdf2d7a9a31b3357ef4170a1309cf2aa4.camel@HansenPartnership.com>
Subject: Re: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     "Serge E. Hallyn" <serge@hallyn.com>, jarkko@kernel.org
Cc:     linux-integrity@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Wang Hai <wanghai38@huawei.com>
Date:   Tue, 02 Feb 2021 09:58:24 -0800
In-Reply-To: <20210202172651.GA2821@mail.hallyn.com>
References: <20210202153317.57749-1-jarkko@kernel.org>
         <20210202172651.GA2821@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-02-02 at 11:26 -0600, Serge E. Hallyn wrote:
> On Tue, Feb 02, 2021 at 05:33:17PM +0200, jarkko@kernel.org wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > An unexpected status from TPM chip is not irrecovable failure of
> > the
> > kernel. It's only undesirable situation. Thus, change the WARN_ONCE
> > instance inside tpm_tis_status() to pr_warn_once().
> > 
> > In addition: print the status in the log message because it is
> > actually
> > useful information lacking from the existing log message.
> > 
> > Suggested-by:  Guenter Roeck <linux@roeck-us.net>
> > Cc: stable@vger.kernel.org
> > Fixes: 6f4f57f0b909 ("tpm: ibmvtpm: fix error return code in
> > tpm_ibmvtpm_probe()")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  drivers/char/tpm/tpm_tis_core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c
> > b/drivers/char/tpm/tpm_tis_core.c
> > index 431919d5f48a..21f67c6366cb 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -202,7 +202,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
> >  		 * acquired.  Usually because tpm_try_get_ops() hasn't
> >  		 * been called before doing a TPM operation.
> >  		 */
> > -		WARN_ONCE(1, "TPM returned invalid status\n");
> > +		pr_warn_once("TPM returned invalid status: 0x%x\n",
> > status);
> >  		return 0;
> >  	}
> 
> Actually in this case I don't understand why _once, especially based
> on the comment.  Would ratelimited not be better?  So we can see if
> it happens repeatedly?  Even better would be if we could see when it
> next gave a valid status after an invalid one.

The reason was that we're trying to catch and kill paths to the status
where the locality is incorrect.  If you do some operation that finds
an incorrect path the likelihood is you'll exercise it more than once,
but all we need to identify it is the call trace from a single access. 
The symptom the user space process sees is a TPM timeout, but we still
have the in-kernel trace to tell us why.

James


