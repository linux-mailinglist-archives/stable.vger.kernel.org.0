Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD1A45C05F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345687AbhKXNHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347267AbhKXNFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:05:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A027E61155;
        Wed, 24 Nov 2021 12:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757453;
        bh=lA42VD3iRzmgxGMgpYLuBwmH0+VxrxRMBuAUeCPxQks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cX2SE+DSRGIZ/KbQQBvJWsFUX8AG3DpDVC+xzy/tRFG0qWQqaC3wn4c+kDANwkr5u
         3IXFv/0M475p2lsbOHYR/4RaOzFgCt2IceQhi+HrHLuvXRN5h9g5KGRstWsRKvqtCI
         C1mSqryHrq48dxPAL197/CVAyIbGajOou66WjoCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 173/323] crypto: pcrypt - Delay write to padata->info
Date:   Wed, 24 Nov 2021 12:56:03 +0100
Message-Id: <20211124115724.791217245@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 68b6dea802cea0dbdd8bd7ccc60716b5a32a5d8a ]

These three events can race when pcrypt is used multiple times in a
template ("pcrypt(pcrypt(...))"):

  1.  [taskA] The caller makes the crypto request via crypto_aead_encrypt()
  2.  [kworkerB] padata serializes the inner pcrypt request
  3.  [kworkerC] padata serializes the outer pcrypt request

3 might finish before the call to crypto_aead_encrypt() returns in 1,
resulting in two possible issues.

First, a use-after-free of the crypto request's memory when, for
example, taskA writes to the outer pcrypt request's padata->info in
pcrypt_aead_enc() after kworkerC completes the request.

Second, the outer pcrypt request overwrites the inner pcrypt request's
return code with -EINPROGRESS, making a successful request appear to
fail.  For instance, kworkerB writes the outer pcrypt request's
padata->info in pcrypt_aead_done() and then taskA overwrites it
in pcrypt_aead_enc().

Avoid both situations by delaying the write of padata->info until after
the inner crypto request's return code is checked.  This prevents the
use-after-free by not touching the crypto request's memory after the
next-inner crypto request is made, and stops padata->info from being
overwritten.

Fixes: 5068c7a883d16 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/pcrypt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 85082574c5154..62e11835f220e 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -138,12 +138,14 @@ static void pcrypt_aead_enc(struct padata_priv *padata)
 {
 	struct pcrypt_request *preq = pcrypt_padata_request(padata);
 	struct aead_request *req = pcrypt_request_ctx(preq);
+	int ret;
 
-	padata->info = crypto_aead_encrypt(req);
+	ret = crypto_aead_encrypt(req);
 
-	if (padata->info == -EINPROGRESS)
+	if (ret == -EINPROGRESS)
 		return;
 
+	padata->info = ret;
 	padata_do_serial(padata);
 }
 
@@ -180,12 +182,14 @@ static void pcrypt_aead_dec(struct padata_priv *padata)
 {
 	struct pcrypt_request *preq = pcrypt_padata_request(padata);
 	struct aead_request *req = pcrypt_request_ctx(preq);
+	int ret;
 
-	padata->info = crypto_aead_decrypt(req);
+	ret = crypto_aead_decrypt(req);
 
-	if (padata->info == -EINPROGRESS)
+	if (ret == -EINPROGRESS)
 		return;
 
+	padata->info = ret;
 	padata_do_serial(padata);
 }
 
-- 
2.33.0



