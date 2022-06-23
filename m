Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E513C5582FC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiFWRXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbiFWRWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D33AB620F;
        Thu, 23 Jun 2022 10:01:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4712C61573;
        Thu, 23 Jun 2022 17:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4DCC3411B;
        Thu, 23 Jun 2022 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003679;
        bh=MqY2zppr9N1x5Ik2eekxRzvKnzXsm5vnnjmfSLbrANk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4Sn4OgnfwlhAdkasKTV+otYocdg+FeE/arr9DXwsXr2K18Ikye4wy65IhzTYSLDL
         YCfLATlw936veopqJhOY9DQA6vREVYFhqeX9/pBhcxTKxtOQXVHJJR89jNyjozC/T+
         s8ZFyTqaSplZG21q33tPmb5RJdoq9gaENe61yqy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 011/237] random: make CPU trust a boot parameter
Date:   Thu, 23 Jun 2022 18:40:45 +0200
Message-Id: <20220623164343.475260325@linuxfoundation.org>
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
 Documentation/admin-guide/kernel-parameters.txt |    6 ++++++
 drivers/char/Kconfig                            |    4 ++--
 drivers/char/random.c                           |   11 ++++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3526,6 +3526,12 @@
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/blockdev/ramdisk.txt.
 
+	random.trust_cpu={on,off}
+			[KNL] Enable or disable trusting the use of the
+			CPU's random number generator (if available) to
+			fully seed the kernel's CRNG. Default is controlled
+			by CONFIG_RANDOM_TRUST_CPU.
+
 	ras=option[,option,...]	[KNL] RAS-specific options
 
 		cec_disable	[X86]
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -602,5 +602,5 @@ config RANDOM_TRUST_CPU
 	that CPU manufacturer (perhaps with the insistence or mandate
 	of a Nation State's intelligence or law enforcement agencies)
 	has not installed a hidden back door to compromise the CPU's
-	random number generation facilities.
-
+	random number generation facilities. This can also be configured
+	at boot with "random.trust_cpu=on/off".
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -779,6 +779,13 @@ static struct crng_state **crng_node_poo
 
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
@@ -799,12 +806,10 @@ static void crng_initialize(struct crng_
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
 


