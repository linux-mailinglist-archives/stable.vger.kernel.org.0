Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB1605A13
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 10:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJTIks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 04:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiJTIkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 04:40:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542C4FE910;
        Thu, 20 Oct 2022 01:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74DB0B826A1;
        Thu, 20 Oct 2022 08:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78BFC433C1;
        Thu, 20 Oct 2022 08:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666255228;
        bh=+9bMSJ0X4Yjn8yLu6yBGJtoukl8NU5/yiaxkP9nsKi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B36vHDFHBJs6hHEaHMyjxe1wh+DcvDlRFCDQYVuTjgT+acfIGU+saTpvMxdQxlk1T
         8TlfBvXwLDxX+eGkk3lQjYjuPA23m9L4Jvci00/mdtEsdTJgxktNiL27Cid/EFBJU9
         0jLMJOtiTlJmiHbR5a2aZ/vJo02P8LQJto6OTbwFCUfY/yR9uSgRj+KRgGXCrTioLW
         RgTyIjae5oL995mOMIaZYthuMfnybMAFi3/EhmRlOC20Dp9Uz6YlpiNbkcp6waw8oy
         1wda+VoWOWJ8c435wgvwcqA23zJ9Rs3OgkuC6gJoyVWo+qvGG5lVnhlKMk5W0ukBKg
         rwn/BHMIFslLg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Lennart Poettering <lennart@poettering.net>,
        stable@vger.kernel.org
Subject: [PATCH v3 1/3] efi: random: reduce seed size to 32 bytes
Date:   Thu, 20 Oct 2022 10:39:08 +0200
Message-Id: <20221020083910.1902009-2-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221020083910.1902009-1-ardb@kernel.org>
References: <20221020083910.1902009-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1656; i=ardb@kernel.org; h=from:subject; bh=+9bMSJ0X4Yjn8yLu6yBGJtoukl8NU5/yiaxkP9nsKi4=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjUQkqg0qt7nSGhTRI40z0ewqgrZPZ4lMqOdNYP6j8 xnKM1D+JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY1EJKgAKCRDDTyI5ktmPJENzC/ 4vYmMEMsuIj+WaTXdML+3JJw2kkRxTAZdg6xm2yFfjuqw+04pJGXHTp40sJQRHHpTbHKxIWKYA8lHF RLeEjRy5s6BQ3V2q1iJ5ttAVEsRJKmLTrzJ1dxk8DDykjW29NCDc6lDoh4Ag9JPcGIrcXc3eKrYa7A E8NnH2s3shVFZjcmPFTbYgDEj/t6IZ+tIKwknt6w2RDodnf4Vv2eyf3qfxvIkMx2aJpOp7RFM2NIlD ypGnTf38d5gXVaMtpoolIP1GFLmOUcr5UNpJ2TlmmxRxUK3qK9UKYcmt8+ZRGXgA+74MxYMCY6JmsV V4qs1FKHDN/FQRw/fCyCiZSVlMua8XxMRW7CE5RaP13ioodvUINDH/uShZGJCfMHw/TFSPEVRWfkKk 8z2Jt/b3e1d4E2kiQv/gK8aBLovalQaoJlt46n/ZmfGxrUZqKgLYJP9pa40rmZbQkgCkQ4LhXH/RJj ZaUY5yWXP2oq48UTTtNXeznwWaddk5l44tJHF5TVEnOHA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

While at it, drop the READ_ONCE(), which was supposed to prevent size
from being evaluated after seed was unmapped. However, this cannot
actually happen, so READ_ONCE() is unnecessary here.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/firmware/efi/efi.c | 2 +-
 include/linux/efi.h        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9624735f1575..a949509de62f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -609,7 +609,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = READ_ONCE(seed->size);
+			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index da3974bf05d3..cf96f8d5f15f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1225,7 +1225,7 @@ efi_status_t efi_random_get_seed(void);
 	arch_efi_call_virt_teardown();					\
 })
 
-#define EFI_RANDOM_SEED_SIZE		64U
+#define EFI_RANDOM_SEED_SIZE		32U // BLAKE2S_HASH_SIZE
 
 struct linux_efi_random_seed {
 	u32	size;
-- 
2.35.1

