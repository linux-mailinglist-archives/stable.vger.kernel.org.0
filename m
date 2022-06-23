Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4383C5585B9
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbiFWSDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbiFWSBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:01:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AF9B3D09;
        Thu, 23 Jun 2022 10:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C5CC61DE5;
        Thu, 23 Jun 2022 17:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D27CC3411B;
        Thu, 23 Jun 2022 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004599;
        bh=hW+pvIhJEdfDOOcLSl+foKY7+VtKrgElChyroSgU2B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TR7YsUOIq0l+eekXC0JFGbCAbYR+xg86i7PI95wdyHzpmOSplSzOd4GtEA80r8qxI
         ZhmOIgGu4Ka24Ytky1vSjliyxtF2CVlZqgfILqBnNOAuNsdtVZkKhUbH51zdQ04gXd
         VcUG3RCqEjZwmFNYxjB8/acGnyUlQ07BJuYmUqcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 090/234] random: zero buffer after reading entropy from userspace
Date:   Thu, 23 Jun 2022 18:42:37 +0200
Message-Id: <20220623164345.605513587@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit 7b5164fb1279bf0251371848e40bae646b59b3a8 upstream.

This buffer may contain entropic data that shouldn't stick around longer
than needed, so zero out the temporary buffer at the end of write_pool().

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -500,6 +500,7 @@ static void crng_reseed(void)
 	int entropy_count;
 	unsigned long next_gen;
 	u8 key[CHACHA20_KEY_SIZE];
+	bool finalize_init = false;
 
 	/*
 	 * First we make sure we have POOL_MIN_BITS of entropy in the pool,
@@ -527,12 +528,14 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	spin_unlock_irqrestore(&base_crng.lock, flags);
-	memzero_explicit(key, sizeof(key));
-
 	if (crng_init < 2) {
 		invalidate_batched_entropy();
 		crng_init = 2;
+		finalize_init = true;
+	}
+	spin_unlock_irqrestore(&base_crng.lock, flags);
+	memzero_explicit(key, sizeof(key));
+	if (finalize_init) {
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
@@ -1334,19 +1337,24 @@ static __poll_t random_poll(struct file
 static int write_pool(const char __user *ubuf, size_t count)
 {
 	size_t len;
+	int ret = 0;
 	u8 block[BLAKE2S_BLOCK_SIZE];
 
 	while (count) {
 		len = min(count, sizeof(block));
-		if (copy_from_user(block, ubuf, len))
-			return -EFAULT;
+		if (copy_from_user(block, ubuf, len)) {
+			ret = -EFAULT;
+			goto out;
+		}
 		count -= len;
 		ubuf += len;
 		mix_pool_bytes(block, len);
 		cond_resched();
 	}
 
-	return 0;
+out:
+	memzero_explicit(block, sizeof(block));
+	return ret;
 }
 
 static ssize_t random_write(struct file *file, const char __user *buffer,


