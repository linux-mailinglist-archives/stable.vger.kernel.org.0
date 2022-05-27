Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4269A53600C
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348013AbiE0LoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiE0LnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:43:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5431339C5;
        Fri, 27 May 2022 04:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC354B824D7;
        Fri, 27 May 2022 11:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C7AC385A9;
        Fri, 27 May 2022 11:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651633;
        bh=f9E5EI7jJkflJj4QutB3zPFBUaC/T63F6pOaKTQ3D9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQmfXXdbD+lGh5Z47M6ITsh5CX7BxVa7FIR0xndHViOoyDC0Oh20tEmG+DiGkf/y/
         QgEyxKj+Xa+g2gmSh7DCdQbrcEFuH2wguVN2Gr1jEgwTHDFq5VdlPmpIc12S2vFJhJ
         bLVJWfy9GiC0Xj4jJXtkEeNnCWsvWNkc+Fet+Ssc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 025/145] random: remove incomplete last_data logic
Date:   Fri, 27 May 2022 10:48:46 +0200
Message-Id: <20220527084853.953801714@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
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

commit a4bfa9b31802c14ff5847123c12b98d5e36b3985 upstream.

There were a few things added under the "if (fips_enabled)" banner,
which never really got completed, and the FIPS people anyway are
choosing a different direction. Rather than keep around this halfbaked
code, get rid of it so that we can focus on a single design of the RNG
rather than two designs.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   39 ++++-----------------------------------
 1 file changed, 4 insertions(+), 35 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -337,7 +337,6 @@
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
 #include <linux/percpu.h>
-#include <linux/fips.h>
 #include <linux/ptrace.h>
 #include <linux/workqueue.h>
 #include <linux/irq.h>
@@ -517,14 +516,12 @@ struct entropy_store {
 	u16 add_ptr;
 	u16 input_rotate;
 	int entropy_count;
-	unsigned int last_data_init:1;
-	u8 last_data[EXTRACT_SIZE];
 };
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int rsvd);
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
-				size_t nbytes, int fips);
+				size_t nbytes);
 
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
 static u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
@@ -821,7 +818,7 @@ static void crng_initialize_secondary(st
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	_extract_entropy(&input_pool, &crng->state[4], sizeof(u32) * 12, 0);
+	_extract_entropy(&input_pool, &crng->state[4], sizeof(u32) * 12);
 	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
@@ -1426,22 +1423,13 @@ static void extract_buf(struct entropy_s
 }
 
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
-				size_t nbytes, int fips)
+				size_t nbytes)
 {
 	ssize_t ret = 0, i;
 	u8 tmp[EXTRACT_SIZE];
-	unsigned long flags;
 
 	while (nbytes) {
 		extract_buf(r, tmp);
-
-		if (fips) {
-			spin_lock_irqsave(&r->lock, flags);
-			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
-				panic("Hardware RNG duplicated output!\n");
-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
-			spin_unlock_irqrestore(&r->lock, flags);
-		}
 		i = min_t(int, nbytes, EXTRACT_SIZE);
 		memcpy(buf, tmp, i);
 		nbytes -= i;
@@ -1467,28 +1455,9 @@ static ssize_t _extract_entropy(struct e
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 				 size_t nbytes, int min, int reserved)
 {
-	u8 tmp[EXTRACT_SIZE];
-	unsigned long flags;
-
-	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
-	if (fips_enabled) {
-		spin_lock_irqsave(&r->lock, flags);
-		if (!r->last_data_init) {
-			r->last_data_init = 1;
-			spin_unlock_irqrestore(&r->lock, flags);
-			trace_extract_entropy(r->name, EXTRACT_SIZE,
-					      ENTROPY_BITS(r), _RET_IP_);
-			extract_buf(r, tmp);
-			spin_lock_irqsave(&r->lock, flags);
-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
-		}
-		spin_unlock_irqrestore(&r->lock, flags);
-	}
-
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	nbytes = account(r, nbytes, min, reserved);
-
-	return _extract_entropy(r, buf, nbytes, fips_enabled);
+	return _extract_entropy(r, buf, nbytes);
 }
 
 #define warn_unseeded_randomness(previous) \


