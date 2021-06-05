Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF2B39C69B
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 09:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFEHbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 03:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229892AbhFEHbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Jun 2021 03:31:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4CCB613E3;
        Sat,  5 Jun 2021 07:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622878162;
        bh=sD4FdAhELqS0DLQbiQk64DhfSNBtsMQjztudND1DlMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fz96jY/xij6RRMc+vj4SXRnz8YYgUg2aniupthXfB8pM8hH2eptOK+d6xLlHdPp7t
         wXjv6c6M2kVt3k68qhGNLn2pB882j/HYyleAHHyO5S8MmXebYY9odATWmXGp1sxMy9
         fumMv3DxqCMp+/blHZKRuVG37XXlhyhTr+kyApjRctqiFcZnP/uf4MxJ+v89//2BfG
         8QJp1B+3TjUcEsJ30qA57YHjxXP2ATWyS5BpCMw2q3Pf3OVqsKYZKHPnEGfvp5Ue4f
         mwMYCWxPo745PN7jwWIQ4r/XWVyPRrSZ4SHpFM/MLkmxLGl0FapoxtGBuyRXqcEYwx
         rk/NXw35NFXeg==
Date:   Sat, 5 Jun 2021 00:29:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: fix derivation of SipHash keys on big endian
 CPUs
Message-ID: <YLsn0cws61VUrawv@sol.localdomain>
References: <20210527225525.2365513-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527225525.2365513-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 03:55:25PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Typically, the cryptographic APIs that fscrypt uses take keys as byte
> arrays, which avoids endianness issues.  However, siphash_key_t is an
> exception.  It is defined as 'u64 key[2];', i.e. the 128-bit key is
> expected to be given directly as two 64-bit words in CPU endianness.
> 
> fscrypt_derive_dirhash_key() forgot to take this into account.
> Therefore, the SipHash keys used to index encrypted+casefolded
> directories differ on big endian vs. little endian platforms.
> This makes such directories non-portable between these platforms.
> 
> Fix this by always using the little endian order.  This is a breaking
> change for big endian platforms, but this should be fine in practice
> since the encrypt+casefold support isn't known to actually be used on
> any big endian platforms yet.
> 
> Fixes: aa408f835d02 ("fscrypt: derive dirhash key for casefolded directories")
> Cc: <stable@vger.kernel.org> # v5.6+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/keysetup.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)

I missed that fscrypt_setup_iv_ino_lblk_32_key() has the same bug too.
I'll send out a new patch which fixes both of these...

- Eric
