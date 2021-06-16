Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCCD3AA55F
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 22:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhFPUhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbhFPUhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 16:37:10 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A9DC061768
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 13:35:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g24so2437470pji.4
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 13:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rp5uDSNPLfj1QcmZiBYhLMtmYzv+FVQAAZdEK27uKbc=;
        b=Og0gg2OCChBPre19U3sdh41BCFNJgrrWEPuD6aCglX/o9TttYW/cqzDdcfcR4hBPVV
         h3WI9fIZbjJO8ZQa0J2SsmHqMOwtZr2g5ChZODwbfC7XMs7iH73cKLI70SeyZy++OKe7
         rNad6QGzUKyuSdhlvmjIrk9rX1E+f2AoO2kys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rp5uDSNPLfj1QcmZiBYhLMtmYzv+FVQAAZdEK27uKbc=;
        b=BWT2Ns52uiwM9nBtrNYDxWBmXdMV1zCm4VJtcoSqclEGsYvngQfwiVFBCm6VcgX9df
         Kh2jjcHAR7K93mXld31K5AeOMJvCk0iWvbU0YGQH+LJFNUiA60Dy83t6rJid0zStAWZZ
         gWZQE5OV7hFIyCa65Kw24e8vToOoc2w0KLi1yWZReNCnUZSva6N8wpDzFx0ILPRt4ujv
         YGazAdDpUdGG3Ny90fMAfUYQSxeriEs2Ye05XUBY54ZWOi0nwC7V5NN6/9/C0U/ZFcHN
         IsOz1tdNzcutzRpBSx7vV/sM6LWwVgikMhfa7JS8CEXiIaAvbhYTlrTwQsBc/VvwuZwZ
         sInw==
X-Gm-Message-State: AOAM532yIGpTu8HAOHS4yZy2qUBArRFWIkCrJ9DtCYTpdx16LEKTU1NS
        5oog7PiRDgfnBBoytn4B2V+Gbg==
X-Google-Smtp-Source: ABdhPJyzc5ao3WqKlsjBFdlm4dtPe8Cw6Kdi48ERNoYRKIjp25bnW25Xlcm9KG2ELq0JbhEhv6iZwA==
X-Received: by 2002:a17:902:b717:b029:11a:fae3:ba7c with SMTP id d23-20020a170902b717b029011afae3ba7cmr1254557pls.28.1623875703099;
        Wed, 16 Jun 2021 13:35:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 11sm3331759pge.57.2021.06.16.13.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 13:35:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: nx: Fix memcpy() over-reading in nonce
Date:   Wed, 16 Jun 2021 13:34:59 -0700
Message-Id: <20210616203459.1248036-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; g=06534d0443fa9fcfa969f0fcd687992b383a757d; i=jYfiGi2izQUFzVtPzV/fVSVDahy6PowWZI9Gw067JJs=; m=QnHbJKc/xtXaH5oFuCZHDTYyfjS26Q6kX/nkbJWmqYE=; p=Rww15zRs5GKN3uLwSu/+HXsr7GkdI7iuJ1PvQJoYJJY=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKYHIACgkQiXL039xtwCbRdBAAqyA FpIIWg3FtYwVUl5xnDktz6gtkdYaXMLl49uYOnAvXQSiVLggX9nLThuEqgupG8pm3Hj8fSC2uW4d8 bUJ3cOiEUoCt8a4Izu4aw2a1ii0axXKma3IaCJWImuScMgsb8Y63HZ9n+5FZ1yrBpv7QBigem7vJd mdcVGiwu7luChzOl6B7WcdrQmKPvJTN7h5/JZ5oVK7Cp1qjSU2v0KiwIsk4zK65PS56Q7dfohFMVP uStgrGTsZYviJvfl5E4LWHWtc77wJqkKRiCtrOE8tst4eIsOt9a+zcP9bB7Iz4VRSlL68AW8qmZ5a mSYqNGraivkXELX3QFey28oZdHc5IYciYgmehULbBbSdD0Z6mwZ7v7hqRDM95Qgm2ZU54LeucplXc fKeeL93dbElzv42ondvChnwZro3o0accfT6/GlTFRuZ7WU2GoCDUdTXv1I4A35sARsrfzigjesQ9m FqLygW2kqJXKo39M2PjDBUy38PctTb+qGvKT6VYqZzxe2ITVIjHzFzijJa/RHbAIqkFbzymz5Rqm/ ux6W8AvzR5v4hoLHqcd5n1T3BGKH9dN92K/Md7UnEthYUM/Scblddr2RCvEKS8HJRKhRnrm8NdWv5 X9nkoLmL61qCjwmL6TFPqlbmCgbv/+50URmm1BT/Hdocymk7dNbQE0xDi8jmZGQM=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix typo in memcpy() where size should be CTR_RFC3686_NONCE_SIZE.

Fixes: 030f4e968741 ("crypto: nx - Fix reentrancy bugs")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/nx/nx-aes-ctr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index 13f518802343..6120e350ff71 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -118,7 +118,7 @@ static int ctr3686_aes_nx_crypt(struct skcipher_request *req)
 	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	u8 iv[16];
 
-	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_IV_SIZE);
+	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_NONCE_SIZE);
 	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
 	iv[12] = iv[13] = iv[14] = 0;
 	iv[15] = 1;
-- 
2.25.1

