Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590565481E5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiFMIJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 04:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239550AbiFMIJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 04:09:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61611E3CB
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 01:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64E81B8015B
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 08:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBBEC34114;
        Mon, 13 Jun 2022 08:09:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hJF2vZ2G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655107741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CL1DkLt7vvLL4sh4xec0xh7SoeyRLxVPKVqMe8OnuHM=;
        b=hJF2vZ2GFGd5g2tchcpssYr2DXTVQIr//q+D62KuX1RLQ/h5UuckQ+U+yl9wGSdJN+Qqjb
        oR/ggXLnj+pwLSGCrZ3E0phjykCaq+nlYJq2m7zFy4S3LQWFNloQ+WQyWMLiIEPhZjrnk5
        kBz3SrFPoFfRB8+cSHfRNUarD9ZhW9Y=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 582e643b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jun 2022 08:09:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.18 5.17 5.15 5.10 2/3] random: mark bootloader randomness code as __init
Date:   Mon, 13 Jun 2022 10:07:48 +0200
Message-Id: <20220613080749.153222-3-Jason@zx2c4.com>
In-Reply-To: <20220613080749.153222-1-Jason@zx2c4.com>
References: <20220613080749.153222-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 39e0f991a62ed5efabd20711a7b6e7da92603170 upstream.

add_bootloader_randomness() and the variables it touches are only used
during __init and not after, so mark these as __init. At the same time,
unexport this, since it's only called by other __init code that's
built-in.

Cc: stable@vger.kernel.org
Fixes: 428826f5358c ("fdt: add support for rng-seed")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c  | 7 +++----
 include/linux/random.h | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9972259809db..d09e78e6f24b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -785,8 +785,8 @@ static void __cold _credit_init_bits(size_t bits)
  *
  **********************************************************************/
 
-static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
-static bool trust_bootloader __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER);
+static bool trust_cpu __initdata = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
+static bool trust_bootloader __initdata = IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER);
 static int __init parse_trust_cpu(char *arg)
 {
 	return kstrtobool(arg, &trust_cpu);
@@ -882,13 +882,12 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
  * Handle random seed passed by bootloader, and credit it if
  * CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  */
-void __cold add_bootloader_randomness(const void *buf, size_t len)
+void __init add_bootloader_randomness(const void *buf, size_t len)
 {
 	mix_pool_bytes(buf, len);
 	if (trust_bootloader)
 		credit_init_bits(len * 8);
 }
-EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
 struct fast_pool {
 	struct work_struct mix;
diff --git a/include/linux/random.h b/include/linux/random.h
index 917470c4490a..3feafab498ad 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -13,7 +13,7 @@
 struct notifier_block;
 
 void add_device_randomness(const void *buf, size_t len);
-void add_bootloader_randomness(const void *buf, size_t len);
+void __init add_bootloader_randomness(const void *buf, size_t len);
 void add_input_randomness(unsigned int type, unsigned int code,
 			  unsigned int value) __latent_entropy;
 void add_interrupt_randomness(int irq) __latent_entropy;
-- 
2.35.1

