Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03133253EC0
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0HPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:15:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34218 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgH0HPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:15:05 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kBC7I-0004FM-7A; Thu, 27 Aug 2020 17:14:37 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Aug 2020 17:14:36 +1000
Date:   Thu, 27 Aug 2020 17:14:36 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH] crypto: af_alg - Work around empty control messages
 without MSG_MORE
Message-ID: <20200827071436.GA30281@gondor.apana.org.au>
References: <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au>
 <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
 <20200826130010.GA3232@gondor.apana.org.au>
 <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
 <20200826141907.GA5111@gondor.apana.org.au>
 <4bb6d926-a249-8183-b3d9-05b8e1b7808a@gmail.com>
 <CAMj1kXEn507bEt+eT6q7MpCwNH=oAZsTkFRz0t=kPEV0QxFsOQ@mail.gmail.com>
 <20200826221913.GA16175@gondor.apana.org.au>
 <CAMj1kXH-qZZhw5D5sBEVFP9=Z04pU+xCnQ78sDDw6WuSM-pRGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXH-qZZhw5D5sBEVFP9=Z04pU+xCnQ78sDDw6WuSM-pRGQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 27, 2020 at 08:40:01AM +0200, Ard Biesheuvel wrote:
>
> It is part of iwd - just build that and run 'make check'
> 
> With your patch applied, the occurrence of sendmsg() in
> operate_cipher() triggers the warn_once(), but if I add MSG_MORE
> there, the test hangs.

I see.  This is a different issue.  The original kernel change
was a bit too strict here and it is barfing at the fact that two
successive sendmsg's of the same request both contain a control
message.

Here's an updated patch to allow this.

---8<---
The iwd daemon uses libell which sets up the skcipher operation with
two separate control messages.  As the first control message is sent
without MSG_MORE, it is interpreted as an empty request.

While libell should be fixed to use MSG_MORE where appropriate, this
patch works around the bug in the kernel so that existing binaries
continue to work.

We will print a warning however.

A separate issue is that the new kernel code no longer allows the
control message to be sent twice within the same request.  This
restriction is obviously incompatible with what iwd was doing (first
setting an IV and then sending the real control message).  This
patch changes the kernel so that this is explicitly allowed.

Reported-by: Caleb Jorden <caljorden@hotmail.com>
Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index a6f581ab200c..8be8bec07cdd 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/rwsem.h>
+#include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/security.h>
 
@@ -845,9 +846,15 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	}
 
 	lock_sock(sk);
-	if (ctx->init && (init || !ctx->more)) {
-		err = -EINVAL;
-		goto unlock;
+	if (ctx->init && !ctx->more) {
+		if (ctx->used) {
+			err = -EINVAL;
+			goto unlock;
+		}
+
+		pr_info_once(
+			"%s sent an empty control message without MSG_MORE.\n",
+			current->comm);
 	}
 	ctx->init = true;
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
