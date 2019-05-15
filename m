Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FB81EAC8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 11:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfEOJQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 05:16:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39105 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfEOJQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 05:16:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id w8so1794652wrl.6;
        Wed, 15 May 2019 02:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=de5WSELj4gSXjf9AoL3U1UDofSw6C63nGgYMrSnkT2g=;
        b=YtxdamWcmi6YX/fdouZCcul6AKXXkilhYp/DWKeBaUtOIls15/USE03WxOE9P78rPX
         xhxAOLE3CHaWNx7YcBpH/3FKKze+xIdvzjBX/cI+kjn+GdkhM5oTiK/Pt0EQTD/m1S0s
         PNYRMCXJ9AmkquApHv7+WzMKxTzkyXIDDtqoGrWWB4hb74su1gIeIUa5mRvbQwl2TYrM
         FCHZknXOcQOZdkY+FhBNVEEBR5FACvvwXvG8P3wcGlrtf/dGK9aaj34gepxjg575lP8x
         vRwnEe4y0AFtvT0h+AOc/ze+G37ShPxMvQGBqlP7QBw+ZAZdMALN2wJG8oJ+cPstQWw6
         LeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=de5WSELj4gSXjf9AoL3U1UDofSw6C63nGgYMrSnkT2g=;
        b=P7utLkS7xDIquwP7DnxvL4ZjjYTM+7K2E3M9PDG6zbummmgTrXCe81UC6cDT4l2Qoe
         oYi02uRibv7wlXWMcS4uAchR1usr2GKAQfqS4WlBxiO33ZTl4eQI9Z4eG5PWjhbfB7GF
         OddL7kSkiq14Li/CfWJU5Lk5/Rs6dWmcpfMnHmXogFtkbyEWi8nTF/ziIm33XsRlm/dj
         zAyXYYHj5NS+mmwnyMdTxt2QKPXp5YoT4GJ+vr7N0ufbaL/jxq3Mmc1DY+F4SQZzbm1t
         y44cD+zFwNpdJV2yyp4rwP5icwm93ZzTxuq/O1viuSrNrqxdvl5ihxk4Cna4upCKyqmf
         NqUw==
X-Gm-Message-State: APjAAAVXIKaqwMubnlqCCpB2dOJGz7XE/dRUOUSGz0RIpJLyD+ybCXZt
        3fXWVYPCEE9g3kAmjM4YZojut6OA
X-Google-Smtp-Source: APXvYqy3X742I9KwcUqRd14IjC9LZoC8p7iNPBq0GYsUZJvygitoYc8BfVa1Ds+RFfjKHLH0gFI+ZA==
X-Received: by 2002:adf:fa4e:: with SMTP id y14mr13380749wrr.149.1557911798704;
        Wed, 15 May 2019 02:16:38 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a128sm1589710wma.23.2019.05.15.02.16.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 02:16:37 -0700 (PDT)
Date:   Wed, 15 May 2019 11:16:35 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] crypto: hash - fix incorrect HASH_MAX_DESCSIZE
Message-ID: <20190515091635.GA4140@Red>
References: <20190514231315.7729-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514231315.7729-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Hello

Thanks for the fix.

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Regards
