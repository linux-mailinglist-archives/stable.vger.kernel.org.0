Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625F349CBCF
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241875AbiAZOGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:06:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39776 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiAZOGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:06:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9D85B81E18;
        Wed, 26 Jan 2022 14:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED0AC340E3;
        Wed, 26 Jan 2022 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643205981;
        bh=fBo2lZFgwC79lVOAmFUYUrB+mT5nY4lcwlxA8CcRsbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5JedRAuSt2BXKLv1ulUjQUsLn2JcJIdAl/jD7mmMZNI1fn+59RUDTae5Yjl3vorR
         SVYzC97i4ru3pk11qodYEk+ISVvz75ZwEgtl8g6kik+ZtmH4962M974pikiExoUscu
         mSjDb62Al1fyqRkrYkWlWWDJE1wY1jCerVE+6YnhV4Co7UQdVZdELCZ6uB+eH+LVGG
         GSC1dIjaew/HdKYMuijnlyajrQvd8RDjacb+7dFzo4arFnsdE1V499X2ld4ULYQpBy
         FCNJJkgPiehpqawBLn+8OD5l+w31poawlpoqWM8MttTBNLsAydmDOUNRInooxJFQiK
         NosvKY9bJC4lQ==
Date:   Wed, 26 Jan 2022 16:06:01 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KEYS: fix length validation in keyctl_pkey_params_get_2()
Message-ID: <YfFVSeWAFi8eqjpj@iki.fi>
References: <20220113200454.72609-1-ebiggers@kernel.org>
 <YeMWLyceg4xcwShF@iki.fi>
 <YeMmPs+gf+q7XUv4@sol.localdomain>
 <YeM7+Nyi2p7Yv7+Q@iki.fi>
 <YedZviVNB2X7yeTX@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YedZviVNB2X7yeTX@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 04:22:22PM -0800, Eric Biggers wrote:
> On Sat, Jan 15, 2022 at 11:26:16PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Jan 15, 2022 at 11:53:34AM -0800, Eric Biggers wrote:
> > > On Sat, Jan 15, 2022 at 08:45:03PM +0200, Jarkko Sakkinen wrote:
> > > > On Thu, Jan 13, 2022 at 12:04:54PM -0800, Eric Biggers wrote:
> > > > > From: Eric Biggers <ebiggers@google.com>
> > > > > 
> > > > > In many cases, keyctl_pkey_params_get_2() is validating the user buffer
> > > > > lengths against the wrong algorithm properties.  Fix it to check against
> > > > > the correct properties.
> > > > > 
> > > > > Probably this wasn't noticed before because for all asymmetric keys of
> > > > > the "public_key" subtype, max_data_size == max_sig_size == max_enc_size
> > > > > == max_dec_size.  However, this isn't necessarily true for the
> > > > > "asym_tpm" subtype (it should be, but it's not strictly validated).  Of
> > > > > course, future key types could have different values as well.
> > > > 
> > > > With a quick look, asym_tpm is TPM 1.x only, which only has 2048-bit RSA
> > > > keys.
> > > 
> > > The code allows other lengths, as well as the case where the "RSA key size"
> > > doesn't match the "public key size".  Probably both are bugs and they should
> > > both be 256 bytes (2048 bits) only.  Anyway, that would be a separate fix.
> > > 
> > > - Eric
> > 
> > I'm fine with the current commit message. E.g. I have no idea at this
> > point whether there should be in future separate asym_tpm2 or all bundled
> > to asym_tpm.
> > 
> > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> 
> Okay, great.  Just to be clear, I'm expecting either you or David
> (maintainer:KEYS/KEYRINGS) to apply this patch.  Acked-by is usually given by a
> maintainer when someone else applies a patch.

I changed it to reviewed-by and applied.

BR, Jarkko
