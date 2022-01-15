Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382D548F98A
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 22:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiAOV0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 16:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiAOV0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 16:26:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77FAC061574;
        Sat, 15 Jan 2022 13:26:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59EA8B80B64;
        Sat, 15 Jan 2022 21:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63938C36AE5;
        Sat, 15 Jan 2022 21:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642281989;
        bh=YBvlnsBnrtDKytZx6mouCpEaP7blm+tVQ1xjpk4JmxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s2vLCv/nTsNhylO8M063FT+vlJLL/YxGhfWcFte1emypc/2qkEsnKBiXuzWXAczjE
         hMJXn4ybLtEu0/wZA9uDlU7I0LEYOK6El9ac6fuDZbsdQ/3ZyblJGEQ9PPiHlpY3Q7
         26iXjjZv5cNBUmUwB18ixD3hL5NmVrNqeW+EOHIk2t8hkT05oJonhdXwfPWLQakoio
         Ra1zNkug8EmXn5I9b1kSjE7SsPYGdQiPuQ74H/fd9YfVw8bV6qsedBPtvFPIowcCAk
         +0QVB9Jixng9P+RCeNqwqKXzclCHvhbASO4Z9w4knsAtvuVs6vTNdRtQtThvvIUiwL
         lhNVuArQJzhWQ==
Date:   Sat, 15 Jan 2022 23:26:16 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KEYS: fix length validation in keyctl_pkey_params_get_2()
Message-ID: <YeM7+Nyi2p7Yv7+Q@iki.fi>
References: <20220113200454.72609-1-ebiggers@kernel.org>
 <YeMWLyceg4xcwShF@iki.fi>
 <YeMmPs+gf+q7XUv4@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeMmPs+gf+q7XUv4@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 15, 2022 at 11:53:34AM -0800, Eric Biggers wrote:
> On Sat, Jan 15, 2022 at 08:45:03PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Jan 13, 2022 at 12:04:54PM -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > In many cases, keyctl_pkey_params_get_2() is validating the user buffer
> > > lengths against the wrong algorithm properties.  Fix it to check against
> > > the correct properties.
> > > 
> > > Probably this wasn't noticed before because for all asymmetric keys of
> > > the "public_key" subtype, max_data_size == max_sig_size == max_enc_size
> > > == max_dec_size.  However, this isn't necessarily true for the
> > > "asym_tpm" subtype (it should be, but it's not strictly validated).  Of
> > > course, future key types could have different values as well.
> > 
> > With a quick look, asym_tpm is TPM 1.x only, which only has 2048-bit RSA
> > keys.
> 
> The code allows other lengths, as well as the case where the "RSA key size"
> doesn't match the "public key size".  Probably both are bugs and they should
> both be 256 bytes (2048 bits) only.  Anyway, that would be a separate fix.
> 
> - Eric

I'm fine with the current commit message. E.g. I have no idea at this
point whether there should be in future separate asym_tpm2 or all bundled
to asym_tpm.

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
