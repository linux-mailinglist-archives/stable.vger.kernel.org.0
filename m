Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD495580BE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiFWQxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiFWQvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A5BCE1A;
        Thu, 23 Jun 2022 09:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 553D9B8248E;
        Thu, 23 Jun 2022 16:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB919C3411B;
        Thu, 23 Jun 2022 16:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003018;
        bh=iKj0d19AD6khnTYeBRFaztB0HYd0A7RuvG1Teazl0+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPPuCOHQ5aQk54o/7o4L8Ulv0kZV7kRFo8WJC0wn0j7A6G+UADF8eY1w0xXd4HdrS
         FCnra/BdYNx8sTqYwmm9O+bQQxBix2vuXR9kZTHt6AHQWZ5Cy/AGryh2Yu3z9Bs1Kh
         QevOkmsKa/2+sfbtL6Y3aG/CQf1z3I9wQcTfz5kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 102/264] random: de-duplicate INPUT_POOL constants
Date:   Thu, 23 Jun 2022 18:41:35 +0200
Message-Id: <20220623164346.957134437@linuxfoundation.org>
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
@@ -360,13 +360,6 @@
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
@@ -441,7 +434,9 @@ enum poolinfo {
 	POOL_TAP2 = 76,
 	POOL_TAP3 = 51,
 	POOL_TAP4 = 25,
-	POOL_TAP5 = 1
+	POOL_TAP5 = 1,
+
+	EXTRACT_SIZE = BLAKE2S_HASH_SIZE / 2
 };
 
 /*
@@ -504,7 +499,7 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
  *
  **********************************************************************/
 
-static u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
+static u32 input_pool_data[POOL_WORDS] __latent_entropy;
 
 static struct {
 	/* read-only data: */
@@ -2009,7 +2004,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 #include <linux/sysctl.h>
 
 static int min_write_thresh;
-static int max_write_thresh = INPUT_POOL_WORDS * 32;
+static int max_write_thresh = POOL_BITS;
 static int random_min_urandom_seed = 60;
 static char sysctl_bootid[16];
 
@@ -2066,7 +2061,7 @@ static int proc_do_entropy(struct ctl_ta
 	return proc_dointvec(&fake_table, write, buffer, lenp, ppos);
 }
 
-static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
+static int sysctl_poolsize = POOL_BITS;
 extern struct ctl_table random_table[];
 struct ctl_table random_table[] = {
 	{


