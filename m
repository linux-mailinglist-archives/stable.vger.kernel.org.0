Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DA95BD1E2
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 18:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiISQJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 12:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiISQJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 12:09:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0CA13F1F;
        Mon, 19 Sep 2022 09:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B92B960C62;
        Mon, 19 Sep 2022 16:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FD6C433C1;
        Mon, 19 Sep 2022 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663603784;
        bh=yt73m9t5ZgC8SztOHgPOeinn+X5PpD3vUgcYSG9Orhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbp9dOQPubbNQSJq1m1g7r/cY/wNUQw+m6YcF9pEpA799Pha30TAc4b1IYNWe8GBn
         gmYCgYDJnmFVHI5HLAAzBh8sbJvmy+XPY4rixwCndBQFoeOQ0fC3lFevaW+NH/R0Sm
         /eiDWoQuh9Qu5r83BSKCr1q+Q63LiYlVOftDQ1RoMrlMgt2xku3sXP4k4opb4umo08
         V4f9QqxnSq2zvxnC+o2ghsU+HEF+xnmHaj6Hz/YKDgSXkp1cw/e6fvWQerRzYFKhkj
         lC2ze7IKC1f/oKsi9lDDIaDpgjtbf3J9kBuqQHdGcjGv8jtbFL7L0fYk/OiT+J6iic
         FUm+dNr/X71tw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Lennart Poettering <lennart@poettering.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] efi: random: reduce seed size to 32 bytes
Date:   Mon, 19 Sep 2022 18:09:29 +0200
Message-Id: <20220919160931.2945427-2-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220919160931.2945427-1-ardb@kernel.org>
References: <20220919160931.2945427-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=ardb@kernel.org; h=from:subject; bh=yt73m9t5ZgC8SztOHgPOeinn+X5PpD3vUgcYSG9Orhk=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjKJQ2BjJhtZa6gBf3DbKuZtxnhbobAqaeNBUrkVqS WmiPI2iJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYyiUNgAKCRDDTyI5ktmPJHFbC/ 4qFkdGnBTSSu2eJPVlHDPUk4RN30Qz/CbPZxdArSWMGCxMrXoyPJIjWpPWHtXBB8ZKlv57vVe9RWOE qpSuj8aBgU8dU4NvWGfaX8u+OceqYf7p7DMwZBeA/g2OGgQqqzSxbtwfLruEn7/DoI9HpP4ujK+x2w O3a5VSPRiZPBVDbUpllW1iX0LCq2ZUSTNKPr2DPwiQ3AHzhLIo6WXcMZFefSq9s0zbOahJmKSLtaa8 Q4lZz80HJLo/4SfTx5yv3XUSXyFCrFbmFAo3LIy+kTyMuC/8tdNfaNEbB3hv89CI6zZwubB7ETbmlG oC6/BVsZC3DPq2ABGxy9tYkEBchwYnqoGgtmVbk0J0frJXl4oYUQhyg61GY/HYk2HgCU7O0sISFUOl Mw7CTGJeL8W2yxWk1mDijtlDrWOmavhIhD9QyW5B6qKhlMDqT07/LaqeCi7Do/oItTeMFp9OL+vROf KpkXFvH9QMqDG2Idxiw1RCvK9ihAYEhI9E78WRgO2S3+s=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We no longer need at least 64 bytes of random seed to permit the early
crng init to complete. The RNG is now based on Blake2s, so reduce the
EFI seed size to the Blake2s hash size, which is sufficient for our
purposes.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/efi.c | 2 +-
 include/linux/efi.h        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index e4080ad96089..06b0755f32a2 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -606,7 +606,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = READ_ONCE(seed->size);
+			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d2b84c2fec39..7b015508c773 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1195,7 +1195,7 @@ efi_status_t efi_random_get_seed(void);
 	arch_efi_call_virt_teardown();					\
 })
 
-#define EFI_RANDOM_SEED_SIZE		64U
+#define EFI_RANDOM_SEED_SIZE		32U // BLAKE2S_HASH_SIZE
 
 struct linux_efi_random_seed {
 	u32	size;
-- 
2.35.1

