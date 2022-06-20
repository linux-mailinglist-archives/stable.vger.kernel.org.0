Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C392551C52
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344697AbiFTN3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345239AbiFTN0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:26:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D711C90C;
        Mon, 20 Jun 2022 06:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A59A260C95;
        Mon, 20 Jun 2022 13:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6667DC3411C;
        Mon, 20 Jun 2022 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730658;
        bh=X7zB1pE8Sst2u4rO6adk2JOEApJkqM0WbyDU/PwXG3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veMfzVbjIEIaEb4KO1Fc6qrV/SAYpQ2Klk+pMuZk5nP7k1JtUsLP8VzorsUU9gyg5
         pZDqct7Y5YvLbpp4IjJHU/T8SQvHU6PBKknN8RiGIhMJj4OjxJFB4tCfecKou4BQBj
         8uHhiymYMfUYUtRGwVByjqJXiW93P9z3pK+E5oks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 016/240] random: remove kernel.random.read_wakeup_threshold
Date:   Mon, 20 Jun 2022 14:48:37 +0200
Message-Id: <20220620124738.281381269@linuxfoundation.org>
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

From: Andy Lutomirski <luto@kernel.org>

commit c95ea0c69ffda19381c116db2be23c7e654dac98 upstream.

It has no effect any more, so remove it.  We can revert this if
there is some user code that expects to be able to set this sysctl.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/a74ed2cf0b5a5451428a246a9239f5bc4e29358f.1577088521.git.luto@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -370,12 +370,6 @@
 #define ENTROPY_BITS(r) ((r)->entropy_count >> ENTROPY_SHIFT)
 
 /*
- * The minimum number of bits of entropy before we wake up a read on
- * /dev/random.  Should be enough to do a significant reseed.
- */
-static int random_read_wakeup_bits = 64;
-
-/*
  * If the entropy count falls under this number of bits, then we
  * should wake up processes which are selecting or polling on write
  * access to /dev/random.
@@ -2076,8 +2070,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 
 #include <linux/sysctl.h>
 
-static int min_read_thresh = 8, min_write_thresh;
-static int max_read_thresh = OUTPUT_POOL_WORDS * 32;
+static int min_write_thresh;
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static int random_min_urandom_seed = 60;
 static char sysctl_bootid[16];
@@ -2153,15 +2146,6 @@ struct ctl_table random_table[] = {
 		.data		= &input_pool.entropy_count,
 	},
 	{
-		.procname	= "read_wakeup_threshold",
-		.data		= &random_read_wakeup_bits,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_read_thresh,
-		.extra2		= &max_read_thresh,
-	},
-	{
 		.procname	= "write_wakeup_threshold",
 		.data		= &random_write_wakeup_bits,
 		.maxlen		= sizeof(int),


