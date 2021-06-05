Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0C039C698
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 09:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFEHaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 03:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhFEHaE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Jun 2021 03:30:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E95D61205;
        Sat,  5 Jun 2021 07:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622878097;
        bh=5g/aAviMny/1FbdkPtEqxlinD1zUu0BX5Eg+Gjxof9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecqtWV5+MliS+73h1GUVDr/6Is2BagPyHqHOLAWXmLeEsp+nor4Oi0a57xaWOWcRf
         7Hni68QjXNX+9wxpVa6eZcO3hIXX3fdRQKfSctMxfWq+j4FJ9ca0z1MgjUFgSr3JsZ
         NDBdYEwmgz9BhUYAxFFSJdpfG7blR0pt87qQbIqRmV7dw4tb4WoppJV7LCZ+xzA/k6
         vqUGV1OOmqn1570/9AAFVvw0H/iGCkOrcGqldrsAovanOxS9cDp33wMGneSDJA3nLt
         YXiAK/xIZxtdksDZYYPE2+GIrmYwQW+XY9Bje6oDYMUYvv0oQ3QbyUU3lOxzuJmXAa
         zILBDus1uZYhg==
Date:   Sat, 5 Jun 2021 00:28:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: don't ignore minor_hash when hash is 0
Message-ID: <YLsnjxXpe+agF6nj@sol.localdomain>
References: <20210527235236.2376556-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527235236.2376556-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 04:52:36PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When initializing a no-key name, fscrypt_fname_disk_to_usr() sets the
> minor_hash to 0 if the (major) hash is 0.
> 
> This doesn't make sense because 0 is a valid hash code, so we shouldn't
> ignore the filesystem-provided minor_hash in that case.  Fix this by
> removing the special case for 'hash == 0'.
> 
> This is an old bug that appears to have originated when the encryption
> code in ext4 and f2fs was moved into fs/crypto/.  The original ext4 and
> f2fs code passed the hash by pointer instead of by value.  So
> 'if (hash)' actually made sense then, as it was checking whether a
> pointer was NULL.  But now the hashes are passed by value, and
> filesystems just pass 0 for any hashes they don't have.  There is no
> need to handle this any differently from the hashes actually being 0.
> 
> It is difficult to reproduce this bug, as it only made a difference in
> the case where a filename's 32-bit major hash happened to be 0.
> However, it probably had the largest chance of causing problems on
> ubifs, since ubifs uses minor_hash to do lookups of no-key names, in
> addition to using it as a readdir cookie.  ext4 only uses minor_hash as
> a readdir cookie, and f2fs doesn't use minor_hash at all.
> 
> Fixes: 0b81d0779072 ("fs crypto: move per-file encryption from f2fs tree to fs/crypto")
> Cc: <stable@vger.kernel.org> # v4.6+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fname.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 

Applied to fscrypt.git#master for 5.14.

- Eric
