Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066213046EB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 19:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732542AbhAZRSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:18:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390565AbhAZIr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 03:47:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 323BD2065C;
        Tue, 26 Jan 2021 08:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611650836;
        bh=rng9Nb9+8117ydjRos2PO70jwsMyORCgsjpX+/KUosE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1V8UDm8mOOhsmNxbzJp34LP+DyptQ7n81ztp/vXlDzJCHm1MDdlCW1MjZFliX1P4
         pOWnsrbxzvRqSTGyDUZ8D8k2/lKzKfE8ZVTWr6t3G3eVFf2yFB1RKJZI2HUkECJkDn
         7Lhn+rEcVJLL8PY6/Xlk7Pmeq6ivl4Iht70MkC5A=
Date:   Tue, 26 Jan 2021 09:47:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anthony Iliopoulos <ailiop@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 12/58] dm integrity: select CRYPTO_SKCIPHER
Message-ID: <YA/XEoDIe7MYXnQV@kroah.com>
References: <20210125183156.702907356@linuxfoundation.org>
 <20210125183157.221452946@linuxfoundation.org>
 <20210125185829.GA2818@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125185829.GA2818@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 07:58:29PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Anthony Iliopoulos <ailiop@suse.com>
> > 
> > [ Upstream commit f7b347acb5f6c29d9229bb64893d8b6a2c7949fb ]
> > 
> > The integrity target relies on skcipher for encryption/decryption, but
> > certain kernel configurations may not enable CRYPTO_SKCIPHER, leading to
> > compilation errors due to unresolved symbols. Explicitly select
> > CRYPTO_SKCIPHER for DM_INTEGRITY, since it is unconditionally dependent
> > on it.
> 
> There is no such config option in 4.19. This patch is not suitable
> here.
> 
> grep -r CRYPTO_SKCIPHER .
> ./include/crypto/skcipher.h:#ifndef _CRYPTO_SKCIPHER_H
> ./include/crypto/skcipher.h:#define _CRYPTO_SKCIPHER_H
> ./include/crypto/skcipher.h:#endif	/* _CRYPTO_SKCIPHER_H */
> 
> Best regards,
> 								Pavel
> 
> > +++ b/drivers/md/Kconfig
> > @@ -527,6 +527,7 @@ config DM_INTEGRITY
> >  	select BLK_DEV_INTEGRITY
> >  	select DM_BUFIO
> >  	select CRYPTO
> > +	select CRYPTO_SKCIPHER
> >  	select ASYNC_XOR
> >  	---help---
> >  	  This device-mapper target emulates a block device that has

Good catch, now dropped, thanks.

greg k-h
