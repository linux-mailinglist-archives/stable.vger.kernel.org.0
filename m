Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692C91E595
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 01:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfENXaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 19:30:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44130 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfENXaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 19:30:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id z16so317846pgv.11
        for <stable@vger.kernel.org>; Tue, 14 May 2019 16:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dr0wEYjOsuwMkb0C7b01iPZFdmbTDV/YOBzLh8vitqk=;
        b=JBcRlSGstwulLHIt6Ogy6o6t1rhwuzuWBvXh9EEQ4jLWv8XMz6eL5JJPx3FkwmM1v8
         RV1mav5MwQ1+DxaAkYD25sM8lCwZTK3i74o+upCQL/pVJuWktp+zRAkAmfl+S4+s8k92
         VmvENyV6ge9AZkbIj03Kzh74NWF2mPywHnNiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dr0wEYjOsuwMkb0C7b01iPZFdmbTDV/YOBzLh8vitqk=;
        b=sbQtwpbQQfn5HFyuL+FVNIO4dqQjSFGu/EFVOKnAD0si/uJU0K5QHxv8SFp7pTEp8F
         Cnpz6fLEHkAXOSkzvX0YC0TkfAm4f8PQSucfUiBS92jfWFsqkKjcJzpsFfqaEFq0NFzA
         Mqx/lnZ19VJE7Lpog8yUhF5rbDJiX8MtpresaKunyoXHUugnnKljK4ySW0351fxO1mKM
         r1T2MacidS3TDWHIyNCTFDqVrsDATniLQu8AcROAYe+0T6SsnUCudivqjrrGyXH+W9j8
         YbKvYH+fT51MKBCDvyHRCgBXPMNNHpAEM8vuUM9dBBl0OsM0RMBfk2qer1kWarHlOxtL
         u4HQ==
X-Gm-Message-State: APjAAAWo67W2LAMvNBxOB9FSePxxCFipknPolOb2BTcy3dfZ3ltXVXQU
        LpiaK8q8ha4Sdg7jFbAC/cwCAzaBLGg=
X-Google-Smtp-Source: APXvYqzCTYmrXIqVdifKvgQD1uMB4RIOkfPXRyOr1prDPNgAW4iOV27TXXqdLy8fcVROp3ZMhWdS+A==
X-Received: by 2002:aa7:8f22:: with SMTP id y2mr31978285pfr.22.1557876609003;
        Tue, 14 May 2019 16:30:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 125sm215710pge.45.2019.05.14.16.30.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 16:30:07 -0700 (PDT)
Date:   Tue, 14 May 2019 16:30:06 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: hash - fix incorrect HASH_MAX_DESCSIZE
Message-ID: <201905141629.12E8DDADF@keescook>
References: <20190514231315.7729-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514231315.7729-1-ebiggers@kernel.org>
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

Ah, yikes! Nice catch. Thanks for fixing this. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
