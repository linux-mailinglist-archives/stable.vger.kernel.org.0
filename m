Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6571130C5E2
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhBBQco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:32:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236460AbhBBQai (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 11:30:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A3B664F77;
        Tue,  2 Feb 2021 16:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612283396;
        bh=auiylDdvS8zkAtHyDuX8d4D4sgyzTsMkWKW7fagY8nk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gQdkQ8C1rd1feBhs+1CgzAEmHuNCL1Pdm2risOYalZ1YW7KPVOx5RcZDYZHhzJ1hv
         uaU4ouB7vymXe504HussybPimhQ/u5+SpmMOTuZOuvr+BskERTl8y1uAKBvyTxSiir
         EzqaTQ6qfLzSnai272Km6u7UVGDKwVZeBYCf8GPF7eamxyPT+x2iwwKZ1PmaF2rd8f
         SvD7uHD/lUfn741kxPXkqPIexN+jWxnBkangNyMoqKwvLRM9rQ3sMteXCXQOKTZEw9
         xdmx8afcHLWxtLwhXSgGHX2FEgxlhU9WE8hTL+yzzK7oZ9jzMMhrrKvy5JQNoNYn09
         6qAdMEvD6bKoA==
Date:   Tue, 2 Feb 2021 18:29:49 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v5 3/3] KEYS: trusted: Reserve TPM for seal and unseal
 operations
Message-ID: <YBl9/V35mwgCWZnl@kernel.org>
References: <20210128235621.127925-1-jarkko@kernel.org>
 <20210128235621.127925-4-jarkko@kernel.org>
 <6459b955f8cb05dae7d15a233f26ff9c9501b839.camel@linux.ibm.com>
 <fe83527d3745b5f071b2807d724f27f7632ed8cb.camel@kernel.org>
 <f7c48b191cdb549197a51d7e55c63b13c503e182.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c48b191cdb549197a51d7e55c63b13c503e182.camel@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 31, 2021 at 07:52:42AM -0500, Mimi Zohar wrote:
> On Sat, 2021-01-30 at 23:28 +0200, Jarkko Sakkinen wrote:
> > On Fri, 2021-01-29 at 08:58 -0500, Mimi Zohar wrote:
> > > On Fri, 2021-01-29 at 01:56 +0200, jarkko@kernel.org wrote:
> > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > 
> > > > When TPM 2.0 trusted keys code was moved to the trusted keys subsystem,
> > > > the operations were unwrapped from tpm_try_get_ops() and tpm_put_ops(),
> > > > which are used to take temporarily the ownership of the TPM chip. The
> > > > ownership is only taken inside tpm_send(), but this is not sufficient,
> > > > as in the key load TPM2_CC_LOAD, TPM2_CC_UNSEAL and TPM2_FLUSH_CONTEXT
> > > > need to be done as a one single atom.
> > > > 
> > > > Take the TPM chip ownership before sending anything with
> > > > tpm_try_get_ops() and tpm_put_ops(), and use tpm_transmit_cmd() to send
> > > > TPM commands instead of tpm_send(), reverting back to the old behaviour.
> > > > 
> > > > Fixes: 2e19e10131a0 ("KEYS: trusted: Move TPM2 trusted keys code")
> > > > Reported-by: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> > > > Cc: stable@vger.kernel.org
> > > > Cc: David Howells <dhowells@redhat.com>
> > > > Cc: Mimi Zohar <zohar@linux.ibm.com>
> > > > Cc: Sumit Garg <sumit.garg@linaro.org>
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > 
> > > Tested-by: Mimi Zohar <zohar@linux.ibm.com> (on TPM 1.2 & PTT, discrete
> > > TPM 2.0)
> > 
> > Thanks, is it OK to apply the whole series?
> 
> Yes.  The testing was with the entire patch set, but I didn't
> explicitly test each change.  For the other two patches, please add my
> Reviewed-by.
> 
> Mimi

Thank you. I will do that.

/Jarkko
