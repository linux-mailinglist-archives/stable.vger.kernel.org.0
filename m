Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F50C6A0963
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbjBWNF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbjBWNF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:05:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9ED521CF
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 247B6616EB
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6D2C4339C;
        Thu, 23 Feb 2023 13:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157522;
        bh=60ZF3qwHgY5n8GYM8lY2Wr1z1mMvQ8sc5JEY6YBajKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6neec+RCJetdqLi1JRqjVshk7lkP40wH3YrfNOcZnz7FpPK+dkERnJtruMb6J2tN
         FekfeAkCPWSknFvW5XdRqGzrScWxEITons9sXs85xESHFe5GItFMoyNJq5QGjYE8Ye
         AoG3WrvkVvqig7wMZGMIb1ai1caDCJ83jVZR52Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        PaX Team <pageexec@freemail.hu>,
        Emese Revfy <re.emese@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/11] random: always mix cycle counter in add_latent_entropy()
Date:   Thu, 23 Feb 2023 14:04:44 +0100
Message-Id: <20230223130424.200339232@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130424.079732181@linuxfoundation.org>
References: <20230223130424.079732181@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit d7bf7f3b813e3755226bcb5114ad2ac477514ebf ]

add_latent_entropy() is called every time a process forks, in
kernel_clone(). This in turn calls add_device_randomness() using the
latent entropy global state. add_device_randomness() does two things:

   2) Mixes into the input pool the latent entropy argument passed; and
   1) Mixes in a cycle counter, a sort of measurement of when the event
      took place, the high precision bits of which are presumably
      difficult to predict.

(2) is impossible without CONFIG_GCC_PLUGIN_LATENT_ENTROPY=y. But (1) is
always possible. However, currently CONFIG_GCC_PLUGIN_LATENT_ENTROPY=n
disables both (1) and (2), instead of just (2).

This commit causes the CONFIG_GCC_PLUGIN_LATENT_ENTROPY=n case to still
do (1) by passing NULL (len 0) to add_device_randomness() when add_latent_
entropy() is called.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Emese Revfy <re.emese@gmail.com>
Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/random.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index 3feafab498ad9..ed75fb2b0ca94 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -19,14 +19,14 @@ void add_input_randomness(unsigned int type, unsigned int code,
 void add_interrupt_randomness(int irq) __latent_entropy;
 void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
-#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
 {
+#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
-}
 #else
-static inline void add_latent_entropy(void) { }
+	add_device_randomness(NULL, 0);
 #endif
+}
 
 void get_random_bytes(void *buf, size_t len);
 size_t __must_check get_random_bytes_arch(void *buf, size_t len);
-- 
2.39.0



