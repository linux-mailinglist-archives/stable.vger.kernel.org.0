Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28361213CB
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 08:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfEQGiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 02:38:01 -0400
Received: from [128.1.224.119] ([128.1.224.119]:55012 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727145AbfEQGiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 02:38:01 -0400
X-Greylist: delayed 2250 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2019 02:38:00 EDT
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hRVuv-0007s9-76; Fri, 17 May 2019 14:00:29 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hRVut-0000YN-9B; Fri, 17 May 2019 14:00:27 +0800
Date:   Fri, 17 May 2019 14:00:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] crypto: hash - fix incorrect HASH_MAX_DESCSIZE
Message-ID: <20190517060027.wqowv4aazpcrr6pv@gondor.apana.org.au>
References: <20190514231315.7729-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514231315.7729-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 04:13:15PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The "hmac(sha3-224-generic)" algorithm has a descsize of 368 bytes,
> which is greater than HASH_MAX_DESCSIZE (360) which is only enough for
> sha3-224-generic.  The check in shash_prepare_alg() doesn't catch this
> because the HMAC template doesn't set descsize on the algorithms, but
> rather sets it on each individual HMAC transform.
> 
> This causes a stack buffer overflow when SHASH_DESC_ON_STACK() is used
> with hmac(sha3-224-generic).
> 
> Fix it by increasing HASH_MAX_DESCSIZE to the real maximum.  Also add a
> sanity check to hmac_init().
> 
> This was detected by the improved crypto self-tests in v5.2, by loading
> the tcrypt module with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y enabled.  I
> didn't notice this bug when I ran the self-tests by requesting the
> algorithms via AF_ALG (i.e., not using tcrypt), probably because the
> stack layout differs in the two cases and that made a difference here.
> 
> KASAN report:
> 
>     BUG: KASAN: stack-out-of-bounds in memcpy include/linux/string.h:359 [inline]
>     BUG: KASAN: stack-out-of-bounds in shash_default_import+0x52/0x80 crypto/shash.c:223
>     Write of size 360 at addr ffff8880651defc8 by task insmod/3689
> 
>     CPU: 2 PID: 3689 Comm: insmod Tainted: G            E     5.1.0-10741-g35c99ffa20edd #11
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
>     Call Trace:
>      __dump_stack lib/dump_stack.c:77 [inline]
>      dump_stack+0x86/0xc5 lib/dump_stack.c:113
>      print_address_description+0x7f/0x260 mm/kasan/report.c:188
>      __kasan_report+0x144/0x187 mm/kasan/report.c:317
>      kasan_report+0x12/0x20 mm/kasan/common.c:614
>      check_memory_region_inline mm/kasan/generic.c:185 [inline]
>      check_memory_region+0x137/0x190 mm/kasan/generic.c:191
>      memcpy+0x37/0x50 mm/kasan/common.c:125
>      memcpy include/linux/string.h:359 [inline]
>      shash_default_import+0x52/0x80 crypto/shash.c:223
>      crypto_shash_import include/crypto/hash.h:880 [inline]
>      hmac_import+0x184/0x240 crypto/hmac.c:102
>      hmac_init+0x96/0xc0 crypto/hmac.c:107
>      crypto_shash_init include/crypto/hash.h:902 [inline]
>      shash_digest_unaligned+0x9f/0xf0 crypto/shash.c:194
>      crypto_shash_digest+0xe9/0x1b0 crypto/shash.c:211
>      generate_random_hash_testvec.constprop.11+0x1ec/0x5b0 crypto/testmgr.c:1331
>      test_hash_vs_generic_impl+0x3f7/0x5c0 crypto/testmgr.c:1420
>      __alg_test_hash+0x26d/0x340 crypto/testmgr.c:1502
>      alg_test_hash+0x22e/0x330 crypto/testmgr.c:1552
>      alg_test.part.7+0x132/0x610 crypto/testmgr.c:4931
>      alg_test+0x1f/0x40 crypto/testmgr.c:4952
> 
> Fixes: b68a7ec1e9a3 ("crypto: hash - Remove VLA usage")
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Cc: <stable@vger.kernel.org> # v4.20+
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/hmac.c         | 2 ++
>  include/crypto/hash.h | 8 +++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
