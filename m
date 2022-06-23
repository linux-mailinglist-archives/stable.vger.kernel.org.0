Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C875580D4
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiFWQxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbiFWQvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B93B50029;
        Thu, 23 Jun 2022 09:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CF4561F99;
        Thu, 23 Jun 2022 16:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9B2C3411B;
        Thu, 23 Jun 2022 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002963;
        bh=5mbXSzNjpSRj9Uu7DEFHfMoAvquSppTKosRivKzhN5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZEK6z8mAoWSSIr+bLIM09xmP7bDEMBulwXLf5RIXpo+IgtkCnER5ks9BvaGqDkc+
         zxJ3wFlNZGPuXFEeGVCbRZ/e3omSqfVO54c4Ry9uBfprqbFOqJl4bu1wHy2F1k1Kf0
         xSXpq4t2qSVvep81PVR2QgoV2bU1+/R0vDc9Mr0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 043/264] random: fix soft lockup when trying to read from an uninitialized blocking pool
Date:   Thu, 23 Jun 2022 18:40:36 +0200
Message-Id: <20220623164345.287939032@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

commit 58be0106c5306b939b07b4b8bf00669a20593f4b upstream.

Fixes: eb9d1bf079bb: "random: only read from /dev/random after its pool has received 128 bits"
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -774,8 +774,11 @@ retry:
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	if (has_initialized)
+	if (has_initialized) {
 		r->initialized = 1;
+		wake_up_interruptible(&random_read_wait);
+		kill_fasync(&fasync, SIGIO, POLL_IN);
+	}
 
 	trace_credit_entropy_bits(r->name, nbits,
 				  entropy_count >> ENTROPY_SHIFT, _RET_IP_);
@@ -791,6 +794,13 @@ retry:
 			entropy_bits = r->entropy_count >> ENTROPY_SHIFT;
 		}
 
+		/* initialize the blocking pool if necessary */
+		if (entropy_bits >= random_read_wakeup_bits &&
+		    !other->initialized) {
+			schedule_work(&other->push_work);
+			return;
+		}
+
 		/* should we wake readers? */
 		if (entropy_bits >= random_read_wakeup_bits &&
 		    wq_has_sleeper(&random_read_wait)) {
@@ -1992,8 +2002,8 @@ _random_read(int nonblock, char __user *
 			return -EAGAIN;
 
 		wait_event_interruptible(random_read_wait,
-			ENTROPY_BITS(&input_pool) >=
-			random_read_wakeup_bits);
+		    blocking_pool.initialized &&
+		    (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits));
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 	}


