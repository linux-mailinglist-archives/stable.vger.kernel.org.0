Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241FB558031
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiFWQp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiFWQp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:45:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5560748E44;
        Thu, 23 Jun 2022 09:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E055C61F91;
        Thu, 23 Jun 2022 16:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D6BC3411B;
        Thu, 23 Jun 2022 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002754;
        bh=yQX9uP7Qi3xmNcgIDslJRU/lmTA01+Fbl3y0OPRwIJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTF91/B6anuKOUi0t7lVdw1UYhjzCOOGNyxUiYt6yXsaqfcEaTlIO/1pmNyNXdYhl
         rZlKpV+Xdv1MUggz3Qq3sJutIBteNpd0tEMSx8GU7rP/VC0YndxzhrPmdK1dnY8R+b
         D3KXJgC4keGUh92XzYclmkeUvOKnyJpu4MMOCqoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 015/264] random: reorder READ_ONCE() in get_random_uXX
Date:   Thu, 23 Jun 2022 18:40:08 +0200
Message-Id: <20220623164344.496193971@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 72e5c740f6335e27253b8ff64d23d00337091535 upstream.

Avoid the READ_ONCE in commit 4a072c71f49b ("random: silence compiler
warnings and fix race") if we can leave the function after
arch_get_random_XXX().

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2161,7 +2161,7 @@ static DEFINE_PER_CPU(struct batched_ent
 u64 get_random_u64(void)
 {
 	u64 ret;
-	bool use_lock = READ_ONCE(crng_init) < 2;
+	bool use_lock;
 	unsigned long flags = 0;
 	struct batched_entropy *batch;
 	static void *previous;
@@ -2177,6 +2177,7 @@ u64 get_random_u64(void)
 
 	warn_unseeded_randomness(&previous);
 
+	use_lock = READ_ONCE(crng_init) < 2;
 	batch = &get_cpu_var(batched_entropy_u64);
 	if (use_lock)
 		read_lock_irqsave(&batched_entropy_reset_lock, flags);
@@ -2196,7 +2197,7 @@ static DEFINE_PER_CPU(struct batched_ent
 u32 get_random_u32(void)
 {
 	u32 ret;
-	bool use_lock = READ_ONCE(crng_init) < 2;
+	bool use_lock;
 	unsigned long flags = 0;
 	struct batched_entropy *batch;
 	static void *previous;
@@ -2206,6 +2207,7 @@ u32 get_random_u32(void)
 
 	warn_unseeded_randomness(&previous);
 
+	use_lock = READ_ONCE(crng_init) < 2;
 	batch = &get_cpu_var(batched_entropy_u32);
 	if (use_lock)
 		read_lock_irqsave(&batched_entropy_reset_lock, flags);


