Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C962C6CC
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 14:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfE1Mmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 08:42:44 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:39625 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbfE1Mmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 08:42:44 -0400
Received: by mail-qk1-f201.google.com with SMTP id x68so27430001qka.6
        for <stable@vger.kernel.org>; Tue, 28 May 2019 05:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ucsJU2RQj5Jr+B5f+dPr47NtIreJR1DFJaQ5vCUwD8U=;
        b=UKtCdcbpzS06owZhQOx3kelGMFAA43Dv8TGAW1GJJBg2Qw2pibkdYVtufrqXn0GzV/
         jD8tBphl8MIuhIr91GDdtnY6OQ/H9p0Ojt2FrTUPCsARHBa1+ouRuSz2CXxTjazydbI7
         kZbZ5TAvfKX/6/YKjNV8v33g/3DnHzrqVjuRmNBSF8Jcj+h4qLxwyyHdkNg14KpFUMC2
         SnbkTixSImnlboEzEfJtw6/rWFvvXVUL3D/CSMMigfmZ3n6vjESMc4Lxi4ea5T2Eyfgp
         n59g38UdoLV5CknSgXHwL8Ccpn/C4yNj/BVWWuuxM0u313sXalM7es0c9VGoyL4c3Int
         xPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ucsJU2RQj5Jr+B5f+dPr47NtIreJR1DFJaQ5vCUwD8U=;
        b=IQaVz0hqt7hkUU2qy38i7MK7/MuWmnjnufFPVF1lrQSFh5Pu4sFyLsAqnsbT4oojol
         QD0k1hl4Gl/g+Kzi5eAdGjhp8gvLApfex7v4fQL0wnmlMFPTqCaWDZ9ZmXhV/sLSRUY/
         umlepmN1JuXb2XV7PbIEPQBvCTVg/zDdfE4q1dUoP5h0271L68NJ6z6BR/YSlk4zAg1P
         1PuHfy0YXvTWshAxb4dxA/UQB3TaO3uV+yNMJLb8cSt9aNYFxNQt3MGychekBA1AoFU+
         PHyOTEsvthpi8GfmqAboiwHI55un0Mocmt7OxD2QWxPgnqD6bnmg4RTO86c5b50vHqVJ
         TOUA==
X-Gm-Message-State: APjAAAXeCp+4HEi8McvgWFEu9CIorF+PkGaUjPIfqIgGMyq+5X7L2tKH
        bDClO20RZRUhfx2rP/Sfzqnlkje7aLC9
X-Google-Smtp-Source: APXvYqw8TpnhllV+/ul++qIitFY8+oWUgnh3WBiNMci8pLjrHtEiS5OzQJWwiDLUSx8OHT2SVZwJV1hNmnGP
X-Received: by 2002:a37:9481:: with SMTP id w123mr90890881qkd.319.1559047363388;
 Tue, 28 May 2019 05:42:43 -0700 (PDT)
Date:   Tue, 28 May 2019 13:41:52 +0100
Message-Id: <20190528124152.191773-1-lenaptr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH] arm64 sha1-ce finup: correct digest for empty data
From:   Elena Petrova <lenaptr@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The sha1-ce finup implementation for ARM64 produces wrong digest
for empty input (len=0). Expected: da39a3ee..., result: 67452301...
(initial value of SHA internal state). The error is in sha1_ce_finup:
for empty data `finalize` will be 1, so the code is relying on
sha1_ce_transform to make the final round. However, in
sha1_base_do_update, the block function will not be called when
len == 0.

Fix it by setting finalize to 0 if data is empty.

Fixes: 07eb54d306f4 ("crypto: arm64/sha1-ce - move SHA-1 ARMv8 implementation to base layer")
Cc: stable@vger.kernel.org
Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 arch/arm64/crypto/sha1-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index eaa7a8258f1c..0652f5f07ed1 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -55,7 +55,7 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 			 unsigned int len, u8 *out)
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
-	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
+	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE) && len;
 
 	if (!crypto_simd_usable())
 		return crypto_sha1_finup(desc, data, len, out);
-- 
2.22.0.rc1.257.g3120a18244-goog

