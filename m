Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57687535FC1
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiE0Llv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351604AbiE0LlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:41:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596E61269A1;
        Fri, 27 May 2022 04:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 133CEB824D9;
        Fri, 27 May 2022 11:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD43C385A9;
        Fri, 27 May 2022 11:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651589;
        bh=ZE8Oti+fu3e1FxWiLUTqce4e2vXw7qouPFIc2w4kBJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dP/zqrSNHHYeiWGOVYLv1i+Ldcpa9f1NWUgDEus236UCIJSMV6omFW+TwTlswaMDD
         5DEremEd6ObZFH8Ds2bIDq+0f38UGxRfZ9QV5n0UMR4DL2dlb73yfRaUdFj3ismbU4
         LNWIh1gGJ2oVCLs224F/VhbnIK9EFcfeqpUtKC4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 061/111] random: do not allow user to keep crng key around on stack
Date:   Fri, 27 May 2022 10:49:33 +0200
Message-Id: <20220527084828.191546873@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
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

commit aba120cc101788544aa3e2c30c8da88513892350 upstream.

The fast key erasure RNG design relies on the key that's used to be used
and then discarded. We do this, making judicious use of
memzero_explicit().  However, reads to /dev/urandom and calls to
getrandom() involve a copy_to_user(), and userspace can use FUSE or
userfaultfd, or make a massive call, dynamically remap memory addresses
as it goes, and set the process priority to idle, in order to keep a
kernel stack alive indefinitely. By probing
/proc/sys/kernel/random/entropy_avail to learn when the crng key is
refreshed, a malicious userspace could mount this attack every 5 minutes
thereafter, breaking the crng's forward secrecy.

In order to fix this, we just overwrite the stack's key with the first
32 bytes of the "free" fast key erasure output. If we're returning <= 32
bytes to the user, then we can still return those bytes directly, so
that short reads don't become slower. And for long reads, the difference
is hopefully lost in the amortization, so it doesn't change much, with
that amortization helping variously for medium reads.

We don't need to do this for get_random_bytes() and the various
kernel-space callers, and later, if we ever switch to always batching,
this won't be necessary either, so there's no need to change the API of
these functions.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jann Horn <jannh@google.com>
Fixes: c92e040d575a ("random: add backtracking protection to the CRNG")
Fixes: 186873c549df ("random: use simpler fast key erasure flow on per-cpu keys")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -532,19 +532,29 @@ static ssize_t get_random_bytes_user(voi
 	if (!nbytes)
 		return 0;
 
-	len = min_t(size_t, 32, nbytes);
-	crng_make_state(chacha_state, output, len);
-
-	if (copy_to_user(buf, output, len))
-		return -EFAULT;
-	nbytes -= len;
-	buf += len;
-	ret += len;
+	/*
+	 * Immediately overwrite the ChaCha key at index 4 with random
+	 * bytes, in case userspace causes copy_to_user() below to sleep
+	 * forever, so that we still retain forward secrecy in that case.
+	 */
+	crng_make_state(chacha_state, (u8 *)&chacha_state[4], CHACHA_KEY_SIZE);
+	/*
+	 * However, if we're doing a read of len <= 32, we don't need to
+	 * use chacha_state after, so we can simply return those bytes to
+	 * the user directly.
+	 */
+	if (nbytes <= CHACHA_KEY_SIZE) {
+		ret = copy_to_user(buf, &chacha_state[4], nbytes) ? -EFAULT : nbytes;
+		goto out_zero_chacha;
+	}
 
-	while (nbytes) {
+	do {
 		if (large_request && need_resched()) {
-			if (signal_pending(current))
+			if (signal_pending(current)) {
+				if (!ret)
+					ret = -ERESTARTSYS;
 				break;
+			}
 			schedule();
 		}
 
@@ -561,10 +571,11 @@ static ssize_t get_random_bytes_user(voi
 		nbytes -= len;
 		buf += len;
 		ret += len;
-	}
+	} while (nbytes);
 
-	memzero_explicit(chacha_state, sizeof(chacha_state));
 	memzero_explicit(output, sizeof(output));
+out_zero_chacha:
+	memzero_explicit(chacha_state, sizeof(chacha_state));
 	return ret;
 }
 


