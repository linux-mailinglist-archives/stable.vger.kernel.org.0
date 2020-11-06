Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5603B2A8FC9
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 08:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKFHBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 02:01:41 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:35026 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgKFHBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Nov 2020 02:01:41 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kavkQ-00080h-KI; Fri, 06 Nov 2020 18:01:23 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2020 18:01:22 +1100
Date:   Fri, 6 Nov 2020 18:01:22 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-hardening@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Elena Petrova <lenaptr@google.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        stable@vger.kernel.org,
        syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: af_alg - avoid undefined behavior accessing
 salg_name
Message-ID: <20201106070122.GC11620@gondor.apana.org.au>
References: <CACT4Y+beaHrWisaSsV90xQn+t2Xn-bxvVgmx8ih_h=yJYPjs4A@mail.gmail.com>
 <20201026200715.170261-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026200715.170261-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 01:07:15PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Commit 3f69cc60768b ("crypto: af_alg - Allow arbitrarily long algorithm
> names") made the kernel start accepting arbitrarily long algorithm names
> in sockaddr_alg.  However, the actual length of the salg_name field
> stayed at the original 64 bytes.
> 
> This is broken because the kernel can access indices >= 64 in salg_name,
> which is undefined behavior -- even though the memory that is accessed
> is still located within the sockaddr structure.  It would only be
> defined behavior if the array were properly marked as arbitrary-length
> (either by making it a flexible array, which is the recommended way
> these days, or by making it an array of length 0 or 1).
> 
> We can't simply change salg_name into a flexible array, since that would
> break source compatibility with userspace programs that embed
> sockaddr_alg into another struct, or (more commonly) declare a
> sockaddr_alg like 'struct sockaddr_alg sa = { .salg_name = "foo" };'.
> 
> One solution would be to change salg_name into a flexible array only
> when '#ifdef __KERNEL__'.  However, that would keep userspace without an
> easy way to actually use the longer algorithm names.
> 
> Instead, add a new structure 'sockaddr_alg_new' that has the flexible
> array field, and expose it to both userspace and the kernel.
> Make the kernel use it correctly in alg_bind().
> 
> This addresses the syzbot report
> "UBSAN: array-index-out-of-bounds in alg_bind"
> (https://syzkaller.appspot.com/bug?extid=92ead4eb8e26a26d465e).
> 
> Reported-by: syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com
> Fixes: 3f69cc60768b ("crypto: af_alg - Allow arbitrarily long algorithm names")
> Cc: <stable@vger.kernel.org> # v4.12+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/af_alg.c             | 10 +++++++---
>  include/uapi/linux/if_alg.h | 16 ++++++++++++++++
>  2 files changed, 23 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
