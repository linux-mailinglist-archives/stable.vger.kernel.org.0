Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E5930CED2
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhBBW1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235560AbhBBWZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:25:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D82264F63;
        Tue,  2 Feb 2021 22:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612304707;
        bh=z8IZi5utl5EY1phe5QlEjf75w9k6Q2h2qdJj6DABJOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L2DNrWtcfNQWccz7hbUyW8Mhq18uzFT613cMXGD8NxaouyhyBOe6DpYDWT7IQM17A
         Yx6I9J3AVo3t4i2JjeCPvlCZLXb7o0VuHEX1NPW1aF/QL9cp0on7mhmIlhy3+xWiHL
         yQkK3X3jBqQR+93tJjHFdebWYK+kq9NIsFht+/Ocn8d2AADsDNYgxLB6pFZLvn5TEZ
         UUAN3HP8xNs19zE1eat/mlyjfcWItabgt0pQBMA4x+Fj2TQLu+BIP3PgZ04mW+qGEK
         ibwfpSIR5wiTdeI8ZM7p01hZf6wk1UOL7BYSGJBcgbS5SstgN8XYaSBWZQoqCLr/mP
         WwU/RNAL/dz/g==
Date:   Wed, 3 Feb 2021 00:25:00 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-integrity@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Wang Hai <wanghai38@huawei.com>
Subject: Re: [PATCH] tpm: WARN_ONCE() -> pr_warn_once() in tpm_tis_status()
Message-ID: <YBnRPC2V2bxofNGe@kernel.org>
References: <20210202153317.57749-1-jarkko@kernel.org>
 <20210202164615.GM4718@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202164615.GM4718@ziepe.ca>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 12:46:15PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 02, 2021 at 05:33:17PM +0200, jarkko@kernel.org wrote:
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
> >  drivers/char/tpm/tpm_tis_core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index 431919d5f48a..21f67c6366cb 100644
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -202,7 +202,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
> >  		 * acquired.  Usually because tpm_try_get_ops() hasn't
> >  		 * been called before doing a TPM operation.
> >  		 */
> > -		WARN_ONCE(1, "TPM returned invalid status\n");
> > +		pr_warn_once("TPM returned invalid status: 0x%x\n", status);
> 
> Use dev_warn_once since we have a chip->dev here
> 
> Jason

Right obviously that one is best to be preferred. I'll do that. Thanks.

/Jarkko
