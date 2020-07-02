Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E67211AA3
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 05:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgGBDdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 23:33:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37150 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgGBDdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 23:33:38 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jqpxV-0008AS-FA; Thu, 02 Jul 2020 13:32:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Jul 2020 13:32:21 +1000
Date:   Thu, 2 Jul 2020 13:32:21 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        lkft-triage@lists.linaro.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>, chrubis <chrubis@suse.cz>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux- stable <stable@vger.kernel.org>
Subject: [v2 PATCH] crypto: af_alg - Fix regression on empty requests
Message-ID: <20200702033221.GA19367@gondor.apana.org.au>
References: <CA+G9fYvHFs5Yx8TnT6VavtfjMN8QLPuXg6us-dXVJqUUt68adA@mail.gmail.com>
 <20200622224920.GA4332@42.do-not-panic.com>
 <CA+G9fYsXDZUspc5OyfqrGZn=k=2uRiGzWY_aPePK2C_kZ+dYGQ@mail.gmail.com>
 <20200623064056.GA8121@gondor.apana.org.au>
 <20200623170217.GB150582@gmail.com>
 <20200626062948.GA25285@gondor.apana.org.au>
 <CA+G9fYutuU55iL_6Qrk3oG3iq-37PaxvtA4KnEQHuLH9YpH-QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYutuU55iL_6Qrk3oG3iq-37PaxvtA4KnEQHuLH9YpH-QA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 02:18:11PM +0530, Naresh Kamboju wrote:
> 
> Since we are on this subject,
> LTP af_alg02  test case fails on stable 4.9 and stable 4.4
> This is not a regression because the test case has been failing from
> the beginning.
> 
> Is this test case expected to fail on stable 4.9 and 4.4 ?
> or any chance to fix this on these older branches ?
> 
> Test output:
> af_alg02.c:52: BROK: Timed out while reading from request socket.
> 
> ref:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.228-191-g082e807235d7/testrun/2884917/suite/ltp-crypto-tests/test/af_alg02/history/
> https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/build/v4.9.228-191-g082e807235d7/testrun/2884606/suite/ltp-crypto-tests/test/af_alg02/log

Actually this test really is broken.  Even though empty requests
are legal, they should never be done with no write(2) at all.
Because this fundamentally breaks the use of a blocking read(2)
to wait for more data.

Granted this has been broken since 2017 but I'm not going to
reintroduce this just because of a broken test case.

So please either remove af_alg02 or fix it by adding a control
message through sendmsg(2).

Thanks,

---8<---
Some user-space programs rely on crypto requests that have no
control metadata.  This broke when a check was added to require
the presence of control metadata with the ctx->init flag.

This patch fixes the regression by setting ctx->init as long as
one sendmsg(2) has been made, with or without a control message.

Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 9fcb91ea10c41..5882ed46f1adb 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -851,6 +851,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		err = -EINVAL;
 		goto unlock;
 	}
+	ctx->init = true;
 
 	if (init) {
 		ctx->enc = enc;
@@ -858,7 +859,6 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 
 		ctx->aead_assoclen = con.aead_assoclen;
-		ctx->init = true;
 	}
 
 	while (size) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
