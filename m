Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E325582E1
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbiFWRVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiFWRVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:21:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3914482886;
        Thu, 23 Jun 2022 10:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA80E6159A;
        Thu, 23 Jun 2022 17:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1511C3411B;
        Thu, 23 Jun 2022 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003639;
        bh=y1xaNaLdb+skoiE1Gt9hFZoRF9x6bVFGrS2X8ZpqWYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0UIZUdKOfnUf845kFYy4zxMAuBLrrYtnh0mf2VpmHINq0Ii3qdDf+OUX1BbQKakr
         uy3V0HnJLOK/73sVpNWfWVK3cYHPgsiJe5RMJNbA4niCrSc3y9fMrXWpLkyK5I9UcJ
         g/4tfjLU1qa+XVwX6ae3H1+5voxAh+0gg1rrzol0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 038/237] random: remove kernel.random.read_wakeup_threshold
Date:   Thu, 23 Jun 2022 18:41:12 +0200
Message-Id: <20220623164344.251557357@linuxfoundation.org>
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
@@ -2010,8 +2004,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 
 #include <linux/sysctl.h>
 
-static int min_read_thresh = 8, min_write_thresh;
-static int max_read_thresh = OUTPUT_POOL_WORDS * 32;
+static int min_write_thresh;
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static int random_min_urandom_seed = 60;
 static char sysctl_bootid[16];
@@ -2087,15 +2080,6 @@ struct ctl_table random_table[] = {
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


