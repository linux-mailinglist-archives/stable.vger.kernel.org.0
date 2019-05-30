Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA3D3014D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 19:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfE3RyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 13:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3RyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 13:54:01 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C039F25ECD;
        Thu, 30 May 2019 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559238840;
        bh=D/PAsRdmHinV0G8J8RSgg+BLFB1EZv/D0c+yzSUAlhI=;
        h=From:To:Cc:Subject:Date:From;
        b=SmpYdl/4ara6nxE2+chm8yUcFEOCr3bQNqCB9DY6QMKQygP7tdj02728lmpiPZJ0Q
         ol9U5cqM0GTUkOM3wnZyQ0rSy6LEzVQZv3kvI7Rbr0kafSkQ0fOdTBku0adckxgl2h
         IFOIWAGHt/ORavLSFlX76Pnv3G96EtlIxxZUqpzQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH] crypto: lrw - use correct alignmask
Date:   Thu, 30 May 2019 10:53:08 -0700
Message-Id: <20190530175308.196938-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit c778f96bf347 ("crypto: lrw - Optimize tweak computation")
incorrectly reduced the alignmask of LRW instances from
'__alignof__(u64) - 1' to '__alignof__(__be32) - 1'.

However, xor_tweak() and setkey() assume that the data and key,
respectively, are aligned to 'be128', which has u64 alignment.

Fix the alignmask to be at least '__alignof__(be128) - 1'.

Fixes: c778f96bf347 ("crypto: lrw - Optimize tweak computation")
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/lrw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index fa302f3f161e0..b43ea285b8c79 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -388,7 +388,7 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = LRW_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
-				       (__alignof__(__be32) - 1);
+				       (__alignof__(be128) - 1);
 
 	inst->alg.ivsize = LRW_BLOCK_SIZE;
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
-- 
2.22.0.rc1.257.g3120a18244-goog

