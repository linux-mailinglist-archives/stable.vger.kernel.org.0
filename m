Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40355580E3
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiFWQyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbiFWQvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063E24B42F;
        Thu, 23 Jun 2022 09:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8827461FC3;
        Thu, 23 Jun 2022 16:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6792FC3411B;
        Thu, 23 Jun 2022 16:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002939;
        bh=x4A2+oNxm/tBREbzWPgS26fuDSRD1nOucw18xy2kmpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNE4duzvuvuLKLz/osiqGzqAFPfmrCa2q6BPhiEao/jslDFxF4mCLJsO74OQO0tA+
         TLdDzIM5ZsHVmM4oGfqhksczVf/wZuF1A2ebzXrqMf+B6Ktp+hcz2wsFW/6uXQCoTh
         2IEVwRhIjaxSRw6zIXry1jR3FsSAett3T/NuDr/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 075/264] random: add arch_get_random_*long_early()
Date:   Thu, 23 Jun 2022 18:41:08 +0200
Message-Id: <20220623164346.192817801@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit 253d3194c2b58152fe830fd27c2fd83ebc6fe5ee upstream.

Some architectures (e.g. arm64) can have heterogeneous CPUs, and the
boot CPU may be able to provide entropy while secondary CPUs cannot. On
such systems, arch_get_random_long() and arch_get_random_seed_long()
will fail unless support for RNG instructions has been detected on all
CPUs. This prevents the boot CPU from being able to provide
(potentially) trusted entropy when seeding the primary CRNG.

To make it possible to seed the primary CRNG from the boot CPU without
adversely affecting the runtime versions of arch_get_random_long() and
arch_get_random_seed_long(), this patch adds new early versions of the
functions used when initializing the primary CRNG.

Default implementations are provided atop of the existing
arch_get_random_long() and arch_get_random_seed_long() so that only
architectures with such constraints need to provide the new helpers.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20200210130015.17664-3-mark.rutland@arm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |   20 +++++++++++++++++++-
 include/linux/random.h |   22 ++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -801,6 +801,24 @@ static bool crng_init_try_arch(struct cr
 	return arch_init;
 }
 
+static bool __init crng_init_try_arch_early(struct crng_state *crng)
+{
+	int		i;
+	bool		arch_init = true;
+	unsigned long	rv;
+
+	for (i = 4; i < 16; i++) {
+		if (!arch_get_random_seed_long_early(&rv) &&
+		    !arch_get_random_long_early(&rv)) {
+			rv = random_get_entropy();
+			arch_init = false;
+		}
+		crng->state[i] ^= rv;
+	}
+
+	return arch_init;
+}
+
 static void __maybe_unused crng_initialize_secondary(struct crng_state *crng)
 {
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
@@ -813,7 +831,7 @@ static void __init crng_initialize_prima
 {
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
 	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
-	if (crng_init_try_arch(crng) && trust_cpu) {
+	if (crng_init_try_arch_early(crng) && trust_cpu) {
 		invalidate_batched_entropy();
 		numa_crng_init();
 		crng_init = 2;
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -6,6 +6,8 @@
 #ifndef _LINUX_RANDOM_H
 #define _LINUX_RANDOM_H
 
+#include <linux/bug.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/once.h>
 
@@ -114,4 +116,24 @@ static inline bool __must_check arch_get
 }
 #endif
 
+/*
+ * Called from the boot CPU during startup; not valid to call once
+ * secondary CPUs are up and preemption is possible.
+ */
+#ifndef arch_get_random_seed_long_early
+static inline bool __init arch_get_random_seed_long_early(unsigned long *v)
+{
+	WARN_ON(system_state != SYSTEM_BOOTING);
+	return arch_get_random_seed_long(v);
+}
+#endif
+
+#ifndef arch_get_random_long_early
+static inline bool __init arch_get_random_long_early(unsigned long *v)
+{
+	WARN_ON(system_state != SYSTEM_BOOTING);
+	return arch_get_random_long(v);
+}
+#endif
+
 #endif /* _LINUX_RANDOM_H */


