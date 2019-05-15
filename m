Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF1C1F8AC
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 18:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfEOQbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 12:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfEOQbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 12:31:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEFD220818;
        Wed, 15 May 2019 16:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557937867;
        bh=oXIY+mWZAJM18zAlnx3Vpiv5R60H6x3FTXcrG/cdL6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T0ZjblAvtCU6LxqojVR9If6yhXX0jEF/u0rEPiHhPvJNwg7d8e8cq3aH3DrMmJuTt
         pT47h+v4nM7VeSvLHmIDlP0mHQlXhC9fnhGcrpoi//2ME94xl2AUPeFJs9ZSl33qbW
         8kbLFhCDWbf7o/XgneclAQbcF9kKsHmEsEvKtG1g=
Date:   Wed, 15 May 2019 18:31:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jinpu Wang <jinpuwang@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "v3.14+, only the raid10 part" <stable@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: Re: [PATCH 4.14 067/115] crypto: testmgr - add AES-CFB tests
Message-ID: <20190515163105.GB30626@kroah.com>
References: <20190515090659.123121100@linuxfoundation.org>
 <20190515090704.367472403@linuxfoundation.org>
 <CAD9gYJ+zOgwe5mxns=0m=Lpz0Dthn0f1_YkyR+n0w7JaAswL1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD9gYJ+zOgwe5mxns=0m=Lpz0Dthn0f1_YkyR+n0w7JaAswL1w@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 05:59:38PM +0200, Jinpu Wang wrote:
> Hi Greg,
> 
> This patch causes build failure for me:
> 
> In file included from crypto/testmgr.c:54:
> crypto/testmgr.h:16081:4: error: 'const struct cipher_testvec' has no
> member named 'ptext'
>    .ptext = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
>     ^~~~~
> crypto/testmgr.h:16089:4: error: 'const struct cipher_testvec' has no
> member named 'ctext'
>    .ctext = "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
>     ^~~~~
> crypto/testmgr.h:16097:4: error: 'const struct cipher_testvec' has no
> member named 'len'; did you mean 'klen'?
>    .len = 64,
>     ^~~
>     klen
> crypto/testmgr.h:16097:10: warning: initialization of 'const char *'
> from 'int' makes pointer from integer without a cast
> [-Wint-conversion]
>    .len = 64,
>           ^~
> crypto/testmgr.h:16097:10: note: (near initialization for
> 'aes_cfb_tv_template[0].result')
> crypto/testmgr.h:16105:4: error: 'const struct cipher_testvec' has no
> member named 'ptext'
>    .ptext = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
>     ^~~~~
> crypto/testmgr.h:16113:4: error: 'const struct cipher_testvec' has no
> member named 'ctext'
>    .ctext = "\xcd\xc8\x0d\x6f\xdd\xf1\x8c\xab"
>     ^~~~~
> crypto/testmgr.h:16121:4: error: 'const struct cipher_testvec' has no
> member named 'len'; did you mean 'klen'?
>    .len = 64,
>     ^~~
>     klen
> crypto/testmgr.h:16121:10: warning: initialization of 'const char *'
> from 'int' makes pointer from integer without a cast
> [-Wint-conversion]
>    .len = 64,
>           ^~
> crypto/testmgr.h:16121:10: note: (near initialization for
> 'aes_cfb_tv_template[1].result')
> crypto/testmgr.h:16130:4: error: 'const struct cipher_testvec' has no
> member named 'ptext'
>    .ptext = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
>     ^~~~~
> crypto/testmgr.h:16138:4: error: 'const struct cipher_testvec' has no
> member named 'ctext'
>    .ctext = "\xdc\x7e\x84\xbf\xda\x79\x16\x4b"
>     ^~~~~
> crypto/testmgr.h:16146:4: error: 'const struct cipher_testvec' has no
> member named 'len'; did you mean 'klen'?
>    .len = 64,
>     ^~~
>     klen
> crypto/testmgr.h:16146:10: warning: initialization of 'const char *'
> from 'int' makes pointer from integer without a cast
> [-Wint-conversion]
>    .len = 64,
>           ^~
> crypto/testmgr.h:16146:10: note: (near initialization for
> 'aes_cfb_tv_template[2].result')
>   CC      drivers/edac/wq.o
> crypto/testmgr.c:2353:23: error: 'struct cipher_test_suite' has no
> member named 'vecs'; did you mean 'dec'?
>  #define __VECS(tv) { .vecs = tv, .count = ARRAY_SIZE(tv) }
> 
> Can you drop the patch?

Yes, now dropped.  Sasha, I think I did this same thing in the past :)
