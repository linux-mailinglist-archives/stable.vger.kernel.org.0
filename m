Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625B15360E4
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347978AbiE0L5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353317AbiE0L4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02325B4A;
        Fri, 27 May 2022 04:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42157CE2511;
        Fri, 27 May 2022 11:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D889C385A9;
        Fri, 27 May 2022 11:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652273;
        bh=ot30keQP2gwcvs0UGuazLhTq4/PPc4e/25W66yAwUX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/ff9hj+HGQbaMf4FDq7mRiSGwjoSOpjIpjBuyF19WDRTcqz9aVcLmvru1Gag/OaN
         K9oyr3+9yftqVX3bAWdn4I9vo0vTvBkTGBUcB3kxK0vpOZeNko3bj9pQ0VPp3f7HXB
         eAbxnTsfSSps3KOomoKknYyVL8OiZz8WzYnNDVTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Graham Christensen <graham@grahamc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 110/163] random: treat bootloader trust toggle the same way as cpu trust toggle
Date:   Fri, 27 May 2022 10:49:50 +0200
Message-Id: <20220527084843.476706465@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
@@ -4035,6 +4035,12 @@
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
@@ -495,4 +495,5 @@ config RANDOM_TRUST_BOOTLOADER
 	device randomness. Say Y here to assume the entropy provided by the
 	booloader is trustworthy so it will be added to the kernel's entropy
 	pool. Otherwise, say N here so it will be regarded as device input that
-	only mixes the entropy pool.
+	only mixes the entropy pool. This can also be configured at boot with
+	"random.trust_bootloader=on/off".
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -945,11 +945,17 @@ static bool drain_entropy(void *buf, siz
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
@@ -1157,7 +1163,7 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_random
  */
 void add_bootloader_randomness(const void *buf, size_t size)
 {
-	if (IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER))
+	if (trust_bootloader)
 		add_hwgenerator_randomness(buf, size, size * 8);
 	else
 		add_device_randomness(buf, size);


