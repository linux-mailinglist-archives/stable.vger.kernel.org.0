Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFFD558061
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiFWQrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiFWQq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6794049F92;
        Thu, 23 Jun 2022 09:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A38C0B82486;
        Thu, 23 Jun 2022 16:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E4AC3411B;
        Thu, 23 Jun 2022 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002810;
        bh=lvn/PPf44nfUMChZGL8ksDAmVaLVyZF9u/g6Comv+j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caNQrGhpK7NZwjkjeXnudJN4pDTiHYi0BVgbuD++WdYqGEdCIFrxWailXHJg2b6oi
         woTjN/uhwccAIDl9P2i2gFM0Vr+mH0HT+gqyh+gE5+fH1+CqzSCVYIOaUekDS4NDxi
         gJNke2T19C1yJg6wbv6VMDo0ZJuncfbgGx/oA600=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 032/264] random: add a config option to trust the CPUs hwrng
Date:   Thu, 23 Jun 2022 18:40:25 +0200
Message-Id: <20220623164344.977732101@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

commit 39a8883a2b989d1d21bd8dd99f5557f0c5e89694 upstream.

This gives the user building their own kernel (or a Linux
distribution) the option of deciding whether or not to trust the CPU's
hardware random number generator (e.g., RDRAND for x86 CPU's) as being
correctly implemented and not having a back door introduced (perhaps
courtesy of a Nation State's law enforcement or intelligence
agencies).

This will prevent getrandom(2) from blocking, if there is a
willingness to trust the CPU manufacturer.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/Kconfig  |   14 ++++++++++++++
 drivers/char/random.c |   11 ++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -595,3 +595,17 @@ source "drivers/char/xillybus/Kconfig"
 
 endmenu
 
+config RANDOM_TRUST_CPU
+	bool "Trust the CPU manufacturer to initialize Linux's CRNG"
+	depends on X86 || S390 || PPC
+	default n
+	help
+	Assume that CPU manufacturer (e.g., Intel or AMD for RDSEED or
+	RDRAND, IBM for the S390 and Power PC architectures) is trustworthy
+	for the purposes of initializing Linux's CRNG.  Since this is not
+	something that can be independently audited, this amounts to trusting
+	that CPU manufacturer (perhaps with the insistence or mandate
+	of a Nation State's intelligence or law enforcement agencies)
+	has not installed a hidden back door to compromise the CPU's
+	random number generation facilities.
+
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -783,6 +783,7 @@ static void invalidate_batched_entropy(v
 static void crng_initialize(struct crng_state *crng)
 {
 	int		i;
+	int		arch_init = 1;
 	unsigned long	rv;
 
 	memcpy(&crng->state[0], "expand 32-byte k", 16);
@@ -793,10 +794,18 @@ static void crng_initialize(struct crng_
 		_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
 	for (i = 4; i < 16; i++) {
 		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
+		    !arch_get_random_long(&rv)) {
 			rv = random_get_entropy();
+			arch_init = 0;
+		}
 		crng->state[i] ^= rv;
 	}
+#ifdef CONFIG_RANDOM_TRUST_CPU
+	if (arch_init) {
+		crng_init = 2;
+		pr_notice("random: crng done (trusting CPU's manufacturer)\n");
+	}
+#endif
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 


