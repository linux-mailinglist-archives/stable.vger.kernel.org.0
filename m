Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84BD61F79F
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbiKGP2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbiKGP2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:28:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6D11DF2F
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:28:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8220B812AA
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C363DC433C1;
        Mon,  7 Nov 2022 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667834914;
        bh=tsasxLGRG3nAs1Shj62whktDNaVQOqAKKjwU+QOSrhE=;
        h=Subject:To:Cc:From:Date:From;
        b=t063/8OyYqQz4/o7T8TUNFIDs2vnRMQZcVpogX+c24QLqqHCzmUlf6TDf3RnNngN3
         uJwsZekW1vwLse/+mtn5dohms6ZioQRk+ThcdJ8xxOWf3SUbAcwSoJZjPvhG80GrWJ
         lsER1/TMmO2XNz3HASDczLx/wR3Qm18+XQv9Ba3g=
Subject: FAILED: patch "[PATCH] efi: random: reduce seed size to 32 bytes" failed to apply to 4.19-stable tree
To:     ardb@kernel.org, Jason@zx2c4.com, ilias.apalodimas@linaro.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 16:28:30 +0100
Message-ID: <1667834910140236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

161a438d730d ("efi: random: reduce seed size to 32 bytes")
6120681bdf1a ("Merge branch 'efi/urgent' into efi/core, to pick up fixes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 161a438d730dade2ba2b1bf8785f0759aba4ca5f Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 20 Oct 2022 10:39:08 +0200
Subject: [PATCH] efi: random: reduce seed size to 32 bytes

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
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3ecdc43a3f2b..a46df5d1d094 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -611,7 +611,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = READ_ONCE(seed->size);
+			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 80f3c1c7827d..929d559ad41d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1222,7 +1222,7 @@ efi_status_t efi_random_get_seed(void);
 	arch_efi_call_virt_teardown();					\
 })
 
-#define EFI_RANDOM_SEED_SIZE		64U
+#define EFI_RANDOM_SEED_SIZE		32U // BLAKE2S_HASH_SIZE
 
 struct linux_efi_random_seed {
 	u32	size;

