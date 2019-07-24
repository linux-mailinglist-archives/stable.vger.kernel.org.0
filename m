Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9874528
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404163AbfGYFjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404156AbfGYFjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:39:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9670922BF3;
        Thu, 25 Jul 2019 05:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033188;
        bh=6vHvRQBtyfYp/zt+ZKBcm/GfCCmNfiJ/IJqu3vk8oD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DO+H+CKOWqhTjWeemV1w3loGNfRVKhU24xcq6k834tkDr+jln96FMf7gm1c3P+Zyg
         SCZKshGo1JzfsZoniGij1S/Zof7KKnKSOrVZwLP+94t2K/w/WgxobhWEDE/XnGvKKp
         80/3UtgYuOzDoShve8RKih+JPs9/sTwzS+cqG7QA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/271] crypto: serpent - mark __serpent_setkey_sbox noinline
Date:   Wed, 24 Jul 2019 21:19:49 +0200
Message-Id: <20190724191705.563020760@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 473971187d6727609951858c63bf12b0307ef015 ]

The same bug that gcc hit in the past is apparently now showing
up with clang, which decides to inline __serpent_setkey_sbox:

crypto/serpent_generic.c:268:5: error: stack frame size of 2112 bytes in function '__serpent_setkey' [-Werror,-Wframe-larger-than=]

Marking it 'noinline' reduces the stack usage from 2112 bytes to
192 and 96 bytes, respectively, and seems to generate more
useful object code.

Fixes: c871c10e4ea7 ("crypto: serpent - improve __serpent_setkey with UBSAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/serpent_generic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 7c3382facc82..600bd288881d 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -229,7 +229,13 @@
 	x4 ^= x2;					\
 	})
 
-static void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 *k)
+/*
+ * both gcc and clang have misoptimized this function in the past,
+ * producing horrible object code from spilling temporary variables
+ * on the stack. Forcing this part out of line avoids that.
+ */
+static noinline void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2,
+					   u32 r3, u32 r4, u32 *k)
 {
 	k += 100;
 	S3(r3, r4, r0, r1, r2); store_and_load_keys(r1, r2, r4, r3, 28, 24);
-- 
2.20.1



