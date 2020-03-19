Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B46518A9C9
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 01:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCSAal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 20:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCSAal (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 20:30:41 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4441E2076C;
        Thu, 19 Mar 2020 00:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584577840;
        bh=lGgOA8i9jqfs6+LhGMKQbt8ZockuHa4KYi8DijDb9RM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8XA+ek/ePQChr2azNKS8Pf09LUP95nJo4TgNt/1yTH1WEtvqN+mTNWIsuWIktOWI
         Fe3Pflwm6UytXRO3JVWX58IuV7L4/vb/AzKT4fhWWgflOyzHcR8obIWbeEThDnHFOl
         QL2gum5qOCMvBHFEhEC2wfQtuxBo+mkQUy/spfBw=
Date:   Wed, 18 Mar 2020 17:30:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH URGENT crypto] crypto: arm64/chacha - correctly walk
 through blocks
Message-ID: <20200319003038.GG2334@sol.localdomain>
References: <20200318234518.83906-1-Jason@zx2c4.com>
 <20200319002359.GF2334@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319002359.GF2334@sol.localdomain>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 05:24:01PM -0700, Eric Biggers wrote:
> Hi Jason,
> 
> On Wed, Mar 18, 2020 at 05:45:18PM -0600, Jason A. Donenfeld wrote:
> > Prior, passing in chunks of 2, 3, or 4, followed by any additional
> > chunks would result in the chacha state counter getting out of sync,
> > resulting in incorrect encryption/decryption, which is a pretty nasty
> > crypto vuln, dating back to 2018. WireGuard users never experienced this
> > prior, because we have always, out of tree, used a different crypto
> > library, until the recent Frankenzinc addition. This commit fixes the
> > issue by advancing the pointers and state counter by the actual size
> > processed.
> > 
> > Fixes: f2ca1cbd0fb5 ("crypto: arm64/chacha - optimize for arbitrary length inputs")
> > Reported-and-tested-by: Emil Renner Berthing <kernel@esmil.dk>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: stable@vger.kernel.org
> 
> Thanks for fixing this!  We definitely should get this fix to Linus for 5.6.
> But I don't think your description of this bug dating back to 2018 is accurate,
> because this bug only affects the new library interface to ChaCha20 which was
> added in v5.5.  In the "regular" crypto API case, the "walksize" is set to
> '5 * CHACHA_BLOCK_SIZE', and chacha_doneon() is guaranteed to be called with a
> multiple of '5 * CHACHA_BLOCK_SIZE' except at the end.  Thus the code worked
> fine with the regular crypto API.

So I think it's actually:

Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
Cc: <stable@vger.kernel.org> # v5.5+
