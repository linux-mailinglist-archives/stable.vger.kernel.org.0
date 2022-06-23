Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395E45581E8
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiFWRI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiFWRGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:06:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43875522CA;
        Thu, 23 Jun 2022 09:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51DACCE25DE;
        Thu, 23 Jun 2022 16:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DA4C3411B;
        Thu, 23 Jun 2022 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003351;
        bh=ZhCC7ZSBiiKk98memvSxOwv4VlB98hX1zyUaBvs9d5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teb2T7EqZdmtq4lllTAJMWrFPDyFI6DNK/LNlg+3nX2RpcG0Jk38MKuPc/vcJBjgW
         x6wD/ujLMCPEmVb81kF9XQWFZS2S/eROZ1EL7rvbp97QntRYAL9d4TDrMHGaa5YjEd
         X72TjZDhEVrUrALBEjnM893Uu0WUInAIHCqN5GS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 173/264] random: check for signals every PAGE_SIZE chunk of /dev/[u]random
Date:   Thu, 23 Jun 2022 18:42:46 +0200
Message-Id: <20220623164348.960381952@linuxfoundation.org>
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

commit e3c1c4fd9e6d14059ed93ebfe15e1c57793b1a05 upstream.

In 1448769c9cdb ("random: check for signal_pending() outside of
need_resched() check"), Jann pointed out that we previously were only
checking the TIF_NOTIFY_SIGNAL and TIF_SIGPENDING flags if the process
had TIF_NEED_RESCHED set, which meant in practice, super long reads to
/dev/[u]random would delay signal handling by a long time. I tried this
using the below program, and indeed I wasn't able to interrupt a
/dev/urandom read until after several megabytes had been read. The bug
he fixed has always been there, and so code that reads from /dev/urandom
without checking the return value of read() has mostly worked for a long
time, for most sizes, not just for <= 256.

Maybe it makes sense to keep that code working. The reason it was so
small prior, ignoring the fact that it didn't work anyway, was likely
because /dev/random used to block, and that could happen for pretty
large lengths of time while entropy was gathered. But now, it's just a
chacha20 call, which is extremely fast and is just operating on pure
data, without having to wait for some external event. In that sense,
/dev/[u]random is a lot more like /dev/zero.

Taking a page out of /dev/zero's read_zero() function, it always returns
at least one chunk, and then checks for signals after each chunk. Chunk
sizes there are of length PAGE_SIZE. Let's just copy the same thing for
/dev/[u]random, and check for signals and cond_resched() for every
PAGE_SIZE amount of data. This makes the behavior more consistent with
expectations, and should mitigate the impact of Jann's fix for the
age-old signal check bug.

---- test program ----

  #include <unistd.h>
  #include <signal.h>
  #include <stdio.h>
  #include <sys/random.h>

  static unsigned char x[~0U];

  static void handle(int) { }

  int main(int argc, char *argv[])
  {
    pid_t pid = getpid(), child;
    signal(SIGUSR1, handle);
    if (!(child = fork())) {
      for (;;)
        kill(pid, SIGUSR1);
    }
    pause();
    printf("interrupted after reading %zd bytes\n", getrandom(x, sizeof(x), 0));
    kill(child, SIGTERM);
    return 0;
  }

Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -524,9 +524,7 @@ EXPORT_SYMBOL(get_random_bytes);
 
 static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
 {
-	bool large_request = nbytes > 256;
-	ssize_t ret = 0;
-	size_t len;
+	size_t len, left, ret = 0;
 	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
 	u8 output[CHACHA20_BLOCK_SIZE];
 
@@ -538,46 +536,47 @@ static ssize_t get_random_bytes_user(voi
 	 * bytes, in case userspace causes copy_to_user() below to sleep
 	 * forever, so that we still retain forward secrecy in that case.
 	 */
-	crng_make_state(chacha_state, (u8 *)&chacha_state[4], CHACHA_KEY_SIZE);
+	crng_make_state(chacha_state, (u8 *)&chacha_state[4], CHACHA20_KEY_SIZE);
 	/*
 	 * However, if we're doing a read of len <= 32, we don't need to
 	 * use chacha_state after, so we can simply return those bytes to
 	 * the user directly.
 	 */
-	if (nbytes <= CHACHA_KEY_SIZE) {
-		ret = copy_to_user(buf, &chacha_state[4], nbytes) ? -EFAULT : nbytes;
+	if (nbytes <= CHACHA20_KEY_SIZE) {
+		ret = nbytes - copy_to_user(buf, &chacha_state[4], nbytes);
 		goto out_zero_chacha;
 	}
 
-	do {
-		if (large_request) {
-			if (signal_pending(current)) {
-				if (!ret)
-					ret = -ERESTARTSYS;
-				break;
-			}
-			cond_resched();
-		}
-
+	for (;;) {
 		chacha20_block(chacha_state, output);
 		if (unlikely(chacha_state[12] == 0))
 			++chacha_state[13];
 
 		len = min_t(size_t, nbytes, CHACHA20_BLOCK_SIZE);
-		if (copy_to_user(buf, output, len)) {
-			ret = -EFAULT;
+		left = copy_to_user(buf, output, len);
+		if (left) {
+			ret += len - left;
 			break;
 		}
 
-		nbytes -= len;
 		buf += len;
 		ret += len;
-	} while (nbytes);
+		nbytes -= len;
+		if (!nbytes)
+			break;
+
+		BUILD_BUG_ON(PAGE_SIZE % CHACHA20_BLOCK_SIZE != 0);
+		if (ret % PAGE_SIZE == 0) {
+			if (signal_pending(current))
+				break;
+			cond_resched();
+		}
+	}
 
 	memzero_explicit(output, sizeof(output));
 out_zero_chacha:
 	memzero_explicit(chacha_state, sizeof(chacha_state));
-	return ret;
+	return ret ? ret : -EFAULT;
 }
 
 /*


