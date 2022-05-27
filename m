Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAC053601D
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiE0Lqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbiE0LoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:44:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE93514D16;
        Fri, 27 May 2022 04:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B62C61D22;
        Fri, 27 May 2022 11:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283B9C385A9;
        Fri, 27 May 2022 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651672;
        bh=EPU17ywD4YYi95dXlLRsZHFwvqTuyb00v/jR+ACZSjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1pid/CX6ua9A9d4dZWUwth+g5Mtks3KBu75BAmowBXaeqMNz7UaF1jLVPqbaA3s7
         acpO6BcqCTahCImpu0cpK0A1qM8Z6nCYfxucXtF7JUrLPHL79QYXMlRnmGA3iADK6d
         AKqZoqaWeymRNgHE3/1pX5wtvoO24z0TQ4uNQd5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 029/145] random: de-duplicate INPUT_POOL constants
Date:   Fri, 27 May 2022 10:48:50 +0200
Message-Id: <20220527084854.353480692@linuxfoundation.org>
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

commit 5b87adf30f1464477169a1d653e9baf8c012bbfe upstream.

We already had the POOL_* constants, so deduplicate the older INPUT_POOL
ones. As well, fold EXTRACT_SIZE into the poolinfo enum, since it's
related.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -359,13 +359,6 @@
 /* #define ADD_INTERRUPT_BENCH */
 
 /*
- * Configuration information
- */
-#define INPUT_POOL_SHIFT	12
-#define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
-#define EXTRACT_SIZE		(BLAKE2S_HASH_SIZE / 2)
-
-/*
  * To allow fractional bits to be tracked, the entropy_count field is
  * denominated in units of 1/8th bits.
  *
@@ -440,7 +433,9 @@ enum poolinfo {
 	POOL_TAP2 = 76,
 	POOL_TAP3 = 51,
 	POOL_TAP4 = 25,
-	POOL_TAP5 = 1
+	POOL_TAP5 = 1,
+
+	EXTRACT_SIZE = BLAKE2S_HASH_SIZE / 2
 };
 
 /*
@@ -503,7 +498,7 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
  *
  **********************************************************************/
 
-static u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
+static u32 input_pool_data[POOL_WORDS] __latent_entropy;
 
 static struct {
 	/* read-only data: */
@@ -1964,7 +1959,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 #include <linux/sysctl.h>
 
 static int min_write_thresh;
-static int max_write_thresh = INPUT_POOL_WORDS * 32;
+static int max_write_thresh = POOL_BITS;
 static int random_min_urandom_seed = 60;
 static char sysctl_bootid[16];
 
@@ -2021,7 +2016,7 @@ static int proc_do_entropy(struct ctl_ta
 	return proc_dointvec(&fake_table, write, buffer, lenp, ppos);
 }
 
-static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
+static int sysctl_poolsize = POOL_BITS;
 extern struct ctl_table random_table[];
 struct ctl_table random_table[] = {
 	{


