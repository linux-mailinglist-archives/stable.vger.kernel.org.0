Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2BE336C6
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 19:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfFCRbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 13:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbfFCRbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 13:31:34 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCD0126D87;
        Mon,  3 Jun 2019 17:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559583094;
        bh=ef4z7eIvFCgptVOwhdxrknQEusVHxKBjNcgPZL7xjwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qtp2a/6xnsWe0YzsE1p3a6RJ4UhAkMhH/cvtVt2NYNKzbFDNwYHZApJ84LoiuQVJF
         XgGPJDNd/C89Mug6ldKVOPF2s3rqmXP/inTecxEBqK9SjdZa5hCb0IZVfz/58Tn6mb
         GJ6AbQHaAB0pOVD3d6n+POGFs88MMudq88uWaWZU=
Date:   Mon, 3 Jun 2019 10:31:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Robinson <pbrobinson@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ghash - fix unaligned memory access in
 ghash_setkey()
Message-ID: <20190603173131.GA240519@gmail.com>
References: <20190530175039.195574-1-ebiggers@kernel.org>
 <0f7e6d3d-aa27-30c3-5c82-67d484bf667c@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f7e6d3d-aa27-30c3-5c82-67d484bf667c@c-s.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 09:27:24AM +0200, Christophe Leroy wrote:
> 
> 
> Le 30/05/2019 à 19:50, Eric Biggers a écrit :
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Changing ghash_mod_init() to be subsys_initcall made it start running
> > before the alignment fault handler has been installed on ARM.  In kernel
> > builds where the keys in the ghash test vectors happened to be
> > misaligned in the kernel image, this exposed the longstanding bug that
> > ghash_setkey() is incorrectly casting the key buffer (which can have any
> > alignment) to be128 for passing to gf128mul_init_4k_lle().
> > 
> > Fix this by memcpy()ing the key to a temporary buffer.
> 
> Shouldn't we make it dependent on CONFIG_HAVE_64BIT_ALIGNED_ACCESS

No, because the buffer can have as little as 1-byte alignment.

> or !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS ?

I don't think that's a good idea because two code paths are harder to test than
one, and also CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS only means that the CPU
allows "regular" loads and stores to be misaligned.  On some architectures the
compiler can still generate load and store instructions that require alignment,
e.g. 'ldrd' or 'ldm' on ARM.

We could change gf128mul_init_4k_lle() to take a byte array and make it use
get_unaligned_be64().  But since it has to allocate and initialize a 4 KiB
multiplication table anyway, that microoptimization would be lost in the noise.

- Eric
