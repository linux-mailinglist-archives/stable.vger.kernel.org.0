Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84B302BB2
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbhAYTfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 14:35:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:46112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbhAYTeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 14:34:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611602091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RACfGCkhI5scU7X7ybvkFm/nrdSxi4NbSKB3Ciwz/80=;
        b=R+YIlUOVpaeaDnsYXuqRDLAWnxLc15ZmI+0PoNuM9AExN/9QM4YNlQrBHrZDwk+qAIS/7e
        0XPH6zNXUBbn7amR2QqW5wvxIVMbDIivLK5Gysm3KHEjGMQMUZRdk7nIGY+EQGDuxm6Sqz
        FLx7yWYc0ayhMSjIienUXxTuSkyGKLQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2A2CDAF11;
        Mon, 25 Jan 2021 19:14:51 +0000 (UTC)
Date:   Mon, 25 Jan 2021 20:14:48 +0100
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 12/58] dm integrity: select CRYPTO_SKCIPHER
Message-ID: <YA8YqIkt2VAbChSU@technoir>
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

This is due to commit b95bba5d0114 ("crypto: skcipher - rename the
crypto_blkcipher module and kconfig option"), which was applied in
v5.5-rc1. As already pointed out in [1], if this is to be backported to
any earlier releases then SKCIPHER needs to be changed to BLKCIPHER.

Best regards,
Anthony

[1] https://lore.kernel.org/lkml/YAfD81Jw%2F0NU0eWN@sol.localdomain/#t
