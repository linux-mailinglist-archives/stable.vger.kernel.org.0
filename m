Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F02B29989F
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 22:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbgJZVQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 17:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgJZVQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 17:16:23 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE59620773;
        Mon, 26 Oct 2020 21:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603746983;
        bh=Vm0qdXXdX+ZSsWf9ikMc+E8cuDcryBDKJGA2NCHqJa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nSti9wrIDRIdUEGdwrPu7NdJqQnSwavn+pFPcPu3zHEPPmaHHoXVT1oKmpbl/ONgm
         d2/PLh3CYk8DU/E6TxG5qPwSaI/atSpXpCKQ/83U22/gutJcBKk9yoe5XQqcTbAWvR
         hcQbXWPlRZ3tSB6oMNlGjTw3h08YRXOL0Iq9PlQ8=
Date:   Mon, 26 Oct 2020 16:21:48 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        syzkaller-bugs@googlegroups.com, linux-hardening@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Elena Petrova <lenaptr@google.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        stable@vger.kernel.org,
        syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: af_alg - avoid undefined behavior accessing
 salg_name
Message-ID: <20201026212148.GA26823@embeddedor>
References: <CACT4Y+beaHrWisaSsV90xQn+t2Xn-bxvVgmx8ih_h=yJYPjs4A@mail.gmail.com>
 <20201026200715.170261-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026200715.170261-1-ebiggers@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

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
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index d11db80d24cd1..9acb9d2c4bcf9 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -147,7 +147,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  	const u32 allowed = CRYPTO_ALG_KERN_DRIVER_ONLY;
>  	struct sock *sk = sock->sk;
>  	struct alg_sock *ask = alg_sk(sk);
> -	struct sockaddr_alg *sa = (void *)uaddr;
> +	struct sockaddr_alg_new *sa = (void *)uaddr;
>  	const struct af_alg_type *type;
>  	void *private;
>  	int err;
> @@ -155,7 +155,11 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  	if (sock->state == SS_CONNECTED)
>  		return -EINVAL;
>  
> -	if (addr_len < sizeof(*sa))
> +	BUILD_BUG_ON(offsetof(struct sockaddr_alg_new, salg_name) !=
> +		     offsetof(struct sockaddr_alg, salg_name));
> +	BUILD_BUG_ON(offsetof(struct sockaddr_alg, salg_name) != sizeof(*sa));
> +
> +	if (addr_len < sizeof(*sa) + 1)
>  		return -EINVAL;
>  
>  	/* If caller uses non-allowed flag, return error. */
> @@ -163,7 +167,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  		return -EINVAL;
>  
>  	sa->salg_type[sizeof(sa->salg_type) - 1] = 0;
> -	sa->salg_name[sizeof(sa->salg_name) + addr_len - sizeof(*sa) - 1] = 0;
> +	sa->salg_name[addr_len - sizeof(*sa) - 1] = 0;
>  
>  	type = alg_get_type(sa->salg_type);
>  	if (PTR_ERR(type) == -ENOENT) {
> diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
> index 60b7c2efd921c..dc52a11ba6d15 100644
> --- a/include/uapi/linux/if_alg.h
> +++ b/include/uapi/linux/if_alg.h
> @@ -24,6 +24,22 @@ struct sockaddr_alg {
>  	__u8	salg_name[64];
>  };
>  
> +/*
> + * Linux v4.12 and later removed the 64-byte limit on salg_name[]; it's now an
> + * arbitrary-length field.  We had to keep the original struct above for source
> + * compatibility with existing userspace programs, though.  Use the new struct
> + * below if support for very long algorithm names is needed.  To do this,
> + * allocate 'sizeof(struct sockaddr_alg_new) + strlen(algname) + 1' bytes, and
> + * copy algname (including the null terminator) into salg_name.
> + */
> +struct sockaddr_alg_new {
> +	__u16	salg_family;
> +	__u8	salg_type[14];
> +	__u32	salg_feat;
> +	__u32	salg_mask;
> +	__u8	salg_name[];
> +};
> +

How something like this, instead:

 struct sockaddr_alg {
-	__u16	salg_family;
-	__u8	salg_type[14];
-	__u32	salg_feat;
-	__u32	salg_mask;
-	__u8	salg_name[64];
+	union {
+		struct {
+			__u16	salg_v1_family;
+			__u8	salg_v1_type[14];
+			__u32	salg_v1_feat;
+			__u32	salg_v1_mask;
+			__u8	salg_name[64];
+		};
+		struct {
+			__u16	salg_family;
+			__u8	salg_type[14];
+			__u32	salg_feat;
+			__u32	salg_mask;
+			__u8	salg_name_new[];
+		};
+	};
 };


--
Gustavo
