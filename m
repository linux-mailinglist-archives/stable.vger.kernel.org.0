Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E12D2C8DD
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 16:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfE1OfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 10:35:20 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:49252 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfE1OfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 10:35:20 -0400
Received: by mail-qk1-f202.google.com with SMTP id c4so27961997qkd.16
        for <stable@vger.kernel.org>; Tue, 28 May 2019 07:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=u6Hmqn+VoyKdzrtqe2ho0SlGWPLtiXGeTWqFLUr85co=;
        b=NL9yD5jUYvPP4qO7lNiSZk/ZyRLfJT27GCzl2DrrIySI1M4qxs8VLhV9Ij/1iHZbeL
         DYgibIRy9GaEfaRewIgFK2nDCGKCtzIAGfW4B8M+/jDP/Tc2E/RAQ7S7zLUzkBZllV79
         pJpAl+Z356uejo4Q8EnxoiHmVSEXpclqN83l22WLXyJyRBg7BFVqYkE1R31nhm5TE7+A
         516KZ+V951PWR3Imh1zxvsmJH+LtKKdvukLVx18bhH5qKhhyU5tlSC7evYFodJwTzjAu
         2oXNs8+rgMXzrUgoce5qtzwgKMsmZX3tnKMzQ62n9vgOWavkcD8+Xmp0ZfG1IdJngvEG
         y4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=u6Hmqn+VoyKdzrtqe2ho0SlGWPLtiXGeTWqFLUr85co=;
        b=DCbP0Q5OKnz8/XGf3xU495GX4BsOw2ygPBkGYw+f3JM98WakLgbD+51q+iiYrervzk
         ZKmGiuhjeMQayrni/fJ2uthbcNUb5TgX0VfdFUnLoqBDRzxp/QrkweykP7xcfykRJFse
         3dTOVIMTNntiKBa+sock805QuqfOvWnJIJewKKfBnTd7i5Kb8oXtchD1gaJs7pqeQkYm
         k7VzZr0aSTN4DGsC5/p0KV1oeXZ7jNpFMoKJzoZGqcj7jFbmCZWthw8khdihLB0mVNjA
         IAPfCMQuEDQW2OrzupydNcdeZzxdabmPjwKTYMnKd4MmwS5MvNp3/twdX3F82riQkfgz
         E27w==
X-Gm-Message-State: APjAAAWv24pYdz9ptQrjV4iAj5IQnRt0xWSq3pSDlr08ZD1I/tiyJTKS
        jYDQhP9gqcMzTDbBkAj/UlracHRZEE2E
X-Google-Smtp-Source: APXvYqwMBBtjjJq05ANZM9pV7i8dJ/KKpmWn4lIpusn+/tr/Hp2FtsNKbxPRvuPOWbwz2LSSEip6w8TJNCUs
X-Received: by 2002:a0c:b626:: with SMTP id f38mr39955266qve.223.1559054119482;
 Tue, 28 May 2019 07:35:19 -0700 (PDT)
Date:   Tue, 28 May 2019 15:35:06 +0100
Message-Id: <20190528143506.212198-1-lenaptr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH] arm64 sha2-ce finup: correct digest for empty data
From:   Elena Petrova <lenaptr@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The sha256-ce finup implementation for ARM64 produces wrong digest
for empty input (len=0). Expected: the actual digest, result: initial
value of SHA internal state. The error is in sha256_ce_finup:
for empty data `finalize` will be 1, so the code is relying on
sha2_ce_transform to make the final round. However, in
sha256_base_do_update, the block function will not be called when
len == 0.

Fix it by setting finalize to 0 if data is empty.

Fixes: 03802f6a80b3a ("crypto: arm64/sha2-ce - move SHA-224/256 ARMv8 implementation to base layer")
Cc: stable@vger.kernel.org
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/crypto/sha2-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index a725997e55f2..6a5ade974a35 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -60,7 +60,7 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 			   unsigned int len, u8 *out)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
-	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE);
+	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE) && len;
 
 	if (!crypto_simd_usable()) {
 		if (len)
-- 
2.22.0.rc1.257.g3120a18244-goog

