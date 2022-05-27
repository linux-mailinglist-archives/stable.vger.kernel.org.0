Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC91535C05
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 10:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350049AbiE0IwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350096AbiE0IwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:52:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10495A168;
        Fri, 27 May 2022 01:51:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A6A7B823D9;
        Fri, 27 May 2022 08:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9EBC385A9;
        Fri, 27 May 2022 08:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641509;
        bh=IrtVp04WXrGF+u/Jx0GCro9bCp6PLkr34Fu9nMRutX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDRgCiaI2zm+Vc8dptGLGjOIm7uxO2F2Ih0KfgmRKHRjLckAgXO9TpK43alsZJD8b
         1SAF4wJor9F2vgqpccUCXb2RhnI2QsuvXA/SU5qMUVZIt1gnDJq9eOzaJ13xHNXTRU
         RyfIDpNohWzo+QHwvsrNtU2MmvWY+ZS3WqR09M7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Stafford Horne <shorne@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 04/47] init: call time_init() before rand_initialize()
Date:   Fri, 27 May 2022 10:49:44 +0200
Message-Id: <20220527084801.829543626@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit fe222a6ca2d53c38433cba5d3be62a39099e708e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/init/main.c
+++ b/init/main.c
@@ -1035,11 +1035,13 @@ asmlinkage __visible void __init __no_sa
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
@@ -1049,7 +1051,6 @@ asmlinkage __visible void __init __no_sa
 	add_device_randomness(command_line, strlen(command_line));
 	boot_init_stack_canary();
 
-	time_init();
 	perf_event_init();
 	profile_init();
 	call_function_init();


