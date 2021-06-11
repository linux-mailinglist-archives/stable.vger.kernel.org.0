Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C792C3A39AF
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 04:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhFKC1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 22:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhFKC1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 22:27:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 253BC6124C;
        Fri, 11 Jun 2021 02:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623378319;
        bh=j3FDr9xnJcCgR07zql+OK4VkeLxdJj8Zl8SGv4olxds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4msDiLz9LmE5aELx0LYd9HBwB8gSJ1pfSUBRfhmsPE9KQ2VrI0Uo5x7cCMwraUHJ
         9Y2xxRkPxwjrVLLakCttfFnNm4yKxj8GDTcfVk6f+gFb8B+EADbCNsyntlOJ5/oi/Y
         uXmzvZmi2MnPhuv/n0jgg1NhC+hO8HOdXJEyc0tSd4rwzEeW0v3knLq9S7qaZcV5um
         Q4ZqJGlKsoy1gMy/v07LBIIhG58rtWVl0YTxazLLHZOJbVnfxaIWxpCaeWsawnViAZ
         5alMaKoRg70mfjdFbWtRDcHDWhYvlKiGHQXE5aT/NS1Pgbe57kpajo9NF2s31eLTTO
         jovtxVxNjtAGg==
Date:   Thu, 10 Jun 2021 19:25:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] fscrypt: fix derivation of SipHash keys on big endian
 CPUs
Message-ID: <YMLJjT97wHh4XJiZ@sol.localdomain>
References: <20210605075033.54424-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605075033.54424-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 05, 2021 at 12:50:33AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Typically, the cryptographic APIs that fscrypt uses take keys as byte
> arrays, which avoids endianness issues.  However, siphash_key_t is an
> exception.  It is defined as 'u64 key[2];', i.e. the 128-bit key is
> expected to be given directly as two 64-bit words in CPU endianness.
> 
> fscrypt_derive_dirhash_key() and fscrypt_setup_iv_ino_lblk_32_key()
> forgot to take this into account.  Therefore, the SipHash keys used to
> index encrypted+casefolded directories differ on big endian vs. little
> endian platforms, as do the SipHash keys used to hash inode numbers for
> IV_INO_LBLK_32-encrypted directories.  This makes such directories
> non-portable between these platforms.
> 
> Fix this by always using the little endian order.  This is a breaking
> change for big endian platforms, but this should be fine in practice
> since these features (encrypt+casefold support, and the IV_INO_LBLK_32
> flag) aren't known to actually be used on any big endian platforms yet.
> 
> Fixes: aa408f835d02 ("fscrypt: derive dirhash key for casefolded directories")
> Fixes: e3b1078bedd3 ("fscrypt: add support for IV_INO_LBLK_32 policies")
> Cc: <stable@vger.kernel.org> # v5.6+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: Fixed fscrypt_setup_iv_ino_lblk_32_key() too, not just
>     fscrypt_derive_dirhash_key().
> 
>  fs/crypto/keysetup.c | 40 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 8 deletions(-)
> 

Applied to fscrypt.git#master for 5.14.

- Eric
