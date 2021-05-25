Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0A93907E7
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 19:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhEYRih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 13:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233967AbhEYRia (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 13:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C4B61378;
        Tue, 25 May 2021 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621964219;
        bh=/rHkfUQ7KM1M9vepQBDF0QwGCdC9VZPZPAfgk+R18YY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hZVQ2JjGl+lCnm+APBmmIYRtZqwkKGm13UKBEIyZmYiHjL3cZpFlB3SugsZ4T6TZj
         rIxFgaA8gtIuvABjxIGUmf4dZLKNxbFPvSXd9OKiw7Kcqh9EbWxDhGTUUknFVbiHss
         eX75jKyf76gaDo5dfm0WtrZE6+YXTjEdebzt/y/stJDnRK7qLDGvQU43/ywWpImzmd
         w4kQ4/f9WdxrSewWYG3Atm+bgLFCmIFkLK2GUBRTWr8c64E5o3MAmCyjMat1NErxPE
         LYKcMMMOHaefqth0PKg5WmlPy+cDvmUNsI2/kDYmeETQ1Vc7+mGJDEeHSfW/vz67Zc
         N0qoy8rdd8q0A==
Date:   Tue, 25 May 2021 10:36:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Andrew Zaborowski <andrew.zaborowski@intel.com>,
        keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [RESEND][PATCH 1/2] keys: crypto: Replace BUG_ON() with WARN()
 in find_asymmetric_key()
Message-ID: <YK01uql9bu5k3sxA@sol.localdomain>
References: <20210525113628.2682248-1-andrew.zaborowski@intel.com>
 <YKzlTR1AzUigShtZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKzlTR1AzUigShtZ@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 01:53:49PM +0200, Greg KH wrote:
> On Tue, May 25, 2021 at 01:36:27PM +0200, Andrew Zaborowski wrote:
> > From: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > BUG_ON() should not be used in the kernel code, unless there are
> > exceptional reasons to do so. Replace BUG_ON() with WARN() and
> > return.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: b3811d36a3e7 ("KEYS: checking the input id parameters before finding asymmetric key")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > No changes from original submission by Jarkko.
> > 
> >  crypto/asymmetric_keys/asymmetric_type.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
> > index ad8af3d70ac..a00bed3e04d 100644
> > --- a/crypto/asymmetric_keys/asymmetric_type.c
> > +++ b/crypto/asymmetric_keys/asymmetric_type.c
> > @@ -54,7 +54,10 @@ struct key *find_asymmetric_key(struct key *keyring,
> >  	char *req, *p;
> >  	int len;
> >  
> > -	BUG_ON(!id_0 && !id_1);
> > +	if (!id_0 && !id_1) {
> > +		WARN(1, "All ID's are NULL\n");
> 
> You still just rebooted a machine (panic-on-warn is commonly set).
> 
> Please just handle this properly, print an error message with dev_err()
> or pr_err() and move on, don't crash things.
> 

If this case is a kernel bug (which looks to be the case here), then WARN() is
correct.  The whole point of panic_on_warn is to panic the kernel when it
encounters something that has been flagged as a kernel bug, even if it would
otherwise be recoverable.

- Eric
