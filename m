Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993855582FB
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiFWRXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiFWRWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:22:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C364FB6204;
        Thu, 23 Jun 2022 10:01:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB059B82490;
        Thu, 23 Jun 2022 17:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD59C3411B;
        Thu, 23 Jun 2022 17:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003676;
        bh=NVduRPoc9LXw1ID7ASguvYUJ3GvEQijehoDrH1Fl0hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQ/J4Km4Qgtm2J9thpWGF0SGOg5ZSOsBnBbayKnKmoalH5dKjlKQU4AGjbulif6iM
         qVJSOTqxUihWhbVXhaLFrYIRxU95JOD3PmC1DFezccQfOHtdojqbcHa3+FrG/sIKho
         kLuknzsMuF784m4OGWmebyiNRnorRfhkaYR59rYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 010/237] random: Make crng state queryable
Date:   Thu, 23 Jun 2022 18:40:44 +0200
Message-Id: <20220623164343.446209230@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

commit 9a47249d444d344051c7c0e909fad0e88515a5c2 upstream.

It is very useful to be able to know whether or not get_random_bytes_wait
/ wait_for_random_bytes is going to block or not, or whether plain
get_random_bytes is going to return good randomness or bad randomness.

The particular use case is for mitigating certain attacks in WireGuard.
A handshake packet arrives and is queued up. Elsewhere a worker thread
takes items from the queue and processes them. In replying to these
items, it needs to use some random data, and it has to be good random
data. If we simply block until we can have good randomness, then it's
possible for an attacker to fill the queue up with packets waiting to be
processed. Upon realizing the queue is full, WireGuard will detect that
it's under a denial of service attack, and behave accordingly. A better
approach is just to drop incoming handshake packets if the crng is not
yet initialized.

This patch, therefore, makes that information directly accessible.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |   15 +++++++++++++++
 include/linux/random.h |    1 +
 2 files changed, 16 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1669,6 +1669,21 @@ int wait_for_random_bytes(void)
 EXPORT_SYMBOL(wait_for_random_bytes);
 
 /*
+ * Returns whether or not the urandom pool has been seeded and thus guaranteed
+ * to supply cryptographically secure random numbers. This applies to: the
+ * /dev/urandom device, the get_random_bytes function, and the get_random_{u32,
+ * ,u64,int,long} family of functions.
+ *
+ * Returns: true if the urandom pool has been seeded.
+ *          false if the urandom pool has not been seeded.
+ */
+bool rng_is_initialized(void)
+{
+	return crng_ready();
+}
+EXPORT_SYMBOL(rng_is_initialized);
+
+/*
  * Add a callback function that will be invoked when the nonblocking
  * pool is initialised.
  *
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -36,6 +36,7 @@ extern void add_interrupt_randomness(int
 
 extern void get_random_bytes(void *buf, int nbytes);
 extern int wait_for_random_bytes(void);
+extern bool rng_is_initialized(void);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
 extern int __must_check get_random_bytes_arch(void *buf, int nbytes);


