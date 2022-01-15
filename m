Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C4748F925
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 20:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiAOTxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 14:53:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38770 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiAOTxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 14:53:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C73C3B80AF2;
        Sat, 15 Jan 2022 19:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BB5C36AE7;
        Sat, 15 Jan 2022 19:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642276416;
        bh=YxN1ydtr52PL3Ynys1IZmTX5ThAF9iwp9eJjSAzaRkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z53PbNuBaq0NfIeRIRLWSAt7/3ZYhsbjQLVvo0HqRBE89fGh5JWR5JT3ei+6NCCYW
         TtxeSXqcsfoRuIJvrOCP5dkP3T0Gg7Ou3h4sS4UyzjWgUlLBvGkA+CzTlnpBiLOdYk
         d1Gy438bDosJXvDwNb7F9aC1zx0/kg2dfxlE74wRjf/VNygWQN3CxHOF34SpkpXON4
         0JZjMSF7WBjVI/O8mUQqpmMI2YevO1lGgfWHkaG6Q0C2RBV2ApJMXB6KonNXG+yslP
         E4KmuYcvie5O3Eosw+YXSBBO8zzZUwamJsQgeEEa534pb8X40tpkqWZYP/dUTmPt9Z
         4tBduESFiq0eg==
Date:   Sat, 15 Jan 2022 11:53:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KEYS: fix length validation in keyctl_pkey_params_get_2()
Message-ID: <YeMmPs+gf+q7XUv4@sol.localdomain>
References: <20220113200454.72609-1-ebiggers@kernel.org>
 <YeMWLyceg4xcwShF@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeMWLyceg4xcwShF@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 15, 2022 at 08:45:03PM +0200, Jarkko Sakkinen wrote:
> On Thu, Jan 13, 2022 at 12:04:54PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > In many cases, keyctl_pkey_params_get_2() is validating the user buffer
> > lengths against the wrong algorithm properties.  Fix it to check against
> > the correct properties.
> > 
> > Probably this wasn't noticed before because for all asymmetric keys of
> > the "public_key" subtype, max_data_size == max_sig_size == max_enc_size
> > == max_dec_size.  However, this isn't necessarily true for the
> > "asym_tpm" subtype (it should be, but it's not strictly validated).  Of
> > course, future key types could have different values as well.
> 
> With a quick look, asym_tpm is TPM 1.x only, which only has 2048-bit RSA
> keys.

The code allows other lengths, as well as the case where the "RSA key size"
doesn't match the "public key size".  Probably both are bugs and they should
both be 256 bytes (2048 bits) only.  Anyway, that would be a separate fix.

- Eric
