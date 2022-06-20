Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B10E551D52
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242185AbiFTNud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348819AbiFTNrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:47:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEAE2E9D4;
        Mon, 20 Jun 2022 06:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD2EB811D5;
        Mon, 20 Jun 2022 13:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28560C3411B;
        Mon, 20 Jun 2022 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731026;
        bh=9peonJ0+z8RcmYnm5XSbbaEivH1c0xcB7jk9cS6OWwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOjxuyTrzFMrBNqLa01sh+4St984YHKF+ff+gZ9ND7wz+Qfua6G6k5xrUIyxi/W3H
         yv2Gk1zfYSixMJegsBdHWk9tNQYdB7p1RIK4ypjg3ueBet+uNbMUehHvYP20EX9nVi
         IDpPnrxz+fWpdUxS0n+cXQLl39wqOFfZtu+UNxbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Stafford Horne <shorne@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 130/240] init: call time_init() before rand_initialize()
Date:   Mon, 20 Jun 2022 14:50:31 +0200
Message-Id: <20220620124742.778536366@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
@@ -680,11 +680,13 @@ asmlinkage __visible void __init start_k
 	hrtimers_init();
 	softirq_init();
 	timekeeping_init();
+	time_init();
 
 	/*
 	 * For best initial stack canary entropy, prepare it after:
 	 * - setup_arch() for any UEFI RNG entropy and boot cmdline access
 	 * - timekeeping_init() for ktime entropy used in rand_initialize()
+	 * - time_init() for making random_get_entropy() work on some platforms
 	 * - rand_initialize() to get any arch-specific entropy like RDRAND
 	 * - add_latent_entropy() to get any latent entropy
 	 * - adding command line entropy
@@ -694,7 +696,6 @@ asmlinkage __visible void __init start_k
 	add_device_randomness(command_line, strlen(command_line));
 	boot_init_stack_canary();
 
-	time_init();
 	perf_event_init();
 	profile_init();
 	call_function_init();


