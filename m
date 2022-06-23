Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13117558081
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiFWQrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiFWQrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7C649B4B;
        Thu, 23 Jun 2022 09:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA08961F4A;
        Thu, 23 Jun 2022 16:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79F9C3411B;
        Thu, 23 Jun 2022 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002819;
        bh=tnmv7JW4ZNhDwG1oVMSeHSRXkCpbPWpz06JUHKDBzTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XulMMaDeUTzkn93lZbdGSW5IGvqSMNXLNClSX71i0+TyvJupr1LXNSP9EypE746UJ
         dIxbZsf/xbyDS2r37l53uUKILeYtH9ikBZDCX7lUHS7SZN5D6ojS1APpGmLFKywhPp
         CBE/XsajVtCYTfNi1fF28/N5ezwKKMw7MEuatL4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 035/264] random: make CPU trust a boot parameter
Date:   Thu, 23 Jun 2022 18:40:28 +0200
Message-Id: <20220623164345.062513423@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit 9b25436662d5fb4c66eb527ead53cab15f596ee0 upstream.

Instead of forcing a distro or other system builder to choose
at build time whether the CPU is trusted for CRNG seeding via
CONFIG_RANDOM_TRUST_CPU, provide a boot-time parameter for end users to
control the choice. The CONFIG will set the default state instead.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/char/Kconfig                |    4 ++--
 drivers/char/random.c               |   11 ++++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3577,6 +3577,12 @@ bytes respectively. Such letter suffixes
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/blockdev/ramdisk.txt.
 
+	random.trust_cpu={on,off}
+			[KNL] Enable or disable trusting the use of the
+			CPU's random number generator (if available) to
+			fully seed the kernel's CRNG. Default is controlled
+			by CONFIG_RANDOM_TRUST_CPU.
+
 	rcu_nocbs=	[KNL]
 			The argument is a cpu list, as described above.
 
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -607,5 +607,5 @@ config RANDOM_TRUST_CPU
 	that CPU manufacturer (perhaps with the insistence or mandate
 	of a Nation State's intelligence or law enforcement agencies)
 	has not installed a hidden back door to compromise the CPU's
-	random number generation facilities.
-
+	random number generation facilities. This can also be configured
+	at boot with "random.trust_cpu=on/off".
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -780,6 +780,13 @@ static struct crng_state **crng_node_poo
 
 static void invalidate_batched_entropy(void);
 
+static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
+static int __init parse_trust_cpu(char *arg)
+{
+	return kstrtobool(arg, &trust_cpu);
+}
+early_param("random.trust_cpu", parse_trust_cpu);
+
 static void crng_initialize(struct crng_state *crng)
 {
 	int		i;
@@ -800,12 +807,10 @@ static void crng_initialize(struct crng_
 		}
 		crng->state[i] ^= rv;
 	}
-#ifdef CONFIG_RANDOM_TRUST_CPU
-	if (arch_init) {
+	if (trust_cpu && arch_init) {
 		crng_init = 2;
 		pr_notice("random: crng done (trusting CPU's manufacturer)\n");
 	}
-#endif
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 


