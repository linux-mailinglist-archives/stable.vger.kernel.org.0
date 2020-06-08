Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB41C1F22BE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgFHXKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbgFHXKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89C4F20890;
        Mon,  8 Jun 2020 23:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657836;
        bh=73KsjooSBJpJiiH+QOeAQXNpAvN1RJ9iKUFTKw70dcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0KciWcBM2kpYve8pyLzVAxScAx6+scfH6ot15zpKsh/6l2jOU5Zy6grIDlCgZ6uY
         /ySlNXhU519zSc9a9PmiXoEZVQ1Dm4FqP0+/bKAWgGYOS7GmC6ANWt/dRhEthEHesP
         JwBcB0a4QvEkOv7C2tTOavgkOIAb89xJgqfp9iH8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.7 205/274] crypto: blake2b - Fix clang optimization for ARMv7-M
Date:   Mon,  8 Jun 2020 19:04:58 -0400
Message-Id: <20200608230607.3361041-205-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0c0408e86dbe8f44d4b27bf42130e8ac905361d6 ]

When building for ARMv7-M, clang-9 or higher tries to unroll some loops,
which ends up confusing the register allocator to the point of generating
rather bad code and using more than the warning limit for stack frames:

warning: stack frame size of 1200 bytes in function 'blake2b_compress' [-Wframe-larger-than=]

Forcing it to not unroll the final loop avoids this problem.

Fixes: 91d689337fe8 ("crypto: blake2b - add blake2b generic implementation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/blake2b_generic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 1d262374fa4e..0ffd8d92e308 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -129,7 +129,9 @@ static void blake2b_compress(struct blake2b_state *S,
 	ROUND(9);
 	ROUND(10);
 	ROUND(11);
-
+#ifdef CONFIG_CC_IS_CLANG
+#pragma nounroll /* https://bugs.llvm.org/show_bug.cgi?id=45803 */
+#endif
 	for (i = 0; i < 8; ++i)
 		S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];
 }
-- 
2.25.1

