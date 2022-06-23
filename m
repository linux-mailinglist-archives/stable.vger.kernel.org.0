Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296675582BE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiFWRTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiFWRQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:16:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E828859E;
        Thu, 23 Jun 2022 09:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 706FAB8248F;
        Thu, 23 Jun 2022 16:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C8CC341C5;
        Thu, 23 Jun 2022 16:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003581;
        bh=k8IRD0CITbwpR3zpBINJA66Fe1woeN7WaFk+Ji76kp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COkbrKlN40AI+K3lzIGlaqr75311G2xktTiFV54QHr4981xGhRO4Lj2epZTi21UVp
         fdqUxtSXqfyDXMfMvxFZ4MkZTpLCV9iDGGloPg7IFJdzb8cUPcDw2ziLoYl+kv9geO
         B/kH/W+jJUZXxi3yNXGauRdlckqgGP+U2pLx3xfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4.14 021/237] fdt: add support for rng-seed
Date:   Thu, 23 Jun 2022 18:40:55 +0200
Message-Id: <20220623164343.763322956@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

commit 428826f5358c922dc378830a1717b682c0823160 upstream.

Introducing a chosen node, rng-seed, which is an entropy that can be
passed to kernel called very early to increase initial device
randomness. Bootloader should provide this entropy and the value is
read from /chosen/rng-seed in DT.

Obtain of_fdt_crc32 for CRC check after early_init_dt_scan_nodes(),
since early_init_dt_scan_chosen() would modify fdt to erase rng-seed.

Add a new interface add_bootloader_randomness() for rng-seed use case.
Depends on whether the seed is trustworthy, rng seed would be passed to
add_hwgenerator_randomness(). Otherwise it would be passed to
add_device_randomness(). Decision is controlled by kernel config
RANDOM_TRUST_BOOTLOADER.

Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Theodore Ts'o <tytso@mit.edu> # drivers/char/random.c
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/Kconfig   |    9 +++++++++
 drivers/char/random.c  |   14 ++++++++++++++
 drivers/of/fdt.c       |   14 ++++++++++++--
 include/linux/random.h |    1 +
 4 files changed, 36 insertions(+), 2 deletions(-)

--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -604,3 +604,12 @@ config RANDOM_TRUST_CPU
 	has not installed a hidden back door to compromise the CPU's
 	random number generation facilities. This can also be configured
 	at boot with "random.trust_cpu=on/off".
+
+config RANDOM_TRUST_BOOTLOADER
+	bool "Trust the bootloader to initialize Linux's CRNG"
+	help
+	Some bootloaders can provide entropy to increase the kernel's initial
+	device randomness. Say Y here to assume the entropy provided by the
+	booloader is trustworthy so it will be added to the kernel's entropy
+	pool. Otherwise, say N here so it will be regarded as device input that
+	only mixes the entropy pool.
\ No newline at end of file
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2440,3 +2440,17 @@ void add_hwgenerator_randomness(const ch
 	}
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
+
+/* Handle random seed passed by bootloader.
+ * If the seed is trustworthy, it would be regarded as hardware RNGs. Otherwise
+ * it would be regarded as device data.
+ * The decision is controlled by CONFIG_RANDOM_TRUST_BOOTLOADER.
+ */
+void add_bootloader_randomness(const void *buf, unsigned int size)
+{
+	if (IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER))
+		add_hwgenerator_randomness(buf, size, size * 8);
+	else
+		add_device_randomness(buf, size);
+}
+EXPORT_SYMBOL_GPL(add_bootloader_randomness);
\ No newline at end of file
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -27,6 +27,7 @@
 #include <linux/debugfs.h>
 #include <linux/serial_core.h>
 #include <linux/sysfs.h>
+#include <linux/random.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -1117,6 +1118,7 @@ int __init early_init_dt_scan_chosen(uns
 {
 	int l;
 	const char *p;
+	const void *rng_seed;
 
 	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
 
@@ -1151,6 +1153,14 @@ int __init early_init_dt_scan_chosen(uns
 
 	pr_debug("Command line is: %s\n", (char*)data);
 
+	rng_seed = of_get_flat_dt_prop(node, "rng-seed", &l);
+	if (rng_seed && l > 0) {
+		add_bootloader_randomness(rng_seed, l);
+
+		/* try to clear seed so it won't be found. */
+		fdt_nop_property(initial_boot_params, node, "rng-seed");
+	}
+
 	/* break now */
 	return 1;
 }
@@ -1262,8 +1272,6 @@ bool __init early_init_dt_verify(void *p
 
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
-	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
-				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
@@ -1289,6 +1297,8 @@ bool __init early_init_dt_scan(void *par
 		return false;
 
 	early_init_dt_scan_nodes();
+	of_fdt_crc32 = crc32_be(~0, initial_boot_params,
+				fdt_totalsize(initial_boot_params));
 	return true;
 }
 
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -19,6 +19,7 @@ struct random_ready_callback {
 };
 
 extern void add_device_randomness(const void *, unsigned int);
+extern void add_bootloader_randomness(const void *, unsigned int);
 
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)


