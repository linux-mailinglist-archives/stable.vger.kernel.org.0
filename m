Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C4F154351
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBFLmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:42:43 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:56295 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgBFLmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 06:42:43 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e4934e92;
        Thu, 6 Feb 2020 11:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=t4Len6Fa4vj2dKk9fEebpyLi4CE=; b=gVIA+J/d6t0WzqD5VlPR
        4w6WZ87s2rKNhWLtVh+9JdsL0UBtVrBOp/aqteq81+fh0aBD6NAvbvnn9l0HpG2b
        re8DQv4++vlATlZg/CK7vA8so7svhSkexO8Fxvhr/XBeX4dsjqYmc9pgnFHfyHXY
        xbt/AQdk7gHgR22e9HZ3IvvAeqUtT36kUjjPBQ812ZqST0nSsDTdWL2+GgiI4D/x
        7lnuGtM2rRTe5SMKemBlEzGfS4OUDmeKHzFWgCbQjfx/2yWKKLpMsYjrxor15IHh
        xXp9675M9a8316r3dJU2PDlMGE4HkM/tpVM6ZCe0i+bJHlJNw463S50e4WbzpbFe
        DQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 242809b6 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 6 Feb 2020 11:41:36 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH stable] crypto: chacha20poly1305 - prevent integer overflow on large input
Date:   Thu,  6 Feb 2020 12:42:01 +0100
Message-Id: <20200206114201.25438-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This code assigns src_len (size_t) to sl (int), which causes problems
when src_len is very large. Probably nobody in the kernel should be
passing this much data to chacha20poly1305 all in one go anyway, so I
don't think we need to change the algorithm or introduce larger types
or anything. But we should at least error out early in this case and
print a warning so that we get reports if this does happen and can look
into why anybody is possibly passing it that much data or if they're
accidently passing -1 or similar.

Fixes: d95312a3ccc0 ("crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine")
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 lib/crypto/chacha20poly1305.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 6d83cafebc69..ad0699ce702f 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -235,6 +235,9 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 		__le64 lens[2];
 	} b __aligned(16);
 
+	if (WARN_ON(src_len > INT_MAX))
+		return false;
+
 	chacha_load_key(b.k, key);
 
 	b.iv[0] = 0;
-- 
2.25.0

