Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A2136CAE
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 08:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfFFG6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 02:58:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39116 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFG6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 02:58:21 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmLs-000731-Ch; Thu, 06 Jun 2019 14:58:20 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmLr-0006nN-El; Thu, 06 Jun 2019 14:58:19 +0800
Date:   Thu, 6 Jun 2019 14:58:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, stable@vger.kernel.org,
        Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH] crypto: chacha20poly1305 - fix atomic sleep when using
 async algorithm
Message-ID: <20190606065819.u3ggps5zlndwdwyx@gondor.apana.org.au>
References: <20190531181230.15746-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531181230.15746-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 11:12:30AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Clear the CRYPTO_TFM_REQ_MAY_SLEEP flag when the chacha20poly1305
> operation is being continued from an async completion callback, since
> sleeping may not be allowed in that context.
> 
> This is basically the same bug that was recently fixed in the xts and
> lrw templates.  But, it's always been broken in chacha20poly1305 too.
> This was found using syzkaller in combination with the updated crypto
> self-tests which actually test the MAY_SLEEP flag now.
> 
> Reproducer:
> 
>     python -c 'import socket; socket.socket(socket.AF_ALG, 5, 0).bind(
>     	       ("aead", "rfc7539(cryptd(chacha20-generic),poly1305-generic)"))'
> 
> Kernel output:
> 
>     BUG: sleeping function called from invalid context at include/crypto/algapi.h:426
>     in_atomic(): 1, irqs_disabled(): 0, pid: 1001, name: kworker/2:2
>     [...]
>     CPU: 2 PID: 1001 Comm: kworker/2:2 Not tainted 5.2.0-rc2 #5
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
>     Workqueue: crypto cryptd_queue_worker
>     Call Trace:
>      __dump_stack lib/dump_stack.c:77 [inline]
>      dump_stack+0x4d/0x6a lib/dump_stack.c:113
>      ___might_sleep kernel/sched/core.c:6138 [inline]
>      ___might_sleep.cold.19+0x8e/0x9f kernel/sched/core.c:6095
>      crypto_yield include/crypto/algapi.h:426 [inline]
>      crypto_hash_walk_done+0xd6/0x100 crypto/ahash.c:113
>      shash_ahash_update+0x41/0x60 crypto/shash.c:251
>      shash_async_update+0xd/0x10 crypto/shash.c:260
>      crypto_ahash_update include/crypto/hash.h:539 [inline]
>      poly_setkey+0xf6/0x130 crypto/chacha20poly1305.c:337
>      poly_init+0x51/0x60 crypto/chacha20poly1305.c:364
>      async_done_continue crypto/chacha20poly1305.c:78 [inline]
>      poly_genkey_done+0x15/0x30 crypto/chacha20poly1305.c:369
>      cryptd_skcipher_complete+0x29/0x70 crypto/cryptd.c:279
>      cryptd_skcipher_decrypt+0xcd/0x110 crypto/cryptd.c:339
>      cryptd_queue_worker+0x70/0xa0 crypto/cryptd.c:184
>      process_one_work+0x1ed/0x420 kernel/workqueue.c:2269
>      worker_thread+0x3e/0x3a0 kernel/workqueue.c:2415
>      kthread+0x11f/0x140 kernel/kthread.c:255
>      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> 
> Fixes: 71ebc4d1b27d ("crypto: chacha20poly1305 - Add a ChaCha20-Poly1305 AEAD construction, RFC7539")
> Cc: <stable@vger.kernel.org> # v4.2+
> Cc: Martin Willi <martin@strongswan.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/chacha20poly1305.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
