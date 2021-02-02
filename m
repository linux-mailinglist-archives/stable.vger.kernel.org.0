Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BDE30CE72
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhBBWHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:07:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231402AbhBBWG4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:06:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D44BE64F78;
        Tue,  2 Feb 2021 22:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612303574;
        bh=qsH2JTCJoBfXTwEuB3rOzMA5cizN7wSbKzDogYG2dtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FhpiZIeAq6FJKTT6H1Bboy7sN1eumKiEQf0DV71RDns7BJYtm8l6ATfC6fzbeiPFF
         yUd1QiO6Hj45spwTo8ZP/vqKQPHCtUmmZ1ADSXckaoW4Xpraa/LDDZRe3hg9x+W3Dk
         XfiFw5yHmAxtR/OnAxujfjx6iJGFMkZzgBYZHhGz1BGpUYZAMSxiabbOzv/1/z4ZDR
         JEUKvZMnDvwe9cbEPvaUdQqGvZD1GuaiCW6hrRVCyodjD2ZylnhTId4fIcTvdZHSNS
         /NxRaE7HFdFkuq6qhwx6LiBcD4eQE4Nr1fYgc1Wh2p1Urlwq0sz4DiSX/XAbHY5mwX
         ip0SSrOkSIUwg==
Date:   Wed, 3 Feb 2021 00:06:07 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Stefan Berger <stefanb@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Wang Hai <wanghai38@huawei.com>
Subject: Re: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
Message-ID: <YBnMzwKeTCdM//Rv@kernel.org>
References: <20210202153317.57749-1-jarkko@kernel.org>
 <3936843b-c0da-dd8c-8aa9-90aa3b49d525@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3936843b-c0da-dd8c-8aa9-90aa3b49d525@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 11:05:36AM -0500, Stefan Berger wrote:
> On 2/2/21 10:33 AM, jarkko@kernel.org wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > An unexpected status from TPM chip is not irrecovable failure of the
> > kernel. It's only undesirable situation. Thus, change the WARN_ONCE
> > instance inside tpm_tis_status() to pr_warn_once().
> > 
> > In addition: print the status in the log message because it is actually
> > useful information lacking from the existing log message.
> > 
> > Suggested-by:  Guenter Roeck <linux@roeck-us.net>
> > Cc: stable@vger.kernel.org
> > Fixes: 6f4f57f0b909 ("tpm: ibmvtpm: fix error return code in tpm_ibmvtpm_probe()")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >   drivers/char/tpm/tpm_tis_core.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index 431919d5f48a..21f67c6366cb 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -202,7 +202,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
> >   		 * acquired.  Usually because tpm_try_get_ops() hasn't
> >   		 * been called before doing a TPM operation.
> >   		 */
> > -		WARN_ONCE(1, "TPM returned invalid status\n");
> > +		pr_warn_once("TPM returned invalid status: 0x%x\n", status);
> >   		return 0;
> >   	}
> 
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

Thank you.

/Jarkko
