Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0E66C7B3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjAPQd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjAPQdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:33:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4799721941
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:21:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDB126104E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65F4C433D2;
        Mon, 16 Jan 2023 16:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886067;
        bh=7i2azwZ+Xdv4ccGKG3x6KIEYjfZZxiiCMsHlS/+CyrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrRyfVhu3WxhrLxs665XLz+lhVN0kQO3HACHnOGaPo2vZ/FI/RYOIO8f3fKjy6Gyj
         JnG9P48AzooWg2ac3+S/kluOjkYxSKwR3Swu1k0qMuy6mtSmc+eE4qGCWXpOPGItBB
         uUdmk7UXnVZgGj8qLVNrIMkr9xrDBUjgxxTOpsoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 250/658] crypto: ccree - swap SHA384 and SHA512 larval hashes at build time
Date:   Mon, 16 Jan 2023 16:45:38 +0100
Message-Id: <20230116154920.992793626@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f08b58501c74d6ec0828b55a0d4e0b2e840c2b9e ]

Due to the way the hardware works, every double word in the SHA384 and
SHA512 larval hashes must be swapped.  Currently this is done at run
time, during driver initialization.

However, this swapping can easily be done at build time.  Treating each
double word as two words has the benefit of changing the larval hashes'
types from u64[] to u32[], like for all other hashes, and allows
dropping the casts and size doublings when calling cc_set_sram_desc().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 4f1c596df706 ("crypto: ccree - Remove debugfs when platform_driver_register failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_driver.c |  1 -
 drivers/crypto/ccree/cc_hash.c   | 49 +++++++++++---------------------
 drivers/crypto/ccree/cc_hash.h   |  2 --
 3 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 8b8eee513c27..58ca59af0b2e 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -653,7 +653,6 @@ static struct platform_driver ccree_driver = {
 
 static int __init ccree_init(void)
 {
-	cc_hash_global_init();
 	cc_debugfs_global_init();
 
 	return platform_driver_register(&ccree_driver);
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index bc71bdf44a9f..9f67df0a4921 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -39,12 +39,19 @@ static const u32 cc_sha256_init[] = {
 	SHA256_H3, SHA256_H2, SHA256_H1, SHA256_H0 };
 static const u32 cc_digest_len_sha512_init[] = {
 	0x00000080, 0x00000000, 0x00000000, 0x00000000 };
-static u64 cc_sha384_init[] = {
-	SHA384_H7, SHA384_H6, SHA384_H5, SHA384_H4,
-	SHA384_H3, SHA384_H2, SHA384_H1, SHA384_H0 };
-static u64 cc_sha512_init[] = {
-	SHA512_H7, SHA512_H6, SHA512_H5, SHA512_H4,
-	SHA512_H3, SHA512_H2, SHA512_H1, SHA512_H0 };
+
+/*
+ * Due to the way the HW works, every double word in the SHA384 and SHA512
+ * larval hashes must be stored in hi/lo order
+ */
+#define hilo(x)	upper_32_bits(x), lower_32_bits(x)
+static const u32 cc_sha384_init[] = {
+	hilo(SHA384_H7), hilo(SHA384_H6), hilo(SHA384_H5), hilo(SHA384_H4),
+	hilo(SHA384_H3), hilo(SHA384_H2), hilo(SHA384_H1), hilo(SHA384_H0) };
+static const u32 cc_sha512_init[] = {
+	hilo(SHA512_H7), hilo(SHA512_H6), hilo(SHA512_H5), hilo(SHA512_H4),
+	hilo(SHA512_H3), hilo(SHA512_H2), hilo(SHA512_H1), hilo(SHA512_H0) };
+
 static const u32 cc_sm3_init[] = {
 	SM3_IVH, SM3_IVG, SM3_IVF, SM3_IVE,
 	SM3_IVD, SM3_IVC, SM3_IVB, SM3_IVA };
@@ -1948,8 +1955,8 @@ int cc_init_hash_sram(struct cc_drvdata *drvdata)
 	}
 
 	if (large_sha_supported) {
-		cc_set_sram_desc((u32 *)cc_sha384_init, sram_buff_ofs,
-				 (ARRAY_SIZE(cc_sha384_init) * 2), larval_seq,
+		cc_set_sram_desc(cc_sha384_init, sram_buff_ofs,
+				 ARRAY_SIZE(cc_sha384_init), larval_seq,
 				 &larval_seq_len);
 		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 		if (rc)
@@ -1957,8 +1964,8 @@ int cc_init_hash_sram(struct cc_drvdata *drvdata)
 		sram_buff_ofs += sizeof(cc_sha384_init);
 		larval_seq_len = 0;
 
-		cc_set_sram_desc((u32 *)cc_sha512_init, sram_buff_ofs,
-				 (ARRAY_SIZE(cc_sha512_init) * 2), larval_seq,
+		cc_set_sram_desc(cc_sha512_init, sram_buff_ofs,
+				 ARRAY_SIZE(cc_sha512_init), larval_seq,
 				 &larval_seq_len);
 		rc = send_request_init(drvdata, larval_seq, larval_seq_len);
 		if (rc)
@@ -1969,28 +1976,6 @@ int cc_init_hash_sram(struct cc_drvdata *drvdata)
 	return rc;
 }
 
-static void __init cc_swap_dwords(u32 *buf, unsigned long size)
-{
-	int i;
-	u32 tmp;
-
-	for (i = 0; i < size; i += 2) {
-		tmp = buf[i];
-		buf[i] = buf[i + 1];
-		buf[i + 1] = tmp;
-	}
-}
-
-/*
- * Due to the way the HW works we need to swap every
- * double word in the SHA384 and SHA512 larval hashes
- */
-void __init cc_hash_global_init(void)
-{
-	cc_swap_dwords((u32 *)&cc_sha384_init, (ARRAY_SIZE(cc_sha384_init) * 2));
-	cc_swap_dwords((u32 *)&cc_sha512_init, (ARRAY_SIZE(cc_sha512_init) * 2));
-}
-
 int cc_hash_alloc(struct cc_drvdata *drvdata)
 {
 	struct cc_hash_handle *hash_handle;
diff --git a/drivers/crypto/ccree/cc_hash.h b/drivers/crypto/ccree/cc_hash.h
index 0d6dc61484d7..3dbd0abefea0 100644
--- a/drivers/crypto/ccree/cc_hash.h
+++ b/drivers/crypto/ccree/cc_hash.h
@@ -104,6 +104,4 @@ cc_digest_len_addr(void *drvdata, u32 mode);
  */
 cc_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode);
 
-void cc_hash_global_init(void);
-
 #endif /*__CC_HASH_H__*/
-- 
2.35.1



