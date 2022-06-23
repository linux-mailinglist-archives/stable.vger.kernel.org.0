Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BA45583F9
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiFWRjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiFWRht (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:37:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C0A9215D;
        Thu, 23 Jun 2022 10:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F29F8B82490;
        Thu, 23 Jun 2022 17:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60075C3411B;
        Thu, 23 Jun 2022 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004025;
        bh=V7VZQRAeVjdGBfQAq7pOoLj/uayn7MvBnfbjcr7tSXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDv9qxi/KRenDGuo1/ECCycS3bp2oRExjnrK7P4QVIsspDKkfnTm4hcMXWYfymcO2
         U6foBEafCCm6DKPCmSxA/XaMfHC0S14uOllKnosNC7QBlwFeYfCQOdbYWjXiSfjnyB
         M0sNG9rKSxZQpLEUDc5X5y8QJBVDCDPFdJDME098=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Graham Christensen <graham@grahamc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 137/237] random: treat bootloader trust toggle the same way as cpu trust toggle
Date:   Thu, 23 Jun 2022 18:42:51 +0200
Message-Id: <20220623164347.095574362@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit d97c68d178fbf8aaaf21b69b446f2dfb13909316 upstream.

If CONFIG_RANDOM_TRUST_CPU is set, the RNG initializes using RDRAND.
But, the user can disable (or enable) this behavior by setting
`random.trust_cpu=0/1` on the kernel command line. This allows system
builders to do reasonable things while avoiding howls from tinfoil
hatters. (Or vice versa.)

CONFIG_RANDOM_TRUST_BOOTLOADER is basically the same thing, but regards
the seed passed via EFI or device tree, which might come from RDRAND or
a TPM or somewhere else. In order to allow distros to more easily enable
this while avoiding those same howls (or vice versa), this commit adds
the corresponding `random.trust_bootloader=0/1` toggle.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Graham Christensen <graham@grahamc.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Link: https://github.com/NixOS/nixpkgs/pull/165355
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    6 ++++++
 drivers/char/Kconfig                            |    3 ++-
 drivers/char/random.c                           |    8 +++++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3532,6 +3532,12 @@
 			fully seed the kernel's CRNG. Default is controlled
 			by CONFIG_RANDOM_TRUST_CPU.
 
+	random.trust_bootloader={on,off}
+			[KNL] Enable or disable trusting the use of a
+			seed passed by the bootloader (if available) to
+			fully seed the kernel's CRNG. Default is controlled
+			by CONFIG_RANDOM_TRUST_BOOTLOADER.
+
 	ras=option[,option,...]	[KNL] RAS-specific options
 
 		cec_disable	[X86]
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -612,4 +612,5 @@ config RANDOM_TRUST_BOOTLOADER
 	device randomness. Say Y here to assume the entropy provided by the
 	booloader is trustworthy so it will be added to the kernel's entropy
 	pool. Otherwise, say N here so it will be regarded as device input that
-	only mixes the entropy pool.
\ No newline at end of file
+	only mixes the entropy pool. This can also be configured at boot with
+	"random.trust_bootloader=on/off".
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -940,11 +940,17 @@ static bool drain_entropy(void *buf, siz
  **********************************************************************/
 
 static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
+static bool trust_bootloader __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER);
 static int __init parse_trust_cpu(char *arg)
 {
 	return kstrtobool(arg, &trust_cpu);
 }
+static int __init parse_trust_bootloader(char *arg)
+{
+	return kstrtobool(arg, &trust_bootloader);
+}
 early_param("random.trust_cpu", parse_trust_cpu);
+early_param("random.trust_bootloader", parse_trust_bootloader);
 
 /*
  * The first collection of entropy occurs at system boot while interrupts
@@ -1152,7 +1158,7 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_random
  */
 void add_bootloader_randomness(const void *buf, size_t size)
 {
-	if (IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER))
+	if (trust_bootloader)
 		add_hwgenerator_randomness(buf, size, size * 8);
 	else
 		add_device_randomness(buf, size);


