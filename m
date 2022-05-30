Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E07538134
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiE3OO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240587AbiE3OMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:12:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE35E52AE;
        Mon, 30 May 2022 06:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD4E560F47;
        Mon, 30 May 2022 13:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76CBC385B8;
        Mon, 30 May 2022 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918166;
        bh=w5dg/U5vb/hD2+0q3mHAmMkfKnRvK4Av+DJhCi5973c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKzxA7ZVQhX1OAQdA2jzgqPD7FSX3ZiaO4oNGrH2V66mUdTClPn0JnG/yYwJtUQ0A
         PtGYX6/h//OoMNHAtXAjlj81mceR4lNrvee2NjM5GL7yUpc96MAzphv5Iv7Zbde4C4
         3xZrGlE65lU2QR25QsFFfbZR2s33s2AftB29s0yvVBrzR2jmjqQx03OkVhK6iKhaib
         A+323eiLdx9O2fDwlAuiHM4SdpQ2IcH8vj/e1sOK5IZl9EkYX+1okoKg0ILps/0IwR
         3cxr+Mc3iwIhLAKWrXZF0M9/legZuIfSrPlN9A6O0v5ZuWIVdKTAT2i17ZbBBc7gLh
         DojGTa+fYngAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>, rostedt@goodmis.org,
        mhiramat@kernel.org, vbabka@suse.cz, ahalaney@redhat.com,
        mark-pk.tsai@mediatek.com, peterz@infradead.org
Subject: [PATCH AUTOSEL 5.15 083/109] init: call time_init() before rand_initialize()
Date:   Mon, 30 May 2022 09:37:59 -0400
Message-Id: <20220530133825.1933431-83-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit fe222a6ca2d53c38433cba5d3be62a39099e708e ]

Currently time_init() is called after rand_initialize(), but
rand_initialize() makes use of the timer on various platforms, and
sometimes this timer needs to be initialized by time_init() first. In
order for random_get_entropy() to not return zero during early boot when
it's potentially used as an entropy source, reverse the order of these
two calls. The block doing random initialization was right before
time_init() before, so changing the order shouldn't have any complicated
effects.

Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 06b98350ebd2..2b9ba7ea42ec 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1041,11 +1041,13 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	kfence_init();
+	time_init();
 
 	/*
 	 * For best initial stack canary entropy, prepare it after:
 	 * - setup_arch() for any UEFI RNG entropy and boot cmdline access
 	 * - timekeeping_init() for ktime entropy used in rand_initialize()
+	 * - time_init() for making random_get_entropy() work on some platforms
 	 * - rand_initialize() to get any arch-specific entropy like RDRAND
 	 * - add_latent_entropy() to get any latent entropy
 	 * - adding command line entropy
@@ -1055,7 +1057,6 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	add_device_randomness(command_line, strlen(command_line));
 	boot_init_stack_canary();
 
-	time_init();
 	perf_event_init();
 	profile_init();
 	call_function_init();
-- 
2.35.1

