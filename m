Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA68055809D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiFWQwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbiFWQvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DC61055C;
        Thu, 23 Jun 2022 09:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6832E61FC0;
        Thu, 23 Jun 2022 16:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FCFC3411B;
        Thu, 23 Jun 2022 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003034;
        bh=VoZb6ocodR9xc0HGJJSvadS65FuRNEOoYsgSzq20xjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6ibYb7zwaKfmNfSMj5F43C3eNSGBCR0TP7/+9rS9Jl7HGrWgN4GvJ8JZh/NBDa78
         wFZG9dSlTV1lPt8Ti1RsXHlETPmS4/8EW5R8z2rUvgwgoMBAU8mUDNALH1eVLhyT6d
         aAgRXXrFfN+azy2HGtYGN6WYTk26eshguImXWqJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 108/264] random: access primary_pool directly rather than through pointer
Date:   Thu, 23 Jun 2022 18:41:41 +0200
Message-Id: <20220623164347.124942403@linuxfoundation.org>
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
@@ -1749,7 +1749,7 @@ int __init rand_initialize(void)
 	init_std_data();
 	if (crng_need_final_init)
 		crng_finalize_init(&primary_crng);
-	crng_initialize_primary(&primary_crng);
+	crng_initialize_primary();
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {
 		urandom_warning.interval = 0;


