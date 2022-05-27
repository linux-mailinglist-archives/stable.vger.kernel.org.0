Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704AD53600D
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351834AbiE0Lq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352319AbiE0Lpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:45:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F08D146761;
        Fri, 27 May 2022 04:42:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C37C5B824D6;
        Fri, 27 May 2022 11:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27047C34113;
        Fri, 27 May 2022 11:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651743;
        bh=05oCL9/vwRD2ONushJmIq7RlXP0+bm7pgIUFoypvMaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PH/rL6yoPKopCyRnwWC6a1rrLZQjlcbzM4y6ggnh2GGvTDe6MzYS6TlmeGrM9d4Ka
         fnvkepUJIoJ5aUlaRarWzEIic6NvJMp7MjQR1Wz3Afi9sa7nA13OeXFaIlyNRvL3Ox
         CCyqCn2rEVUoYF9EN/Dc1LDDIkVJ5vjrSNc6qYHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 054/163] random: access primary_pool directly rather than through pointer
Date:   Fri, 27 May 2022 10:48:54 +0200
Message-Id: <20220527084835.550251190@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit ebf7606388732ecf2821ca21087e9446cb4a5b57 upstream.

Both crng_initialize_primary() and crng_init_try_arch_early() are
only called for the primary_pool. Accessing it directly instead of
through a function parameter simplifies the code.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -762,7 +762,7 @@ static bool crng_init_try_arch(struct cr
 	return arch_init;
 }
 
-static bool __init crng_init_try_arch_early(struct crng_state *crng)
+static bool __init crng_init_try_arch_early(void)
 {
 	int i;
 	bool arch_init = true;
@@ -774,7 +774,7 @@ static bool __init crng_init_try_arch_ea
 			rv = random_get_entropy();
 			arch_init = false;
 		}
-		crng->state[i] ^= rv;
+		primary_crng.state[i] ^= rv;
 	}
 
 	return arch_init;
@@ -788,16 +788,16 @@ static void crng_initialize_secondary(st
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
-static void __init crng_initialize_primary(struct crng_state *crng)
+static void __init crng_initialize_primary(void)
 {
-	_extract_entropy(&crng->state[4], sizeof(u32) * 12);
-	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
+	_extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
+	if (crng_init_try_arch_early() && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
 		crng_init = 2;
 		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
-	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
+	primary_crng.init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
 static void crng_finalize_init(struct crng_state *crng)
@@ -1698,7 +1698,7 @@ int __init rand_initialize(void)
 	init_std_data();
 	if (crng_need_final_init)
 		crng_finalize_init(&primary_crng);
-	crng_initialize_primary(&primary_crng);
+	crng_initialize_primary();
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {
 		urandom_warning.interval = 0;


